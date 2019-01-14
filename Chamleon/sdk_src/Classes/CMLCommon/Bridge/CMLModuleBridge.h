//
//  CMLExecuteModuleBridge.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import <Foundation/Foundation.h>
#import "CMLBridgeProtocol.h"

@interface CMLModuleBridge : NSObject

@property (nonatomic,weak) id <CMLBridgeDelegate>delegate;

- (void)handleBridgeURL:(NSURL *)url instanceId:(NSString *)instanceId;
- (void)invokeJsMethod:(NSString *)moduleName methodName:(NSString *)methodName arguments:(id)arguments;

@end


