//
//  CMLCommonDefine.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#ifndef CMLCommonDefine_h
#define CMLCommonDefine_h

typedef NS_ENUM(NSInteger, CMLRenderURLType){
    CMLRenderURLTypeNone = 0,
    CMLRenderURLTypeRemoteBundle, //直接加载远端bundle
    CMLRenderURLTypeLocalBundle, //加载从远端下载到本地的bundle
    CMLRenderURLTypeDefaultLocalBundle, //加载默认本地兜底bundle
    CMLRenderURLTypeWeb, //加载web页
    CMLRenderURLTypeDefaultErrWeb, //加载默认的web err页
};

typedef NS_ENUM(NSInteger, CMLRenderFailerType){
    CMLRenderFailerTypeNone = 0,
    CMLRenderFailerTypeRemoteBundle, //远端bundle加载失败 1
    CMLRenderFailerTypeLocalBundle, //本地bundle加载失败 2
    CMLRenderFailerTypeURLDecode, //url内容decode失败 3
    CMLRenderFailerTypeWhiteList, //url内容decode成功，但是命中了强制web白名单 4
    CMLRenderFailerTypeBundleFailedNoHtmlHasLocalDefaultBundle, //bundle加载失败&webH5链接缺失&配置了本地默认bundle 5
    CMLRenderFailerTypeBundleFailedNoHtmlNoLocalDefaultBundle, //bundle加载失败&webH5链接缺失&没配置本地默认bundle 6
    CMLRenderFailerTypeWebFailedHasLocalDefaultBundle, //web加载失败&配置了本地默认bundle 7
    CMLRenderFailerTypeWebFailedNoLocalDefaultBundle, //web加载失败&没配置本地默认bundle 8
    CMLRenderFailerDefaultLocalBundle, //本地默认bundle加载失败 9
    CMLRenderFailerDefaultErrWeb, //默认错误web页加载失败 10
};


#define CML_COMMON_CACHE_PATH ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Chameleon"])


#endif /* CMLCommonDefine_h */
