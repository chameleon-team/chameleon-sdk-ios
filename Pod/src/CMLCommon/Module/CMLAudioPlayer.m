//
//  CMLAudioPlayer.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/5/16.
//

#import "CMLAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+CMLExtends.h"
#import "CMLUtility.h"
#import "CMLConstants.h"

@interface CMLAVPlayerItem : AVPlayerItem

@property (nonatomic, strong) NSString *looping;

@end

@implementation CMLAVPlayerItem
@end


@interface CMLAudioPlayer ()

@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) CMLAVPlayerItem *currentItem;
@property (nonatomic, copy) CMLAudioPlayerStatusBlock playerStatusBlock;

@end

@implementation CMLAudioPlayer

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currentItem removeObserver:self forKeyPath:@"status"];
    [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//    [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

- (void)create:(NSDictionary *)parms block:(CMLAudioPlayerStatusBlock)playerStatusBlock{
    
    NSURL *url = [NSURL URLWithString:parms[@"url"]];
    NSString *looping = parms[@"looping"]?:@"0";
    NSString *volume = parms[@"volume"]?:@"1";
    if (url) {
        _currentItem = [[CMLAVPlayerItem alloc] initWithURL:url];
        _currentItem.looping = looping;
        _audioPlayer = [[AVPlayer alloc]initWithPlayerItem:_currentItem];
        _audioPlayer.volume = [volume floatValue];
        
        _duration =  CMTimeGetSeconds(_audioPlayer.currentItem.asset.duration);
       
        [_currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//        [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//        [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
        //给AVPlayerItem添加播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_audioPlayer.currentItem];
        
        self.playerStatusBlock = ^(id result) {
            if (playerStatusBlock) {
                playerStatusBlock(result);
            }
        };
    }
}

-(void)playFinished:(NSNotification*)notification
{
    if ([_currentItem.looping boolValue]) {
        [_audioPlayer seekToTime:CMTimeMake(0, 1)];
        [_audioPlayer play];
    }
   
    if (self.statusChangeBlock) {
        NSString *audioId = self.indentifier;
        NSDictionary *result = @{@"id":audioId,@"status":@"4"};
        self.statusChangeBlock(result);
    }
}
    
- (void)play:(NSDictionary *)parms {
    
    [_audioPlayer play];
    if (self.statusChangeBlock) {
        NSString *audioId = self.indentifier;
        NSDictionary *result = @{@"id":audioId,@"status":@"2"};
        self.statusChangeBlock(result);
    }
}

- (void)pause:(NSDictionary *)parms {
    
    [_audioPlayer pause];
    if (self.statusChangeBlock) {
        NSString *audioId = self.indentifier;
        NSDictionary *result = @{@"id":audioId,@"status":@"3"};
        self.statusChangeBlock(result);
    }
}

- (void)seekTo:(NSDictionary *)parms {
    
    NSString *msec = parms[@"msec"];
    //跳转到当前指定时间
    [_audioPlayer seekToTime:CMTimeMake([msec doubleValue]/1000, 1)];

}

- (void)currentPos:(NSDictionary *)parms block:(CMLGetCurrentPosBlock)currentPosBlock {
    
    NSString *audioId = parms[@"id"];
    NSDictionary *result = @{@"id":audioId,@"msec":[NSNumber numberWithDouble:CMTimeGetSeconds(_audioPlayer.currentItem.currentTime) * 1000]};
    NSString *dataStr = _CMLJSONStringWithObject(result);
    dataStr = dataStr?[dataStr CM_urlEncode]:@"";
    
    NSDictionary *cmlResult = @{@"errno": @"0", @"msg": @"",@"data":dataStr};
    if (currentPosBlock) {
        currentPosBlock(cmlResult);
    }
}

- (void)destroy:(NSDictionary *)parms {
    
     [_audioPlayer pause];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([object isKindOfClass:[CMLAVPlayerItem class]]) {
        CMLAVPlayerItem *item = (CMLAVPlayerItem *)object;
        if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            NSArray *array = item.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            NSLog(@"当前缓冲时间:%f",totalBuffer);
          
            NSString *audioId = self.indentifier;
            if (_duration > 0) {
                NSDictionary *result = @{@"id":audioId,@"percent":[NSString stringWithFormat:@"%.1f",totalBuffer * 100 / _duration]};
                NSLog(@"当前缓冲进度:%.1f",totalBuffer * 100 / _duration);
                if (self.bufferingChangeBlock) {
                    self.bufferingChangeBlock(result);
                }
            }
           
        }else if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
           
            if (status == AVPlayerStatusUnknown) {
                if (self.playerStatusBlock) {
                    NSString *audioId = self.indentifier;
                    self.playerStatusBlock(@{@"id":audioId,@"errno":@"-1"});
                }
                
            }else if(status==AVPlayerStatusReadyToPlay){
                if (self.statusChangeBlock) {
                    NSString *audioId = self.indentifier;
                    NSDictionary *result = @{@"id":audioId,@"status":@"1"};
                    self.playerStatusBlock(@{@"id":audioId,@"errno":@"0"});
                    self.statusChangeBlock(result);
                }
                
            }else if (status == AVPlayerStatusFailed) {
                if (self.playerStatusBlock) {
                    NSString *audioId = self.indentifier;
                    self.playerStatusBlock(@{@"id":audioId,@"errno":@"-1"});
                }
            }
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
        {
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
        {
          
        }
    }
}

@end
