//
//  CMLChameleon.m
//
//  Created by Chameleon-Team on 2018/5/30.
//

#import "CMLInstance.h"
#import "CMLInstanceManager.h"
#import "CMLModuleProtocol.h"

@interface CMLInstance ()

@property (nonatomic, strong) NSMutableDictionary *mInstances;

@end

@implementation CMLInstance

- (void)destroyInstance {
    
    NSString *indentifier = [NSString stringWithFormat:@"instance_%lud", (unsigned long)self.hash];
    [[CMLInstanceManager sharedManager] removeInstanceIdentifier:indentifier];
    
}

- (void)createdInstance {
    
    NSString *indentifier = [NSString stringWithFormat:@"instance_%lud", (unsigned long)self.hash];
    [[CMLInstanceManager sharedManager] storeInstance:self identifier:indentifier];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mInstances = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (id)instanceForClass:(Class)clazz instanceId:(NSString *)instanceId
{
    if(!clazz) return nil;
    
    NSString *clsName = NSStringFromClass(clazz);
    
    id <CMLModuleProtocol>instance = _mInstances[clsName];
    if(!instance){
        instance = [[clazz alloc] init];
        instance.cmlInstance = [[CMLInstanceManager sharedManager] instanceForIdentifier:instanceId];
        _mInstances[clsName] = instance;
    }
    return instance;
}

@end
