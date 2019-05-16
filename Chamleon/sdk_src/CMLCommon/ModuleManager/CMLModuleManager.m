//
//  CMLModuleManager.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLModuleManager.h"
#import "CMLModuleConfig.h"

@interface CMLModuleManager ()
@property (nonatomic, strong) NSMutableDictionary *registeredModules;
@end

@implementation CMLModuleManager

static CMLModuleManager *__sharedManager = nil;
+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__sharedManager == nil)
            __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _registeredModules = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerModule:(NSString *)moduleName className:(NSString *)className {
    
    if (!moduleName || !className) return;
    CMLModuleConfig *export = _registeredModules[moduleName];
    if(!export){
        export = [[CMLModuleConfig alloc] initWithClassName:className];
        _registeredModules[moduleName] = export;
    }
}

- (CMLModuleConfig *)moduleWithName:(NSString *)moduleName {
    
    if(!moduleName) return nil;
    return _registeredModules[moduleName];
}

-(NSDictionary *)getAllModules {
    return _registeredModules;
}
@end
