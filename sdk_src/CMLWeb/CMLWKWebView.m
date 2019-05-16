//
//  CMLWKWebView.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWKWebView.h"
#import "CMLConstants.h"
#import "CMLBridgeProtocol.h"
#import "CMLUtility.h"
#import "CMLInstance.h"

@interface CMLWKWebView ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebViewConfiguration *customConfiguration;

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSDictionary *urlParms;

@end

@implementation CMLWKWebView

-(void)dealloc{
   
}

- (instancetype)initWithUrl:(NSString *)url parms:(NSDictionary *)parms
{
    self = [self init];
    if(self){
        self.UIDelegate = self;
        self.navigationDelegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.urlParms = parms;
        self.urlStr = url;
        
    }
    return self;
}

- (void)loadURLRequest {
    
    NSMutableString *requertUrl = [NSMutableString stringWithString:self.urlStr];
    [requertUrl appendString:[self additionalUrl]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requertUrl]];
    [self loadRequest:request];
}

#pragma mark - url 增加字段
- (NSString *)additionalUrl{
    NSDictionary *addParams = [self addCustomParams:self.urlParms];
    if (addParams) {
        NSMutableString *addStr = [NSMutableString string];
        NSArray *keys = [addParams allKeys];
        for (int i = 0; i < [keys count]; i++) {
            NSString *key = keys[i];
            if (i == 0) {
                [addStr appendFormat:@"?%@=%@",key, addParams[key]];
                
            }else if ([addParams valueForKey:key] != nil) {
                [addStr appendFormat:@"&%@=%@",key, addParams[key]];
            }
        }
        if (addStr.length > 0) {
            return addStr;
        }
    }
    return @"";
}

- (NSDictionary *)addCustomParams:(NSDictionary *)parms {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:parms];
    [dictM setObject:CMLSDKVersion forKey:@"cml_sdk"];
    return [dictM copy];
}



- (WKWebViewConfiguration *)customConfiguration
{
    if(_customConfiguration) return _customConfiguration;
    
    _customConfiguration = [[WKWebViewConfiguration alloc] init];
    return _customConfiguration;
}

- (void)addUserScript:(NSString *)userScript
{
    if(!userScript) return;
    
    NSArray *scripts = [[self customConfiguration].userContentController userScripts];
    for(WKUserScript *script in scripts){
        if([script.source isEqualToString:userScript])
            return;
    }
    WKUserScript *script = [[WKUserScript alloc] initWithSource:userScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [[self customConfiguration].userContentController addUserScript:script];
}

#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    NSURL *url = navigationResponse.response.URL;
    decisionHandler(WKNavigationResponsePolicyAllow);

}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    // jsbridge处理
    if([url.scheme isEqualToString:CMLBridgeScheme]){
        decisionHandler(WKNavigationActionPolicyCancel);
        if ([self.delegate respondsToSelector:@selector(handleBridgeURL:instanceId:)]) {
            [self.delegate handleBridgeURL:url instanceId:nil];
        }
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];

}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert]; [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
     [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];

}

#pragma mark WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

}

@end
