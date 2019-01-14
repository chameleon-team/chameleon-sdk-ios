//
//  CMLStreamModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/4.
//

#import "CMLStreamModule.h"
#import "CMLConstants.h"
#import "CMLWeexRenderPage.h"
#import "CMLUtility.h"
#if __has_include("WXStreamModule.h")
#import "WXStreamModule.h"
#endif

@interface CMLStreamModule ()

#if __has_include("WXStreamModule.h")
@property (nonatomic, strong) WXStreamModule *streamModule;
#endif

@end

@implementation CMLStreamModule
@synthesize cmlInstance;

#if __has_include("WXStreamModule.h")

CML_EXPORT_METHOD(@selector(fetch:callback:progressCallback:))

- (WXStreamModule *)streamModule {
    
    if (!_streamModule) {
        _streamModule = [WXStreamModule new];
       
        id viewController = self.cmlInstance.viewController;
        if (viewController && [viewController isKindOfClass:[CMLWKWebView class]]) {
            viewController = ((CMLWKWebView *)viewController).viewController;
        }
    
        if (viewController && [viewController isKindOfClass:[CMLWeexRenderPage class]]) {
            _streamModule.weexInstance = ((CMLWeexRenderPage *)viewController).render;
        }
    }
    return _streamModule;
}

- (void)fetch:(NSDictionary *)options callback:(CMLMoudleCallBack)callback progressCallback:(CMLMoudleCallBack)progressCallback {
    
    if (self.streamModule) {
        
        [self.streamModule fetch:options callback:^(id result, BOOL keepAlive) {
            
            NSDictionary *cmlResult = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(result)?:@"", @"msg": @""};
            if (callback) {
                callback(cmlResult);
            }
        } progressCallback:^(id result, BOOL keepAlive) {
            
            NSDictionary *cmlResult = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(result)?:@"", @"msg": @""};
            if (callback) {
                progressCallback(cmlResult);
            }
        }];
    }
}
#endif

@end
