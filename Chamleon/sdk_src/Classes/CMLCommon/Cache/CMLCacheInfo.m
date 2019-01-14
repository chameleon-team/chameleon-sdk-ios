//
//  CMLChameleonCacheInfo.m
//
//  Created by Chameleon-Team on 2018/6/6.
//

#import "CMLCacheInfo.h"
#import "CMLCommonService.h"

@interface CMLCacheInfo ()

- (void)saveInfo;
- (void)controlCacheSize:(CMLChameleonCacheKind)kind;
- (void)recursiveRemoveOldCache:(CMLChameleonCacheKind)kind;

@end

@implementation CMLCacheInfo

#pragma mark - Life cycle methods

+ (instancetype)loadCacheInfoWithService:(CMLCommonService *)service
{
    CMLCacheInfo *_instance = nil;
    NSString *filePath = [service.config cacheConfigPath];
    if (![FILE_MANAGER fileExistsAtPath:filePath]) {
        _instance = [[CMLCacheInfo alloc]init];
        _instance.service = service;
        [_instance saveInfo];
    } else {
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSError *error = nil;
        _instance = [[CMLCacheInfo alloc]initWithDictionary:data error:&error];
        _instance.service = service;
        if (!_instance && error) {
            [service.cache dropAllCache];
            _instance = [[CMLCacheInfo alloc]init];
            [_instance saveInfo];
        }
    }
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _runtimeQueueOrder = [NSMutableArray new];
        _prefetchQueueOrder = [NSMutableArray new];
        _cacheStorage = [NSMutableDictionary new];
        _runtimeCacheSize = @0;
        _prefetchCacheSize = @0;
    }
    return self;
}

#pragma mark -

- (void)saveInfo
{
    NSDictionary *data = [self toDictionary];
    [NSKeyedArchiver archiveRootObject:data toFile:[self.service.config cacheConfigPath]];
}

- (void)controlCacheSize:(CMLChameleonCacheKind)kind
{
    [self recursiveRemoveOldCache:kind];
}

- (void)recursiveRemoveOldCache:(CMLChameleonCacheKind)kind
{
    CMLConfig *config = self.service.config;
    if (kind == CMLChameleonCacheRuntime) {
        if (self.runtimeCacheSize.longLongValue >= [config maxRuntimeCacheSize].longLongValue) {
            CMLCacheItem *item = [self.runtimeQueueOrder firstObject];
            if ([item deleteItemFile]) {
                [self.runtimeQueueOrder removeObject:item];
                [self.cacheStorage removeObjectForKey:item.identifier];
                self.runtimeCacheSize = @(self.runtimeCacheSize.longLongValue - item.fileSize.longLongValue);
                [self saveInfo];
            }
            //清理一次之后再看看是不是还需要再次清理。
            if (self.runtimeCacheSize.longLongValue >= [config maxRuntimeCacheSize].longLongValue) {
                [self recursiveRemoveOldCache:kind];
            }
        }
    } else if (kind == CMLChameleonCachePrefetch) {
        if (self.prefetchCacheSize.longLongValue >= [config maxPrefetchCacheSize].longLongValue) {
            CMLCacheItem *item = [self.prefetchQueueOrder firstObject];
            if ([item deleteItemFile]) {
                [self.prefetchQueueOrder removeObject:item];
                [self.cacheStorage removeObjectForKey:item.identifier];
                self.prefetchCacheSize = @(self.prefetchCacheSize.longLongValue - item.fileSize.longLongValue);
                [self saveInfo];
            }
            //清理一次之后再看看是不是还需要再次清理。
            if (self.prefetchCacheSize.longLongValue >= [config maxPrefetchCacheSize].longLongValue) {
                [self recursiveRemoveOldCache:kind];
            }
        }
    }
}

#pragma mark - CRUD methods

- (void)addCacheInfo:(CMLCacheItem *)item
{
    if (item) {
        [self.cacheStorage setObject:item forKey:item.identifier];
        
        if (item.cacheType.integerValue == CMLChameleonCachePrefetch) {
            [self.prefetchQueueOrder addObject:item];
            [self setPrefetchCacheSize:@(self.prefetchCacheSize.integerValue + item.fileSize.integerValue)];
            [self controlCacheSize:CMLChameleonCachePrefetch];
        } else if (item.cacheType.integerValue == CMLChameleonCacheRuntime) {
            [self.runtimeQueueOrder addObject:item];
            [self setRuntimeCacheSize:@(self.runtimeCacheSize.integerValue + item.fileSize.integerValue)];
            [self controlCacheSize:CMLChameleonCacheRuntime];
        }
        
        [self saveInfo];
    }
}

- (void)removeCacheInfo:(CMLCacheItem *)item
{
    if (item) {
        [self.cacheStorage removeObjectForKey:item.identifier];
        CMLCacheItem *itemForRemove = nil;
        if (item.cacheType.integerValue == CMLChameleonCachePrefetch) {
            for (CMLCacheItem *itemForLookup in self.prefetchQueueOrder) {
                if ([itemForLookup.identifier isEqualToString:item.identifier]) {
                    itemForRemove = itemForLookup;
                    break;
                }
            }
            [self setPrefetchCacheSize:@(self.prefetchCacheSize.integerValue - item.fileSize.integerValue)];
        } else if (item.cacheType.integerValue == CMLChameleonCacheRuntime) {
            for (CMLCacheItem *itemForLookup in self.runtimeQueueOrder) {
                if ([itemForLookup.identifier isEqualToString:item.identifier]) {
                    itemForRemove = itemForLookup;
                    break;
                }
            }
            [self.runtimeQueueOrder removeObject:itemForRemove];
            [self setRuntimeCacheSize:@(self.runtimeCacheSize.integerValue - item.fileSize.integerValue)];
        } else {}
        [self saveInfo];
    }
}

- (CMLCacheItem *)getCacheInfo:(NSString *)identifier
{
    return [self.cacheStorage objectForKey:identifier];
}

- (void)cacheHadBeenUsed:(CMLCacheItem *)item
{
    if (item) {
        NSMutableArray *listSort = nil;
        if (item.cacheType.integerValue == CMLChameleonCachePrefetch) {
            listSort = self.prefetchQueueOrder;
        } else {
            listSort = self.runtimeQueueOrder;
        }
        
        CMLCacheItem *targetItem = nil;
        for (CMLCacheItem *element in listSort) {
            if ([element.identifier isEqualToString:item.identifier]) {
                targetItem = element;
                break;
            }
        }
        if (targetItem) {
            [listSort removeObject:targetItem];
            [listSort addObject:targetItem];
            [self saveInfo];
        }
    }
}

@end
