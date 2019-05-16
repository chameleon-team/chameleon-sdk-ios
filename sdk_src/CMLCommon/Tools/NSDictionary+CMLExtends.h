//
//  NSDictionary+CMLExtends.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CMLSafeAccess)

- (BOOL)cml_hasKey:(NSString *)key;

- (NSString*)cml_stringForKey:(id)key;
- (NSString*)cml_stringForKey:(id)key defaultValue:(NSString *)defaultValue;

- (NSNumber*)cml_numberForKey:(id)key;

- (NSDecimalNumber *)cml_decimalNumberForKey:(id)key;

- (NSArray*)cml_arrayForKey:(id)key;

- (NSDictionary*)cml_dictionaryForKey:(id)key;

- (NSInteger)cml_integerForKey:(id)key;

- (NSUInteger)cml_unsignedIntegerForKey:(id)key;

- (BOOL)cml_boolForKey:(id)key;
// 从 NSDictionary 中获取 key 对应的 bool 型value; 若无，则返回 defaultValue
- (BOOL)cml_boolForKey:(id)aKey defaultValue:(BOOL)defaultValue;

- (int16_t)cml_int16ForKey:(id)key;

- (int32_t)cml_int32ForKey:(id)key;

- (int64_t)cml_int64ForKey:(id)key;

- (char)cml_charForKey:(id)key;

- (short)cml_shortForKey:(id)key;

- (float)cml_floatForKey:(id)key;

- (double)cml_doubleForKey:(id)key;

- (long long)cml_longLongForKey:(id)key;

- (unsigned long long)cml_unsignedLongLongForKey:(id)key;

- (NSDate *)cml_dateForKey:(id)key dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)cml_CGFloatForKey:(id)key;

- (CGPoint)cml_pointForKey:(id)key;

- (CGSize)cml_sizeForKey:(id)key;

- (CGRect)cml_rectForKey:(id)key;
@end


@interface NSMutableDictionary (ONESafeAccess)

- (void)cml_setValue:(id)i forKey:(NSString*)key;
- (void)cml_setValueEx:(id)aValue forKey:(NSString *)aKey;

-(void)cml_setString:(NSString*)i forKey:(NSString*)key;

-(void)cml_setBool:(BOOL)i forKey:(NSString*)key;

-(void)cml_setInt:(int)i forKey:(NSString*)key;

-(void)cml_setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)cml_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)cml_setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)cml_setChar:(char)c forKey:(NSString*)key;

-(void)cml_setFloat:(float)i forKey:(NSString*)key;

-(void)cml_setDouble:(double)i forKey:(NSString*)key;

-(void)cml_setLongLong:(long long)i forKey:(NSString*)key;

-(void)cml_setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)cml_setSize:(CGSize)o forKey:(NSString*)key;

-(void)cml_setRect:(CGRect)o forKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
