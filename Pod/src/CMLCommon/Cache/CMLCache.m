//
//  CMLChameleonCache.m
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import "CMLCache.h"
#import "NSString+CMLExtends.h"
#import "CMLCommonService.h"


@interface CMLCache ()

@property(nonatomic, weak) CMLCommonService *service; //通过持有service，得知当前cache为哪个service服务

@end


@implementation CMLCache
#pragma mark - Lifecycle Mehtods

- (instancetype)initWithService:(CMLCommonService *)service
{
    self = [super init];
    if (self) {
        _service = service;
        //TODO: 是否需要开多条队列
        _workQueue = dispatch_queue_create("com.chameleon.chameleon", NULL);
        dispatch_set_target_queue(_workQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    return self;
}

#pragma mark - Interface Methods

- (CMLCacheInfo *)cacheInfo
{
    if (!_cacheInfo) {
        _cacheInfo = [CMLCacheInfo loadCacheInfoWithService:self.service];
    }
    return _cacheInfo;
}

- (void)prefetchJSBundle
{
    dispatch_async(self.workQueue, ^{
        if ([self.service.config isEnableCacheFeature]) {
            NSArray *prefetchQueue = [self.service.config prefetchContents];
            [prefetchQueue enumerateObjectsUsingBlock:^(NSString * _Nonnull elements, NSUInteger idx, BOOL * _Nonnull stop) {
                [self prefetchJSBundleWithJSBundleUrl:[elements CM_urlDecode]];
            }];
        }
    });
}

- (void)prefetchJSBundleWithJSBundleUrl:(NSString *)url
{
    if (url.length) {
        NSString *identifier = [url CM_MD5];
        CMLCacheItem *info = [self.cacheInfo getCacheInfo:identifier];
        
        NSURL *requestURL = [NSURL URLWithString:url];
        if (!info && requestURL) {
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_barrier_async(self.workQueue, ^{
                    NSString *destinationPath = [[self.service.config cachePath] stringByAppendingPathComponent:identifier];
                    if ([data writeToFile:destinationPath atomically:YES]) {
                        CMLCacheItem *item = [CMLCacheItem new];
                        [item setIdentifier:identifier];
                        [item setCacheType:@(CMLChameleonCachePrefetch)];
                        NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:destinationPath error:nil];
                        [item setFileSize:fileAttribute[NSFileSize]];
                        [self.cacheInfo addCacheInfo:item];
                    }
                });
            }];
            [task resume];
        }
    }
}

- (void)dropAllCache
{
    dispatch_barrier_async(self.workQueue, ^{
        [FILE_MANAGER removeItemAtPath:[self.service.config cachePath] error:nil];
        [self setCacheInfo:nil];
    });
}

- (void)dropCacheOfJSBundleUrl:(NSString *)url
{
    dispatch_barrier_async(self.workQueue, ^{
        CMLCacheItem *item = [self.cacheInfo getCacheInfo:[url CM_MD5]];
        [self.cacheInfo removeCacheInfo:item];
    });
}

- (void)getBundleCacheOfJSBundleUrl:(NSString *)url completion:(void(^)(NSString *url, NSDictionary *parameter))completion
{
    dispatch_async(self.workQueue, ^{
        [self generateUrlInformation:url decode:YES completion:^(NSString *noQueryUrl, NSDictionary *param) {
            CMLCacheItem *item = [self.cacheInfo getCacheInfo:[noQueryUrl CM_MD5]];
            NSString *filePath = nil;
            
            if (item && item.identifier.length && [self.service.config isEnableCacheFeature]) {
                filePath = [NSURL fileURLWithPath:[item filePath]].absoluteString;
            }
            
            if (!filePath.length) {
                filePath = noQueryUrl;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(filePath, param);
                }
            });
        }];
    });
}

- (void)addJSBundleCache:(NSData *)data url:(NSString *)url kind:(CMLChameleonCacheKind)kind completion:(void(^)(BOOL success))completion
{
    NSURL *urlForValidation = [NSURL URLWithString:url];
    
    //URL合法，数据包有值
    if (urlForValidation && data && [self.service.config isEnableCacheFeature]) {
        dispatch_async(self.workQueue, ^{
            NSString *identifier = [url CM_MD5];
            CMLCacheItem *item = [self.cacheInfo getCacheInfo:identifier];
            
            if (item) { //目前的设计里，不存在URL不变对应的资源却发生变化的case(每一个JSBundle均为一个URI)，所以不需要重新复写data，只需要调整顺序即可。
                dispatch_barrier_async(self.workQueue, ^{
                    [self.cacheInfo cacheHadBeenUsed:item];
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(YES);
                        });
                    }
                });
            } else {
                BOOL success = NO;
                NSString *filePath = [[self.service.config cachePath] stringByAppendingPathComponent:identifier];
                success = [data writeToFile:filePath atomically:YES];
                
                if (success) {
                    CMLCacheItem *item = [CMLCacheItem new];
                    [item setIdentifier:identifier];
                    [item setCacheType:@(kind)];
                    
                    NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                    [item setFileSize:fileAttribute[NSFileSize]];
                    
                    [self.cacheInfo addCacheInfo:item];
                }
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(success);
                    });
                }
            }
        });
    } else {
        if (completion) {
            completion(NO);
        }
    }
}

#pragma mark - Action methods

- (void)generateUrlInformation:(NSString *)url decode:(BOOL)decode completion:(void(^)(NSString *noQueryUrl, NSDictionary *param))completion
{
    NSString *decodedUrl = url;
    if (decode) {
        decodedUrl = [url CM_urlDecode];
    }
    [url CM_urlDecode];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *noQueryPath = nil;
    
    NSScanner *scanner = [NSScanner scannerWithString:decodedUrl];
    BOOL result = [scanner scanUpToString:@"?" intoString:&noQueryPath];
    if (!result) {//说明没有query，直接用原始URL就行了。
        noQueryPath = decodedUrl;
    }
    
    NSString *paramString = [[NSURL URLWithString:decodedUrl] query];
    NSArray *components = [paramString componentsSeparatedByString:@"&"];
    for (NSString *component in components) {
        NSArray *elementComponent = [component componentsSeparatedByString:@"="];
        if (elementComponent.count == 2) {
            [parameters setObject:[elementComponent lastObject] forKey:[elementComponent firstObject]];
        }
    }
    
    if (completion) {
        completion(noQueryPath, [parameters copy]);
    }
}

@end
