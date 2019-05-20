//
//  CMLCommonService.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLCache.h"
#import "CMLConfig.h"

NS_ASSUME_NONNULL_BEGIN

#define FILE_MANAGER ([NSFileManager defaultManager])

@interface CMLCommonService : NSObject

@property (nonatomic, strong) CMLCache *cache;

@property (nonatomic, strong) CMLConfig *config;

@end

NS_ASSUME_NONNULL_END
