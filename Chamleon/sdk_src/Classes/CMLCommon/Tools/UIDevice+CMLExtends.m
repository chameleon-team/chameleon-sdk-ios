//
//  UIDevice+CMLExtends.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/9.
//

#import "UIDevice+CMLExtends.h"

@implementation UIDevice (CMLExtends)

- (BOOL)cml_isIphone_X_series {
    if (@available(iOS 11.0, *)) {
        return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom > 0.0;
    } else {
        return NO;
    }
}
@end
