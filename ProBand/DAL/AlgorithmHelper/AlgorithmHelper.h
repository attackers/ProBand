//
//  AlgorithmHelper.h
//  LenovoVB10
//
//  Created by jacy on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepdownModel.h"
#import "SleepdownModel.h"
@interface AlgorithmHelper : NSObject
//***********************计步相关算法**************************
//测试数据
+(void)insertTestData;

+(NSArray *)getNumberCountFromDataDbWithIndex:(NSInteger)index;
//有效数据从2015-1-1开始，更新所有数据
+(void)updateAllData;
/**
 *  按日期更新计步数据
 *
 *  @param dateStr yyyy-MM-dd
 *  @param isupdate 是够更新
 */
+(void)updateCurrentStepsDataToDBWithDate:(NSString *)dateStr withUpdate:(BOOL)isupdate;

/**
 *  获取该日期当天的计步数据
 *
 *  @param date yyyy-MM-dd
 *
 *  @return 当天的数据模型
 */
+(StepdownModel *)getCurrentDayStepDataWithDate:(NSString *)date;

/**
 *  按日期更新睡眠数据
 *
 *  @param dateStr yyyy-MM-dd
 *  @param isupdate 是够更新
 */
+(void)updateCurrentSleepDataToDBWithDate:(NSString *)dateStr withUpdate:(BOOL)isupdate;
/**
 *  获取该日期当天的睡眠数据
 *
 *  @param date yyyy-MM-dd
 *
 *  @return 当天的数据模型
 */
+(SleepdownModel *)getCurrentDaySleepDataWithDate:(NSString *)date;

//得到每分钟消耗的卡路里
+(float)getCalorieFromStep:(UInt16)stepCount;
//得到每分钟的距离
+(float)getDistanceFromStep:(UInt16)stepCount;
//计算步长/每分钟
+(float)getStrideFromStep:(UInt16)stepCount;
//***********************计步相关算法**************************
@end
