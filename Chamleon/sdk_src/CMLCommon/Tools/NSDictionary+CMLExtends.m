//
//  NSDictionary+CMLExtends.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/26.
//

#import "NSDictionary+CMLExtends.h"

@implementation NSDictionary (CMLSafeAccess)

- (BOOL)cml_hasKey:(NSString *)key {
    return [self objectForKey:key] != nil;
}

- (NSString*)cml_stringForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSString*)cml_stringForKey:(id)key defaultValue:(NSString *)defaultValue {
    if (key != nil && [key conformsToProtocol: @protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null]) {
            if ([ret isKindOfClass:[NSString class]]) {
                return ret;
            }
            else if ([ret isKindOfClass:[NSDecimalNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
            else if ([ret isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
        }
    }
    
    return defaultValue;
}

- (NSNumber*)cml_numberForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    
    return nil;
}

- (NSDecimalNumber *)cml_decimalNumberForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    
    return nil;
}

- (NSArray*)cml_arrayForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return nil;
}

- (NSDictionary*)cml_dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    return nil;
}

- (NSInteger)cml_integerForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    
    return 0;
}

- (NSUInteger)cml_unsignedIntegerForKey:(id)key{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:value];
        return [number unsignedIntegerValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    
    return 0;
}

- (BOOL)cml_boolForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    
    return NO;
}

// 从 NSDictionary 中获取 key 对应的 bool 型value; 若无，则返回 defaultValue
- (BOOL)cml_boolForKey:(id)key defaultValue:(BOOL)defaultValue {
    if (key != nil && [key conformsToProtocol: @protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
            return [ret boolValue];
        }
    }
    
    return defaultValue;
}

- (int16_t)cml_int16ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    
    return 0;
}

- (int32_t)cml_int32ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    
    return 0;
}

- (int64_t)cml_int64ForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    
    return 0;
}

- (char)cml_charForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value charValue];
    }
    
    return 0;
}

- (short)cml_shortForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    
    return 0;
}

- (float)cml_floatForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    
    return 0;
}

- (double)cml_doubleForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    
    return 0;
}

- (long long)cml_longLongForKey:(id)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    
    return 0;
}

- (unsigned long long)cml_unsignedLongLongForKey:(id)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (NSDate *)cml_dateForKey:(id)key dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] &&dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

- (CGFloat)cml_CGFloatForKey:(id)key {
    id value = self[key];
    
    if ([value respondsToSelector:@selector(doubleValue)]) {
        CGFloat f = [self[key] doubleValue];
        return f;
    }
    
    return 0;
}

- (CGPoint)cml_pointForKey:(id)key {
    NSString *value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return CGPointFromString(value);
    }
    
    return CGPointZero;
}

- (CGSize)cml_sizeForKey:(id)key {
    NSString *value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    
    return CGSizeZero;
}

- (CGRect)cml_rectForKey:(id)key {
    NSString *value = self[key];
    if ([value isKindOfClass:[NSString class]]) {
        return CGRectFromString(value);
    }
    
    return CGRectNull; // (origin = (x = +Inf, y = +Inf), size = (width = 0, height = 0))
}
@end

@implementation NSMutableDictionary (ONESafeAccess)

- (void)cml_setValue:(id)i forKey:(NSString*)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    if (i != nil) {
        [self setValue:i forKey:key];
    }
}

// 在aValue为nil时，删除原来的key
- (void)cml_setValueEx:(id)aValue forKey:(NSString *)aKey {
    if (!aKey) {
        NSParameterAssert(aKey);
        return;
    }
    
    if (aValue != nil) {
        [self setValue:aValue forKey:aKey];
    } else {
        [self removeObjectForKey:aKey];
    }
}

- (void)cml_setString:(NSString*)i forKey:(NSString*)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    [self setValue:i forKey:key];
}

- (void)cml_setBool:(BOOL)i forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setInt:(int)i forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setInteger:(NSInteger)i forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setCGFloat:(CGFloat)f forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(f);
}

- (void)cml_setChar:(char)c forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(c);
}

- (void)cml_setFloat:(float)i forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

-(void)cml_setDouble:(double)i forKey:(NSString*)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setLongLong:(long long)i forKey:(NSString*)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = @(i);
}

- (void)cml_setPoint:(CGPoint)o forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = NSStringFromCGPoint(o);
}

- (void)cml_setSize:(CGSize)o forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = NSStringFromCGSize(o);
}

- (void)cml_setRect:(CGRect)o forKey:(NSString *)key {
    if (!key) {
        NSParameterAssert(key);
        return;
    }
    
    self[key] = NSStringFromCGRect(o);
}

@end
