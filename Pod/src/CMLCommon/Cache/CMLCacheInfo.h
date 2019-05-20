//
//  CMLChameleonCacheInfo.h
//
//  Created by Chameleon-Team on 2018/6/6.
//

#import <JSONModel/JSONModel.h>
/*
 这里面的方法都是给CMLChameleonCache用的。不是这个模块的修改就别看了。
 */
#import "CMLCacheItem.h"

@class CMLCommonService;
@interface CMLCacheInfo : JSONModel

@property (nonatomic, weak) CMLCommonService <Ignore> *service;

@property (nonatomic, strong) NSNumber <Optional> *runtimeCacheSize;
@property (nonatomic, strong) NSMutableArray <Optional> *runtimeQueueOrder;

@property (nonatomic, strong) NSNumber <Optional> *prefetchCacheSize;
@property (nonatomic, strong) NSMutableArray <Optional> *prefetchQueueOrder;

@property (nonatomic, strong) NSMutableDictionary <Optional> *cacheStorage;

+ (instancetype)loadCacheInfoWithService:(CMLCommonService *)service;

- (void)addCacheInfo:(CMLCacheItem *)item;
- (void)removeCacheInfo:(CMLCacheItem *)item;
- (CMLCacheItem *)getCacheInfo:(NSString *)identifier;

- (void)cacheHadBeenUsed:(CMLCacheItem *)item;

@end
