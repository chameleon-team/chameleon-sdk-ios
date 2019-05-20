//
//  CMLConstants.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "UIDevice+CMLExtends.h"

#ifndef CMLConstants_h
#define CMLConstants_h


#define CMLSDKVersion @"0.1"
#define CMLBridgeScheme @"cml"
#define CMLCallBackBridgeScheme @"cml"
/*
 * Concatenate preprocessor tokens a and b without expanding macro definitions
 * (however, if invoked from a macro, macro arguments are expanded).
 */
#define CML_CONCAT(a, b)   a ## b
/*
 * Concatenate preprocessor tokens a and b after macro-expanding them.
 */
#define CML_CONCAT_WRAPPER(a, b)    CML_CONCAT(a, b)

#define CML_EXPORT_METHOD_INTERNAL(method, token) \
+ (NSString *)CML_CONCAT_WRAPPER(token, __LINE__) { \
return NSStringFromSelector(method); \
}

/**
 *  @abstract export public method
 */
#define CML_EXPORT_METHOD(method) CML_EXPORT_METHOD_INTERNAL(method,wx_export_method_)

#define CMLScreenWidth [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE_X    UIDevice.currentDevice.cml_isIphone_X_series
//iPhoneX安全区域宏定义
///导航栏+状态栏高度
#define CML_IPHONE_NAVIGATIONBAR_HEIGHT (IS_IPHONE_X ? 88 : 64)
///状态栏高度
#define CML_IPHONE_STATUSBAR_HEIGHT (IS_IPHONE_X ? 44 : 20)
///iPhoneX的Home条高度
#define CML_IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X ? 34 : 0)

#define CML_IPHONE_PUSH_STATUSBAR_HEIGHT (IS_IPHONE_X ? 44 : 0)

#endif /* CMLConstants_h */
