//
//  CMLInstanceManager.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import <Foundation/Foundation.h>
#import "CMLInstance.h"

@interface CMLInstanceManager : NSObject

/**
 * 单例实现
 **/
+ (instancetype)sharedManager;

- (CMLInstance *)instanceForIdentifier:(NSString *)identifier;

- (void)storeInstance:(CMLInstance *)instance identifier:(NSString *)identifier;

- (void)removeInstanceIdentifier:(NSString *)identifier;

@end

