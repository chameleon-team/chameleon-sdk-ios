//
//  DCChameleonPage.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/5/30.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexRenderPage.h"
#import "Masonry.h"
#import "CMLEnvironmentManage.h"
#import "CMLCommonDefine.h"
#import "CMLConstants.h"
#import "NSString+CMLExtends.h"
#import "NSDictionary+CMLExtends.h"

@interface CMLWeexRenderPage ()<WKNavigationDelegate>

@property (nonatomic, assign) CMLRenderURLType renderType;
@property (nonatomic, assign) NSTimeInterval initStartTime;
@property (nonatomic, assign) NSTimeInterval renderStartTime;

@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) WXSDKInstance *render;

@property (nonatomic, copy) NSString *rendingURL; //当前正在渲染中的链接

- (void)onCreate:(UIView *)view;
- (void)onFailed:(NSError *)error;
- (void)onRenderFinished:(UIView *)view;
- (void)onRenderProgress:(CGRect)renderRect;
- (void)onJSRuntimeException:(WXJSExceptionInfo *)exception;
- (void)onJSDownloadedFinish:(WXResourceResponse *)response request:(WXResourceRequest *)request data:(NSData *)data error:(NSError *)error;
- (void)onScroll:(CGPoint)contentOffset;

- (void)loadJSBundle;

@end

@implementation CMLWeexRenderPage

#pragma mark - 重载父类方法
-(void)creatRenderInstance{
    
    self.currentEnvironment = CMLCurrentRunEnvironmentWeex;
    
    //Page初始化完成后,记录开始初始化的时间。
    _initStartTime = CFAbsoluteTimeGetCurrent();
    
    _render = [[WXSDKInstance alloc] init];
    _render.viewController = self;
    [_render setFrame:self.CMLFrame];
    
    typeof(self) __weak weakSelf = self;
    [_render setOnCreate:^(UIView *view) {
        [weakSelf onCreate:view];
    }];
    [_render setOnFailed:^(NSError *error) {
        [weakSelf onFailed:error];
    }];
    [_render setRenderFinish:^(UIView *view) {
        [weakSelf onRenderFinished:view];
    }];
    [_render setOnRenderProgress:^(CGRect renderRect) {
        [weakSelf onRenderProgress:renderRect];
    }];
    [_render setOnJSRuntimeException:^(WXJSExceptionInfo *jsException) {
        [weakSelf onJSRuntimeException:jsException];
    }];
    [_render setOnJSDownloadedFinish:^(WXResourceResponse *response, WXResourceRequest *request, NSData *data, NSError *error) {
        [weakSelf onJSDownloadedFinish:response request:request data:data error:error];
    }];
    [_render setOnScroll:^(CGPoint contentOffset) {
        [weakSelf onScroll:contentOffset];
    }];
    
}

// 作为公共参数传入
- (NSDictionary *)standardQueryDict {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:CMLSDKVersion forKey:@"cml_sdk"];
    [dict setObject:self.url?:@"" forKey:@"cml_url"];
    return dict;
}

- (void)loadJSBundle
{
    if (self.bundleUrl.length) {
        _renderStartTime = CFAbsoluteTimeGetCurrent();
        
        CMLWeexCache *cache = (CMLWeexCache *)[CMLEnvironmentManage chameleon].weexService.cache;
        [cache getBundleCacheOfJSBundleUrl:self.bundleUrl completion:^(NSString *url, NSDictionary *parameter) {
            if(url.length > 0){
                //本地默认bundle、remote、local加载都会走到这里
                if(self.renderType != CMLRenderURLTypeDefaultLocalBundle){
                    NSNumber *renderTypeNum = [parameter valueForKey:@"renderType"];
                    self.renderType = renderTypeNum.integerValue;
                }
                NSMutableDictionary *param = [NSMutableDictionary new];
                [param addEntriesFromDictionary:parameter];
                [param addEntriesFromDictionary:self.commonParameter];
                [param addEntriesFromDictionary:[self standardQueryDict]];
                
                self.rendingURL = url;
                [self.render renderWithURL:[NSURL URLWithString:url] options:@{@"query" : [param copy]} data:nil];
                self.queryDic = [param copy];
                
            } else {
                CMLRenderFailerType failerType = CMLRenderFailerTypeNone;
                //如果是加载的本地默认缓存，则failerType和远端bundle、本地bundle不同
                NSString *localBundlePath = [[CMLEnvironmentManage chameleon].weexService.config.defaultBundlePaths objectForKey:self.url];
                if(self.htmlUrl.length > 0){
                    failerType = CMLRenderFailerTypeURLDecode;
                } else {
                    if(localBundlePath.length > 0) {
                        failerType = CMLRenderFailerTypeBundleFailedNoHtmlHasLocalDefaultBundle;
                    } else {
                        failerType = CMLRenderFailerTypeBundleFailedNoHtmlNoLocalDefaultBundle;
                    }
                }
                [self dealWithFailerType:failerType];
            }
        }];
    } else {
        [self.view addSubview:self.webPage];
        [self.webPage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
}

- (void)reloadJSBundle{
    /*重新加载不生效，通过先销毁，在创建加载的方式实现重新加载功能*/
    [_render destroyInstance];
    _render = nil;
    [self creatRenderInstance];
    [self loadJSBundle];
}

- (CMLCache *)cmlCacheInstance{
    return [CMLEnvironmentManage chameleon].weexService.cache;
}

- (void)destroyInstance{
    [_render destroyInstance];
}

- (void)cmlPageCommunication:(NSNotification *)notification {
    
    [self.bridge invokeJsMethod:@"onBroadcast" methodName:@"cml" arguments:notification.object];
}

-(void)rendWithCustomBundleUrl:(NSString *)bundleUrl params:(NSDictionary *)params{
    NSString *url = nil;
    if(bundleUrl.length > 0){
        url = bundleUrl;
    } else {
        url = self.rendingURL;
    }
    
    NSMutableDictionary *queryParams = [NSMutableDictionary new];
    [queryParams addEntriesFromDictionary:params];
    [queryParams addEntriesFromDictionary:[self standardQueryDict]];
    
    [self.render renderWithURL:[NSURL URLWithString:url] options:(queryParams ? @{@"query" : [queryParams copy]} : nil) data:nil];
    self.queryDic = [queryParams copy];
}

- (void)executeScript:(NSString *)script handler:(void (^ _Nullable)(NSString * _Nullable, NSError * _Nullable))handler
{
    if(!script) return;
    
    if (self.currentEnvironment == CMLCurrentRunEnvironmentWeb) {
       
        NSString *callScript = [NSString stringWithFormat:@"window.cmlBridge.channel('%@')",script];
        
        [self.webPage evaluateJavaScript:callScript completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            if(handler){
                handler([item isKindOfClass:[NSString class]] ? item : nil, error);
            }
        }];
        
    }else if (self.currentEnvironment == CMLCurrentRunEnvironmentWeex){
        
        NSDictionary *parms = @{@"protocol":script};
        [_render fireGlobalEvent:@"cmlBridgeChannel" params:parms];
    }
}
#pragma mark - Weex delegate
- (void)onCreate:(UIView *)view
{
    self.currentEnvironment = CMLCurrentRunEnvironmentWeex;
    [self.weexView removeFromSuperview];
    [self setWeexView:view];
    [self.view addSubview:self.weexView];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.weexView);
}

- (void)onFailed:(NSError *)error
{
    CMLRenderFailerType failerType = CMLRenderFailerTypeNone;
    NSString *localBundlePath = [[CMLEnvironmentManage chameleon].weexService.config.defaultBundlePaths objectForKey:self.url];
    if(self.renderType == CMLRenderURLTypeDefaultLocalBundle){
        failerType = CMLRenderFailerDefaultLocalBundle;
    } else {
        if(self.htmlUrl.length > 0){
            if(self.renderType == CMLRenderURLTypeRemoteBundle){
                failerType = CMLRenderFailerTypeRemoteBundle;
            } else if (self.renderType == CMLRenderURLTypeLocalBundle) {
                failerType = CMLRenderFailerTypeLocalBundle;
            }
        } else {
            if(localBundlePath.length > 0) {
                failerType = CMLRenderFailerTypeBundleFailedNoHtmlHasLocalDefaultBundle;
            } else {
                failerType = CMLRenderFailerTypeBundleFailedNoHtmlNoLocalDefaultBundle;
            }
        }
    }
    [self dealWithFailerType:failerType];
}

- (void)onRenderFinished:(UIView *)view
{
}

- (void)onRenderProgress:(CGRect)renderRect
{
    
}

- (void)onJSRuntimeException:(WXJSExceptionInfo *)exception
{
#ifdef DEBUG
    NSString *titleStr = [NSString stringWithFormat:@"渲染错误信息 \n errorCode%@",exception.errorCode];
    NSString *messageStr = exception.exception;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"复制错误信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = messageStr;
        
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
#endif
    
}

- (void)onJSDownloadedFinish:(WXResourceResponse *)response request:(WXResourceRequest *)request data:(NSData *)data error:(NSError *)error
{
    CMLWeexCache *cache = (CMLWeexCache *)[CMLEnvironmentManage chameleon].weexService.cache;
    [cache addJSBundleCache:data originUrl:request.URL.absoluteString kind:CMLChameleonCacheRuntime completion:nil];
}

- (void)onScroll:(CGPoint)contentOffset
{
    
}

#pragma mark - WebView delegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    CMLRenderFailerType failerType = CMLRenderFailerTypeNone;
    NSString *localBundlePath = [[CMLEnvironmentManage chameleon].weexService.config.defaultBundlePaths objectForKey:self.url];
    if(self.renderType == CMLRenderURLTypeWeb){
        if(localBundlePath.length > 0) {
            failerType = CMLRenderFailerTypeWebFailedHasLocalDefaultBundle;
        }else {
            failerType = CMLRenderFailerTypeWebFailedNoLocalDefaultBundle;
        }
    } else if(self.renderType == CMLRenderURLTypeDefaultErrWeb){
        failerType = CMLRenderFailerDefaultErrWeb;
    }
    [self dealWithFailerType:failerType];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

#pragma mark - 降级状态机
- (void)dealWithFailerType:(CMLRenderFailerType) failerType{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (failerType) {
            case CMLRenderFailerTypeRemoteBundle:
            case CMLRenderFailerTypeLocalBundle:
            case CMLRenderFailerTypeURLDecode:
            case CMLRenderFailerTypeWhiteList:
                self.renderType = CMLRenderURLTypeWeb;
                self.navigationBar.hidden = NO;
                [self downgradingToWebURL:self.htmlUrl];
                break;
            case CMLRenderFailerTypeBundleFailedNoHtmlHasLocalDefaultBundle:
            case CMLRenderFailerTypeWebFailedHasLocalDefaultBundle:
                self.renderType = CMLRenderURLTypeDefaultLocalBundle;
                self.navigationBar.hidden = YES;
                [self downgradingToLocalBundle:[[CMLEnvironmentManage chameleon].weexService.config.defaultBundlePaths objectForKey:self.url]];
                break;
            case CMLRenderFailerTypeBundleFailedNoHtmlNoLocalDefaultBundle:
            case CMLRenderFailerTypeWebFailedNoLocalDefaultBundle:
            case CMLRenderFailerDefaultLocalBundle:
                self.navigationBar.hidden = NO;
                self.renderType = CMLRenderURLTypeDefaultErrWeb;
                [self downgradingToDefaultErrWebURL:[CMLEnvironmentManage chameleon].weexService.config.defaultErrUrl];
                break;
            default:
                break;
        }
    });
    
}

@end
