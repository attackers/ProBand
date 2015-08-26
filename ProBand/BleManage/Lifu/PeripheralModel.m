//
//  PeripheralModel.m
//  BLEManager
//
//  Created by attack on 15/6/11.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "PeripheralModel.h"
@implementation PeripheralModel
- (void)setPeripheral:(CBPeripheral*)peripheral
{
    _peripheral = peripheral;
    _name = peripheral.name;
    _RSSIValue = [peripheral.RSSI floatValue];
    _UUID = peripheral.identifier.UUIDString;
    
}
@end
