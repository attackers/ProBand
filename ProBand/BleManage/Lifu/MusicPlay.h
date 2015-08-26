//
//  MusicPlay.h
//  BLEManager
//
//  Created by attack on 15/7/13.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MusicPlay : NSObject
- (void)play;
- (void)pause;
- (void)stop;
- (void)skipToNextItem;
- (void)skipToPreviousItem;
- (void)addVolume;
- (void)reduceVolume;
- (NSString*)getSongName;
@end
