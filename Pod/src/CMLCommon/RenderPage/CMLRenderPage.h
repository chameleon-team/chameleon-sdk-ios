//
//  CMLRenderPage.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLWKWebView.h"
#import "CMLCommonService.h"
#import "CMLNavigationBar.h"
#import "CMLModuleBridge.h"


typedef NS_ENUM(NSInteger, CMLCurrentRunEnvironment){
    CMLCurrentRunEnvironmentWeex = 0,
    CMLCurrentRunEnvironmentRN,
    CMLCurrentRunEnvironmentWeb,
};

@interface CMLRenderPage : UIViewController

@property (nonatomic, strong) CMLCommonService *service;

@property (nonatomic,assign) CMLCurrentRunEnvironment currentEnvironment;

@property (nonatomic,assign) CGRect CMLFrame;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *bundleUrl;

@property (nonatomic, strong) NSDictionary *queryDic;

@property (nonatomic, copy) NSString *htmlUrl;

@property (nonatomic, strong, readonly) CMLWKWebView *webPage;

@property (nonatomic, strong) CMLNavigationBar *navigationBar;
@property (nonatomic, assign) BOOL hideNavigationBar;//默认显示

@property (nonatomic, strong) CMLModuleBridge *bridge;

/**
 初始化变色龙页面的实例。
 
 @param url 传入的URL
 @return Instance
 */
- (instancetype)initWithLoadUrl:(NSString *)url;

#pragma mark - 主动触发事件支持
/**
 H5主动通知降级的方法。
 Note：该方法仅供Module去调用。
 */
- (void)needsFusionWebViewToBeEngagement;

/**
 重新加载JSBundle
 Note：该方法仅供Module去调用。
 */
- (void)reloadJSBundleWithUrl:(NSString *)reloadUrl;

#pragma mark - 重置Web支持
/**
 子类可重置web frame
 */
-(void)setWebPageFrame;

/**
 子类可重置web样式
 */
-(void)modifyWebPageStyle;

/**
 设置页面标题
 */
-(void)setTopNavTitle:(NSString *)title;

/**
 加载自定义bundle
 */
-(void)rendWithCustomBundleUrl:(NSString *)bundleUrl params:(NSDictionary *)params;

#pragma mark - 降级支持
/**
 降级为web页
 */
- (void)downgradingToWebURL:(NSString *)webURL;

/**
 降级为本地默认bundle
 */
- (void)downgradingToLocalBundle:(NSString *)localBundle;

/**
 降级为默认default错误Web页
 */
- (void)downgradingToDefaultErrWebURL:(NSString *)defaultErrWebURL;

- (void)handleBridgeURL:(NSURL *)url instanceId:(NSString *)instanceId;

@end

