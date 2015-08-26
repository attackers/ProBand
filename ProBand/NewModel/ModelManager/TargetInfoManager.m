//
//  TargetInfoManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/23.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TargetInfoManager.h"

@implementation TargetInfoManager

SINGLETON_SYNTHE
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)insertDefaultTarget
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasInsertDefaultTarget"]==nil ) {
        NSDictionary *sportTarget = @{@"userid":[Singleton getUserID],
                                      @"mac":[Singleton getMacSite],
                                      @"goal_step":@"10000",
                                      @"goal_kcal":@"400",
                                      @"goal_time":@"50",
                                      @"goal_distance":@"4600"};
        [DBOPERATOR insertSingleDataToDB:StepGoalTable withDictionary:sportTarget];
        NSDictionary *sleepTarget = @{@"userid":[Singleton getUserID],
                                      @"mac":[Singleton getMacSite],
                                      @"goal_sleep_time":@"8小时0分钟",
                                      @"goal_getup_time":@"22小时30分钟",
                                      @"goal_auto_sleep_switch":@"0"};
        [DBOPERATOR insertSingleDataToDB:SleepGoalTable withDictionary:sleepTarget];
        NSDictionary *exerciseTarget = @{@"userid":[Singleton getUserID],
                                         @"mac":[Singleton getMacSite],
                                         @"goal_time":@"8小时30分钟",
                                         @"goal_step":@"0",
                                         @"goal_kcal":@"0",
                                         @"goal_distance":@"5000"};
        [DBOPERATOR insertSingleDataToDB:ExerciseGoalTable withDictionary:exerciseTarget];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"hasInsertDefaultTarget"];
    }
}

- (void)updateSportTargetWithDictionary:(t_goal_step *)sportModel
{
    //使用字典更新数据库
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where userid = '%@'",StepGoalTable,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET mac='%@',goal_step='%@',goal_kcal='%@',goal_time='%@',goal_distance='%@' where userid = '%@'",StepGoalTable,sportModel.mac,sportModel.goal_step,sportModel.goal_kcal,sportModel.goal_time,sportModel.goal_distance,sportModel.userid];
    [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
}

- (t_goal_step *)sportTargetFromDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userid = '%@'",StepGoalTable,[Singleton getUserID]];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    t_goal_step *model = [[t_goal_step alloc]init];
    model = [t_goal_step convertDataToModel:dic];
    return model;
}

- (void)updateSleepTargetWithDictionary:(t_goal_sleep *)sleepModel
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where userid = '%@'",SleepGoalTable,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET mac='%@',goal_sleep_time='%@',goal_getup_time='%@',goal_auto_sleep_switch='%@' where userid = '%@'",SleepGoalTable,sleepModel.mac,sleepModel.goal_sleep_time,sleepModel.goal_getup_time,sleepModel.goal_auto_sleep_switch,sleepModel.userid];
    [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
}

- (t_goal_sleep *)sleepTargetFromDB
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where userid = '%@'",SleepGoalTable,[Singleton getUserID]];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    t_goal_sleep *model = [[t_goal_sleep alloc]init];
    model = [t_goal_sleep convertDataToModel:dic];
    return model;
}
@end
