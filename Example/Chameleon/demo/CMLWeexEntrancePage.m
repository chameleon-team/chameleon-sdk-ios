//
//  CMLWeexEntrancePage.m
//  Chameleon_Example
//
//  Created by Chameleon-Team on 2019/5/20.
//  Copyright © 2019 Chameleon-Team. All rights reserved.
//

#import "CMLWeexEntrancePage.h"

#import "CMLSDKEngine.h"
#import "CMLWKWebView.h"
#import "CMLWeexRenderPage.h"

@interface CMLWeexEntrancePage () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@end

@implementation CMLWeexEntrancePage

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Chameleon调试"];
    [CMLSDKEngine initSDKEnvironment];
    //设置服务类型为weex
    [CMLEnvironmentManage chameleon].serviceType = CMLServiceTypeWeex;
    [CMLEnvironmentManage chameleon].weexService.config.prefetchContents = @[@"http%3A%2F%2F172.22.139.32%3A8000%2Fweex%2Fchameleon-bridge.js%3Ft%3D1546502643623"];
    [[CMLEnvironmentManage chameleon].weexService setupPrefetch];
    
    [_textView.layer setBorderColor:[UIColor blueColor].CGColor];
    [_textView.layer setBorderWidth:0.5f];
    
    [_jumpBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [_jumpBtn.layer setBorderWidth:0.5f];
    [_jumpBtn.layer setCornerRadius:10.0f];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (IBAction)creatWeexView:(id)sender
{
    if(self.textView.text.length > 0){
        NSString *encodeUrl = self.textView.text;
        CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:encodeUrl];
        weexDemo.service = [CMLEnvironmentManage chameleon].weexService;
        [self.navigationController pushViewController:weexDemo animated:YES];
    }
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
