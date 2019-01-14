//
//  CMLChameleonCacheItem.m
//
//  Created by Chameleon-Team on 2018/6/6.
//

#import "CMLCacheItem.h"
#import "CMLCommonDefine.h"
#import "CMLEnvironmentManage.h"

@implementation CMLCacheItem

- (NSString *)filePath
{
    if (self.identifier.length) {
        NSString *url = [CML_COMMON_CACHE_PATH stringByAppendingPathComponent:self.identifier];
        return [@"file://" stringByAppendingPathComponent:url];
    }
    return nil;
}

- (BOOL)deleteItemFile
{
    BOOL result = NO;
    NSString *filePath = [self filePath];
    if (filePath.length) {
        NSError *error = nil;
        result = [FILE_MANAGER removeItemAtPath:filePath error:&error];
        if (error) {
            result = NO;
        }
    }
    return result;
}

@end
