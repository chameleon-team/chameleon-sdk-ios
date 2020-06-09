//
//  CMLEnvironmentManage.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import <Foundation/Foundation.h>
#import "CMLWeexService.h"
//#import "CMLReactNativeService.h"

typedef NS_ENUM(NSInteger, CMLServiceType){
    CMLServiceTypeWeex = 1,
    CMLServiceTypeReactNative = 1 << 1
};

@interface CMLEnvironmentManage : NSObject

/**
 CM服务类型，可以分别或同时支持weex和RN
 */
@property (nonatomic, assign) CMLServiceType serviceType;

/**
 weex服务实例
 */
@property (nonatomic, strong) CMLWeexService *weexService;

/**
 ReactNative服务实例
 */
//@property (nonatomic, strong) CMLReactNativeService *ReactNativeService;


+ (instancetype)chameleon;


@end

