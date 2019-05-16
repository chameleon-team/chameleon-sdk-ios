//
//  CMLNavigationBar.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/9.
//

typedef void (^CMLNavigationBackClick)(void);

@interface CMLNavigationBar : UIView

@property (nonatomic, copy) CMLNavigationBackClick backAction;

/**
 初始化变色龙页面的实例。
 
 @param title 标题
 @return 返回导航view实例
 */
+ (CMLNavigationBar *)defaultNavigationBarWithTitle:(NSString *)title;

/**
 刷新页面标题
 
 @param title 标题
 */
- (void)refreshTitle:(NSString *)title;

@end

