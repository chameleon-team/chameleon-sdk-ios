//
//  CMLCallBackList.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLUtility.h"

@interface CMLCallBackList : NSObject

- (NSString *)setCallback:(CMLMoudleCallBack)callback callBackId:(NSString *)callBackId;

- (CMLMoudleCallBack)getCallback:(NSString *)cbName;

@end


