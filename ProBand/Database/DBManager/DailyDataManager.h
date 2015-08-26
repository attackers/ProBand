//
//  DailyDataManager.h
//  ProBand
//
//  Created by star.zxc on 15/7/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyDayModel.h"
#import "DailyWeekModel.h"
#import "DailyMonthModel.h"
#import "SectionModel.h"

#import "t_stepData.h"
@interface DailyDataManager : NSObject
SINGLETON

//将所有原始表中日常数据汇总
+ (void)collectAllDailyData;
//根据当天日期生成一个model
- (DailyDayModel *)dailyDayModelForDate:(NSString *)date;
//根据一个星期的第一天生成一个model
- (DailyWeekModel *)dailyWeekModelForDate:(NSString *)date;
//根据连续4个星期的第一天生成一个model
- (DailyMonthModel *)dailyMonthModelForDate:(NSString *)date;
//整合一天的数据，按时间段划分
- (SectionModel *)dailySectionModelForDate:(NSString *)date;

//插入计步数据：插入后马上汇总一次
+ (void)insertStepData:(t_stepData *)stepModel;

+ (void)insertStepArray:(NSArray *)array;
@end
