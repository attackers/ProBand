//
//  SendCommandToPeripheral.h
//  BLEManager
//
//  Created by attack on 15/6/23.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEManage.h"
#import "GetWeather.h"

@interface SendCommandToPeripheral : NSObject
@property (nonatomic,strong)  BLEManage *manage;
/**
 *  位移，从高位和低位的转换
 *
 *  @param data 需要转换的数据
 *
 *  @return 返回转换后的数据
 */
- (NSData*)returnByteForData:(NSData*)data;
@end

#pragma mark ****************************** 日程信息 *****************************************
@interface ScheduleSyncInformation:SendCommandToPeripheral
/**
 *  同步日程
 */
- (void)scheduleSync;
/**
 *  日程提醒开
 */
- (void)scheduleReminOpen;
/**
 *  日程提醒关
 */
- (void)scheduleReminOff;
/**
 *  删除日程
 */
- (void)scheduleRemove;
@end

#pragma mark ****************************** 时间、天气同步 *****************************************
@interface DateAndWeatherInformation:SendCommandToPeripheral
/**
 *  时间同步
 */
- (void)timeSync;
/**
 *  天气同步
 */
- (void)weatherSync;
/**
 *  请求获取天气
 */
- (void)getWeather;
/**
 *  请求获取天气
 */
- (void)getTime;
@end

#pragma mark ****************************** 闹钟同步 *****************************************
/*
 *闹钟同步
 */
@interface AlermInformation:SendCommandToPeripheral
/**
 *  闹钟提醒
 *
 *  @param alarmhour          提示时间小时
 *  @param alarmin            提示时间分钟
 *  @param rep                重复周期，1为当天，最高位为0，参数为1-7
 *  @param openCMD            是否开启
 *  @param alerInstervalValue 提示间隔时间，单位为分，为0则响铃一次；
 *  @param capacityOpen       开启智能提醒
 *  @param alerTitle          提醒事项
 */
- (void)alermRemind:(UInt8)alarmhour alarmMin:(UInt8)alarmin repeat:(UInt8)rep isopen:(UInt8)openCMD interval:(UInt8)alerInstervalValue capacityAlarm:(UInt8)capacityOpen title:(NSString*)alerTitle;
/**
 *  闹钟打开
 */
- (void)alermOpen;
/**
 *  闹钟关闭
 */
- (void)alermOff;
/**
 *  闹钟列表
 */
- (void)alermList;
/**
 *  闹钟删除
 */
- (void)alermRemove:(UInt8)alermID;
@end

#pragma mark ****************************** 找手机 *****************************************
@interface FindPhoneInformation:SendCommandToPeripheral

/**
 *  找手机停止 (APP -> 手环)
 */
- (void)findStopForPhone;
@end


#pragma mark ****************************** 获取电量 **************************************
@interface ElectricInformation:SendCommandToPeripheral
/**
 *  获取电量请求
 */
- (void)getElectricRequest;
@end

#pragma mark ****************************** 睡眠数据 **************************************
@interface SleepInformation:SendCommandToPeripheral
/**
 *  睡眠数据请求
 */
- (void)sleepDataRequest;
@end

#pragma mark ****************************** 日常(计步)数据 **************************************
@interface DailyInformation:SendCommandToPeripheral
/**
 *  请求获取日常数据
 */
- (void)dailyReques;
@end

#pragma mark ****************************** 获取手环各种版本信息 **************************************
@interface VersionInformation:SendCommandToPeripheral
/**
 *  请求获取ST资源版本
 */
- (void)versionSTCode;
/**
 *  请求获取ST资源版本（预留）
 */
- (void)versionSTReources;
/**
 *  请求获取蓝牙版本
 */
- (void)versionBluetooth;
/**
 *  请求获取硬件版本
 */
- (void)versionHardware;
@end


#pragma mark ****************************** 各应用的使用情况统计 **************************************
@interface ProBandApplicationInfo:SendCommandToPeripheral
/**
 *  手环配对
 */
- (void)probandpair;
/**
 *  标准（计步）模式
 */
- (void)probandStandardPattern;
/**
 *  训练模式
 */
- (void)probandTrainPattern;
/**
 *  睡眠模式
 */
- (void)probandSleepPattern;
/**
 *  通知推送
 */
- (void)probandNotify;
/**
 *  语音日程
 */
- (void)probandVoiceDaily;
/**
 *  支付
 */
- (void)probandPay;
/**
 *  找手机
 */
- (void)probandFindPhone;
/**
 *  闹钟
 */
- (void)probandAlarm;
@end

#pragma mark ****************************** 手环模式切换(预留) **************************************
@interface ProBandPatternChangCommand:SendCommandToPeripheral
- (void)sleepPattern;
- (void)dailyPattern;
- (void)TrainPattern;
@end
#pragma mark ****************************** 个人目标 **************************************

@interface PersonalGoalsRequest:SendCommandToPeripheral
/**
 *  运动目标
 */
- (void)getMovementGoals;
/**
 *  睡眠目标
 */
- (void)getSleepGoals;
/**
 *  训练目标
 */
- (void)getTrainGoals;
/**
 *  传输运动目标
 *  step:步数
 *  calorie:卡路里
 *  movementTime:运动时间
 *  distances:距离
 */
- (void)sendMovementGoals:(UInt16)step Calorie:(UInt16)calorie MovementTime:(UInt32)movementTime Distances:(UInt32)distances;
/**
 *  传输睡眠目标
 *  startH:开始时间的小时数
 *  startM:开始时间的分钟数
 *  endH:结束时间小时数
 *  endM:结束时间分钟数
 *  open:自动睡眠开关，1表示开，0表示关
 */
- (void)sendSleepGoals:(UInt8)startH StartM:(UInt8)startM EndH:(UInt8)endH EndM:(UInt8)endM automaticSleep:(UInt8)open;
/**
 *  传输训练目标
 *  type:目标类型，1表示距离，0表示时间
 *  duration:训练时长
 *  distance:训练距离
 */
- (void)sendTrainGoals:(UInt8)type Duration:(UInt32)duration Distance:(UInt32)distance;
@end

#pragma mark ****************************** 个人信息 **************************************

@interface UserInfoMation:SendCommandToPeripheral
/**
 *  发送用户信息
 *
 *  @param age    年龄
 *  @param gender 性别
 *  @param high   身高
 *  @param weight 体重
 *  @param name   名字
 */
- (void)sendUserInfoMation:(UInt8)age Gender:(UInt8)gender High:(UInt8)high Weight:(UInt8)weight Name:(NSString*)name;
@end

#pragma mark ****************************** 历史数据 **************************************
@interface HistoryData:SendCommandToPeripheral
/**
 *  获取历史数据;接收历史数据类是HistoryDataInfomation
 */
- (void)getHostoryDataRequest;
/**
 *  命令手环清除历史数据
 */
- (void)SendCommandDeleteHostoryData;
@end

#pragma mark ****************************** OTA升级 **************************************
@interface OTAUpgradeManager:SendCommandToPeripheral
- (void)NoticeBandUpgrade;
- (void)sendUpgradeBox;
@end