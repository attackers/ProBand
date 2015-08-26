//
//  BleGetDataFromBand.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleMecro.h"

@interface BleGetDataFromBand : NSObject
SINGLETON

@property (nonatomic, strong)void(^getDataFromBandToApp)(NSData *resultData);//BLE设备接收到数据时的回调，如遥控牌拍照等

- (void)didReceiveDataFromBand:(NSData *)data;
/**
 *  由于IOS系统的限制，在连接上BLE设备后APP主动去请求获得蓝牙MAC地址
 *
 *  @param data 获得的原始数据
 */
-(void)didReceiveMacAddressFromBand:(NSData *)data;
/**
 *  获取BLE设备的版本号
 *
 *  @param data 接收到的源数据
 */
-(void)didReceiveBandSoftwareVersion:(NSData *)data;
/**
 *  得到手环电量情况
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveBatteryLeverFromBand:(NSData *)data;

/**
 *  获取BLE设备上的总步数
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotalUiStepfromBand:(NSData *)data;

/**
 *  获取BLE设备上总的卡路里
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotalUiCalofromBand:(NSData *)data;
/**
 *  获取BLE设备上总的睡眠数
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotaluiSleepTimeFromBand:(NSData *)data;

/**
 *  获取手环详细
 *
 *  @param data 获取手环详细信息，计步睡眠
 */
- (void)didReceiveAllDetailDataFromBand:(NSData *)data;
/**
 *  同步历史数据完成
 */
-(void)synchronizationDataFinish;



@end

