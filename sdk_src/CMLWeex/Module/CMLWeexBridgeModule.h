//
//  CMLWeexBridgeModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/29.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface CMLWeexBridgeModule : NSObject<WXModuleProtocol>

@property (nonatomic, weak) WXSDKInstance *weexInstance;

@end


