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
@interface TargetInfoManager : NSObject
SINGLETON

//插入默认的目标值
- (void)insertDefaultTarget;
//使用字典更新数据库：点击下一步或者确认时再更新
- (void)updateSportTargetWithDictionary:(t_goal_step *)sportModel;
//从数据库中获取model
- (t_goal_step *)sportTargetFromDB;

//使用model更新数据库
- (void)updateSleepTargetWithDictionary:(t_goal_sleep *)sleepModel;
//从数据库中获取睡眠model
- (t_goal_sleep *)sleepTargetFromDB;
@end
