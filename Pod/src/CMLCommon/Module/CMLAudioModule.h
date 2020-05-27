//
//  CMLAudioModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/5/13.
//

#import <Foundation/Foundation.h>
#import "CMLModuleProtocol.h"


@interface CMLAudioModule : NSObject<CMLModuleProtocol>

@property (nonatomic, weak) CMLInstance *cmlInstance;

@end
