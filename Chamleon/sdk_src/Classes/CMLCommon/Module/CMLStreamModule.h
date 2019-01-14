//
//  CMLStreamModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/4.
//

#import <Foundation/Foundation.h>
#import "CMLModuleProtocol.h"

@interface CMLStreamModule : NSObject<CMLModuleProtocol>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end
