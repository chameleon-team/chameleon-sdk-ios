//
//  CMLModuleProtocol.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/28.
//

#import <Foundation/Foundation.h>
#import "CMLInstance.h"

@protocol CMLModuleProtocol <NSObject>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end
