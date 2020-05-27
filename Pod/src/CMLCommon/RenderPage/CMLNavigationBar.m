//
//  CMLNavigationBar.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/9.
//

#import "CMLNavigationBar.h"
#import "Masonry.h"

@implementation CMLNavigationBar {
    UIButton *_backBtn;
    UILabel *_titleLabel;
    UIView *_lineView;
}

+ (CMLNavigationBar *)defaultNavigationBarWithTitle:(NSString *)title {
    CMLNavigationBar *navigationBar = [[CMLNavigationBar alloc] initWithtitle:title];
    return navigationBar;
}

- (instancetype)initWithtitle:(NSString *)title{
    if(self = [super init]){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"<" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_backBtn];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:_titleLabel];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 44));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)refreshTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)backBtnClicked:(UIButton *)btn {
    if(self.backAction){
        self.backAction();
    }
}

@end
