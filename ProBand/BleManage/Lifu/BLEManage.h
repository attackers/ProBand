//
//  BLEManage.h
//  BLEManager
//
//  Created by attack on 15/6/11.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class BLEManage;
typedef void(^GetProbandList) (NSMutableArray *probandlistArray);
//typedef void(^ProBandList) (NSDictionary *dic);
typedef void(^CenterState) (BOOL open);

typedef void(^GetData) (NSData *data);

typedef void(^ConnectOk) (BOOL ok);

@interface BLEManage : NSObject
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,copy) CenterState centerState;
@property (nonatomic,copy)GetProbandList prolist;
@property (nonatomic,strong) ConnectOk connectOK;
@property (nonatomic,copy) GetData getdata;
@property (nonatomic,assign)BOOL isOpenOrOFF;
+(BLEManage*)shareCentralManager;
/**
 *  开始扫描
 */
- (void)startscanPeripheral;
/**
 *  停止扫描
 */
- (void)stopScanPeripheral;
/**
 *  连接指定设备
 *
 *  @param peripheral 所需要连接的设备
 */
- (void)connectPeripheral:(CBPeripheral*)peripheral;
/**
 *  写入数据
 *
 *  @param byte 所要写入的数据
 */
- (void)writeData:(NSData*)byte;
/**
 *  传递设备端传输过来的数据
 *
 *  @param data 设备端数据
 */
- (void)getPeripheralData:(GetData)data;
/**
 * 连接状态
 *
 *  @param state block bool值
 */
- (void)connectState:(ConnectOk)state;
/**
 *  传递扫描到的手环列表
 *
 *  @param list 列表
 */
- (void)returnProbandArray:(GetProbandList)list;
@end
