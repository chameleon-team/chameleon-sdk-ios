//
//  NSArray+ONTExtends.h
//  Pods
//
//  Created by zhanghuawei on 7/4/16.
//
//

#import <Foundation/Foundation.h>

/****************	Immutable Array		****************/
NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CMLExtends)

///  return value if index is valid, return   nil if others.
- (id)cml_objectAtIndex:(NSUInteger)index;

/// return @"" if value is nil or NSNull; return value if NSString or NSNumber class; return nil if others
- (NSString*)cml_stringWithIndex:(NSUInteger)index;

/**
 return nil if value is nill; return NSDictionary if value is NSDictionary; return nil if others.
 */
- (NSDictionary*)cml_dictionaryWithIndex:(NSUInteger)index;

/// return nil if value is nil or NSNull;return the value whitch is member of filter class;return the unfiltered value  if filter is nil.
- (nullable id)cml_objectAtIndex:(NSUInteger)index filter:(Class __nullable)filter;

/// 是否为有效的数组
+ (BOOL)cml_isValid:(NSArray *)array;

///是否为空数组
+ (BOOL)cml_isEmpty:(NSArray *)array;

@end

/****************	Mutable Array		****************/

@interface NSMutableArray(ONESafeAccess)

/**
 add object if object is not nil; add object if object is [NSNull null]; do nothing if object is nil.
 */
- (void)cml_addObject:(id)object;

/// return nil if value is nill;return the value whitch is member of filter class;;return the unfiltered value  if filter is nil.
- (nullable id)cml_objectAtIndex:(NSUInteger)index filter:(Class __nullable)filter;

/// 是否为有效的可变数组
+ (BOOL)cml_isValid:(NSMutableArray *)array;

///是否为空可变数组
+ (BOOL)cml_isEmpty:(NSMutableArray *)array;

@end

@interface NSArray(ONEJSONString)

- (NSString *)cml_JSONString;

- (NSString *)cml_JSONStringWithOptions:(NSJSONWritingOptions)opt;

@end

NS_ASSUME_NONNULL_END
