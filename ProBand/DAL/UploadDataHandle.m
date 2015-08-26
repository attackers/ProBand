//
//  UploadDataHandle.m
//  LenovoVB10
//
//  Created by Echo on 15/6/15.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UploadDataHandle.h"
#import "StepDataDeviceidManager.h"
//#import "stepDate_deviceidManage.h"
#import "SleepDataDeviceidManager.h"

@interface UploadDataHandle ()
{
    NSMutableArray *stepArr;
    NSMutableArray *sleepArr;
}

@end

@implementation UploadDataHandle

- (void)uploadStepData
{
    if(![PublicFunction isConnect]) return;
    
    NSArray *arr = [StepDataDeviceidManager getUnUploadStep];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in arr)
    {
        stepDate_deviceid_Model *obj = [[stepDate_deviceid_Model alloc]init];
        obj.steps = dic[@"steps"];
        //obj.durations = dic[@"durations"];
        obj.mac = dic[@"mac"];
        obj.calories = dic[@"caiories"];
        obj.totalCalories = dic[@"totalCalories"];
        obj.meters = dic[@"meters"];
        obj.totalSteps = dic[@"totalStep"];
        obj.date = dic[@"date"];
        obj.totalDistance = dic[@"totalDistance"];
        obj.sportDuration = dic[@"sportDuration"];
        obj.Id = dic[@"Id"];
        [tempArr addObject:obj];
    }
    
    stepArr =[NSMutableArray arrayWithArray:tempArr];
    
    NSMutableArray *subArr;
    for (int i = 0; i < stepArr.count/20; i++) {
        [subArr removeAllObjects];
        subArr =[NSMutableArray arrayWithArray:[stepArr subarrayWithRange:NSMakeRange(i*20, 20)]];
        if ([self useSyncBackUpSportData:subArr]) return;
    }
    if (stepArr.count%20){
        [subArr removeAllObjects];
        subArr = [NSMutableArray arrayWithArray:[stepArr subarrayWithRange:NSMakeRange((stepArr.count/20)*20, stepArr.count%20)]];
        if ([self useSyncBackUpSportData:subArr]) return;
    }

}

- (void)uploadSleepData
{
    if(![PublicFunction isConnect]) return;
    
    NSArray *arr = [SleepDataDeviceidManager getUnUploadSleep];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in arr)
    {
        sleepDate_deviceid_Model *obj =[sleepDate_deviceid_Model new];
        obj.userId = dic[@"userId"];
        obj.lightTime = dic[@"lightTime"];
        obj.deepTime = dic[@"deepTime"];
        obj.quality = dic[@"quailty"];
        obj.wakeTime = dic[@"wakeTime"];
        obj.sleeps = dic[@"sleeps"];
        obj.date = dic[@"date"];
        obj.totalSleep = dic[@"totalSleep"];
        //obj.Flag = dic[@"Flag"];
        obj.Id = dic[@"Id"];
        [tempArr addObject:obj];
    }
    
    sleepArr = [NSMutableArray arrayWithArray:tempArr];
    
    NSMutableArray *subArr;
    for (int i = 0; i < sleepArr.count/20; i++) {
        [subArr removeAllObjects];
        subArr =[NSMutableArray arrayWithArray:[sleepArr subarrayWithRange:NSMakeRange(i*20, 20)]];
        if (![self useSyncBackUpSleepData:subArr]) return;
    }
    if (sleepArr.count%20){
        [subArr removeAllObjects];
        subArr = [NSMutableArray arrayWithArray:[sleepArr subarrayWithRange:NSMakeRange((sleepArr.count/20)*20, sleepArr.count%20)]];
        if (![self useSyncBackUpSleepData:subArr]) return;
    }
}

- (BOOL)useSyncBackUpSleepData:(NSArray *)arr
{
    for (int i = 0; i < arr.count; i++){
        if ([NetWorkManage submitSleepData:arr[i]]){
            if (![NetWorkManage submitSleepDetail:arr[i]]) return NO;
        }else{
            return NO;
        }
    }
    [SleepDataDeviceidManager updateFlag:@"1" withArray:arr];
    return YES;
}

- (BOOL)useSyncBackUpSportData:(NSArray *)arr
{
    for (int i = 0; i < arr.count; i++) {
        if ([NetWorkManage submitSportDataToServer:arr[i]]){
            if (![NetWorkManage submitSportDetailWithModel:arr[i]]) return NO;
        }else{
            return NO;
        }
    }
    [StepDataDeviceidManager updateFlag:@"1" withArray:arr];
    return YES;
}

@end
