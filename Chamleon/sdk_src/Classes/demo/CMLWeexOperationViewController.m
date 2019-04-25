//
//  CMLChameleonPageView.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/8/6.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexOperationViewController.h"
#import "CMLSDKEngine.h"
#import "CMLWKWebView.h"
#import "CMLWeexRenderPage.h"

@interface CMLWeexOperationViewController ()
<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,weak)CMLWeexRenderPage *weexView;
@end

@implementation CMLWeexOperationViewController

- (void)viewDidLoad {
    //self.hideWebProgressBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
   
    [CMLSDKEngine initSDKEnvironment];
    //设置服务类型为weex
    [CMLEnvironmentManage chameleon].serviceType = CMLServiceTypeWeex;
    
    [CMLEnvironmentManage chameleon].weexService.config.prefetchContents = @[@"http%3A%2F%2F172.22.139.32%3A8000%2Fweex%2Fchameleon-bridge.js%3Ft%3D1546502643623"];
    [[CMLEnvironmentManage chameleon].weexService setupPrefetch];
}
- (void)createNav {
    
    UILabel *lb1 = [UILabel new];
    lb1.textColor = [UIColor whiteColor];
    lb1.frame = CGRectMake(10, 80, 200, 20);
    lb1.text = @"填入weexd链接:";
    [self.view addSubview:lb1];

    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(10, 110, self.view.frame.size.width - 20, 30);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    self.textView.text = @"http://172.22.139.13:8000/pages/index/index?cml_addr=http://172.22.139.13:8000/weex/chameleon-bridge.js&name=chameleon";
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"weex页跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 150, 200, 30);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 210, 200, 30);
    [button setTitle:@"点击调用js方法" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 260, 200, 30);
    [button1 setTitle:@"关闭" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor redColor];
    [self.view addSubview:button1];
    
}

- (void)btnClicked:(UIButton *)btn {
    [self creatWeexView];
}


- (void)creatWeexView {
    if(self.textView.text.length > 0){
        NSString *encodeUrl = self.textView.text;
        CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:encodeUrl];
        weexDemo.service = [CMLEnvironmentManage chameleon].weexService;
        [self.navigationController pushViewController:weexDemo animated:YES];
    }
}

- (void)navButtonAction {
   
   
}

- (void)close {
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textViewDidChange:(UITextView *)textView {
    
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
