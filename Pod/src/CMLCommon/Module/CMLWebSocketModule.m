//
//  CMLWebSocketModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/4.
//

#import "CMLWebSocketModule.h"
#import "CMLUtility.h"
#import "CMLConstants.h"
#import "WXWebSocketModule.h"
#import "CMLRenderPage.h"

@interface  CMLWebSocketModule()
@property (nonatomic, strong) WXWebSocketModule *webSocket;

@end

@implementation CMLWebSocketModule
@synthesize cmlInstance;

CML_EXPORT_METHOD(@selector(WebSocket:callBack:))
CML_EXPORT_METHOD(@selector(send:callBack:))
CML_EXPORT_METHOD(@selector(close:callBack:))

- (void)WebSocket:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    NSString *url = parms[@"url"];
    NSString *protocol = parms[@"protocol"];
    if (!url || url.length <= 0) {
        return;
    }
    NSString * methodName = @"WebSocket:protocol:";
    if (methodName && methodName.length > 0) {
        SEL selector = NSSelectorFromString(methodName);
        if ([self.webSocket respondsToSelector:selector]) {
            IMP imp = [self.webSocket methodForSelector:selector];
            void (*func)(id, SEL , NSString *, NSString *) = (void *)imp;
            func(self.webSocket, selector, url,protocol);
            
            NSDictionary *result = @{@"errno": @"0", @"data":@"", @"msg": @""};
            if(callback) callback(result);
        }
    }
}
- (void)send:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
  
    NSString * methodName = @"send:";
    if (methodName && methodName.length > 0) {
        SEL selector = NSSelectorFromString(methodName);
        if ([self.webSocket respondsToSelector:selector]) {
            IMP imp = [self.webSocket methodForSelector:selector];
            void (*func)(id, SEL , id) = (void *)imp;
            func(self.webSocket, selector, _CMLJSONStringWithObject(parms));
            
            if (callback) {
                NSDictionary *result = @{@"errno": @"0", @"msg": @""};
                if(callback) callback(result);
            }
        }
    }
}

- (void)close:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    NSString *methodName = @"close";
    if (methodName && methodName.length > 0) {
        SEL selector = NSSelectorFromString(methodName);
        if ([self.webSocket respondsToSelector:selector]) {
            IMP imp = [self.webSocket methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self.webSocket, selector);
            
            if (callback) {
                NSDictionary *result = @{@"errno": @"0", @"msg": @""};
                if(callback) callback(result);
            }
        }
    }
}

- (WXWebSocketModule *)webSocket {

    if (!_webSocket) {
        _webSocket = [WXWebSocketModule new];
        
        __weak typeof(self) weakSelf = self;
        [self callWebSocketMethodName:@"onopen:" callBack:^(id result, BOOL keepAlive) {
           
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
                
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"webSocket" methodName:@"onopen" arguments:result];
            
            }
        }];
        [self callWebSocketMethodName:@"onclose:" callBack:^(id result, BOOL keepAlive) {
           
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
            
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"webSocket" methodName:@"onclose" arguments:result];
                
            }
        }];
        [self callWebSocketMethodName:@"onmessage:" callBack:^(id result, BOOL keepAlive) {
           
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
                
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"webSocket" methodName:@"onmessage" arguments:result];
                
            }
        }];
        [self callWebSocketMethodName:@"onerror:" callBack:^(id result, BOOL keepAlive) {
           
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
            
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"webSocket" methodName:@"onerror" arguments:result];
                
            }
        }];
    }
    return _webSocket;
}

- (void)callWebSocketMethodName:(NSString *)methodName callBack:(CMLModuleKeepAliveCallback)callBack {
    
    if (methodName && methodName.length > 0) {
        SEL selector = NSSelectorFromString(methodName);
    
        if ([self.webSocket respondsToSelector:selector]) {
            IMP imp = [self.webSocket methodForSelector:selector];
            void (*func)(id, SEL , CMLModuleKeepAliveCallback) = (void *)imp;
            func(self.webSocket, selector,callBack);
        }
    }
}

@end
