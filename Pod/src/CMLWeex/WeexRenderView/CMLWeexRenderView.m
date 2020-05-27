//
//  CMLWeexRenderView.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/4/16.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexRenderView.h"
#import "CMLWeexRenderPage.h"
#import "CMLEnvironmentManage.h"

@interface CMLWeexRenderView ()
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) CMLWeexRenderPage *weexPage;
@end

@implementation CMLWeexRenderView

- (instancetype)initWithLoadUrl:(NSString *)url withFrame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        _url = url;
        [self loadWeexView];
    }
    return self;
}

- (void)loadWeexView {
    
    _weexPage = [[CMLWeexRenderPage alloc] initWithLoadUrl:self.url];
    _weexPage.hideNavigationBar = YES;
     _weexPage.service = [CMLEnvironmentManage chameleon].weexService;
    _weexPage.CMLFrame = self.bounds;
    _weexPage.view.frame = self.bounds;
    [self addSubview:_weexPage.view];
    
}

@end
