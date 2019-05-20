//
//  CMLSDKEngine.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLEnvironmentManage.h"

@interface CMLSDKEngine : NSObject

+ (void)initSDKEnvironment;

+ (void)registerModule:(NSString *)moduleName className:(NSString *)className;

+ (void)setCMLEnvironment:(enum CMLServiceType)serviceType;

@end
