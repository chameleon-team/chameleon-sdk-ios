//
//  CMLBridgeProtocol.h
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/27.
//

#import <Foundation/Foundation.h>

@protocol CMLBridgeDelegate <NSObject>

- (void)executeScript:(NSString *)script handler:(void (^)(NSString *item, NSError *error))handler;

@end

@protocol CMLBridgeProtocol <NSObject>

@end


