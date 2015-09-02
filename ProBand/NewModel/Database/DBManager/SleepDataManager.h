//
//  SleepDataManager.h
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SleepDayModel.h"
#import "SleepWeekModel.h"
#import "SleepMonthModel.h"
#import "SectionModel.h"

#import "t_sleepData.h"
@interface SleepDataManager : NSObject
SINGLETON
/**
 *  将所有原始睡眠数据表中的数据汇总
 */
+ (void)collectAllSleepData;
//根据日期获取model
- (SleepDayModel *)sleepDayModelForDate:(NSString *)date;
//根据某一个星期的第一天获取model
- (SleepWeekModel *)sleepWeekModelForDate:(NSString *)date;
//根据连续4个星期的第一天获取model
- (SleepMonthModel *)sleepMonthModelForDate:(NSString *)date;
//整合一天的数据
- (SectionModel *)sleepSectionModelForDate:(NSString *)date;

//插入睡眠数据：插入后马上汇总一次
+ (void)insertSleepData:(t_sleepData *)model;

//批量插入睡眠数据
+ (void)insertSleepArray:(NSArray *)array;
@end
