//
//  NSURL+CML.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CML)
/**
 * 获取url component
 **/
- (NSURLComponents *)cml_URLComponents;
/**
 * 获取URL query dictionary
 **/
- (NSDictionary *)cml_queryDict;
@end


