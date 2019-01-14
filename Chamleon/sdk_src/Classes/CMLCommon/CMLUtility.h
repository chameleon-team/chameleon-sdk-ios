//
//  CMLUtility.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CMLMoudleCallBack)(id result);

UIViewController *CMLRootViewController(void);
id _CMLObjectFromJSON(NSString *json);
NSString *_CMLJSONStringWithObject(id object);
NSString *_CMLBase64DataEncode(NSData *input);

@interface CMLUtility : NSObject

+ (NSDictionary *)getEnvironment;

@end
