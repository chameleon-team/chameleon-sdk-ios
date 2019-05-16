//
//  CMLWKWebProtocol.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMLWKWebProtocol <NSObject>

- (void)handleBridgeURL:(NSURL *)url instanceId:(NSString *)instanceId;

@end


