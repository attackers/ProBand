//
//  SleepBaseModel.m
//  LenovoVB10
//
//  Created by 于苗 on 15/4/22.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepBaseModel.h"

@implementation SleepBaseModel

-(id)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
    
    
}

-(SleepBaseModel *)initWithSleepDate_deviceid_Model:(sleepDate_deviceid_Model*)obj
{
    SleepBaseModel *sleepObj = [[SleepBaseModel alloc]init];
    sleepObj.date = obj.date;
    NSArray *tempArr = [obj.sleeps componentsSeparatedByString:@","];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<tempArr.count; i++) {
        NSString *str = tempArr[i];
        [arr addObject:[NSNumber numberWithInteger:[str integerValue]]];
    }
    sleepObj.sleeps = arr;
    sleepObj.light = obj.lightTime;
    sleepObj.dreep = obj.deepTime;
    sleepObj.weak = obj.wakeTime;
    sleepObj.totalSleep = obj.totalSleep;
    sleepObj.sleepArr = [NSArray arrayWithObjects:sleepObj.dreep,sleepObj.light,sleepObj.weak,nil];
    //NSLog(@"~~~~~~~~~~~~~~~%@------%@--------%@",sleepObj.dreep,sleepObj.light,sleepObj.weak);
    return sleepObj;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"-----%@--",_date];
}
@end
