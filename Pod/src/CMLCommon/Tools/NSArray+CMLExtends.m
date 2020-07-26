//
//  NSArray+ONTExtends.m
//  Pods
//
//  Created by zhanghuawei on 7/4/16.
//
//

#import "NSArray+CMLExtends.h"

@implementation NSArray (CMLExtends)

- (id)cml_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)cml_stringWithIndex:(NSUInteger)index{
    id value = [self cml_objectAtIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}


- (NSDictionary*)cml_dictionaryWithIndex:(NSUInteger)index {
    id value = [self cml_objectAtIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    
    return nil;
}

- (id)cml_objectAtIndex:(NSUInteger)index filter:(Class)filter {
    
    if ([NSArray cml_isEmpty:self]) {
        return nil;
    }
    
    if (index < self.count) {
        id value = [self objectAtIndex:index];
        if (value == nil) {
            return nil;
        }
        
        if (!filter) {
            return value;
        }
        
        if ([value isMemberOfClass:filter]) {
            return value;
        }
    }
    return nil;
}

+ (BOOL)cml_isValid:(NSArray *)array {
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return NO;
    }
    return YES;
}

+ (BOOL)cml_isEmpty:(NSArray *)array {
    if ([NSArray cml_isValid:array]) {
        return array.count < 1;
    }
    return YES;
}

@end

@implementation NSMutableArray(ONESafeAccess)

- (void)cml_addObject:(id)object{
    if (object == nil) {
        return;
    }
    [self addObject:object];
}

- (id)cml_objectAtIndex:(NSUInteger)index filter:(Class)filter {
    if ([NSMutableArray cml_isEmpty:self]) {
        return nil;
    }
    
    if (index < self.count) {
        id value = [self objectAtIndex:index];
        if (value == nil) {
            return nil;
        }
        
        if (!filter) {
            return value;
        }
        
        if ([value isMemberOfClass:filter]) {
            return value;
        }
    }
    return nil;
}

+ (BOOL)cml_isValid:(NSMutableArray *)array {
    if (!array || ![array isMemberOfClass:[NSMutableArray class]]) {
          return NO;
      }
      return YES;
}

+ (BOOL)cml_isEmpty:(NSMutableArray *)array {
    if ([self cml_isValid:array]) {
        return array.count < 1;
    }
    return YES;
}

@end

@implementation NSArray(ONEJSONString)

-(NSString *)cml_JSONString{
    NSString *jsonString = [self cml_JSONStringWithOptions:NSJSONWritingPrettyPrinted];
    return jsonString;
}

- (NSString *)cml_JSONStringWithOptions:(NSJSONWritingOptions)opt {
    NSError *error = nil;
    NSData *jsonData;
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                   options:opt
                                                     error:&error];
    } @catch (NSException *exception) {
        
    }
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from array: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
