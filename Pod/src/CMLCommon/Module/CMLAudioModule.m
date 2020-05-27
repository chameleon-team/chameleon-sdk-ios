//
//  CMLAudioModule.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/5/13.
//

#import "CMLAudioModule.h"
#import "CMLUtility.h"
#import "CMLConstants.h"
#import "CMLAudioPlayer.h"
#import "NSString+CMLExtends.h"
#import "CMLRenderPage.h"

@interface CMLAudioModule ()

@property (nonatomic, strong)NSMutableDictionary *players;

@end

@implementation CMLAudioModule
CML_EXPORT_METHOD(@selector(create:callback:))
CML_EXPORT_METHOD(@selector(play:callback:))
CML_EXPORT_METHOD(@selector(pause:callback:))
CML_EXPORT_METHOD(@selector(seekTo:callback:))

CML_EXPORT_METHOD(@selector(currentPos:callback:))
CML_EXPORT_METHOD(@selector(destroy:callback:))

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _players = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)create:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
    
    NSURL *url = [NSURL URLWithString:parms[@"url"]];
    if (url) {
        CMLAudioPlayer* player = [[CMLAudioPlayer alloc] init];

        __weak typeof(self) weakSelf = self;
        [player create:parms block:^(id result) {

            NSString *indentifier = result[@"id"];
            NSString *status = result[@"errno"]?:@"0";
            CMLAudioPlayer *player = [weakSelf.players objectForKey:indentifier];
            if ([status isEqualToString:@"-1"] && player) {
                [player destroy:parms];
                [weakSelf.players removeObjectForKey:indentifier];
            }
            NSDictionary *callResult = @{@"id":indentifier,@"duration":[NSNumber numberWithDouble:player.duration]};
            NSString *dataStr = _CMLJSONStringWithObject(callResult);
            dataStr = dataStr?[dataStr CM_urlEncode]:@"";
            NSDictionary *cmlResult = @{@"errno": status, @"data":dataStr, @"msg": @""};
            if (callback) {
                callback(cmlResult);
            }

        }];
        NSString *indentifier = [NSString stringWithFormat:@"player_%lud", (unsigned long)player.hash];
        player.indentifier = indentifier;

        [player setBufferingChangeBlock:^(id result) {
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"audio" methodName:@"onBufferingChange" arguments:result];
            }
        }];

        [player setStatusChangeBlock:^(id result) {
            id viewController = weakSelf.cmlInstance.viewController;
            if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
                CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
                [pageVC.bridge invokeJsMethod:@"audio" methodName:@"onStatusChange" arguments:result];
            }
        }];

        if (player && indentifier) {
            [_players setObject:player forKey:indentifier];

        }
    }
}

- (void)play:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
   
    NSString *audioId = parms[@"id"];
    if (audioId && [_players objectForKey:audioId]) {
        CMLAudioPlayer *player = [_players objectForKey:audioId];
        [player play:parms];
        NSDictionary *cmlResult = @{@"errno": @"0", @"msg": @""};
        if (callback) {
            callback(cmlResult);
        }
    }
}

- (void)pause:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
    
    NSString *audioId = parms[@"id"];
    if (audioId && [_players objectForKey:audioId]) {
        CMLAudioPlayer *player = [_players objectForKey:audioId];
        [player pause:parms];
        NSDictionary *cmlResult = @{@"errno": @"0", @"msg": @""};
        if (callback) {
            callback(cmlResult);
        }
    }
}

- (void)seekTo:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
    
    NSString *audioId = parms[@"id"];
    if (audioId && [_players objectForKey:audioId]) {
        CMLAudioPlayer *player = [_players objectForKey:audioId];
        [player seekTo:parms];
        NSDictionary *cmlResult = @{@"errno": @"0", @"msg": @""};
        if (callback) {
            callback(cmlResult);
        }
    }
}

- (void)currentPos:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
    
    NSString *audioId = parms[@"id"];
    if (audioId && [_players objectForKey:audioId]) {
        CMLAudioPlayer *player = [_players objectForKey:audioId];
        [player currentPos:parms block:^(id result) {
            if (callback) {
                callback(result);
            }
        }];
    }
}

- (void)destroy:(NSDictionary *)parms callback:(CMLMoudleCallBack)callback {
    
    NSString *audioId = parms[@"id"];
    if (audioId && [_players objectForKey:audioId]) {
        CMLAudioPlayer *player = [_players objectForKey:audioId];
        [player destroy:parms];
        [_players removeObjectForKey:audioId];
        player = nil;
        NSDictionary *cmlResult = @{@"errno": @"0", @"msg": @""};
        if (callback) {
            callback(cmlResult);
        }
    }
}

@end
