//
//  CMLChameleonCache.h
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import <Foundation/Foundation.h>
#import "CMLCacheItem.h"
#import "CMLCacheInfo.h"

@class CMLCommonService;
/*
 并行读，串行写。
 所有操作均在子线程完成，然后主线程回调。
 */

@interface CMLCache : NSObject

@property (nonatomic, strong) dispatch_queue_t workQueue;

@property (nonatomic, strong) CMLCacheInfo *cacheInfo;

/**
 初始化，传入需要提供缓存服务的service
 */
- (instancetype)initWithService:(CMLCommonService *)service;

/**
 预加载JSBundle
 */
- (void)prefetchJSBundle;

/**
 移除所有的缓存。
 */
- (void)dropAllCache;

/**
 移除特定URL对应的缓存。

 @param url url
 */
- (void)dropCacheOfJSBundleUrl:(NSString *)url;

/**
 根据URL获取对应的本地缓存地址。
 如果本地没有缓存的时候，会返回传入的url不带任何参数后的请求地址。

 @param url url
 @param completion 回调，parameter是url中所带的query。
 */
- (void)getBundleCacheOfJSBundleUrl:(NSString *)url completion:(void(^)(NSString *url, NSDictionary *parameter))completion;

/**
 添加JSBundle的离线缓存。
 在添加的时候，会检查缓存是否超过大小。(缓存会被自动清理。)
 
 @param data JSBundle的data。
 @param url 对应的url
 @param kind 缓存的类型。
 @param completion 成功或者失败的回调。
 */
- (void)addJSBundleCache:(NSData *)data url:(NSString *)url kind:(CMLChameleonCacheKind)kind completion:(void(^)(BOOL success))completion;

/**
 获取URL的处理方法。（工具方法）

 @param url 原始的URL
 @param decode YES则会decode
 @param completion 结果的回调，noQueryURL就是原始的没有参数的url，param是url的query集合
 */
- (void)generateUrlInformation:(NSString *)url decode:(BOOL)decode completion:(void(^)(NSString *noQueryUrl, NSDictionary *param))completion;

@end
