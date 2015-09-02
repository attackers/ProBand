//
//  TargetInfoManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/23.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TargetInfoManager.h"

@implementation TargetInfoManager

//插入默认的目标信息
+ (void)insertDefaultTarget
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasInsertDefaultTarget"]==nil ) {
        NSDictionary *sportTarget = @{@"userid":[Singleton getUserID],
                                      @"mac":[Singleton getMacSite],
                                      @"goal_step":@"10000",
                                      @"goal_kcal":@"400",
                                      @"goal_time":@"50",
                                      @"goal_distance":@"4600"};
        [DBOPERATOR insertSingleDataToDB:StepGoalTable withDictionary:sportTarget];
        [XlabTools setStringValue:sportTarget defaultKey:StepDataTable];
        
        NSDictionary *sleepTarget = @{@"userid":[Singleton getUserID],
                                      @"mac":[Singleton getMacSite],
                                      @"goal_sleep_time":@"8小时0分钟",
                                      @"goal_getup_time":@"22小时30分钟",
                                      @"goal_auto_sleep_switch":@"0"};
        [DBOPERATOR insertSingleDataToDB:SleepGoalTable withDictionary:sleepTarget];
        [XlabTools setStringValue:sleepTarget defaultKey:SleepDataTable];
        NSDictionary *exerciseTarget = @{@"userid":[Singleton getUserID],
                                         @"mac":[Singleton getMacSite],
                                         @"goal_time":@"8小时30分钟",
                                         @"goal_step":@"0",
                                         @"goal_kcal":@"0",
                                         @"goal_distance":@"5000"};
        [DBOPERATOR insertSingleDataToDB:ExerciseGoalTable withDictionary:exerciseTarget];
        [XlabTools setStringValue:exerciseTarget defaultKey:ExerciseDataTable];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"hasInsertDefaultTarget"];
    }
}
//更新几步目标
+ (void)updateSportTargetWithDictionary:(t_goal_step *)sportModel
{
    //使用字典更新数据库
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where userid = '%@'",StepGoalTable,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET mac='%@',goal_step='%@',goal_kcal='%@',goal_time='%@',goal_distance='%@' where userid = '%@'",StepGoalTable,sportModel.mac,sportModel.goal_step,sportModel.goal_kcal,sportModel.goal_time,sportModel.goal_distance,sportModel.userid];
    [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
    
    NSArray *array = [DBOPERATOR getDataForSQL:sqlexist];
    if ([array count]>0)
    {
        //保存锻炼目标到plist文件
        [XlabTools setStringValue:array[0] defaultKey:StepGoalTable];
    }
}
//从数据库中直接取出记步目标
+ (t_goal_step *)sportTargetFromDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userid = '%@'",StepGoalTable,[Singleton getUserID]];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    if ([array count]>0)
    {
        NSDictionary *dic = array[0];
        t_goal_step *model = [t_goal_step convertDataToModel:dic];
        return model;
    }

    return nil;
}

//更新睡眠目标
+ (void)updateSleepTargetWithDictionary:(t_goal_sleep *)sleepModel
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where userid = '%@'",SleepGoalTable,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET mac='%@',goal_sleep_time='%@',goal_getup_time='%@',goal_auto_sleep_switch='%@' where userid = '%@'",SleepGoalTable,sleepModel.mac,sleepModel.goal_sleep_time,sleepModel.goal_getup_time,sleepModel.goal_auto_sleep_switch,sleepModel.userid];
    [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];

    NSArray *array = [DBOPERATOR getDataForSQL:sqlexist];
    if ([array count]>0)
    {
        //保存锻炼目标到plist文件
        [XlabTools setStringValue:array[0] defaultKey:SleepGoalTable];
    }
}

//从数据库中直接去处睡眠目标
+ (t_goal_sleep *)sleepTargetFromDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userid = '%@'",SleepGoalTable,[Singleton getUserID]];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    if ([array count]>0)
    {
        NSDictionary *dic = array[0];
        t_goal_sleep *model = [t_goal_sleep convertDataToModel:dic];
        return model;
    }

    return nil;
}

//更新锻炼目标
+ (void)updateExerciseTargetWithDictionary:(t_goal_exercise *)exerciseModel
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where userid = '%@'",ExerciseGoalTable,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET mac='%@',goal_time='%@',goal_step='%@',goal_kcal='%@',goal_distance = '%@' where userid = '%@'",ExerciseGoalTable,
                           exerciseModel.mac,
                           exerciseModel.goal_time,
                           exerciseModel.goal_step,
                           exerciseModel.goal_kcal,
                           exerciseModel.goal_distance,
                           [Singleton getUserID]];
    [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
    
    NSArray *array = [DBOPERATOR getDataForSQL:sqlexist];
    if ([array count]>0)
    {
        //保存锻炼目标到plist文件
        [XlabTools setStringValue:array[0] defaultKey:ExerciseTotalTable];
    }
    
}

//直接从数据库中取出Model
+ (t_goal_exercise *)exerciseTargetFromDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userid = '%@'",ExerciseGoalTable,[Singleton getUserID]];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    if ([array count]>0)
    {
        NSDictionary *dic = array[0];
        t_goal_exercise *model = [t_goal_exercise convertDataToModel:dic];
        return model;
    }
    return nil;
}


@end
