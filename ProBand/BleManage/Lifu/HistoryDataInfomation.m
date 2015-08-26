//
//  HistoryDataInfomation.m
//  ProBand
//
//  Created by attack on 15/7/31.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "HistoryDataInfomation.h"
#import "t_exerciseData.h"
#import "t_sleepData.h"
#import "t_stepData.h"
#import "DailyDataManager.h"
#import "ExerciseDataManager.h"
#import "SleepDataManager.h"
@interface HistoryDataInfomation()
{
    
    NSMutableArray *sleepDataArray;/*睡眠数据*/
    NSMutableArray *everyDayArray;/*日常数据*/
    NSMutableArray *trainArray;/*训练数据*/
    NSMutableArray *everyDayStatisticsArray;/*日常统计数据*/
    NSMutableArray *trainStatisticsArray;/*训练统计数据*/
    NSMutableArray *sleepDataStatisticsArray;/*睡眠统计数据*/
    
    NSMutableData *sleepStatisticsData;/*拼接睡眠统计数据*/
    
    UInt32 goToSleepU32;/*入睡时间*/
    UInt32 getUpSleepU32;/*起床时间*/
    UInt16 deepSleepU16;/*沉睡时长*/
    UInt16 shallowSleepU16;/*浅睡时长*/
    UInt16 awakeU16;/*清醒时长*/
    
}
@end
@implementation HistoryDataInfomation
+ (HistoryDataInfomation *)shareHistoryDataInfomation
{
    static HistoryDataInfomation *h = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        h=[[HistoryDataInfomation alloc]init];
    });
    return h;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        sleepDataArray = [NSMutableArray array];
        everyDayArray = [NSMutableArray array];
        trainArray = [NSMutableArray array];
        everyDayStatisticsArray = [NSMutableArray array];
        trainStatisticsArray = [NSMutableArray array];
        sleepDataStatisticsArray = [NSMutableArray array];
        sleepStatisticsData = [NSMutableData data];
        __weak HistoryDataInfomation *weakSelf = self;
        _bandHistoryData = ^(NSData *data){
            Byte *byte = (Byte*)[data bytes];
          NSString*  string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            [weakSelf historyClassify:comType Data:data];
        
        };
    }
    return self;
}
- (void)historyClassify:(int)type Data:(NSData*)data
{
    switch (type) {
        case 22:
        {
            NSData *suData = [data subdataWithRange:NSMakeRange(7, 5)];
            Byte *by = (Byte*)[[suData subdataWithRange:NSMakeRange(4, 1)] bytes];
            UInt32 timeUInt32 = [self NSDataToUInt32:[suData subdataWithRange:NSMakeRange(0, 4)]];
            UInt8 dData = by[0];
            NSLog(@"睡眠数据: %d %d",(unsigned int)timeUInt32,dData);
            
            NSMutableDictionary *Dic = [NSMutableDictionary dictionary];
            [Dic setValue:[Singleton getUserID] forKey:@"userid"];
            [Dic setValue:[Singleton getMacSite] forKey:@"mac"];
            [Dic setValue:[NSString stringWithFormat:@"%d",(unsigned int)timeUInt32] forKey:@"time"];

            if (dData<=10) {

                [Dic setValue:[NSString stringWithFormat:@"%d",1] forKey:@"sleeps"];

            }else if (dData>10&dData<=60){
                
                [Dic setValue:[NSString stringWithFormat:@"%d",2] forKey:@"sleeps"];

            }else{
            
                [Dic setValue:[NSString stringWithFormat:@"%d",3] forKey:@"sleeps"];

            }
            //添加by Star：向Attack说明
            [Dic setValue:@"0" forKey:@"isRead"];
            [sleepDataArray addObject:Dic];
        }
            break;
        case 23:
        {
            NSData *timeData = [data subdataWithRange:NSMakeRange(7, 4)];
            UInt32 timeUInt32 = [self NSDataToUInt32:timeData];
            
            NSData *suData = [data subdataWithRange:NSMakeRange(11, 2)];
            UInt16 stepUInt16 = [self NSDataToUInt16:suData];
            
            NSData *caData = [data subdataWithRange:NSMakeRange(13, 2)];
            UInt16 caUInt16 = [self NSDataToUInt16:caData];
            
            NSData *diData = [data subdataWithRange:NSMakeRange(15, 2)];
            UInt16 diUInt16 = [self NSDataToUInt16:diData];
            NSLog(@"日常数据: %d %d %d %d",(unsigned int)timeUInt32,stepUInt16,caUInt16,diUInt16);
            
            NSMutableDictionary *Dic = [NSMutableDictionary dictionary];
            
            [Dic setValue:[NSString stringWithFormat:@"%@",[Singleton getUserID]] forKey:@"userid"];
            [Dic setValue:[NSString stringWithFormat:@"%@",[Singleton getMacSite]] forKey:@"mac"];
            [Dic setValue:[NSString stringWithFormat:@"%d",(unsigned int)timeUInt32] forKey:@"time"];
            [Dic setValue:[NSString stringWithFormat:@"%d",stepUInt16] forKey:@"steps"];
            [Dic setValue:[NSString stringWithFormat:@"%d",caUInt16] forKey:@"kCalories"];
            [Dic setValue:[NSString stringWithFormat:@"%d",diUInt16] forKey:@"meters"];
            [Dic setValue:@"0" forKey:@"isRead"];
            [everyDayArray addObject:Dic];
        }
            break;
        case 24:
        {
            NSData *suData = [data subdataWithRange:NSMakeRange(7, 4)];
            UInt32 caUInt32 = [self NSDataToUInt32:suData];
            
            NSData *stData = [data subdataWithRange:NSMakeRange(11, 4)];
            UInt32 stUInt32 = [self NSDataToUInt32:stData];
            
            NSData *diData = [data subdataWithRange:NSMakeRange(15, 4)];
            UInt32 diUInt32 = [self NSDataToUInt32:diData];
             NSLog(@"日常统计数据: %d %d %d ",(unsigned int)caUInt32,(unsigned int)stUInt32,(unsigned int)diUInt32);
            
            NSMutableDictionary *stepDic = [NSMutableDictionary dictionary];
            [stepDic setValue:[Singleton getUserID] forKey:@"userid"];
            [stepDic setValue:[Singleton getMacSite] forKey:@"mac"];
            [stepDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)caUInt32] forKey:@"total_kCalory"];
            [stepDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)stUInt32] forKey:@"total_step"];
            [stepDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)diUInt32] forKey:@"total_meter"];            
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setValue:stepDic forKey:statisticsStepData];
            [de synchronize];
            
        }
            break;
        case 25:
        {
            NSData *suData = [data subdataWithRange:NSMakeRange(7, 4)];
            UInt32 timeData = [self NSDataToUInt32:suData];
            
            NSData *typeData = [data subdataWithRange:NSMakeRange(11, 1)];
            Byte *by = (Byte*)[typeData bytes];
            UInt8 tyData = by[0];
            
            NSData *stData = [data subdataWithRange:NSMakeRange(12, 2)];
            UInt16 stUInt = [self NSDataToUInt16:stData];
            
            NSData *caData = [data subdataWithRange:NSMakeRange(14, 2)];
            UInt16 caUInt16 = [self NSDataToUInt16:caData];
            
            NSData *diData = [data subdataWithRange:NSMakeRange(16, 2)];
            UInt16 diUInt16 = [self NSDataToUInt16:diData];
            NSLog(@"训练数据: %d %d %d %d %d",(unsigned int)timeData,tyData,stUInt,caUInt16,diUInt16);
            
            NSMutableDictionary *Dic = [NSMutableDictionary dictionary];
            [Dic setValue:[Singleton getUserID] forKey:@"userid"];
            [Dic setValue:[Singleton getMacSite] forKey:@"mac"];
            [Dic setValue:[NSString stringWithFormat:@"%d",(unsigned int)timeData] forKey:@"time"];
            [Dic setValue:[NSString stringWithFormat:@"%d",tyData] forKey:@"exercise"];
            [Dic setValue:[NSString stringWithFormat:@"%d",stUInt] forKey:@"steps"];
            [Dic setValue:[NSString stringWithFormat:@"%d",caUInt16] forKey:@"kCalories"];
            [Dic setValue:[NSString stringWithFormat:@"%d",diUInt16] forKey:@"meters"];
            [trainArray addObject:Dic];
        }
            break;
        case 26:
        {
            NSData *suData = [data subdataWithRange:NSMakeRange(7, 4)];
            UInt32 caUInt32 = [self NSDataToUInt32:suData];
            
            NSData *stData = [data subdataWithRange:NSMakeRange(11, 4)];
            UInt32 stUInt32 = [self NSDataToUInt32:stData];
            
            NSData *diData = [data subdataWithRange:NSMakeRange(15, 4)];
            UInt32 diUInt32 = [self NSDataToUInt32:diData];
            
            NSLog(@"日常训练统计数据: %d %d %d ",(unsigned int)caUInt32,(unsigned int)stUInt32,(unsigned int)diUInt32);
            
            NSMutableDictionary *exerciseDic = [NSMutableDictionary dictionary];
            [exerciseDic setValue:[Singleton getUserID] forKey:@"userid"];
            [exerciseDic setValue:[Singleton getMacSite] forKey:@"mac"];
            [exerciseDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)goToSleepU32] forKey:@"total_kCalory"];
            [exerciseDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)getUpSleepU32] forKey:@"total_step"];
            [exerciseDic setValue:[NSString stringWithFormat:@"%d",deepSleepU16] forKey:@"total_meter"];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setValue:exerciseDic forKey:statisticsexerciseData];
            [de synchronize];
        }
            break;
        case 27:
        {
            NSData *boxNumber = [data subdataWithRange:NSMakeRange(6, 1)];
            Byte *by = (Byte*)[boxNumber bytes];
            int box = by[0];
            if (box == 0) {
                NSData *firstData = [data subdataWithRange:NSMakeRange(19, 1)];
                [sleepStatisticsData appendData:firstData];
                
                NSData *goToSleepData = [data subdataWithRange:NSMakeRange(7, 4)];
                goToSleepU32 = [self NSDataToUInt32:goToSleepData];
                
                NSData *getUpSleepData = [data subdataWithRange:NSMakeRange(11, 4)];
                getUpSleepU32 = [self NSDataToUInt32:getUpSleepData];
                
                NSData *deepSleepData = [data subdataWithRange:NSMakeRange(15, 2)];
                deepSleepU16 = [self NSDataToUInt16:deepSleepData];
                
                NSData *shallowSleepData = [data subdataWithRange:NSMakeRange(17, 2)];
                shallowSleepU16 = [self NSDataToUInt16:shallowSleepData];
                

             
            }else{
                NSData *secondData = [data subdataWithRange:NSMakeRange(7, 1)];
                [sleepStatisticsData appendData:secondData];
                
            }
            awakeU16 = [self NSDataToUInt16:sleepStatisticsData];
            NSLog(@"睡眠统计数据: %d %d %d %d %d",(unsigned int)goToSleepU32,(unsigned int)getUpSleepU32,deepSleepU16,shallowSleepU16,awakeU16);
            NSMutableDictionary *sleepDic = [NSMutableDictionary dictionary];
            [sleepDic setValue:[Singleton getUserID] forKey:@"userid"];
            [sleepDic setValue:[Singleton getMacSite] forKey:@"mac"];
            [sleepDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)goToSleepU32] forKey:@"start_time"];
            [sleepDic setValue:[NSString stringWithFormat:@"%d",(unsigned int)getUpSleepU32] forKey:@"end_time"];
            [sleepDic setValue:[NSString stringWithFormat:@"%d",deepSleepU16] forKey:@"total_awake_sleep"];
            [sleepDic setValue:[NSString stringWithFormat:@"%d",shallowSleepU16] forKey:@"total_light_sleep"];
            [sleepDic setValue:[NSString stringWithFormat:@"%d",shallowSleepU16] forKey:@"total_deep_sleep"];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setValue:sleepDic forKey:statisticsSleepData];
            [de synchronize];

        }
            break;
        case 28:
        {
            //去除数组中相同的元素:by Star
            everyDayArray = [Singleton arrayFromRepeatArray:everyDayArray];
            sleepDataArray = [Singleton arrayFromRepeatArray:sleepDataArray];
            [DailyDataManager insertStepArray:everyDayArray];
            [SleepDataManager insertSleepArray:sleepDataArray];
            everyDayArray = [NSMutableArray array];
            sleepDataArray = [NSMutableArray array];
            [self.delegate historyDataSyncEnd:YES];
        }
            break;
        default:
            break;
    }

}
- (UInt16)NSDataToUInt16:(NSData*)data
{
    UInt16 number = 0;
    [data getBytes:&number length:sizeof(number)];
    number = (((number>>8)&0xFF)) | ((number<<8)&0xFF);
    return number;
}
- (UInt32) NSDataToUInt32:(NSData *)data
{
    UInt32 number  = 0;
    [data getBytes:&number length:sizeof(UInt32)];
    number = ((number&0xFF)<<24) | (((number>>8)&0xFF)<<16) | (((number>>16)&0xFF)<<8) | ((number >>24)&0xFF);
    return number;
}
- (void)historySyncDataEnd:(HistorySyncDataEnd)isEnd
{
    if (_syncDataEnd) {
        _syncDataEnd = ^(BOOL end){
            isEnd(end);
        };
    }

}
@end
