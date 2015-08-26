//
//  BluetoothManage.h
//  iiTagBluetooth
//
//  Created by shi hu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AlertTableView.h"


#define ConnectSuccess @"ConnectSuccess"
#define ConnectFail @"ConnectFail"
#define disConnect @"disConnect"

#define SERVICE_UUID    @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E" //@"6e400001-b5a3-f393-e0a9-e50e24dcca9f"

/**
 *  写特性uuid，写入数据
 */
#define WRITE_UUID    @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E" // @"6e400002-b5a3-f393-e0a9-e50e24dcca9f"
                         
/**
 *  读特性uuid，读出数据
 */
#define RADE_UUID    @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E" //@"6e400003-b5a3-f393-e0a9-e50e24dcca9f"




typedef enum
{
    connected,
    connectFail,
    ConnectLost,
} BleStatus;

@protocol BluetoothManageDelegate
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
-(void)didReceiveData:(NSData *)data;
-(void)showReturnStatus:(NSString *)status address:(NSString *)address;
- (void) showReturnMessage:(NSString *)message type:(NSString *)type;
@end

@interface BluetoothManage : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate,AlertTableViewDelegate>
{
    AlertTableView *device_picker;
    BOOL AutoScan;
    CBPeripheral *connectPeripheral;
  
    CBCentralManager    *centralManager;
	BOOL				pendingInit;
    NSTimer   *TimerReadRSSI;
  
    NSString *serviceUUIDString;
    CBPeripheral *servicePeripheral;
    NSString *PeripheralAddress;
    NSMutableArray    *foundPeripheralAddress;
    NSMutableArray    *foundPeripherals;
    CBCharacteristic *writeCharacteristic;
    
}
//获取信号最强的设备
-(CBPeripheral *)getMaxRSSIperipheral;
-(NSString  *)getMaxRSSIperipheralName;
//block
typedef void (^ConnectStatusBlock)(NSString *);
@property (nonatomic, copy) ConnectStatusBlock connectStatusBlock;
- (void) scanBle;
- (void) scanBleAuto;
- (void) startAutoScan;
- (void) startScan;
-(void)sendData:(NSData *)toSend;
+ (id)sharedInstance;
-(void)writeMeaasge:(NSData *)message   serviceUUID:(NSString *)serviceUUID writeUUID:(NSString *)writeUUID;
-(void)connectLastPeripheral;
-(void)stopLastConnect;
- (void) loadSavedDevices;
- (void) startScanningForUUIDString:(NSString *)uuidString  isAutoScan:(BOOL)isAutoScan;
- (void) stopScanDevice;
- (void) clearDevices;
- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;
-(void) disconnectCurPeripheral:(int)index;
@property (nonatomic, assign)  id delegate;
@property (nonatomic, retain) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCentralManager    *centralManager;
@property (nonatomic, retain) NSTimer *TimerReadRSSI;
@property (nonatomic,retain) NSString *PeripheralAddress;
@property (nonatomic,retain) NSString *serviceUUIDString;

@property (nonatomic,retain) CBPeripheral *connectedPeripheral;
@property (nonatomic,retain) NSMutableArray    *foundPeripheralAddress;
@property (nonatomic,retain) NSMutableArray    *foundPeripherals;
@property (nonatomic,retain) NSMutableArray	*connectedServices;	// Array of LeManage
@property (nonatomic,strong)   NSString *myUUid;
@property (nonatomic,assign) BOOL isConnectedBLE;
@end
