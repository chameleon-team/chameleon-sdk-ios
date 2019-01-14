//
//  CMLModuleConfig.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLModuleConfig.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "CMLModuleMethodConfig.h"
#import "CMLInstanceManager.h"

@interface CMLModuleConfig ()

@end

@implementation CMLModuleConfig

- (instancetype)init
{
    self = [super init];
    if(self){
        _methods = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithClassName:(NSString *)clsName
{
    self = [self init];
    if(self){
        _clsName = clsName;
        [self loadModuleMethods];
    }
    return self;
}
- (void)loadModuleMethods
{
    unsigned int outCount = 0;
    Class cls = NSClassFromString(_clsName);
    
    Method *methods = class_copyMethodList(object_getClass(cls), &outCount);
    
    for(int i = 0; i < outCount; i++){
        NSString *selStr = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
        
        NSString *methodName = nil, *method = nil;
        SEL selector = NSSelectorFromString(selStr);
        if ([cls respondsToSelector:selector]) {
            method = ((NSString* (*)(id, SEL))[cls methodForSelector:selector])(cls, selector);
        }
        NSRange range = [method rangeOfString:@":"];
        if (range.location != NSNotFound) {
            methodName = [method substringToIndex:range.location];
        } else {
            methodName = method;
        }
        
        CMLModuleMethodConfig *moduleMethod = [CMLModuleMethodConfig new];
        moduleMethod.methodName = methodName;
        moduleMethod.selector = NSSelectorFromString(method);
        
        _methods[moduleMethod.methodName] = moduleMethod;
    }
    
    if(methods) free(methods);
}

- (id)targetForMethodName:(NSString *)methodName instanceId:(NSString *)instanceId
{
    if(!methodName || !_clsName) return nil;
    
    CMLModuleMethodConfig *method = _methods[methodName];
    if(!method){
        return nil;
    }
    Class clazz = NSClassFromString(_clsName);
    if(!clazz){
        return nil;
    }
    CMLInstance *instance = [[CMLInstanceManager sharedManager] instanceForIdentifier:instanceId];
    if (!instance) {
        return nil;
    }
    return [instance instanceForClass:clazz instanceId:instanceId];
}

- (SEL)selectorForMethodName:(NSString *)methodName
{
    if(!methodName) return nil;
    
    CMLModuleMethodConfig *method = _methods[methodName];
    if(!method){
        return nil;
    }
    return method.selector;
}


@end
