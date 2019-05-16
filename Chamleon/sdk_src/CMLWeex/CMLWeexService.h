//
//  CMLWeexService.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/25.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLCommonService.h"
#import "CMLWeexCache.h"
#import "CMLWeexConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLWeexService : CMLCommonService

@property (nonatomic, strong) CMLWeexCache *cache;

@property (nonatomic, strong) CMLWeexConfig *config;

- (void)setupPrefetch;

@end

NS_ASSUME_NONNULL_END
