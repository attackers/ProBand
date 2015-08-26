//
//  MusicPlay.m
//  BLEManager
//
//  Created by attack on 15/7/13.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "MusicPlay.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@implementation MusicPlay
{
    MPMusicPlayerController *playManage;
    MPMediaQuery *query;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        playManage = [MPMusicPlayerController applicationMusicPlayer];
        query = [MPMediaQuery songsQuery];
//        playManage.volume = 0.5;
        [playManage setQueueWithQuery:query];
    }
    return self;

}

- (void)play
{
    [playManage play];
}
- (void)pause
{
    [playManage pause];
}
- (void)stop
{
    [playManage stop];
}
- (void)skipToNextItem
{
    NSInteger index = playManage.indexOfNowPlayingItem;
    if (index == query.items.count - 1) {
        return;
    }
    [playManage skipToNextItem];
}
- (void)skipToPreviousItem
{
    NSInteger index = playManage.indexOfNowPlayingItem;
    if (index == 0) {
        return;
    }
    [playManage skipToPreviousItem];
}
- (void)addVolume
{
    playManage.volume = playManage.volume+0.1;
}
- (void)reduceVolume
{
    playManage.volume = playManage.volume-0.1;
}
- (NSString*)getSongName
{
    NSInteger index = playManage.indexOfNowPlayingItem;
    MPMediaItem *item = query.items[index];
    return [item  valueForProperty:MPMediaItemPropertyTitle];

}
@end
