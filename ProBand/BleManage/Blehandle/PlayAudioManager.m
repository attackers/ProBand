//
//  PlayAudioManager.m
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "PlayAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayAudioManager()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}

@end

@implementation PlayAudioManager
SINGLETON_SYNTHE

- (id)init
{
    
    //检测音频中断
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:  @selector(interruption:)
                                                 name:       AVAudioSessionInterruptionNotification
                                               object:      [AVAudioSession sharedInstance]];
    if (self = [super init])
    {
        
    }
    
    return self;
}

-(void)playAudio:(NSString *)audioName audioType:(NSString *)audioType
{
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"carina" ofType:@"aac"];
    if (musicPath)
    {
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 让后台可以处理多媒体的事件
        NSLog(@"%s",__FUNCTION__);
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil]; //后台播放
        
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        [[AVAudioSession sharedInstance]
         setCategory:AVAudioSessionCategoryPlayback error:nil];
        audioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL  error:nil];
        
        NSLog(@"~musicPath~~%@",musicPath);
        [audioPlayer stop];
        audioPlayer.numberOfLoops = -1;
        audioPlayer.volume = 1.0;
        [audioPlayer setDelegate:self];
    }
    [audioPlayer play];
}

-(void)stopFindPhone
{
    if (audioPlayer.playing)
    {
        [audioPlayer stop];
    }
}


- (void)interruption:(NSNotification *)notify
{
    //[self stopFindPhone];
}


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [audioPlayer stop];
    //[audioPlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [audioPlayer play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    [audioPlayer play];
}

@end
