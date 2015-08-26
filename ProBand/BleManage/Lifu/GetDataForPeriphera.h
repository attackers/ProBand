//
//  GetDataForPeriphera.h
//  BLEManager
//
//  Created by attack on 15/7/13.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  用于传送闹钟
 *
 */
typedef void(^MyAlarmList) (NSMutableArray* alermArray);
/**
 *  用于传输语音
 *
 */
typedef void(^VoiceData) (NSMutableData *voData);
/**
 *  主要用来接收手环发送过来的数据
 */
@interface GetDataForPeriphera : NSObject
@property (nonatomic,strong)AVAudioPlayer *audioPlay;
@property (nonatomic,copy)MyAlarmList alarmArray;
@property (nonatomic,copy)VoiceData voiceDataForBand;
/**
 * 初始化单例
 *
 *  @return 返回单例本身
 */
+ (GetDataForPeriphera*)shareDataForPeriphera;
/**
 *  返回闹钟列表
 *
 *  @param myAlarm 单个闹钟数据，根据协议格式存放数据
 */
- (void)returnMyAlarmList:(MyAlarmList)myAlarm;
/**
 *  语音日程数据
 *
 *  @param vData 传输的语音数据
 */
- (void)returnVoiceData:(VoiceData)vData;
@end
