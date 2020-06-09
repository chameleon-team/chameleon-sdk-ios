//
//  CMLEnvironmentManage.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import "CMLEnvironmentManage.h"

@interface CMLEnvironmentManage ()


@end

@implementation CMLEnvironmentManage

+ (instancetype)chameleon
{
    static dispatch_once_t onceToken;
    static CMLEnvironmentManage *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[CMLEnvironmentManage alloc]init];
    });
    return _instance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //empty
    }
    return self;
}

#pragma mark - getter/setter
- (void)setServiceType:(enum CMLServiceType)serviceType {
    if(serviceType & CMLServiceTypeWeex){
        _weexService = [[CMLWeexService alloc] init];
    }
    
//    if(serviceType & CMLServiceTypeReactNative){
//        _ReactNativeService = [[CMLReactNativeService alloc] init];
//    }
}

@end
