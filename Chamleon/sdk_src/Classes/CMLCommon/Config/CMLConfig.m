//
//  CMLChameleonConfig.m
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import "CMLConfig.h"
#import "CMLEnvironmentManage.h"
#import "NSDictionary+CMLExtends.h"

@interface CMLConfig()

@property (nonatomic, strong) NSMutableDictionary *defaultBundlePaths;

@end

@implementation CMLConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置默认值
        _isFeatureAvailable = YES;
        
        _isEnableCacheFeature = YES;
        
        //和fe配置平台协议约定，固定为cml_addr
        _renderUrlParamKey = @"cml_addr";
        
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Chameleon"];
        
        if (![FILE_MANAGER fileExistsAtPath:filePath]) {
            [FILE_MANAGER createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _cachePath = filePath;
        
        _cacheConfigPath = [_cachePath stringByAppendingPathComponent:@"config.Chameleon"];
        
        _maxRuntimeCacheSize = @(1048576 * 1024);
        
        _maxPrefetchCacheSize = @(1048576 * 1024);
        
        _prefetchContents = nil;
    }
    
    return self;
}

- (void)addDefaultBundlePath:(NSString *)bundlePath forOriginBundleUrl:(NSString *)originBundleUrl {
    [self.defaultBundlePaths cml_setValue:bundlePath forKey:originBundleUrl];
}

- (void)delDefaultBundlePath:(NSString *)bundlePath forOriginBundleUrl:(NSString *)originBundleUrl {
    [self.defaultBundlePaths cml_setValue:bundlePath forKey:originBundleUrl];
}

- (void)removeAllDefaultBundlePath {
    [self.defaultBundlePaths removeAllObjects];
    self.defaultBundlePaths = nil;
}

- (NSMutableDictionary *)defaultBundlePaths{
    if(!_defaultBundlePaths){
        _defaultBundlePaths = [NSMutableDictionary new];
    }
    return _defaultBundlePaths;
}

@end
