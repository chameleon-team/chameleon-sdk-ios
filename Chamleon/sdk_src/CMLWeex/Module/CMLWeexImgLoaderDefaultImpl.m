//
//  CMLChameleonImgLoaderDefaultImpl.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/6/15.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexImgLoaderDefaultImpl.h"

#if __has_include("SocketRocket.h")
#import "SDWebImageManager.h"
#endif


@implementation CMLWeexImgLoaderDefaultImpl

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    if ([url hasPrefix:@"//"]) {
        url = [@"https:" stringByAppendingString:url];
    }
    
#if __has_include("SocketRocket.h")
    return (id<WXImageOperationProtocol>)[[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, finished);
        }
    }];
#endif
    
    return nil;
}

@end
