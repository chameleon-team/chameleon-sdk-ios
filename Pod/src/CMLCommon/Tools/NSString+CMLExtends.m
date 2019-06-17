//
//  NSString+Extends.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//

#import "NSString+CMLExtends.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (CMLExtends)

- (NSString *)CM_MD5
{
    NSMutableString *MD5String;
    
    if (self.length) {
        const char *value = [self UTF8String];
        
        unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
        
        MD5String = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
            [MD5String appendFormat:@"%02x", outputBuffer[count]];
        }
    }
    
    return MD5String;
}

- (NSString *)CM_urlEncode
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)CM_urlDecode
{
    return [self stringByRemovingPercentEncoding];
}

@end
