//
//  CMLWeexBridgeModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/29.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLWeexBridgeModule.h"
#import "CMLRenderPage.h"

@interface CMLWeexBridgeModule ()

@end

@implementation CMLWeexBridgeModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(channel:))

-(void)dealloc{
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}

-(void)channel:(NSString *)script{
    
    if (self.weexInstance.viewController && [self.weexInstance.viewController isKindOfClass:[CMLRenderPage class]]) {
        CMLRenderPage *pageVC = (CMLRenderPage *)self.weexInstance.viewController;
        [pageVC handleBridgeURL:[NSURL URLWithString:script] instanceId:nil];
    }
}

@end
