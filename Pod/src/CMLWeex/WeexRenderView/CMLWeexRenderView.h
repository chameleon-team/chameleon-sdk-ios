//
//  CMLWeexRenderView.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/4/16.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLWeexRenderView : UIView

/**
 初始化变色龙页面的实例。
 
 @param url 传入的URL
 @return Instance
 */
- (instancetype)initWithLoadUrl:(NSString *)url withFrame:(CGRect)frame;

@end


