//
//  CMLSDKEngine.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon. All rights reserved.
//

#import "CMLSDKEngine.h"
#import "CMLModuleManager.h"
#import "WXSDKEngine.h"
#import "CMLRichTextComponent.h"

@implementation CMLSDKEngine

+ (void)initSDKEnvironment
{
    [CMLSDKEngine registerModule:@"cml" className:@"CMLCommonModule"];
    [CMLSDKEngine registerModule:@"modal" className:@"CMLModalUIModule"];
    [CMLSDKEngine registerModule:@"storage" className:@"CMLStorageModule"];
    [CMLSDKEngine registerModule:@"clipboard" className:@"CMLClipboardModule"];
    [CMLSDKEngine registerModule:@"stream" className:@"CMLStreamModule"];
    [CMLSDKEngine registerModule:@"audio" className:@"CMLAudioModule"];
    [CMLSDKEngine registerModule:@"webSocket" className:@"CMLWebSocketModule"];
    [WXSDKEngine registerComponent:@"richtext" withClass:[CMLRichTextComponent class]];
}

+ (void)registerModule:(NSString *)moduleName className:(NSString *)className
{
    [[CMLModuleManager sharedManager] registerModule:moduleName className:className];
}

+ (void)setCMLEnvironment:(enum CMLServiceType)serviceType{
    
    [[CMLEnvironmentManage chameleon] setServiceType:serviceType];
    
}

@end
