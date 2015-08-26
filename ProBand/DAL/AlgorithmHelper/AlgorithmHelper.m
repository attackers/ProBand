//
//  AlgorithmHelper.m
//  LenovoVB10
//
//  Created by jacy on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AlgorithmHelper.h"
#import "sleepDate_deviceidManage.h"
#import "stepDate_deviceidManage.h"
#import "original_dataManage.h"
#import "DataBase.h"
#import "DateHandle.h"
#import "DBOperator.h"
#import "Singleton.h"
#import "UserInfoModel.h"
@implementation AlgorithmHelper

//***********************计步相关算法**************************
+(void)insertTestData{//测试5天的数据,大数据
    NSMutableArray *datas = [NSMutableArray new];
    NSString *date = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO];
    
    NSArray *stepArray = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where date = '%@' and userId = '%@'",date,[Singleton getUserID]]];
    if(stepArray.count<=0){
        for (int i = 0; i<100; i++) {
            NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:-i withType:@"yyyy-MM-dd"];
            
            for (int j = 0; j<480; j++) {
                NSInteger num = j*3;
                if (j>=160 && j<=460) {
                    [datas addObject:@{@"userId":[Singleton getUserID],
                                       @"date":dateStr,
                                       @"time":[NSString stringWithFormat:@"%@ %02d:%02d",dateStr,num/60,num%60],
                                       @"count":[NSString stringWithFormat:@"%d",arc4random() %10],
                                       @"type":@"0"}];
                }else{
                    int count = 0;
                    if (j>460) {
                        count = arc4random() %29+60;
                    }else if(j>=0 && j<100){
                        count = arc4random() %29+30;
                    }else{
                        count = arc4random() %29+91;
                    }
                    [datas addObject:@{@"userId":[Singleton getUserID],
                                       @"date":dateStr,
                                       @"time":[NSString stringWithFormat:@"%@ %02d:%02d",dateStr,num/60,num%60],
                                       @"count":[NSString stringWithFormat:@"%d",count],
                                       @"type":@"1"}];
                }
            }
        }
        
        [original_dataManage insertWithArray:datas];
       
        
        [self updateAllData];
    
    }
    
}
//获取所有天数的数据
+(NSArray *)getNumberCountFromDataDbWithIndex:(NSInteger)index{
   
    NSArray *array = [NSArray new];
    switch (index) {
        case 0:
        {
            array = [DBOPERATOR queryAllDataForSQL:@"t_stepDate_deviceid"];
        }
            break;
        case 1:
        {
            array = [DBOPERATOR queryAllDataForSQL:@"t_sleepDate_deviceid"];
        }
            break;
        default:
            break;
    }
    return array;
}
//有效数据从2015-1-1开始
+(void)updateAllData
{
    
    //NSInteger num = [DateHandle daysWithinEraFromDate:@"2015-1-1" toDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO]];
    NSArray *array=[original_dataManage getUnSaveDateArray:[Singleton getUserID]];
    
    for (int i = 0; i<array.count; i++) {//多少天数据
        NSString *date =[array objectAtIndex:i];//[DateHandle getTomorrowAndYesterDayByCurrentDate:@"2015-1-1" byIndex:i withType:@"yyyy-MM-dd"];
        [self updateCurrentStepsDataToDBWithDate:date withUpdate:NO];
        [self updateCurrentSleepDataToDBWithDate:date withUpdate:NO];
    }
}
/**
 *  按日期更新计步数据
 *
 *  @param dateStr yyyy-MM-dd
 */
+(void)updateCurrentStepsDataToDBWithDate:(NSString *)dateStr withUpdate:(BOOL)isupdate
{
    
    //获取源表中还未处理的计步数据，更新到计步数据表中
    
    //NSArray *dataArray = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_original_data where date ='%@' AND type = 0 ",dateStr]];
    NSArray *dataArray =[original_dataManage getModelArrayBySQL:[NSString stringWithFormat:@"select * from t_original_data where date ='%@' AND type = 0 ",dateStr]];
    NSLog(@" 将计步数据按日合并 保存到数据库,dataArray.count=%lu",(unsigned long)dataArray.count);
    if(dataArray.count>0){

        NSMutableArray *stepsArr = [NSMutableArray new];
        for (int i = 0; i<480; i++)//3分钟一条数据
        {
            [stepsArr addObject:@"0"];
        }
        
        /*
        //合并之前已经处理好的数据
        NSArray *stepArray = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where date = '%@' and userId = '%@'",dateStr,[Singleton getUserID]]];
        if (stepArray.count>0) {
            NSString *stepStr = stepArray[0][@"steps"];
            stepsArr = [[NSMutableArray alloc] initWithArray:[stepStr componentsSeparatedByString:@","]];
        }
        */
        
        
     
        
        //把数据更新到对应的480个点中，最后做拼接处理
        __block NSInteger steps = 0;//每个点的数据
        __block CGFloat met = 0;
        __block CGFloat cal = 0;
        __block NSInteger datetTime = 0;//单位分钟
        __block NSInteger totalSteps = 0;
        __block CGFloat totalMet = 0;
        __block CGFloat totalCal = 0;
        __block NSString *stepStr = @"";
        __block NSString *metStr = @"";
        __block NSString *calStr = @"";
        __block NSString *currentdate = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO];
        NSLog(@"~~~~%@日~总共%lu条计步数据~~~",dateStr,(unsigned long)dataArray.count);
        //更新计步数据表中对应点的数据
        [dataArray enumerateObjectsUsingBlock:^(original_data_Model *model, NSUInteger idx, BOOL *stop)
         {
            NSInteger count = [model.count integerValue];
            if (count>0)
            {
                NSString *date = model.time;//yyyy-MM-dd HH:mm
                currentdate = [date componentsSeparatedByString:@" "][0];
                NSString *times = [date componentsSeparatedByString:@" "][1];
                NSArray *minutesArr = [times componentsSeparatedByString:@":"];
                NSInteger minutesNum = [minutesArr[0] integerValue]*60 + [minutesArr[1] integerValue];
                
                NSInteger index = minutesNum/3 + (minutesNum%3 >0 ? 1:0);
                [stepsArr replaceObjectAtIndex:index withObject:model.count];
            }

            if(idx == dataArray.count-1)
            {
                [stepsArr enumerateObjectsUsingBlock:^(NSString *objt, NSUInteger index, BOOL *stops) {
                    
                    if ([objt integerValue]>0) {
                        steps = [objt integerValue];
                        met = [AlgorithmHelper getDistanceFromStep:[objt integerValue]/3]*3;//计算每3分钟的距离
                        cal = [AlgorithmHelper getCalorieFromStep:[objt integerValue]/3]*3;//计算每3分钟的卡路里
                        totalSteps = totalSteps +steps;
                        totalMet = totalMet + met;
                        totalCal = totalCal + cal;
                        datetTime = datetTime +3;
                    }else{
                        steps = 0;
                        met = 0;
                        cal = 0;
                    }
                    if (index>0) {
                        stepStr = [NSString stringWithFormat:@"%@,%ld",stepStr,(long)steps];
                        metStr = [NSString stringWithFormat:@"%@,%.0f",metStr,met];
                        calStr = [NSString stringWithFormat:@"%@,%.0f",calStr,cal];
                    }else{
                        stepStr = [NSString stringWithFormat:@"%ld",(long)steps];
                        metStr = [NSString stringWithFormat:@"%.0f",met];
                        calStr = [NSString stringWithFormat:@"%.0f",cal];
                    }
                  
//                    NSLog(@"~~~~****第%d个点>>>>>>>~~",index);
                    if (index == stepsArr.count -1)
                    {
          NSLog(@"totalSteps=%ld totalMet=%f totalCal=%f",(long)totalSteps,totalMet,totalCal);
                        NSString *exitSql = [NSString stringWithFormat:@"select count(*) from t_stepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],currentdate];
                        
                         FMDatabase *dataBase = [DataBase setup];
                        int count =[[dataBase stringForQuery:exitSql] intValue];
                         NSLog(@"step count=%d",count);
                        if (count==0)
                        {
                            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_stepDate_deviceid(userId,mac,date,steps,meters,calories,totalSteps,totalDistance,totalCalories,sportDuration)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                                                   [Singleton getUserID],
                                                   @"",
                                                   currentdate,
                                                   stepStr,
                                                   metStr,
                                                   calStr,
                                                   [NSString stringWithFormat:@"%ld",(long)totalSteps],
                                                   [NSString stringWithFormat:@"%.0f",totalMet],
                                                   [NSString stringWithFormat:@"%.0f",totalCal],
                                                   [NSString stringWithFormat:@"%ld",(long)datetTime]];
                            
                            [dataBase executeUpdate:insertSql];
                        }
                        else
                        {
                            NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET mac = '%@',steps = '%@',meters = '%@',calories = '%@',totalSteps = '%@',totalDistance= '%@',totalCalories = '%@',sportDuration ='%@' where userId = '%@' and date = '%@'",
                                                   @"",
                                                   stepStr,
                                                   metStr,
                                                   calStr,
                                                   [NSString stringWithFormat:@"%ld",(long)totalSteps],
                                                   [NSString stringWithFormat:@"%.0f",totalMet],
                                                   [NSString stringWithFormat:@"%.0f",totalCal],
                                                   [NSString stringWithFormat:@"%ld",(long)time],
                                                   [Singleton getUserID],
                                                   currentdate];
                            
                        [dataBase executeUpdate:updateSql];
                        }
                        /*
                        if (isupdate) {
                            [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:exitSql];
                        }else{
                            [DBOPERATOR insertDataToSQL:insertSql
                                           withExsitSql:exitSql];
                        }
                        */
                        
                        *stops = YES;
                    }
                }];
                *stop = YES;
            }

         }];
       
    }
}




/**
 *  按日期更新睡眠数据
 *
 *  @param dateStr yyyy-MM-dd
 */
+(void)updateCurrentSleepDataToDBWithDate:(NSString *)dateStr  withUpdate:(BOOL)isupdate
{
    //获取源表中还未处理的数据
    //NSArray *dataArray = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_original_data where date = '%@' and type = 1 AND flag = 0 ",dateStr]];
    
      NSArray *dataArray =[original_dataManage getModelArrayBySQL:[NSString stringWithFormat:@"select * from t_original_data where date = '%@' and type = 1 ",dateStr]];
    
     NSLog(@" 将睡眠数据按日合并 保存到数据库,dataArray.count=%lu",(unsigned long)dataArray.count);
    
    if(dataArray.count>0){
        
        NSMutableArray *sleepArr = [NSMutableArray new];
        for (int i = 0; i<480; i++) {
            [sleepArr addObject:@"0"];
        }
        /*
        //合并之前已经处理好的数据
        NSArray *sleepArray = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],dateStr]];
        if (sleepArray.count>0) {
            NSString *stepStr = sleepArray[0][@"sleeps"];
            sleepArr = [[NSMutableArray alloc] initWithArray:[stepStr componentsSeparatedByString:@","]];
        }
        */
       //删除源表中已经处理了的数据
       // [DBOPERATOR deleteDataToSqlitewithSqlexsit:[NSString stringWithFormat:@"select count(*) from t_original_data where date = '%@' and type = 1",dateStr]
                                       //  deleteSql:[NSString stringWithFormat:@"DELETE from t_original_data where date = '%@' and type = 1",dateStr]];
        
        //把数据更新到对应的480个点中，最后做拼接处理
        __block NSInteger totalSleep = 0;
        __block NSInteger light = 0;
        __block NSInteger deep = 0;
        __block NSInteger wake = 0;//单位分钟
        __block NSString *sleepStr = @"";
        __block NSString *quality = @"正常";
        __block NSString *currentdate = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO];
        [dataArray enumerateObjectsUsingBlock:^(original_data_Model *model, NSUInteger idx, BOOL *stop)
         {
             //original_data_Model *model=[];
            NSInteger count = [model.count integerValue];
            if (count>0) {
                NSString *date =model.time;//yyyy-MM-dd HH:mm
                currentdate = [date componentsSeparatedByString:@" "][0];
                NSString *times = [date componentsSeparatedByString:@" "][1];
                NSArray *minutesArr = [times componentsSeparatedByString:@":"];
                NSInteger minutesNum = [minutesArr[0] integerValue]*60 + [minutesArr[1] integerValue];
                NSInteger index = minutesNum/3 + (minutesNum%3 >0 ? 1:0);
                [sleepArr replaceObjectAtIndex:index withObject:model.count];
            }
             
            //拼接处理完成后保存到对应的数据库表中
            if(idx == dataArray.count -1){
                [sleepArr enumerateObjectsUsingBlock:^(NSString *objt, NSUInteger index, BOOL *stops) {
                    if ([objt integerValue]>0) {
                        totalSleep = totalSleep+3;
                        if ([objt integerValue]>0 && [objt integerValue] <60) {//深睡
                            deep = deep +3;
                        }else if ([objt integerValue] >= 60 && [objt integerValue] < 90) {//浅睡
                            light = light +3;
                        }else{//清醒
                            wake = wake +3;
                        }
                    }
                    if (index>0) {
                        sleepStr = [NSString stringWithFormat:@"%@,%ld",sleepStr,(long)[objt integerValue]];
                    }else{
                        sleepStr = [NSString stringWithFormat:@"%ld",(long)[objt integerValue]];
                    }
                    
                    if (index == sleepArr.count -1) {
                        
                       
                        
                       
                        NSString *exitSql = [NSString stringWithFormat:@"select count(*) from t_sleepDate_deviceid where userId = '%@' and date = '%@'",[Singleton getUserID],currentdate];
                        
                        FMDatabase *dataBase = [DataBase setup];
                        int count =[[dataBase stringForQuery:exitSql] intValue];
                        NSLog(@"sleep count=%d",count);
                        if (count==0) {
                            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_sleepDate_deviceid(userId,date,sleeps,lightTime,deepTime,wakeTime,totalSleep,quality)VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",
                                                   [Singleton getUserID],
                                                   currentdate,
                                                   sleepStr,
                                                   [NSString stringWithFormat:@"%ld",(long)light],
                                                   [NSString stringWithFormat:@"%ld",(long)deep],
                                                   [NSString stringWithFormat:@"%ld",(long)wake],
                                                   [NSString stringWithFormat:@"%ld",(long)totalSleep],
                                                   quality];
                            
                            [dataBase executeUpdate:insertSql];
                        }
                        else
                        {
                            NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET sleeps = '%@',lightTime = '%@',deepTime = '%@',wakeTime = '%@',totalSleep= '%@',quality = '%@' where userId = '%@' and date = '%@'",
                                                   sleepStr,
                                                   [NSString stringWithFormat:@"%ld",(long)light],
                                                   [NSString stringWithFormat:@"%ld",(long)deep],
                                                   [NSString stringWithFormat:@"%ld",(long)wake],
                                                   [NSString stringWithFormat:@"%ld",(long)totalSleep],
                                                   quality,
                                                   [Singleton getUserID],
                                                   currentdate];
                            
                            [dataBase executeUpdate:updateSql];
                        }
                        /*
                        if (isupdate) {
                            [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:exitSql];
                        }else{
                            [DBOPERATOR insertDataToSQL:insertSql
                                           withExsitSql:exitSql];
                        }*/
                        
                        *stops = YES;
                    }
                }];
                *stop = YES;
            }
         }];
      }
}
+(StepdownModel *)getCurrentDayStepDataWithDate:(NSString *)date{
    
    [stepDate_deviceidManage getPageList:0];
    StepdownModel *stepModel = [StepdownModel new];
    
    NSString  *format=@"%Y-%m-%d";
    NSString *dataSql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where userid='%@' and  strftime('%@',date)='%@'  ",[Singleton getUserID],format,date];
    
    NSArray *array = [DBOPERATOR getDataForSQL:dataSql];
    if (array.count>0) {
        
        
        stepModel = [StepdownModel convertDataToModel:array[0]];
        //NSLog(@"stepModel %@ \n steps %@ \n  totalSteps %@ \n calories %@ \n totalCalories %@ \n",stepModel.date,stepModel.steps,stepModel.totalSteps,stepModel.calories,stepModel.totalCalories);
        
        
    }else{//给默认值
        
    }
    
    return stepModel;
}

/**
 *  获取该日期当天的睡眠数据
 *
 *  @param date yyyy-MM-dd
 *
 *  @return 当天的数据模型
 */
+(SleepdownModel *)getCurrentDaySleepDataWithDate:(NSString *)date
{
    
    SleepdownModel *sleepModel = [SleepdownModel new];
    NSString  *format=@"%Y-%m-%d";
    NSString *dataSql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userid='%@' and  strftime('%@',date)='%@' ",[Singleton getUserID],format,date];
    NSArray *array = [DBOPERATOR getDataForSQL:dataSql];
    if (array.count>0) {
        sleepModel = [SleepdownModel convertDataToModel:array[0]];
     
        //NSLog(@"sleepModel %@ %@ %@ %@ %@",sleepModel.date,sleepModel.sleeps,sleepModel.lightTime,sleepModel.totalSleep,sleepModel.wakeTime);
    }else{//给默认值
        
    }
    
    return sleepModel;
}
//得到每分钟消耗的卡路里
+(float)getCalorieFromStep:(UInt16)stepCount
{
    float milSec =60000;
    UserInfoModel *usermodel = [UserInfoModel getUserInfoDic];
    int weight = [usermodel.weight intValue];
    if (weight==0) {
        weight=65;
    }
    float stride = [self getStrideFromStep:stepCount];
    return (4.5f * weight * stepCount * stride * milSec / (1800*60*2000.0));
}

//得到每分钟的距离
+(float)getDistanceFromStep:(UInt16)stepCount
{
    
    float stride = [self getStrideFromStep:stepCount];
    return (stride * stepCount);
    
}

//计算步长
+(float)getStrideFromStep:(UInt16)stepCount
{
    float stride = 0;
    UserInfoModel *usermodel = [UserInfoModel getUserInfoDic];
    int height = [usermodel.height intValue];
    if(height==0)
    {
        height=168;
    }
    if (stepCount < 2 * 30){
        stride = height / 100.0f / 5.0f;
    } else if (stepCount < 3 * 30) {
        stride = height / 100.0f / 4.0f;
    } else if (stepCount < 4 * 30) {
        stride = height / 100.0f / 3.0f;
    } else if (stepCount < 5 * 30) {
        stride = height / 100.0f / 2.0f;
    } else if (stepCount < 6 * 30) {
        stride = height / 100.0f / 1.2f;
    } else if (stepCount < 8 * 30) {
        stride = height / 100.0f;
    } else {
        stride = 1.2f * height / 100.0f;
    }
    
    return stride;
    
}
//***********************计步相关算法**************************
//***********************睡眠信息相关算法**************************


//***********************睡眠信息相关算法**************************
@end
