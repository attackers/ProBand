//
//  TotalInfoManager.h
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//汇总数据管理工具

#import <Foundation/Foundation.h>
#import "t_total_sleepData.h"
#import "t_total_stepData.h"
#import "t_total_exerciseData.h"
@interface TotalInfoManager : NSObject
//从本地获取model列表
+ (t_total_sleepData *)totalSleepModelFromUserDefaults;
//从本地获取计步的汇总值
+ (t_total_stepData *)totalStepModelFromUserDefaults;
//从本地获取训练的汇总值
+ (t_total_exerciseData *)totalExerciseModelFromUserDefaults;

//从数据库获取汇总数据:date格式为yyyy-MM-dd
+ (t_total_stepData *)totalSTepModelFromDBWithDate:(NSString *)date;
+ (t_total_sleepData *)totalSleepModelFromDBWithDate:(NSString *)date;
+ (t_total_exerciseData *)totalExerciseModelFromDBWithDate:(NSString *)date;
@end
