//
//  CMLRNRenderPage.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import "CMLRNRenderPage.h"

#import <Masonry/Masonry.h>
#import <React/RCTRootView.h>

@interface CMLRNRenderPage ()

@property (nonatomic, strong) RCTRootView *rnView;

@end

@implementation CMLRNRenderPage

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)creatRenderInstance
{
    //子类重载，创建渲染实例
}

- (void)loadJSBundle
{
    _rnView = [[RCTRootView alloc]initWithBundleURL:[NSURL URLWithString:@"http://www.example.com/static/wb/do1_4TC95ZmdUEV82LTiibIZ"] moduleName:@"Chameleon" initialProperties:nil launchOptions:nil];
    [self.view addSubview:self.rnView];
    [self.rnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)destroyInstance
{
    //子类重载，销毁渲染实例
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
