//
//  DefaultString.h
//  BLEManager
//
//  Created by attack on 15/6/15.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#ifndef BLEManager_DefaultString_h
#define BLEManager_DefaultString_h

#pragma mark *************************** 服务以及特征UUID **********************************
#define SERVICE_UUID  @"F000C0E0-0451-4000-B000-000000000000" //@"6e400001-b5a3-f393-e0a9-e50e24dcca9f"

/**
 *  写特性uuid，写入数据
 */
#define WRITE_UUID    @"F000F0E7-0451-4000-B000-000000000000" // @"6e400002-b5a3-f393-e0a9-e50e24dcca9f"

/**
 *  读特性uuid，读出数据
 */
#define RADE_UUID     @"F000C0E1-0451-4000-B000-000000000000" //@"6e400003-b5a3-f393-e0a9-e50e24dcca9f"

#define BLEhead 0xAA
/**
 *  社交
 */
#define BLEsocial 0x11 /** 社交 **/
/**
 *  来电
 */
#define BLEcallPhone 0x12 /** 来电 **/
/**
 *  信息
 */
#define BLEnote 0x13 /** 信息 **/
/**
 *  日程
 */
#define BLEschedule 0x15 /** 日程 **/
/**
 *  时间和天气
 */
#define BLEtimeAndWeather 0x16 /** 时间和天气 **/
/**
 *  闹钟
 */
#define BLEalarm 0x17 /** 闹钟 **/
/**
 *  找手机
 */
#define BLEfind 0x18 /** 找手机 **/
/**
 *  电量
 */
#define BLEelectric 0x1A /** 电量 **/
/**
 *  用户信息
 */
#define BLEuserInfomation 0x1B /** 用户信息 **/
/**
 *  个人目标
 */
#define BLEmotionGoal 0x1C /** 个人目标 **/
/**
 *  历史
 */
#define BLEhistory 0x1D /** 历史 **/
/**
 *  手环版本
 */
#define BLEbandversion 0x20 /** 手环版本 **/
/**
 *  应用统计
 */
#define BLEappStatistics 0x23 /** 应用统计 **/
/**
 *  模式
 */
#define BLEbandModel 0x24 /** 模式 **/
/**
 *  通知手环有OTA更新
 */
#define BLEOTAUpgradeInform 0x30 /** 通知手环有OTA更新 **/
/**
 *  传输OTA升级包
 */
#define BLEOTAUpgradeBox 0x31 /** 传输OTA升级包 **/
/**
 *  绑定
 *
 */
#define BLEBingDing 0x28
#endif

