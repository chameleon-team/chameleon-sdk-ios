//
//  CMLWeexCache.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/26.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLWeexCache : CMLCache

/**
 添加JSBundle的离线缓存。（支持增量更新，在添加时会将URL中的多个js数据区分为小块存储）
 在添加的时候，会检查缓存是否超过大小。(缓存会被自动清理。)
 
 @param data JSBundle的data。
 @param originUrl 对应的originUrl
 @param kind 缓存的类型。
 @param completion 成功或者失败的回调。
 */
- (void)addJSBundleCache:(NSData *)data originUrl:(NSString *)originUrl kind:(CMLChameleonCacheKind)kind completion:(void(^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
