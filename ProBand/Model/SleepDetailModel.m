//
//  SleepDetailModel.m
//  LenovoVB10
//
//  Created by 于苗 on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepDetailModel.h"
#import "SleepDetailManager.h"
#import "sleepDate_deviceidManage.h"
@implementation SleepDetailModel



-(void)getAllSleepDetailInfo
{
    NSArray *allBaseDateInfo = [sleepDate_deviceidManage getAllSleepInfoByuserId:[Singleton getUserID]];
    self.dayArray = [SleepDetailManager getDaySleepDetail:allBaseDateInfo];
    self.weekArray = [SleepDetailManager getWeekSleepDetail:allBaseDateInfo];
    self.monthArray = [SleepDetailManager getMonthSleepDetail:allBaseDateInfo];
}
@end
