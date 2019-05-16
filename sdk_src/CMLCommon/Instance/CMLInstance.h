//
//  CMLChameleon.h
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import <Foundation/Foundation.h>
#import "CMLEnvironmentManage.h"

@interface CMLInstance : NSObject

@property (nonatomic, weak) id viewController;

@property (nonatomic, assign) CMLServiceType currentEnvironment;

- (id)instanceForClass:(Class)clazz instanceId:(NSString *)instanceId;
- (void)createdInstance;
- (void)destroyInstance;

@end
