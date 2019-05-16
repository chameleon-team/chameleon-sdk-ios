//
//  CMLInstanceManager.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import "CMLInstanceManager.h"

@interface CMLInstanceManager ()

@property (nonatomic, strong) NSMutableDictionary *instances;

@end

@implementation CMLInstanceManager

static CMLInstanceManager *__sharedManager = nil;
+ (instancetype)sharedManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__sharedManager == nil)
            __sharedManager = [[self alloc] init];
    });
    return __sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       _instances = [NSMutableDictionary dictionary];
    }
    return self;
}

- (CMLInstance *)instanceForIdentifier:(NSString *)identifier {
    if (!identifier) {
        return nil;
    }
    return _instances[identifier];
}

- (void)storeInstance:(CMLInstance *)instance identifier:(NSString *)identifier {
    
    if (!instance || !identifier) {
        return;
    }
    _instances[identifier] = instance;
}

- (void)removeInstanceIdentifier:(NSString *)identifier {
    
    if (!identifier) {
        return;
    }
    [_instances removeObjectForKey:identifier];
    
}

@end
