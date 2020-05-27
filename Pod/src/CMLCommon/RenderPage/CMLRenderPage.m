//
//  CMLRenderPage.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLRenderPage.h"
#import "Masonry.h"
#import "CMLConstants.h"
#import "CMLEnvironmentManage.h"
#import "NSString+CMLExtends.h"
#import "CMLWKWebProtocol.h"
#import "CMLInstance.h"

@interface CMLRenderPage ()<CMLBridgeDelegate,CMLWKWebProtocol>

//@property (nonatomic, strong) CMLWKWebView *webPage;
@property (nonatomic, strong) CMLInstance *cmlInstance;

@property (nonatomic, copy) NSDictionary *parameter;

- (void)needFusionWebViewEngagement;

- (void)separateJSBundleUrlAndHtml5UrlAndParameter;
@end

@implementation CMLRenderPage

#pragma mark - lifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self destroyInstance];
    [_cmlInstance destroyInstance];
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithLoadUrl:(NSString *)url
{
    self = [self init];
    if (self) {
        if(url.length){
            [self setUrl:url];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cmlPageCommunication:) name:CMLPageAndPageCommunication object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*容器必须保证有大小，外部没有设置CMLFrame 默认为self.view.frame*/
    if (CGRectEqualToRect(self.CMLFrame, CGRectZero)) {
        self.CMLFrame = self.view.frame;
    }
    [self separateJSBundleUrlAndHtml5UrlAndParameter];
    [self creatRenderInstance];
    [self loadJSBundle];
    [self.cmlInstance createdInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CMLPageViewDidAppear" object:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CMLPageViewDidDisappear" object:self];
}

#pragma mark - privateMethods
-(void)creatRenderInstance{
    //子类重载，创建渲染实例
}

- (void)loadJSBundle{
    //子类重载，渲染JSBundle
}

- (void)destroyInstance{
    //子类重载，销毁渲染实例
}

- (void)cmlPageCommunication:(NSNotification *)notification {
    //子类重载，页面间通信通知
    
}

- (void)separateJSBundleUrlAndHtml5UrlAndParameter
{
    if (self.url.length) {
        [[self cmlCacheInstance] generateUrlInformation:self.url decode:NO completion:^(NSString *noQueryUrl, NSDictionary *param) {
            [self setHtmlUrl:noQueryUrl];
            [self setParameter:param];
            NSString *url = [param objectForKey:self.service.config.renderUrlParamKey];
            /*兼容一下*/
            if (!url || url.length <= 0) {
                url = [param objectForKey:@"wx_addr"];
            }
            
            if (url.length) {
                url = [url CM_urlDecode];
            } else {
                url = [self.url CM_urlDecode];
            }
            [self setBundleUrl:url];
        }];
    }
}

- (CMLCache *)cmlCacheInstance{
    return nil;
}

- (void)loadLocalJSBundle{

}

#pragma mark - publicMethods
-(void)setTopNavTitle:(NSString *)title {
    [self.navigationBar refreshTitle:title];
}

-(void)rendWithCustomBundleUrl:(NSString *)bundleUrl params:(nonnull NSDictionary *)params{
    
}

-(void)modifyWebPageStyle{
    /*暴露方法 子类可重置web样式*/
}

-(void)setWebPageFrame{
    /*暴露方法 子类可重置web页面的大小，主要首页车主服务页面容器大小有变化*/
    self.webPage.frame = CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
}

- (void)needsFusionWebViewToBeEngagement
{
    [self needFusionWebViewEngagement];
    
}

- (void)needFusionWebViewEngagement
{
    [self downgradingToWebURL:self.htmlUrl];
}

- (void)reloadJSBundleWithUrl:(NSString *)reloadUrl
{
    if (reloadUrl && [reloadUrl length]>0) {
        [self setUrl:reloadUrl];
        [self separateJSBundleUrlAndHtml5UrlAndParameter];
    }
    //TODO: weex和RN分别在自己的子类里实现重新加载功能
    [self reloadJSBundle];
    _navigationBar.hidden = YES;
}

- (void)reloadJSBundle{
    //子类重载，重新加载渲染实例
}

- (void)downgradingToWebURL:(NSString *)webURL{
    
    _navigationBar.hidden = NO;
    if (!_webPage) {
        _webPage = [self webPageWithUrl:webURL];
        [self.view addSubview:self.webPage];
        [self modifyWebPageStyle];
        [self setWebPageFrame];
    } else {
        if(webURL){
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webURL]];
            [_webPage loadRequest:request];
        }
    }
    [self.view bringSubviewToFront:self.navigationBar];
    [self.view bringSubviewToFront:self.webPage];
    self.currentEnvironment = CMLCurrentRunEnvironmentWeb;
}

- (void)downgradingToLocalBundle:(NSString *)localBundle{
    [self setBundleUrl:localBundle];
    [self loadJSBundle];
}

- (void)downgradingToDefaultErrWebURL:(NSString *)defaultErrWebURL{
    [self downgradingToWebURL:defaultErrWebURL];
}

#pragma CMLExecuteScriptProtocol
- (void)executeScript:(NSString *)script handler:(void (^ _Nullable)(NSString * _Nullable, NSError * _Nullable))handler
{
    if(!script) return;
    
    NSString *callScript = [NSString stringWithFormat:@"window.cmlBridge.channel('%@')",script];
    
    [self.webPage evaluateJavaScript:callScript completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if(handler){
            handler([item isKindOfClass:[NSString class]] ? item : nil, error);
        }
    }];
}

#pragma CMLWKWebProtocol
- (void)handleBridgeURL:(NSURL *)url instanceId:(NSString *)instanceId {
    
    NSString *indentifier = [NSString stringWithFormat:@"instance_%lud", (unsigned long)self.cmlInstance.hash];
    [self.bridge handleBridgeURL:url instanceId:indentifier];
    
}


#pragma mark - getter/setter
- (CMLWKWebView *)webPageWithUrl:(NSString *)htmlUrl
{
    if (!_webPage) {
        [self.view addSubview:self.navigationBar];
       
        _webPage = [[CMLWKWebView alloc] initWithUrl:htmlUrl parms:self.parameter];
        _webPage.backgroundColor = [UIColor lightGrayColor];
        _webPage.viewController = self;
        _webPage.delegate = self;
        [self.view addSubview:_webPage];
        [_webPage loadURLRequest];
     
    }
    return _webPage;
}

- (CMLNavigationBar *)navigationBar {
    if(!_navigationBar){
        UIView *topCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CMLScreenWidth, CML_IPHONE_STATUSBAR_HEIGHT - 20)];
        if (_hideNavigationBar) {
            topCoverView.frame = CGRectMake(0, 0, CMLScreenWidth, 0);
        }
        topCoverView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:topCoverView];
        _navigationBar = [CMLNavigationBar defaultNavigationBarWithTitle:@"chameleon"];
        _navigationBar.frame = CGRectMake(0, CML_IPHONE_STATUSBAR_HEIGHT-20, CMLScreenWidth, CML_IPHONE_NAVIGATIONBAR_HEIGHT);
        if (_hideNavigationBar) {
            _navigationBar.frame = CGRectMake(0, CML_IPHONE_STATUSBAR_HEIGHT-20, CMLScreenWidth, 0);
        }
        _navigationBar.backgroundColor = [UIColor whiteColor];
        _navigationBar.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        _navigationBar.backAction = ^{
            if (weakSelf.webPage.canGoBack) {
                [weakSelf.webPage goBack];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
        };
        
    }
    return _navigationBar;
}

- (CMLModuleBridge *)bridge {
    
    if (!_bridge) {
        _bridge = [[CMLModuleBridge alloc] init];
        _bridge.delegate = self;
    }
    return _bridge;
}

- (CMLInstance *)cmlInstance {
    
    if (!_cmlInstance) {
        _cmlInstance = [CMLInstance new];
        _cmlInstance.viewController = self;
        _cmlInstance.currentEnvironment = CMLServiceTypeWeex;
    }
    return _cmlInstance;
}

@end
