//
//  originalDataManager.m
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "originalDataManager.h"
#import "original_data_Model.h"

@implementation originalDataManager

+(int)updateAllFlag
{

    NSString *sql=@"UPDATE t_original_data SET Flag = 1 ";
    NSString *existStr = @"select  * from t_original_data where Flag = 0";
    NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:existStr withSql:sql];
     if (error.localizedDescription)
     {
        return 0;
     }
    return 1;
}

//根据日期获取睡眠总时间
+(NSString *)getTotalSleepTimeByDay:(NSString *)day
{

    NSString *strSql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],day];
    NSArray *arr = [DBOPERATOR getDataForSQL:strSql];
    if (arr.count>0) {
        NSDictionary *dic = arr[0];
        if (dic[@"totalSleep"])
        {
            NSString *total = dic[@"totalSleep"];
            return total;
        }
    }

    return  @"0";
}

//根据日期获取深睡浅睡和清醒时间
+(NSString *)getSleepCategoryTimeByDay:(NSString *)day
{
  
    NSString *selectStr = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],day];
    
    NSArray *array = [DBOPERATOR getDataForSQL:selectStr];
    
    int lightSleep=0;
    int deepSleep=0;
    int wake=0;
    
    
    if ([array count]>0)
    {
        NSDictionary *dic = array[0];
        deepSleep = [[dic objectForKey:@"deepTime"] intValue];
        lightSleep = [[dic objectForKey:@"lightTime"]intValue];
        wake= [[dic objectForKey:@"wakeTime"]intValue];
    }

    NSLog(@"deepSleep =%d,lightSleep= %d,wake =%d",deepSleep,lightSleep,wake);
    return  [NSString stringWithFormat:@"%d,%d,%d",deepSleep,lightSleep,wake];
}


+(void)insertWithArray:(NSArray *)valueArray
{

    if ([valueArray count] <= 0)
    {
        return;
    }
    if ([DBOPERATOR.fmdb open])
    {
        NSMutableArray *resultSleepArray = [NSMutableArray new];
        // NSLog(@"valueArray=%@",valueArray);
        NSString *userid=[Singleton getUserID];
        
        for (int number = 0; number < valueArray.count; number++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[valueArray objectAtIndex:number]];
            
            NSString *sql = [NSString stringWithFormat:@"select * from t_original_data where userid = '%@' and time='%@'",userid,[dic objectForKey:@"time"]];
            NSLog(@"sql=%@",sql);
            NSArray *array = [DBOPERATOR getDataForSQL:sql];

            if ([array count]<=0)
            {
                NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_original_data (userId,Flag,date,count,type,time)  VALUES ('%@','%@','%@','%@','%@','%@') ",userid,@"0",[dic objectForKey:@"date"],[dic objectForKey:@"count"],[dic objectForKey:@"type"],[dic objectForKey:@"time"]];
                [resultSleepArray addObject:sql];
            }
        };
        
        //使用事务处理
        [DBOPERATOR.fmdb beginTransaction];
        for (NSString *sql in resultSleepArray)
        {
            if (![DBOPERATOR.fmdb executeUpdate:sql]) {
                NSLog(@"～～～～～～～～插入失败,sql=%@",sql);
            }
            else
            {
                NSLog(@"插入成功 sql=%@",sql);
            }
        }
        [DBOPERATOR.fmdb commit];
        [DBOPERATOR.fmdb close];
        
        
    }
    
}


+ (int) countByDate:(NSString *)date
{
  
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data  where date='%@' ",date];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    return [array count];
}

+ (int) count
{
    NSString *str = @"SELECT *  FROM t_original_data";
    NSArray *array = [DBOPERATOR getDataForSQL:str];
    return [array count];
}

+(NSArray *)getUnSaveDateArray:(NSString *)userid
{
    // NSString  *format=@"%Y-%m-%d";
   
    NSString *sql = [NSString stringWithFormat:@"select * from t_original_data where userid='%@' and Flag =0",userid];
    return  [DBOPERATOR getDataForSQL:sql];
    
}


+(NSArray *)getPageList:(int)pageId type:(NSString *)type
{
    NSInteger fromRow=pageId*50;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type='%@' order by id desc limit %ld,50",type,(long)fromRow];
    
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSMutableArray *newArray = [NSMutableArray new];
    if ([array count])
    {
        for (int i = 0; i<[array count]; i++)
        {
            original_data_Model *model = [original_data_Model convertDataToModel:array[i]];
            [newArray addObject:model];
        }
        
    }
    
    
    return newArray;
}

+(NSArray *)getPageListByDate:(NSString *)Date
{
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where date='%@' and type='0' order by id desc ",Date];
    return [DBOPERATOR getDataForSQL:sql];
}


+(NSString *)getTodayStep
{
     NSString *strSql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO]];
    NSArray *arry = [DBOPERATOR getDataForSQL:strSql];
    
    if ([arry count]>0)
    {
        return [[arry objectAtIndex:0] objectForKey:@"totalSteps"];
    }
    return  @"0";
}


+(NSString *)getDistanceCalorieMinutesByDay:(NSString *)day
{
    NSString *strSql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO]];
    NSArray *arry = [DBOPERATOR getDataForSQL:strSql];
    if ([arry count]>0)
    {
        return [NSString stringWithFormat:@"%@,%@,%@",[arry[0]objectForKey:@"totalDistance"],[arry[0]objectForKey:@"totalCalories" ],[arry[0]objectForKey:@"sportDuration"]];
    }
    return  @"0,0,0";
}


@end
