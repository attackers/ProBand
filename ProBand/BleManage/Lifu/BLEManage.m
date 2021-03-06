
//  BLEManage.m
//  BLEManager
//
//  Created by attack on 15/6/11.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "BLEManage.h"
#import <UIKit/UIKit.h>
#import "PeripheralModel.h"
#import "DefaultString.h"
#import "SendCommandToPeripheral.h"
@interface BLEManage()<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>
{
    NSMutableArray *peripheralArray;
    PeripheralModel *peripheralModel;
    CBCharacteristic *writeCharacteristic;
    
}
@end
@implementation BLEManage
+(BLEManage*)shareCentralManager
{
    static BLEManage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BLEManage alloc]init];
        
    });
    return manager;
}
-(instancetype)init
{
    
    if (self ==[super init]) {
        
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        peripheralModel = [[PeripheralModel alloc]init];
        peripheralArray = [NSMutableArray array];
        
    }
    return self;
}
#pragma mark ************** scan peripheral  connect peripheral  disconnect peripheral **************
/**
 *  查看设备有没有开启蓝牙
 *
 *  @param central 设备本身
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state){
        case CBCentralManagerStatePoweredOn:
        {
            if (_centerState) {
                _centerState(YES);
            }
            _isOpenOrOFF = YES;
            NSLog(@"蓝牙已打开,请扫描外设");
            [self startscanPeripheral];
            _centralManager = central;//扫描
        }
            break;
            
        case CBCentralManagerStateUnsupported:
        {
            if (_centerState) {
                _centerState(NO);
                
            }
            _isOpenOrOFF = NO;
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"not_support_BT", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"i_know", nil), nil];
            [aler show];
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            if (_centerState) {
                
                _centerState(NO);
                
            }
            _isOpenOrOFF = NO;
            NSLog(@"未授权");
            
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            if (_centerState) {
                
                _centerState(NO);
                
            }
            _isOpenOrOFF = NO;
            NSLog(@"蓝牙未打开");
        }//蓝牙未打开，系统会自动提示打开，所以不用自行提示
        default:
            break;
    }
}
/**
 *  开始扫描
 */
- (void)startscanPeripheral
{
    
    /**
     *  启动扫描，其中第一个参数为设备的服务UUID,第二个为扫描方式，当前是设备扫描设备后，对已扫描设备不做重复扫描
     */
 
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];

}
/**
 *  停止扫描
 */
- (void)stopScanPeripheral
{
    [_centralManager stopScan];
    if (_prolist) {
        
        _prolist(peripheralArray);
        
    }
}
- (void)returnProbandArray:(GetProbandList)list
{
    _prolist = ^(NSMutableArray *array){
        list(array);
    };
}
/**
 *  搜索到peripheral设备
 *
 *  @param central           设备本身
 *  @param peripheral        扫描到的设备
 *  @param advertisementData 扫描到的设备信息
 *  @param RSSI              扫描到的设备信号
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    _centralManager = central;
    _peripheral = peripheral;
    NSString *defaultUUID = [[NSUserDefaults standardUserDefaults]objectForKey:[Singleton getUserID]];
    
    if ([defaultUUID isEqualToString:peripheral.identifier.UUIDString]) {
        [_centralManager stopScan];
        peripheralModel.peripheral = peripheral;
        _peripheral = peripheral;
        [_centralManager connectPeripheral:peripheral options:nil];
        
    }
    if (peripheralArray.count == 0) {
        
        if (peripheral.name.length>7) {
            NSString *nameSub = [peripheral.name substringWithRange:NSMakeRange(0, 7)];
            if (![nameSub isEqualToString:@"payband"]) {
                return;
            }
        }else{
            return;
        }
        
        NSArray *array = [advertisementData objectForKey:@"kCBAdvDataSolicitedServiceUUIDs"];
        CBUUID *uuidAdvData = array[2];
        peripheralModel.peripheral = peripheral;
        if (uuidAdvData.UUIDString.length== 0 ) {
            peripheralModel.macAddr = @"0000";
            
        }else{
            peripheralModel.macAddr = uuidAdvData.UUIDString;
            
        }
        [peripheralArray addObject:peripheralModel];
        
    }else{
        @try {
            if (peripheral.name.length>7) {
                NSString *nameSub = [peripheral.name substringWithRange:NSMakeRange(0, 7)];
                if (![nameSub isEqualToString:@"payband"]) {
                    return;
                }
            }else{
                return;
            }
            
            BOOL inArray = NO;
            for (int i = 0; i<peripheralArray.count; i++) {
                PeripheralModel *mode=peripheralArray[i];
                NSString *pName = peripheral.name;
                if ([mode.name isEqualToString:pName]) {
                    inArray = YES;
                    break;
                }
            }
            if (!inArray) {
                NSArray *array = [advertisementData objectForKey:@"kCBAdvDataSolicitedServiceUUIDs"];
                CBUUID *uuidAdvData = array[2];
                PeripheralModel *m = [[PeripheralModel alloc]init];
                if (uuidAdvData.UUIDString.length == 0 ) {
                    m.macAddr = @"0000";
                }else{
                    m.macAddr = uuidAdvData.UUIDString;
                }
                m.peripheral = peripheral;
                [peripheralArray addObject:m];
            }
            
            inArray = NO;
        }

        @catch (NSException *exception) {
            NSLog(@"exception:%@",exception);
        }
        @finally {
        }
        
    }
    NSLog(@"advertisementData: %@",advertisementData);
    NSDictionary *dic = advertisementData;
    [dic setValue:peripheral forKey:@"peripheral"];
    
}

/**
 *  与peripheral设备连接成功
 *
 *  @param central    设备本身
 *  @param peripheral 所连接的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"is connect peripheral");
    _peripheral = peripheral;
    _peripheral.delegate = self;
    if (_connectOK) {
        _connectOK(YES);
        
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:peripheral.identifier.UUIDString forKey:[Singleton getUserID]];
    NSArray	*serviceArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:SERVICE_UUID], nil];
    [_peripheral discoverServices:serviceArray];
}
/**
 *  连接失败
 *
 *  @param central    设备本身
 *  @param peripheral 所连接的设备
 *  @param error      错误信息
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _peripheral = peripheral;
    //    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"is not" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    //    [aler show];
    if (error) {
        if (_connectOK) {
            _connectOK(NO);
        }
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [central cancelPeripheralConnection:peripheral];
        [central connectPeripheral:peripheral options:nil];
        return;
    }
}
/**
 *  与peripheral设备断开连接。BLE默认情况下会与设备连接一定时间后自动断开，需要在此做相关的自动连接
 *
 *  @param central    设备本身
 *  @param peripheral 所断开的设备
 *  @param error      错误信息
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _peripheral = peripheral;
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
    }
    if (_connectOK) {
        _connectOK(NO);
    }
    NSLog(@"is Disconnect peripheral");
    [central connectPeripheral:_peripheral options:nil];
}

#pragma mark ********************** Services Characteristics ***************************
/**
 *  读取设备服务
 *
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    _peripheral = peripheral;
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"discover Services");
    for (CBService *service in peripheral.services) {
        
        NSLog(@"serviceUUID:%@",service.UUID.UUIDString);
        
        if ([service.UUID.UUIDString isEqualToString:SERVICE_UUID]) {
            
            NSArray *array = [NSArray arrayWithObjects:[CBUUID UUIDWithString:WRITE_UUID],[CBUUID UUIDWithString:RADE_UUID],nil];
            [peripheral discoverCharacteristics:array forService:service];
            
        }
    }
}
/**
 *  读取设备特征
 *
 *  @param service    指定的服务
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (_connectOK) {
        _connectOK(YES);
        
    }
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"discover characteristics");
    NSArray *array =  service.characteristics;
    
    for (CBCharacteristic *characteristic in array) {
        _peripheral = peripheral;

        CBUUID *uuid = characteristic.UUID;
        NSLog(@"charateristicUUID:%@",uuid.UUIDString);
        if ([uuid.UUIDString isEqualToString:WRITE_UUID]) {
            
            writeCharacteristic = characteristic;
            NSLog(@"charateristicUUID:%@",uuid.UUIDString);
            [self syncData];
            
        }
        if ([uuid.UUIDString isEqualToString:RADE_UUID]) {
            _peripheral = peripheral;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }

        
    }
}
/**
 *  写入数据后的回调
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    _peripheral = peripheral;
    NSData *data =  characteristic.value;
    Byte *byte = (Byte*)[data bytes];
    for (int i = 0 ; i<[data length]; i++) {
        
        NSLog(@"byte%d:%c",i,byte[i]);
    }
    if (error) {
        
        NSLog(@"Error: %@", [error userInfo]);
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSData *data = characteristic.value;
    const unsigned char *byte = (Byte*)[data bytes];
    for (int i= 0;i<[data length];i++) {
        NSLog(@"byte：%@",[NSString stringWithFormat:@"%02x", byte[i]]);
    }
}
/**
 *  读取或者订阅特征的回调
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSData *data = characteristic.value;
    if (_getdata) {
        _getdata(data);
    }
#ifdef _DEBUG
    const unsigned char *byte = (Byte*)[data bytes];
    for (int i= 0;i<[data length];i++) {
        NSLog(@"byte：%@",[NSString stringWithFormat:@"%02x", byte[i]]);
    }
#endif
    
}
#pragma mark *************************** 自定义方法 **********************************

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)readRSSI
{
    [_peripheral readRSSI];
    NSLog(@"peripheralRSSI：%@",_peripheral.RSSI);
}

- (void)writeData:(NSData*)byte
{
    
    NSData *data = byte;
#warning -写特性可能为空
    [_peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
- (void)getPeripheralData:(GetData)data
{
    _getdata = ^(NSData *datas){
        data(datas);
    };
    
}
- (void)connectPeripheral:(CBPeripheral*)peripheral
{
    
    [_centralManager connectPeripheral:peripheral options:nil];
    [self performSelector:@selector(isConnectOk) withObject:self afterDelay:10];
}
- (void)isConnectOk
{
    if (_peripheral.state != CBPeripheralStateConnected) {
    
        [_centralManager cancelPeripheralConnection:_peripheral];
        if (_connectOK) {
            
            _connectOK(NO);
        }
    }
}
- (void)connectState:(ConnectOk)state
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _connectOK = ^(BOOL ok){
        state(ok);
        if (ok) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"connect" object:@YES];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"connect" object:@NO];

        }
    };
    [def synchronize];
}
- (void)syncData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[DateAndWeatherInformation alloc]init] timeSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[DateAndWeatherInformation alloc]init] weatherSync];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Byte by[4] = {BLEhead,BLEBingDing,0x33,0x21};
            UInt8 box = 1;
            UInt8 type = 2;
            NSString *userID = [Singleton getUserID];
            NSLog(@"userID:%@",userID);
            NSData *uData = [userID dataUsingEncoding:NSUTF8StringEncoding];
            UInt16 leg = CFSwapInt16(13);
            
            NSMutableData *sendData = [NSMutableData dataWithBytes:by length:sizeof(by)];
            [sendData appendBytes:&leg length:sizeof(leg)];
            [sendData appendBytes:&box length:sizeof(box)];
            [sendData appendBytes:&type length:sizeof(type)];
            [sendData appendData:uData];
            if (sendData.length<20) {
                NSInteger l = 20 - sendData.length;
                for (NSInteger i = 0; i<l; i++) {
                    UInt8 v = 0;
                    [sendData appendBytes:&v length:sizeof(v)];
                }
            }
            [self writeData:sendData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[HistoryData alloc]init] getHostoryDataRequest];
    });

}

@end
