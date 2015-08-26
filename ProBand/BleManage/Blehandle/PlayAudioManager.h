//
//  PlayAudioManager.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleMecro.h"
#import "BleSinglten.h"
@interface PlayAudioManager : NSObject
SINGLETON

-(void)playAudio:(NSString *)audioName audioType:(NSString *)audioType;
-(void)stopFindPhone;
@end
