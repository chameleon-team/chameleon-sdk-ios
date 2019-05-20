//
//  CMLChameleonCacheItem.h
//
//  Created by Chameleon-Team on 2018/6/6.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, CMLChameleonCacheKind) {
    CMLChameleonCacheUnknown = 0,
    CMLChameleonCachePrefetch,
    CMLChameleonCacheRuntime,
};

@interface CMLCacheItem : JSONModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *cacheType;
@property (nonatomic, strong) NSNumber *fileSize;

- (NSString *)filePath;
- (BOOL)deleteItemFile;

@end
