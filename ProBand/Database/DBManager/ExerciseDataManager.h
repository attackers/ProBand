//
//  ExerciseDataManager.h
//  ProBand
//
//  Created by star.zxc on 15/7/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseDayModel.h"
#import "ExerciseWeekModel.h"
#import "ExerciseMonthModel.h"
#import "SectionModel.h"
#import "ExerciseSectionModel.h"

#import "t_exerciseData.h"
@interface ExerciseDataManager : NSObject
SINGLETON
//将所有锻炼数据汇总
+ (void)collectAllExerciseData;
//根据日期获取当天的model
- (ExerciseDayModel *)exerciseDayModelForDate:(NSString *)date;
//根据某个星期的第一天获取相关model
- (ExerciseWeekModel *)exerciseWeekModelForDate:(NSString *)date;
//根据连续4个星期的第一天获取相关model
- (ExerciseMonthModel *)exerciseMonthModelForDate:(NSString *)date;
//根据日期将当天日期分段
- (SectionModel *)exerciseSectionModelForDate:(NSString *)date;

- (ExerciseSectionModel *)exerciseSectionModelFromDate:(NSString *)date;

//插入计步数据：插入后马上汇总一次
+ (void)insertStepData:(t_exerciseData *)stepModel;
@end
