//
//  CMLCallBackList.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLCallBackList.h"

@interface CMLCallBackList()

@property (nonatomic, strong) NSMutableDictionary *callbacks;

@end

@implementation CMLCallBackList

- (instancetype)init
{
    self = [super init];
    if(self){
        _callbacks = [NSMutableDictionary dictionary];
    }
    return self;
}
static NSUInteger __cbName = 0;
- (NSString *)setCallback:(CMLMoudleCallBack)callback callBackId:(NSString *)callBackId
{
    if (!callBackId || callBackId.length <= 0) {
        return [self setCallback:callback];
    }
    NSString *cbName = nil;
    if(callback){
        cbName = [NSString stringWithFormat:@"%@",callBackId];
        _callbacks[cbName] = callback;
        __cbName ++;
    }
    return cbName;
}

- (NSString *)setCallback:(CMLMoudleCallBack)callback
{
    
    NSString *cbName = nil;
    if(callback){
        cbName = [NSString stringWithFormat:@"cml_callback_%lu", (unsigned long)__cbName];
        _callbacks[cbName] = callback;
        __cbName ++;
    }
    return cbName;
}

- (CMLMoudleCallBack)getCallback:(NSString *)cbName
{
    if(cbName){
        return _callbacks[cbName];
    }
    return nil;
}


@end
