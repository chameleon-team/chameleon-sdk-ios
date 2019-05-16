//
//  CMLModuleBridge.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import "CMLModuleBridge.h"
#import "NSURL+CML.h"
#import "CMLConstants.h"
#import "NSString+CMLExtends.h"
#import "CMLUtility.h"
#import "CMLModuleManager.h"
#import "CMLCallBackList.h"

@interface CMLModuleBridge ()

@property (nonatomic, strong) CMLCallBackList *callBackList;

@end

@implementation CMLModuleBridge

- (CMLCallBackList *)callBackList
{
    if(_callBackList == nil){
        _callBackList = [CMLCallBackList new];
    }
    return _callBackList;
}

- (void)handleBridgeURL:(NSURL *)url instanceId:(NSString *)instanceId
{
    if(!url) return;
    
//    NSString *methodName = url.host;
    NSDictionary *params = [url cml_queryDict];
    NSString *actionName = params[@"action"];
    NSString *callBackId = params[@"callbackId"];
    NSDictionary *arguments = _CMLObjectFromJSON(params[@"args"]);
    
    if([actionName isEqualToString:@"invokeNativeMethod"]){
        [self callNative:params[@"module"] methodName:params[@"method"] arguments:arguments instanceId:instanceId callBackId:callBackId];
    }
    else if([actionName isEqualToString:@"callbackNative"]){
        [self callBackNative:params[@"method"] arguments:arguments];
    }
}

- (void)callBackJS:(NSString *)cbName arguments:(id)arguments callBackId:(NSString *)callBackId
{
    if(!cbName){
        return;
    }
    id args;
    if ([arguments isKindOfClass:[NSDictionary class]]) {
         args = [self JSArgsDictWithArguments:arguments callBackId:callBackId];
        
    }else if ([arguments isKindOfClass:[NSArray class]]){
        args = [self JSArgsArrayWithArguments:arguments callBackId:callBackId];
        
    }
    NSString *argsStr = _CMLJSONStringWithObject(args);
    argsStr = [argsStr CM_urlEncode];
    
    NSString *script = [NSString stringWithFormat:@"%@://channel?action=%@&args=%@&callbackId=%@",CMLCallBackBridgeScheme,cbName,argsStr,callBackId];

    if(script && [self.delegate respondsToSelector:@selector(executeScript:handler:)]){
        [self.delegate executeScript:script handler:nil];
    }
}

- (void)invokeJsMethod:(NSString *)moduleName methodName:(NSString *)methodName arguments:(id)arguments
{
    if(!moduleName || !methodName){
        return;
    }
    id args;
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        args = [self JSArgsDictWithArguments:arguments callBackId:nil];
        
    }else if ([arguments isKindOfClass:[NSArray class]]){
        args = [self JSArgsArrayWithArguments:arguments callBackId:nil];
        
    }
    NSString *argsStr = _CMLJSONStringWithObject(args);
    argsStr = [argsStr CM_urlEncode];
    
    NSString *script = [NSString stringWithFormat:@"%@://channel?action=%@&module=%@&method=%@&args=%@",CMLCallBackBridgeScheme,@"invokeJsMethod",moduleName,methodName,argsStr];
    
    if(script && [self.delegate respondsToSelector:@selector(executeScript:handler:)]){
        [self.delegate executeScript:script handler:nil];
    }
}


- (void)callBackNative:(NSString *)cbName arguments:(NSDictionary *)arguments
{
    if(!cbName){
        return;
    }
    CMLMoudleCallBack callback = [_callBackList getCallback:cbName];
    if(callback){
        callback(arguments);
    }
}

- (void)callNative:(NSString *)moduleName methodName:(NSString *)methodName arguments:(NSDictionary *)arguments instanceId:(NSString *)instanceId callBackId:(NSString *)callBackId
{
    if(!moduleName || !methodName) return;
    
    CMLModuleConfig *exportModule = [[CMLModuleManager sharedManager] moduleWithName:moduleName];
    
    if(!exportModule){
        return;
    }
    id target = [exportModule targetForMethodName:methodName instanceId:instanceId];
    if(!target){
        return;
    }
    SEL selector = [exportModule selectorForMethodName:methodName];
    if(!selector) return;
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        return;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    [invocation retainArguments];
    [self doInvocation:invocation arguments:arguments callBackId:callBackId];
}

- (void)doInvocation:(NSInvocation *)invocation arguments:(NSDictionary *)arguments callBackId:(NSString *)callBackId
{
    
    NSMethodSignature *signature = invocation.methodSignature;
    
    for(int i = 0; i < signature.numberOfArguments - 2; i++){
        const char *objCType = [signature getArgumentTypeAtIndex:i + 2];
    
        if(strncmp(objCType, "@?", 2) == 0){
            __weak typeof(self) weakSelf = self;
            CMLMoudleCallBack callback = ^(id args){
                [weakSelf callBackJS:@"callbackToJs" arguments:args callBackId:callBackId];
            };
            [invocation setArgument:(void *)&callback atIndex:i + 2];
            
        }else if(*objCType == '@'){
            id value = arguments;
            if(value == [NSNull null]){ value = nil; }
            [invocation setArgument:(void *)&value atIndex:i + 2];
        }
    }
    [invocation invoke];
}

- (NSMutableArray *)JSArgsArrayWithArguments:(id)arguments callBackId:(NSString *)callBackId
{
    
    NSMutableArray *args = [NSMutableArray array];
    
    for(id arg in arguments){
        if([arg isKindOfClass:NSClassFromString(@"NSBlock")]){
            NSString *cbName = [self.callBackList setCallback:arg callBackId:callBackId];
            NSString *jsFunc = [NSString stringWithFormat:@"%@", cbName];
            [args addObject:jsFunc];
            
        } else if([arg isKindOfClass:[NSString class]] ||
                  [arg isKindOfClass:[NSNumber class]] ||
                  [arg isKindOfClass:[NSArray class]] ||
                  [arg isKindOfClass:[NSDictionary class]]){
            [args addObject:arg];
        }
    }
    return args;
}
- (NSMutableDictionary *)JSArgsDictWithArguments:(id)arguments callBackId:(NSString *)callBackId
{
    
    NSMutableDictionary *argsDict = [NSMutableDictionary dictionary];
    
    for(id arg in ((NSDictionary*)arguments).allKeys){
        
        if([arguments[arg] isKindOfClass:[NSString class]] ||
           [arguments[arg] isKindOfClass:[NSNumber class]] ||
           [arguments[arg] isKindOfClass:[NSArray class]] ||
           [arguments[arg] isKindOfClass:[NSDictionary class]]){
           [argsDict setObject:arguments[arg] forKey:arg];
        }
        
        if([arguments[arg] isKindOfClass:NSClassFromString(@"NSBlock")]){
            NSString *cbName = [self.callBackList setCallback:arguments[arg] callBackId:callBackId];
            NSString *jsFunc = [NSString stringWithFormat:@"%@", cbName];
            [argsDict setObject:jsFunc forKey:arg];
        }
    }
    return argsDict;
}
@end
