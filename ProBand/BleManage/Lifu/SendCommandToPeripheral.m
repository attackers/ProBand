//
//  SendCommandToPeripheral.m
//  BLEManager
//
//  Created by attack on 15/6/23.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "SendCommandToPeripheral.h"
#import "GetWeather.h"
@interface SendCommandToPeripheral()

@end
@implementation SendCommandToPeripheral
-(instancetype)init
{
    if (self == [super init]) {
        _manage = [BLEManage shareCentralManager];
    }
    return self;
}
- (NSData*)returnByteForData:(NSData*)data
{
    
    Byte *byData = (Byte*)[data bytes];
    
    Byte yb[[data length]];
    for (int i = 0; i<data.length; i++) {
        NSLog(@"by = %d",byData[i]);
        yb[[data length]- 1-i] = byData[i];
        
    }
    
    NSData *das = [NSData dataWithBytes:&yb length:sizeof(yb)];
    for (int i = 0; i<das.length; i++) {
        NSLog(@"yb = %d",yb[i]);
    }
    
    return das;
}
@end

@implementation ScheduleSyncInformation

- (void)scheduleSync:(NSTimeInterval)timeIn  content:(NSString*)content
{
    Byte bytes[4] = {BLEhead,BLEschedule,0x00,0x26};
    UInt16 leg = CFSwapInt16(13);
    UInt8 box = 1;
    UInt32 t = CFSwapInt32(timeIn);
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *sendData = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [sendData appendBytes:&leg length:sizeof(leg)];
    [sendData appendBytes:&box length:sizeof(box)];
    [sendData appendBytes:&t length:sizeof(t)];
    UInt8 source = 0;
    [sendData appendBytes:&source length:sizeof(source)];
    [sendData appendData:contentData];
    
    int l = 20 - sendData.length;
    for (int i = 0; i<l; i++) {
        UInt8 v = 0;
        [sendData appendBytes:&v length:sizeof(v)];
        
    }
    
    [self.manage writeData:sendData];
    
}
- (void)scheduleReminOpen
{
    //Byte *bytes = ScheduleRemindOpen;
    
}
- (void)scheduleReminOff
{
    //Byte *bytes = ScheduleRemindOff;
    
}
- (void)scheduleRemove
{
    //Byte *bytes = ScheduleRemove;
    
}
@end

@implementation DateAndWeatherInformation

- (void)timeSync
{
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    
    Byte by[4] = {BLEhead,BLEtimeAndWeather,0x00,0x22};
    UInt16 leg = CFSwapInt16(13);
    UInt8 box = 1;
    UInt32 timeValue = t;
    UInt8 timezone = 8;
    NSMutableData *data = [NSMutableData dataWithBytes:by length:sizeof(by)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    
    NSData *da = [NSData dataWithBytes:&timeValue length:sizeof(timeValue)];
    Byte *byData = (Byte*)[da bytes];
    Byte yb[[da length]];
    for (int i = 0; i<da.length; i++) {
        NSLog(@"by = %d",byData[i]);
        yb[[da length]- 1-i] = byData[i];
    }
    NSData *das = [NSData dataWithBytes:&yb length:sizeof(yb)];
    for (int i = 0; i<das.length; i++) {
        NSLog(@"yb = %d",yb[i]);
    }
    
    [data appendBytes:&yb length:sizeof(yb)];
    [data appendBytes:&timezone length:sizeof(timezone)];
    
    int l = 20 - data.length;
    for (int i = 0; i< l; i++) {
        UInt8 v = 0;
        [data appendBytes:&v length:sizeof(v)];
    }
    [self.manage writeData:data];
}
- (void)weatherSync
{
    Byte by[4] = {BLEhead,BLEtimeAndWeather,0x00,0x21};
    UInt16 leg = CFSwapInt16(13);
    UInt8 box = 1;
    NSData *getWeatherData = [[GetWeather shareGetWeather]weatherByte];
    NSMutableData *sendData = [NSMutableData dataWithBytes:&by length:sizeof(by)];
    [sendData appendBytes:&leg length:sizeof(leg)];
    [sendData appendBytes:&box length:sizeof(box)];
    [sendData appendData:getWeatherData];
    
    int l = 20 - sendData.length;
    for (int i = 0; i< l; i++) {
        UInt8 v = 0;
        [sendData appendBytes:&v length:sizeof(v)];
    }
    
    [self.manage writeData:sendData];
}

@end

@implementation AlermInformation

- (void)alermRemind:(UInt8)alarmhour alarmMin:(UInt8)alarmin repeat:(UInt8)rep isopen:(UInt8)openCMD interval:(UInt8)alerInstervalValue capacityAlarm:(UInt8)capacityOpen title:(NSString*)alerTitle;
{
    Byte bytes[4] = {BLEhead,BLEalarm,0x00,0x21};
    UInt8 alarmNumber = arc4random()%99+0;
    UInt8 alarmHour = alarmhour;
    UInt8 alarmMin = alarmin;
    UInt8 repeat  = rep;
    UInt8 open = openCMD;
    UInt16 alerInterval = CFSwapInt16(alerInstervalValue);
    UInt8 source = 0;
    UInt8 capacityAlarm = capacityOpen;
    NSString *string = @"好";
    NSData *titleData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    UInt16 leg = CFSwapInt16(9+titleData.length);
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    int i = 0;
    while (i<=titleData.length/4) {
        UInt8 box = i+1;
        NSMutableData *sendData = [NSMutableData dataWithData:data].mutableCopy;
        [sendData appendBytes:&box length:sizeof(box)];
        if (i==0) {
            
            [sendData appendBytes:&alarmNumber length:sizeof(alarmNumber)];
            [sendData appendBytes:&alarmHour length:sizeof(alarmHour)];
            [sendData appendBytes:&alarmMin length:sizeof(alarmMin)];
            [sendData appendBytes:&repeat length:sizeof(repeat)];
            [sendData appendBytes:&open length:sizeof(open)];
            [sendData appendBytes:&alerInterval length:sizeof(alerInterval)];
            [sendData appendBytes:&source length:sizeof(source)];
            [sendData appendBytes:&capacityAlarm length:sizeof(capacityAlarm)];
        }
        
        if (i==titleData.length/4) {
            [sendData appendData:[titleData subdataWithRange:NSMakeRange(i*4, titleData.length%4)]];
        }else{
            [sendData appendData:[titleData subdataWithRange:NSMakeRange(i*4, 4)]];
        }
        [self.manage writeData:sendData];
        i++;
    }
}
- (void)alermOpen
{
    Byte bytes[5] = {BLEhead,BLEalarm,0x00,0x24,1};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.manage writeData:data];
    
}
- (void)alermOff
{
    Byte bytes[5] = {BLEhead,BLEalarm,0x00,0x24,2};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.manage writeData:data];
}
- (void)alermList
{
    Byte bytes[4] = {BLEhead,BLEalarm,0x00,0x25};
    UInt16 leg = CFSwapInt16(13);
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    NSInteger l = 20-data.length;
    for (int i = 0; i< l; i++) {
        UInt8 v = 0;
        [data appendBytes:&v length:sizeof(v)];
    }
    [self.manage writeData:data];
    
}
- (void)alermRemove:(UInt8)alermID
{
    Byte bytes[4] = {BLEhead,BLEalarm,0x00,0x26};
    UInt16 leg = 0x00;
    UInt8 box = 0x01;
    UInt8 number = alermID;
    UInt8 source = 0;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [data appendBytes:&number length:sizeof(number)];
    [data appendBytes:&source length:sizeof(source)];
    [self.manage writeData:data];
}
@end

@implementation FindPhoneInformation

- (void)findStopForPhone
{
    Byte bytes[4] = {BLEhead,BLEfind,0x00,0x21};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.manage writeData:data];
}

@end

@implementation ElectricInformation

- (void)getElectricRequest
{
    Byte bytes[4] = {BLEhead,BLEelectric,0x00,0x21};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [self.manage writeData:data];
}
@end

@implementation SleepInformation

- (void)sleepDataRequest
{
    //Byte *bytes = SleepDataRequest;
    
}

@end

@implementation DailyInformation
- (void)dailyReques
{
    //Byte *bytes = DailyRequest;
}
@end

@implementation VersionInformation

- (void)versionSTCode
{
    //Byte *bytes = VersionSTCode;
}
- (void)versionSTReources
{
    //Byte *bytes = VersionSTResources;
}
- (void)versionBluetooth
{
    //Byte *bytes = VersionBluetooth;
}
- (void)versionHardware
{
    //Byte *bytes = VersionHardware;
}

@end

@implementation ProBandApplicationInfo

- (void)probandpair
{
    //Byte *bytes = ProbandPair;
}
- (void)probandStandardPattern
{
    //Byte *bytes = ProbandStandardPattern;
    
    
}
- (void)probandTrainPattern
{
    //Byte *bytes = ProbandTrainPattern;
    
    
}
- (void)probandSleepPattern
{
    //Byte *bytes = ProbandSleepPattern;
    
    
}
- (void)probandNotify
{
    //Byte *bytes = ProbandNotify;
    
    
}
- (void)probandVoiceDaily
{
    //Byte *bytes = ProbandVoiceDaily;
    
    
}
- (void)probandPay
{
    //Byte *bytes = ProbandPay;
    
    
}
- (void)probandFindPhone
{
    //Byte *bytes = ProbandFindPhone;
    
    
}
- (void)probandAlarm
{
    //Byte *bytes = ProbandAlarm;
    
    
}
@end

@implementation ProBandPatternChangCommand
- (void)sleepPattern
{
    //Byte *bytes = Sleep;
    
    
}
- (void)dailyPattern
{
    //Byte *bytes = Daily;
    
    
}
- (void)TrainPattern
{
    //Byte *bytes = Train;
    
    
}
@end
@implementation PersonalGoalsRequest

- (void)getMovementGoals
{
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x21};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [self.manage writeData:data];
}
- (void)getSleepGoals
{
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x23};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [self.manage writeData:data];
}

- (void)getTrainGoals
{
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x25};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [self.manage writeData:data];
}
- (void)sendMovementGoals:(UInt16)step Calorie:(UInt16)calorie MovementTime:(UInt32)movementTime Distances:(UInt32)distances
{
    
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x22};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [data appendBytes:&step length:sizeof(step)];
    [data appendBytes:&calorie length:sizeof(calorie)];
    [data appendBytes:&movementTime length:sizeof(movementTime)];
    [data appendBytes:&distances length:sizeof(distances)];
    [self.manage writeData:data];
    
}
- (void)sendSleepGoals:(UInt8)startH StartM:(UInt8)startM EndH:(UInt8)endH EndM:(UInt8)endM automaticSleep:(UInt8)open
{
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x24};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [data appendBytes:&startH length:sizeof(startH)];
    [data appendBytes:&startM length:sizeof(startM)];
    [data appendBytes:&endH length:sizeof(endH)];
    [data appendBytes:&endM length:sizeof(endM)];
    [data appendBytes:&open length:sizeof(open)];
    [self.manage writeData:data];
}
- (void)sendTrainGoals:(UInt8)type Duration:(UInt32)duration Distance:(UInt32)distance
{
    Byte bytes[4] = {BLEhead,BLEmotionGoal,0x00,0x26};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [data appendBytes:&type length:sizeof(type)];
    [data appendBytes:&duration length:sizeof(duration)];
    [data appendBytes:&distance length:sizeof(distance)];
    [self.manage writeData:data];
}

@end

@implementation UserInfomation

- (void)sendUserInfomationToBand:(UInt8)age Gender:(UInt8)gender Height:(UInt8)height Weight:(UInt8)weight Name:(NSString*)name
{
    Byte bytes[4] = {BLEhead,BLEuserInfomation,0x00,0x21};
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    UInt16 leg = CFSwapInt16(4+nameData.length);
    [data appendBytes:&leg length:sizeof(leg)];
    int i = 0;
    while (nameData.length/9 >= i) {
        NSMutableData *sendData = [NSMutableData dataWithData:data];
        UInt8 box = i+1;
        UInt8 userAge = age;
        UInt8 userGender = gender;
        UInt8 userHeight = height;
        UInt8 userWeight = weight;
        NSMutableData *sendNameData = [NSMutableData data];
        if (nameData.length/9==i) {
            sendNameData = [nameData subdataWithRange:NSMakeRange(i*9, nameData.length%9)].mutableCopy;
        }else{
            sendNameData = [nameData subdataWithRange:NSMakeRange(i*9, 9)].mutableCopy;
        }
        [sendData appendBytes:&box length:sizeof(box)];
        [sendData appendBytes:&userAge length:sizeof(userAge)];
        [sendData appendBytes:&userGender length:sizeof(userGender)];
        [sendData appendBytes:&userHeight length:sizeof(userHeight)];
        [sendData appendBytes:&userWeight length:sizeof(userWeight)];
        [sendData appendData:sendNameData];
        [self.manage writeData:sendData];
        i++;
    }
}
@end
@implementation HistoryData

- (void)getHostoryDataRequest
{
    Byte bytes[4] = {BLEhead,BLEhistory,0x00,0x21};
    UInt16 leg = CFSwapInt16(13);
    UInt8 box = 1;
    UInt8 values = 0;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [data appendBytes:&values length:sizeof(values)];
    int l = 20 - data.length;
    for (int i = 0; i <l ; i++) {
        UInt8 va = 0;
        [data appendBytes:&va length:sizeof(va)];
        
    }
    [self.manage writeData:data];}

- (void)SendCommandDeleteHostoryData
{
    Byte bytes[4] = {BLEhead,BLEhistory,0x00,0x29};
    UInt16 leg = 0x00;
    UInt8 box = 1;
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:sizeof(bytes)];
    [data appendBytes:&leg length:sizeof(leg)];
    [data appendBytes:&box length:sizeof(box)];
    [self.manage writeData:data];
}

@end