//
//  CMLChameleonPage.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/5/30.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLRenderPage.h"
#import "WeexSDK.h"

@interface CMLWeexRenderPage : CMLRenderPage

/**
 weex页面发起请求的公参
 */
@property (nonatomic, copy) NSDictionary *commonParameter;

@property (nonatomic, strong, readonly) WXSDKInstance *render;

@end
