//
//  CMLModuleConfig.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import <Foundation/Foundation.h>


@interface CMLModuleConfig : NSObject

@property (nonatomic, readonly) NSString *clsName;
@property (nonatomic, readonly) NSMutableDictionary *methods;

/**
 * 初始化函数
 * @param clsName  类名
 * @return Module对象
 **/
- (instancetype)initWithClassName:(NSString *)clsName;

- (id)targetForMethodName:(NSString *)methodName instanceId:(NSString *)instanceId;

- (SEL)selectorForMethodName:(NSString *)methodName;

@end


