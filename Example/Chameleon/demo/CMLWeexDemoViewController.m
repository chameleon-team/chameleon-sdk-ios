//
//  CMLChameleonPageView.m
//  CarpoolBlord
//
//  Created by mxf on 2018/8/6.
//

#import "CMLWeexDemoViewController.h"
#import "CMLSDKEngine.h"
#import "CMLWKWebView.h"
#import "CMLWeexRenderPage.h"

@interface CMLWeexDemoViewController ()
@property(nonatomic,weak)CMLWKWebView *webView;
@property(nonatomic,weak)CMLWeexRenderPage *weexView;
@end

@implementation CMLWeexDemoViewController

- (void)viewDidLoad {
    //self.hideWebProgressBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
//    [self creatWeexView];
    //[self createWebView];
    [CMLSDKEngine registerModule:@"DidiBridgeAdapter" className:@"CMLUserInfoModule"];
}
- (void)createNav{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:navView];
    
    navView.backgroundColor = [UIColor blueColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 20, 200, 30);
    [button setTitle:@"点击调用js方法" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [navView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 50, 200, 30);
    [button1 setTitle:@"关闭" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor redColor];
    [navView addSubview:button1];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"weex测试" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnClicked:(UIButton *)btn {
    [self creatWeexView];
}


-(void)creatWeexView{
    [CMLEnvironmentManage chameleon].serviceType = CMLServiceTypeWeex;
    NSString *encodeUrl = [@"https://static.didialift.com/pinche/gift/chameleon-ui/chameleon-ui_1dbbe9f5394d7c61d6f7.js"
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:encodeUrl];
    [self presentViewController:weexDemo animated:YES completion:nil];
}

- (void)createWebView{
    
    CMLWKWebView *webView = [[CMLWKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:webView];
    self.webView = webView;
    
    //    // 加载本地index.html文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [[NSURL alloc] initWithString:filePath];
    [self.webView loadHTMLString:htmlString baseURL:url];
    
    //    加载线上web
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"https://www.jianshu.com/p/6ec9571a0105"]];
    //    [webView loadRequest:request];
}
- (void)navButtonAction{
    // iOS调用js里的navButtonAction方法并传入两个参数
    [self.webView evaluateJavaScript:@"navButtonAction('Jonas',25)" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@=====%@",response,error);
    }];
    
    CMLWeexDemoViewController *vcc = [[CMLWeexDemoViewController alloc] init];
    
    [self presentViewController:vcc animated:YES completion:^{
        
    }];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if ([CarpoolAppsDefines carpoolAppId] == CarpoolAppBlord) [self setNeedsStatusBarAppearanceUpdate]; // 独立端状态栏兼容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setContentFrame:(CGRect)contentFrame {
    //self.CMLFrame = contentFrame;

}
-(void)modifyWebPageStyle{
    //TODO:孟祥峰 webView相关
//    self.webPage.webView.backgroundColor = [UIColor whiteColor];
//    self.webPage.topNavgationView.hidden = YES;
//    self.webPage.shouldProgressBarHidden = YES;
}
-(void)setWebPageFrame{

   // [self.webPage.view setFrame:self.CMLFrame];
    //TODO:孟祥峰 webView相关
//    CGFloat yOffset = 0;
//    [self.webPage.webView setFrame:CGRectMake(0, yOffset, self.webPage.view.frame.size.width, self.webPage.view.frame.size.height - yOffset)];
    
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
