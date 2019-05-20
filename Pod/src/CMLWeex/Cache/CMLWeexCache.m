//
//  CMLWeexCache.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/26.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexCache.h"
#import "CMLEnvironmentManage.h"
#import "CMLCommonDefine.h"
#import "NSString+CMLExtends.h"
#import "NSDictionary+CMLExtends.h"

@implementation CMLWeexCache
#pragma mark - privateMethods(reload superClass)
- (void)prefetchJSBundleWithJSBundleUrl:(NSString *)url
{
    if (url.length) {
        //如果请求URL的各部分在缓存中都存在，则不执行请求
        //如果请求URL有未缓存部分，则请求去重后的URL，请求完之后添加至缓存
        NSString *separateStr = @"/??/";
        NSRange range = [url rangeOfString:separateStr];
        //单段js、正常多段js，都会去请求，
        if(range.location != NSNotFound){
            if([self newComponentsAfterRemoveDuplicateJsBundleWithOriginUrl:url].count == 0){
                return;
            }
        }
        
        NSURL *requestURL = [NSURL URLWithString:url];
        if (requestURL) {
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_barrier_async(self.workQueue, ^{
                    [self addJSBundleCache:data originUrl:url kind:CMLChameleonCachePrefetch completion:nil];
                });
            }];
            [task resume];
        }
        
    }
}

- (void)getBundleCacheOfJSBundleUrl:(NSString *)url completion:(void(^)(NSString *url, NSDictionary *parameter))completion
{
    dispatch_async(self.workQueue, ^{
        NSString *noQueryPath;
        NSString *filePath = nil;
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        
        //1、透传参数
        NSString *paramString = [[NSURL URLWithString:url] query];
        NSArray *components = [paramString componentsSeparatedByString:@"&"];
        for (NSString *component in components) {
            NSArray *elementComponent = [component componentsSeparatedByString:@"="];
            if (elementComponent.count == 2) {
                [parameters setObject:[elementComponent lastObject] forKey:[elementComponent firstObject]];
            }
        }
        
        //2、判断是否有多段js
        NSString *separateStr = @"/??/";
        NSRange range = [url rangeOfString:separateStr];
        if(range.location == NSNotFound){
            //url里没有多段js参数，直接拿本地路径或url进行渲染
            CMLCacheItem *item = [self getCacheItemWithUrl:url];
            if(item){
                filePath = item.filePath;
                [parameters cml_setValue:@(CMLRenderURLTypeLocalBundle) forKey:@"renderType"];
            } else {
                filePath = url;
                [parameters cml_setValue:@(CMLRenderURLTypeRemoteBundle) forKey:@"renderType"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(filePath, parameters);
                }
            });
            
        } else {
            [parameters cml_setValue:@(CMLRenderURLTypeLocalBundle) forKey:@"renderType"];
            noQueryPath = [url substringToIndex:range.location];
            //URL里有多段js参数的情况下，三步
            //第一步：请求本地无缓存的差量部分
            //第二步：读取本地有缓存的缓存部分
            //第三步：组合
            NSArray *originJsKeyArray = [self jsBundleKeyNameArrayFromUrlString:url];
            NSArray *newJsNameArray = [self newComponentsAfterRemoveDuplicateJsBundleWithOriginUrl:url];
            if(newJsNameArray.count > 0){
                //差量部分拼接出的请求URL
                NSString *newUrl;
                NSString *queryPath;
                if(newJsNameArray.count > 1){
                    queryPath = [noQueryPath stringByAppendingPathComponent:@"/??/"];
                } else {
                    queryPath = noQueryPath;
                }
                newUrl = [queryPath stringByAppendingPathComponent:[newJsNameArray componentsJoinedByString:@","]];
                NSURL *requestURL = [NSURL URLWithString:newUrl];
                
                //遍历keyName数组，删掉URL请求部分，获取本地有缓存的部分，cacheJsKeyNameArray
                NSMutableArray *cacheJsKeyNameArray = [[NSMutableArray alloc] initWithArray:originJsKeyArray];
                for(NSString *jsName in newJsNameArray){
                    NSString *jsKeyName = [noQueryPath stringByAppendingPathComponent:jsName];
                    if([cacheJsKeyNameArray containsObject:jsKeyName]){
                        [cacheJsKeyNameArray removeObject:jsKeyName];
                    }
                }
                
                //组合
                [self combineWeexDataWithrequestURL:requestURL OriginJSKeyArr:originJsKeyArray cacheJSKeyArr:cacheJsKeyNameArray parameters:parameters completion:completion];
            } else {
                //全部都有缓存，直接从缓存中取出所有文件，将data拼装成一个新的path，扔给weex
                [self combineWeexDataWithrequestURL:nil OriginJSKeyArr:originJsKeyArray cacheJSKeyArr:originJsKeyArray parameters:parameters completion:completion];
            }
        }
    });
}

//本地+网络数据组合方法：
//参数1：差量请求URL（获得网络Data）
//参数2：原始模板（模板）
//参数3：缓存keys（获得缓存Data）
//参数4：请求透传参数列表
//参数5：渲染回调
- (void)combineWeexDataWithrequestURL:(NSURL *)requestURL
                       OriginJSKeyArr:(NSArray *)originJSKeyArr
                        cacheJSKeyArr:(NSArray *)cacheJSKeyArr
                           parameters:(NSDictionary *)parameters
                           completion:(void(^)(NSString *url, NSDictionary *parameter))completion{
    dispatch_group_t combineGroup = dispatch_group_create();
    dispatch_queue_t combineGroupQueue = dispatch_queue_create("com.chameleon.chameleon.combineData", DISPATCH_QUEUE_CONCURRENT);
    __block NSMutableDictionary *jsDataDict;
    
    if (requestURL) {
        dispatch_group_enter(combineGroup);
        dispatch_async(combineGroupQueue, ^{
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary *jsNetDataDict = [self jsBundleDataDictFromHtmlData:data url:requestURL.absoluteString];
                if(!jsDataDict){
                    jsDataDict = [[NSMutableDictionary alloc] initWithDictionary:jsNetDataDict];
                } else {
                    [jsDataDict addEntriesFromDictionary:jsNetDataDict];
                }
                
                dispatch_group_leave(combineGroup);
                dispatch_barrier_async(self.workQueue, ^{
                    [self addJSBundleCache:data originUrl:requestURL.absoluteString kind:CMLChameleonCachePrefetch completion:nil];
                });
            }];
            [task resume];
        });
    }
    
    if(!jsDataDict){
        jsDataDict = [NSMutableDictionary new];
    }
    
    
    [cacheJSKeyArr enumerateObjectsUsingBlock:^(NSString *cachedjskey, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(combineGroup);
        dispatch_async(combineGroupQueue, ^{
            NSString *identifier = [cachedjskey CM_MD5];
            CMLCacheItem *item = [self.cacheInfo getCacheInfo:identifier];
            if(item.filePath.length > 0){
                NSData *data = [NSData dataWithContentsOfFile:item.filePath];
                NSString *cachedDataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [jsDataDict cml_setValue:cachedDataStr forKey:cachedjskey];
            }
            dispatch_group_leave(combineGroup);
        });
    }];
    
    
    dispatch_group_notify(combineGroup, combineGroupQueue, ^{
        NSMutableString *htmlStr = [NSMutableString new];
        for(NSString *jsKeyStr in originJSKeyArr){
            NSString *jsData = [jsDataDict objectForKey:jsKeyStr];
            if(jsData.length > 0){
                [htmlStr appendString:jsData];
            }
        }
        NSString *filePath = [[[CMLEnvironmentManage chameleon].weexService.config cachePath] stringByAppendingPathComponent:@"finallyPath"];
        BOOL success = [[htmlStr dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(filePath, parameters);
                }
            });
        }
    });
}


#pragma mark - publicMethods
- (void)addJSBundleCache:(NSData *)data originUrl:(NSString *)originUrl kind:(CMLChameleonCacheKind)kind completion:(void(^)(BOOL success))completion {
    if([originUrl hasPrefix:@"http"]){
        NSString *noQueryPath = nil;
        NSString *separateStr = @"/??/";
        NSRange range = [originUrl rangeOfString:separateStr];
        if(range.location == NSNotFound){//没有??，说明只有一个js文件
            [self addJSBundleCache:data url:originUrl kind:kind completion:completion];
        } else {
            //拆分出各个小模块的key
            noQueryPath = [originUrl substringToIndex:range.location];
            
            //拆分出各个小模块的value
            NSDictionary *jsDataDict = [self jsBundleDataDictFromHtmlData:data url:originUrl];
            
            [jsDataDict enumerateKeysAndObjectsUsingBlock:^(NSString *jskey, NSString *jsDataStr, BOOL * _Nonnull stop) {
                [self addJSBundleCache:[jsDataStr dataUsingEncoding:NSUTF8StringEncoding] url:jskey kind:kind completion:completion];
            }];
        }
    }
}

#pragma mark - cache tool methods

- (CMLCacheItem *)getCacheItemWithUrl:(NSString *)url
{
    NSString *identifier = [url CM_MD5];
    CMLCacheItem *info = [self.cacheInfo getCacheInfo:identifier];
    return info;
}

//根据URL和data，获取到jsBundleName和内容对应的缓存键值对
//例：@"https://www.example.com/nodejs_v5/a.js" = @"balabala...."
- (NSDictionary *)jsBundleDataDictFromHtmlData:(NSData *)data url:(NSString *)url
{
    NSMutableDictionary *jsBundleDataDict = [NSMutableDictionary new];
    NSString *separateStr = @"/??/";
    NSString *noQueryPath = nil;
    
    NSString *originHtmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *jsDataArray = [originHtmlStr componentsSeparatedByString:@"/*============("];
    NSMutableArray *jsDataArrayM = [[NSMutableArray alloc] initWithArray:jsDataArray];
    [jsDataArrayM removeObjectAtIndex:0];
    
    NSRange range = [url rangeOfString:separateStr];
    if(range.location == NSNotFound){
        if(jsDataArrayM.count == 1){
            NSString *jsKeyStr = url;
            NSString *jsString = [jsDataArrayM firstObject];
            NSString *jsDataStr = [@"/*============(" stringByAppendingString:jsString];
            //填写键值对
            [jsBundleDataDict cml_setValue:jsDataStr forKey:jsKeyStr];
        } else {
            return nil;
        }
    } else {
        noQueryPath = [url substringToIndex:range.location];
        for(NSString *string in jsDataArrayM){
            
            NSRange rangeJS = [string rangeOfString:@".js"];
            if(rangeJS.location != NSNotFound){
                //key
                NSString *jsName = [string substringToIndex:rangeJS.location + rangeJS.length];
                NSString *jsKeyStr = [jsName stringByAppendingPathComponent:@""];
                
                //value
                NSString *jsDataStr = [@"/*============(" stringByAppendingString:string];
                
                //填写键值对
                [jsBundleDataDict cml_setValue:jsDataStr forKey:jsKeyStr];
            }
        }
    }
    
    return jsBundleDataDict;
}

//获取本地缓存去重后，URL中的jsBundle部分数组
- (NSArray *)newComponentsAfterRemoveDuplicateJsBundleWithOriginUrl:(NSString *)url
{
    NSString *noQueryPath = nil;
    NSString *separateStr = @"/??/";
    
    NSRange range = [url rangeOfString:separateStr];
    if(range.location == NSNotFound){
        return nil;
    } else {
        noQueryPath = [url substringToIndex:range.location];
        NSArray *components = [self jsBundleNameArrayFromUrlString:url];
        NSMutableArray *newComponents = [[NSMutableArray alloc] initWithArray:components];
        for (NSString *jsName in components) {
            NSMutableString *jsKeyUrl = [[NSMutableString alloc] initWithString:noQueryPath];
            NSString *cacheUrl = [jsKeyUrl stringByAppendingPathComponent:jsName];
            if([self getCacheItemWithUrl:cacheUrl]){
                [newComponents removeObject:jsName];
            }
        }
        if(newComponents.count > 0){
            return newComponents;
        } else {
            return nil;
        }
    }
}

//根据URL获取到JSBundleName，例
//输入：
//https://www.example.com/v5/??/nodejs_v5/common.js,/nodejs_v5/a.js,/nodejs_v5/b.js
//输出：
//[nodejs_v5/common.js, nodejs_v5/a.js, nodejs_v5/b.js]
- (NSArray *)jsBundleNameArrayFromUrlString:(NSString *)url
{
    NSString *separateStr = @"/??/";
    NSRange range = [url rangeOfString:separateStr];
    if(range.location != NSNotFound){
        NSString *paramString = [url substringFromIndex:range.location + range.length];
        NSArray *components = [paramString componentsSeparatedByString:@","];
        return components;
    } else {
        return nil;
    }
}

//根据URL获取到JSBundleKeyName，例
//输入：
//https://www.example.com/v5/??/nodejs_v5/common.js,/nodejs_v5/a.js,/nodejs_v5/b.js
//输出：
//[https://www.example.com/v5/nodejs_v5/common.js, https://www.example.com/v5/nodejs_v5/a.js, https://integ-wise.example.com/v5/nodejs_v5/b.js]
- (NSArray *)jsBundleKeyNameArrayFromUrlString:(NSString *)url
{
    NSString *separateStr = @"/??/";
    NSRange range = [url rangeOfString:separateStr];
    if(range.location != NSNotFound){
        NSString *noQueryPath = [url substringToIndex:range.location];
        NSString *paramString = [url substringFromIndex:range.location + range.length];
        NSArray *components = [paramString componentsSeparatedByString:@","];
        NSMutableArray *keyNameComponents = [NSMutableArray new];
        for(NSString *jsName in components){
            [keyNameComponents addObject:[noQueryPath stringByAppendingPathComponent:jsName]];
        }
        return keyNameComponents;
    } else {
        return nil;
    }
}

@end
