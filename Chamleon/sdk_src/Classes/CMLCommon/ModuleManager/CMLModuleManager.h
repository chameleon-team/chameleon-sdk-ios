//
//  CMLModuleManager.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import <Foundation/Foundation.h>
#import "CMLModuleConfig.h"

@interface CMLModuleManager : NSObject
/**
 * 单例实现
 **/
+ (instancetype)sharedManager;

- (void)registerModule:(NSString *)moduleName className:(NSString *)className;

- (CMLModuleConfig *)moduleWithName:(NSString *)moduleName;

- (NSDictionary *)getAllModules;



@end


