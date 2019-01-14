//
//  CMLWebSocketModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/4.
//

#import <Foundation/Foundation.h>
#import "CMLModuleProtocol.h"

typedef void (^CMLModuleKeepAliveCallback)(id result, BOOL keepAlive);

@interface CMLWebSocketModule : NSObject<CMLModuleProtocol>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end
