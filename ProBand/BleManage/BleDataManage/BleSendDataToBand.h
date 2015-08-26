//
//  BleSendDataToBand.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleMecro.h"
#import "BleSinglten.h"


@interface BleSendDataToBand : NSObject
@property (nonatomic,assign)BleAssistMessageState state;
@property (nonatomic,assign)BOOL isSeparate;//yes单独调用，no为状态机调用

SINGLETON
/**
 *  以状态机的形式发送数据到BLE设备
 */
-(void)didReceiveResponse;

/**
 *  简单命令头发送通用函数
 *
 *  @param type  简单指令类型
 *  @param param 携带的具体参数
 *
 *
 包括： GET_NRF_BDADDR                        = 0x61,//获取手环地址(IOS)
        GET_VERSION_ID                        = 0x62,//获取手环版本
        GET_BATTERY_LEVER                     = 0x63,//获取手环电池电量
        GET_TOTAL_STEPS                       = 0x6a,//获取手环步数
        GET_TOTAL_CALORIE                     = 0x6b,//获取手环卡路里
        SYNC_DATA_REQUEST    			     = 0xa2,//获取数据
        DATE_TIME_SET                         = 0x31,//全部使用UTC时间，添加时区。
        RESPOND_USER_INFO                     = 0x88,//同步用户信息
        PERSONAL_GOAL                         = 0x45,//个人目标
        RESPOND_AUTO_SLEEP_TIME               = 0x86,//同步睡眠设置
        RESPOND_ALARM                         = 0x87,//同步闹钟设置
        拍照 on/off
        同步防丢开关
        同步天气/同步短信/同步微信/twitter/facebook
 
        //只需接受信息的指令
        1.拍照信号
        2.来电静音/拒接 信号
        3.找手机
        4.同步数据
 */
- (void)sendSyncCMD:(WEARABLE_PACKAGEHEADER)type param:(id)param;
- (void)sendSampleCMD:(WEARABLE_PACKAGEHEADER)type param:(id)param;

/***********************************设置类发送方法*******************************/
/**
 *  获取手环Mac地址
 */
- (void)getCurrentBandMacAddress;
/**
 *  获取手环软件版本
 */
- (void)getCurrentBandVersionID;
/**
 *  获取手环电量
 */
- (void)getCurrentBatteryLever;
/**
 *  获取BLE外设总步数
 */
- (void)getCurrentTotalsStepToBand;
/**
 *  获取BLE外设总卡路里数
 */
-(void)getCurrentTotalCalorieToBand;
/**
 *  获取所有数据
 */
-(void)getAllDataFromBand;
-(void)getTotalStepDataFromBand;
-(void)getTotalSleepDataFromBand;
/**
 *  同步时间到手环
 */
-(void)sendSynTimeAndDateToBand;
/**
 *  发送用户信息
 */
-(void)sendUserInfoToBand;
/**
 *  同步个人目标设置
 */
-(void)sendUserGoalToBand;
/**
 *  从数据库中取出保存的开关状态，发送到BLE端。
 */
- (void)sendPhoneLostSwitchState;
/**
 *  同步睡眠设置到BLE外设
 */
-(void)sendOutoSleepSettingToBand;
/**
 *  同步APP闹钟设置到手环
 */
-(void)sendAlermSettingToBand;
/**
 *  同步天气信息到手环
 */
-(void)sendWeatherSettingToBand;
/**
 *  同步城市信息到手环
 */
-(void)sendCityNameToBand;
/**
 *  同步勿扰模式开始结束时间
 */
-(void)sendInDisturbTimeSettingToBand;
/**
 *  打开或者关闭相机
 *
 *  @param blean yes 为打开；no 为关闭
 */
- (void)openOrCloseCameraWithBlean:(BOOL)blean;
/**
 *  防丢、短信、电话、微信
 */
- (void)sendMCWSwitchState;
- (void)sendDFUCommond;

/**
 *  运动提醒
-(void)sendSportSettingToBand;
*/
@end
