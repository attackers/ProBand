//
//  PeripheralModel.h
//  BLEManager
//
//  Created by attack on 15/6/11.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralModel : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;
/**
 *  设备名字
 */
@property (nonatomic,strong) NSString *name;
/**
 *  设备信号
 */
@property (nonatomic,assign) CGFloat RSSIValue;
/**
 *  设备UUID
 */
@property (nonatomic,strong) NSString *UUID;
@property (nonatomic,strong) NSString *macAddr;

@end
