//
//  NSURL+CML.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "NSURL+CML.h"
#import <objc/runtime.h>

@implementation NSURL (CML)
- (NSURLComponents *)cml_URLComponents
{
    id object = objc_getAssociatedObject(self, _cmd);
    if(!object){
        object = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

- (NSDictionary *)cml_queryDict
{
    id object = objc_getAssociatedObject(self, _cmd);
    if(!object){
        NSArray<NSURLQueryItem *> *querItems = [[self cml_URLComponents] queryItems];
        
        object = [NSMutableDictionary dictionary];
        [querItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.name){
                [object setValue:obj.value?:@"" forKey:obj.name];
            }
        }];
        
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

@end
