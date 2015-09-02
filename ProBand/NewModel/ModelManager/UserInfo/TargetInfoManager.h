//
//  TargetInfoManager.h
//  ProBand
//
//  Created by star.zxc on 15/8/23.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "t_goal_step.h"
#import "t_goal_sleep.h"
#import "t_goal_exercise.h"
@interface TargetInfoManager : NSObject

//插入默认的目标值
+ (void)insertDefaultTarget;
//使用字典更新数据库：点击下一步或者确认时再更新 同时存储plist文件
+ (void)updateSportTargetWithDictionary:(t_goal_step *)sportModel;
//从数据库中获取model
+ (t_goal_step *)sportTargetFromDB;

//使用model更新数据库 同时存储plist文件
+ (void)updateSleepTargetWithDictionary:(t_goal_sleep *)sleepModel;
//从数据库中获取睡眠model
+ (t_goal_sleep *)sleepTargetFromDB;

//更新锻炼目标 同时存储plist文件
+ (void)updateExerciseTargetWithDictionary:(t_goal_exercise *)exerciseModel;

//直接从数据库中取出Model:只需要获取两个值，训练时间和训练距离,形式分别为xx小时xx分钟，5000
+ (t_goal_exercise *)exerciseTargetFromDB;

@end
