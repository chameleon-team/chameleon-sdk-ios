//
//  CMLWeexService.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/25.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexService.h"
#import "CMLWeexBridgeModule.h"
#import "CMLWeexImgLoaderDefaultImpl.h"
#import "WeexSDK.h"
#if __has_include("SocketRocket.h")
#import "CMLWeeXWebSocketDefaultImpl.h"
#endif

@interface CMLWeexService()

- (void)prefetch;
- (void)configuration;
- (void)registerComponents;

@end

@implementation CMLWeexService

@dynamic cache;
@dynamic config;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [[CMLWeexCache alloc] initWithService:self];
        self.config = [[CMLWeexConfig alloc] init];
        [self configuration];
        [self registerComponents];
    }
    return self;
}

- (void)setupPrefetch
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prefetch) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self prefetch];
}

- (void)prefetch
{
    if ([self.config isFeatureAvailable]) {
        [self.cache prefetchJSBundle];
    }
}


- (void)configuration
{
    [WXAppConfiguration setAppName:self.config.appName];
    [WXAppConfiguration setAppVersion:self.config.appVersion];
    [WXSDKEngine initSDKEnvironment];
    [WXSDKEngine setCustomEnvironment:self.config.customEnvConfig];
    [WXLog setLogLevel: WXLogLevelError];
}


- (void)registerComponents
{
    
    [WXSDKEngine registerModule:@"cmlBridge" withClass:[CMLWeexBridgeModule class]];
    
    [WXSDKEngine registerHandler:[CMLWeexImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
#if __has_include("SocketRocket.h")
        [WXSDKEngine registerHandler:[CMLWeeXWebSocketDefaultImpl new] withProtocol:@protocol(WXWebSocketHandler)];
#endif
    
}


@end
