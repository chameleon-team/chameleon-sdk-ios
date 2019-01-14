//
//  CMLClipboardModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/3.
//
#import <Foundation/Foundation.h>
#import "CMLModuleProtocol.h"

@interface CMLClipboardModule : NSObject<CMLModuleProtocol>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end
