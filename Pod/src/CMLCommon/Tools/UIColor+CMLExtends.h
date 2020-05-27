//
//  UIColor+CMLExtends.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/3/12.
//  Copyright © 2018年 Chameleon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CMLExtends)

+ (UIColor *)cml_colorWithHex:(UInt32)hex;
+ (UIColor *)cml_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)cml_colorWithHexString:(NSString *)hexString;
+ (UIColor *)cml_colorWithString:(NSString *)hexString;

@end


