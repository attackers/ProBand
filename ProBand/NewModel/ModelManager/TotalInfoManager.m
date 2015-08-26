//
//  TotalInfoManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TotalInfoManager.h"

@implementation TotalInfoManager

+ (t_total_sleepData *)totalSleepModelFromUserDefaults
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsSleepData];
    t_total_sleepData *model = [[t_total_sleepData alloc]init];
    if (dic)
    {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [mutableDic setObject:@"" forKey:@"date"];
        [mutableDic setObject:@"" forKey:@"sleeps"];
        [mutableDic setObject:@"0" forKey:@"isUpload"];
        model = [t_total_sleepData convertDataToModel:mutableDic];
    }
    return model;
}
+ (t_total_stepData *)totalStepModelFromUserDefaults
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData];
    t_total_stepData *model = [[t_total_stepData alloc]init];
    if (dic)
    {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [mutableDic setObject:@"" forKey:@"date"];
        [mutableDic setObject:@"" forKey:@"steps"];
        [mutableDic setObject:@"" forKey:@"meters"];
        [mutableDic setObject:@"" forKey:@"kCalories"];
        [mutableDic setObject:@"" forKey:@"start_time"];
        [mutableDic setObject:@"" forKey:@"end_time"];
        [mutableDic setObject:@"" forKey:@"isUpload"];
        model = [t_total_stepData convertDataToModel:mutableDic];
    }
    return model;
}
#warning -需要修改，先预留
+ (t_total_exerciseData *)totalExerciseModelFromUserDefaults
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsexerciseData];
    t_total_exerciseData *model = [[t_total_exerciseData alloc]init];
    if (dic)
    {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [mutableDic setObject:@"" forKey:@"date"];
        [mutableDic setObject:@"" forKey:@"steps"];
        [mutableDic setObject:@"" forKey:@"meters"];
        [mutableDic setObject:@"" forKey:@"kCalories"];
        [mutableDic setObject:@"" forKey:@"start_time"];
        [mutableDic setObject:@"" forKey:@"end_time"];
        [mutableDic setObject:@"" forKey:@"isUpload"];
        model = [t_total_exerciseData convertDataToModel:mutableDic];
    }
    return model;
}

+ (t_total_stepData *)totalSTepModelFromDBWithDate:(NSString *)date
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where date = %@",StepTotalTable,date];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    t_total_stepData *model = [[t_total_stepData alloc]init];
    if (dic) {
        model = [t_total_stepData convertDataToModel:dic];
    }
    return model;
}

+ (t_total_sleepData *)totalSleepModelFromDBWithDate:(NSString *)date
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where date = %@",SleepTotalTable,date];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    t_total_sleepData *model = [[t_total_sleepData alloc]init];
    if (dic) {
        model = [t_total_sleepData convertDataToModel:dic];
    }
    return model;
}

+ (t_total_exerciseData *)totalExerciseModelFromDBWithDate:(NSString *)date
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where date = %@",ExerciseTotalTable,date];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    t_total_exerciseData *model = [[t_total_exerciseData alloc]init];
    if (dic) {
        model = [t_total_exerciseData convertDataToModel:dic];
    }
    return model;
}
@end
