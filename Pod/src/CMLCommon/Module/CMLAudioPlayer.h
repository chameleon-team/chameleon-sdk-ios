//
//  CMLAudioPlayer.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/5/16.
//

#import <Foundation/Foundation.h>

typedef void(^CMLGetCurrentPosBlock)(id result);
typedef void(^CMLAudioBufferingChangeBlock)(id result);
typedef void(^CMLAudioStatusChangeBlock)(id result);
typedef void(^CMLAudioPlayerStatusBlock)(id result);


@interface CMLAudioPlayer : NSObject

@property (nonatomic, strong) NSString *indentifier;
@property (nonatomic, assign, readonly) double duration;
@property (nonatomic, copy) CMLAudioBufferingChangeBlock bufferingChangeBlock;
@property (nonatomic, copy) CMLAudioStatusChangeBlock statusChangeBlock;

- (void)create:(NSDictionary *)parms block:(CMLAudioPlayerStatusBlock)playerStatusBlock;
- (void)play:(NSDictionary *)parms;
- (void)pause:(NSDictionary *)parms;
- (void)seekTo:(NSDictionary *)parms;
- (void)currentPos:(NSDictionary *)parms block:(CMLGetCurrentPosBlock)currentPosBlock;
- (void)destroy:(NSDictionary *)parms;

@end


