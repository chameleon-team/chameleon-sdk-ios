//
//  CMLCommonModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/29.
//

#import <Foundation/Foundation.h>
#import "CMLModuleProtocol.h"

@interface CMLCommonModule : NSObject<CMLModuleProtocol>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end

