//
//  CMLChameleonConfig.h
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import <Foundation/Foundation.h>



@interface CMLConfig : NSObject

@property (nonatomic, copy) NSString *appName;

@property (nonatomic, copy) NSString *appVersion;

/**
 *  自定义环境配置
 */
@property (nonatomic, strong) NSDictionary *customEnvConfig;

/**
 *  是否开启Chameleon功能（默认开启）
 */
@property (nonatomic, assign) BOOL isFeatureAvailable;

/**
 *  是否开启缓存（默认开启）
 */
@property (nonatomic, assign) BOOL isEnableCacheFeature;

/**
 *  Chameleon缓存目录(默认document）
 */
@property (nonatomic, copy) NSString *cachePath;

/**
 *  Chameleon配置缓存path（默认cachePath/config.weex)
 */
@property (nonatomic, copy) NSString *cacheConfigPath;

/**
 *  运行时缓存限制Size
 */
@property (nonatomic, strong) NSNumber *maxRuntimeCacheSize;

/**
 *  预加载缓存限制Size
 */
@property (nonatomic, strong) NSNumber *maxPrefetchCacheSize;

/**
 *  需要预加载的所有链接
 */
@property (nonatomic, strong) NSArray *prefetchContents;

/**
 * 如果prefetch不成功时，加载的本地默认页面内容Bundle键值对，key：页面标识 value：bundle路径
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *defaultBundlePaths;

/*
 * 加载的本地默认页面内容Bundle时透传给weex前端的参数
 */
@property (nonatomic, strong) NSDictionary *defaultParam;

/*
 * 业务方配置的默认错误web链接
 */
@property (nonatomic, strong) NSString *defaultErrUrl;

/*
 * 请求URL中的远端bundle地址（业务方客户端和FE协议制定)
 */
@property (nonatomic, copy) NSString *renderUrlParamKey;

/**
 * 添加本地默认bundle （Chameleon内部是通过原始请求链接检索本地bundle文件的，所以添加本地默认bundle的key必须是原始请求链接，否则本地降级方案不生效）
 *
 * @param bundlePath       本地bundle文件所在路径（键值对的value）
 * @param originBundleUrl  对应的原始请求链接（键值对的key）
 */
- (void)addDefaultBundlePath:(NSString *)bundlePath forOriginBundleUrl:(NSString *)originBundleUrl;

/*
 * 删除指定本地默认bundle
 *
 * @param bundlePath       本地bundle文件所在路径（键值对的value）
 * @param originBundleUrl  对应的原始请求链接（键值对的key）
 */
- (void)delDefaultBundlePath:(NSString *)bundlePath forOriginBundleUrl:(NSString *)originBundleUrl;

/**
 * 删除所有本地默认bundle
 */
- (void)removeAllDefaultBundlePath;


@end
