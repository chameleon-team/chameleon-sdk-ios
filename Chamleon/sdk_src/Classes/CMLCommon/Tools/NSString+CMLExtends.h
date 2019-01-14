//
//  NSString+Extends.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CMLExtends)

- (NSString *)CM_MD5;

- (NSString *)CM_urlEncode;
- (NSString *)CM_urlDecode;

@end

NS_ASSUME_NONNULL_END
