//
//  CMLWKWebView.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CMLModuleBridge.h"
#import "CMLWKWebProtocol.h"

@interface CMLWKWebView : WKWebView

- (instancetype)initWithUrl:(NSString *)url parms:(NSDictionary*)parms;

@property (nonatomic,weak) id <CMLWKWebProtocol>delegate;
@property (nonatomic, weak) id viewController;

- (void)loadURLRequest;

- (void)addUserScript:(NSString *)userScript;

@end


