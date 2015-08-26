//
//  StepDataDeviceidManager.m
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "StepDataDeviceidManager.h"

@implementation StepDataDeviceidManager



//更新标志位
+(void)updateFlag:(NSString *)Flag
{
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET Flag = '%@' ",Flag];
    NSString *exiteStr = @"select * from t_stepDate_deviceid where Flag = 1";
    [DBOPERATOR updateTheDataToDbWithExsitSql:exiteStr withSql:sql];
}

+(NSArray *)getUnUploadStep
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_stepDate_deviceid where Flag=0  order by id desc"];
    return [DBOPERATOR getDataForSQL:sql];
}

+ (void)updateFlag:(NSString *)flag withArray:(NSArray *)array
{
    if ([array count] <= 0) return;
    
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int number = 0; number < array.count; number++)
    {
        NSString *sql=[NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET Flag = '%@' WHERE Id = '%@'",[NSNumber numberWithInteger:[flag integerValue]],[array[number] valueForKey:@"Id"]];
        [resultArray addObject:sql];
    }
    if([DBOPERATOR.fmdb open])
    {
        //使用事务处理
        [DBOPERATOR.fmdb beginTransaction];
        
        for (NSString *sql in resultArray)
        {
            NSLog(@"%@---sql--",sql);
            if (![DBOPERATOR.fmdb executeUpdate:sql])
            {
                NSLog(@"～～～～～～～～更新失败,sql=%@",sql);
            }
            else
            {
                //            NSLog(@"更新成功！！！！！ sql=%@",sql);
            }
        }
        
        [DBOPERATOR.fmdb commit];
        [DBOPERATOR.fmdb close];
    }
   
}


+ (int) count
{
    NSString *selectStr = @"SELECT * FROM t_sleepDate_deviceid";
    NSArray *array = [DBOPERATOR getDataForSQL:selectStr];
    return [array count];
}


+(void)insertWithStepDateArray:(NSArray *)stepDateArray withFlag:(NSString *)flag
{
    if ([stepDateArray count] <= 0) return;
    
    //NSLog(@"stepDateArray-------%@",stepDateArray);
    
//    NSMutableArray *selectArr =[NSMutableArray new];
//    NSMutableArray *updateArr = [NSMutableArray new];
//    NSMutableArray *resultArray = [NSMutableArray new];
    NSString *userid=[Singleton getUserID];
    for (int number = 0; number < stepDateArray.count; number++){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[stepDateArray objectAtIndex:number]];
        //select count(*) from t_stepDate_deviceid where userId = '10046629912' and date='2015-04-22'
        NSString *sql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where userId = '%@' and date='%@'",userid,[dic objectForKey:@"calendar"]];
 
        NSArray *array = [DBOPERATOR getDataForSQL:sql];
        NSLog(@"sql=%@",sql);
        if ([array count] <= 0)
        {
            NSString *sql=[NSString stringWithFormat:@"insert into  t_stepDate_deviceid (userId,date,totalCalories,totalSteps,Flag)  VALUES ('%@','%@','%@','%@','%@') ",userid,[dic objectForKey:@"calendar"],[dic objectForKey:@"calorie"],[dic objectForKey:@"record"],[NSNumber numberWithInteger:[flag integerValue]]];
            NSString *selectSql = [NSString stringWithFormat:@"select *from t_stepDate_deviceid where date = '%@'",[dic objectForKey:@"calendar"]];
            NSString *updateSql = [NSString stringWithFormat:@"update t_stepDate_deviceid set totalCalories＝'%@',totalSteps='%@',Flag='%@' where date = '%@' and userId = '%@'",[dic objectForKey:@"calorie"],[dic objectForKey:@"record"],[NSNumber numberWithInteger:[flag integerValue]],[dic objectForKey:@"calendar"],userid];
            [DBOPERATOR insertDataToSQL:sql updatesql:updateSql withExsitSql:selectSql];
//            [selectArr addObject:selectSql];
//            [updateArr addObject:updateSql];
//            [resultArray addObject:sql];
        }
    }
    
   
//    if ([DBOPERATOR.fmdb open]) {
//    
//    //使用事务处理
//    [DBOPERATOR.fmdb beginTransaction];
////        for (int i = 0;i<resultArray.count;i++)
//    {
//        NSString *selectSql = [selectArr objectAtIndex:i];
//        NSString *updateSql = [updateArr objectAtIndex:i];
//        NSString *insertSql = [resultArray objectAtIndex:i];
//        [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:selectSql];
//        
//    }

//    [DBOPERATOR.fmdb commit];
//    [DBOPERATOR.fmdb close];
    //}
}

+(void)updateWithStepDetailArray:(NSArray *)stepDetailArray
{
    if ([stepDetailArray count] <= 0) return;
    
//    NSMutableArray *resultArray = [NSMutableArray new];
//    NSMutableArray *slectArr = [NSMutableArray new];
//    NSMutableArray *insertArr = [NSMutableArray new];
    //NSString *userid=[Singleton getUserID];
    for (int number = 0; number < stepDetailArray.count; number++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[stepDetailArray objectAtIndex:number]];
        //SELECT steps FROM t_stepDate_deviceid WHERE date = '2015-04-22'
//        NSString *sql = [NSString stringWithFormat:@"SELECT steps FROM t_stepDate_deviceid WHERE userId = '%@' and date='%@'",userid,[dic objectForKey:@"calendar"]];
//        NSArray *array = [DBOPERATOR getDataForSQL:sql];
//        if ([array count]<=0)
//        {
            float met = 0;
            float cal = 0;
            float dur = 0;
            float totalMet = 0;
            float totalCal = 0;
            float datetTime = 0;
            float sportDuration = 0;
            float totalDistance = 0;
            int totalSteps = 0;
        
            NSString *metStr = @"";
            NSString *calStr = @"";
            NSString *durStr = @"";
            NSString *str = [dic objectForKey:@"detail"];
            NSArray *tempArr = [str componentsSeparatedByString:@","];
            for (int i =0; i<tempArr.count; i++) {
                
                NSString *tempStr = tempArr[i];
                totalSteps = totalSteps + [tempStr intValue];
                if ([tempStr intValue]>0) {
                    met = [AlgorithmHelper getDistanceFromStep:[tempStr intValue]];
                    cal = [AlgorithmHelper getCalorieFromStep:[tempStr integerValue]];//计算每3分钟的卡路里
                    dur = 3;
                    totalMet = totalMet + met;
                    totalCal = totalCal + cal;
                    datetTime = datetTime + dur;
                }
                else
                {
                    met = 0;
                    cal = 0;
                    dur = 0;
                }
                sportDuration = sportDuration + dur;
                totalDistance = totalDistance + met;
                if (i>0) {
                    metStr = [NSString stringWithFormat:@"%@,%.0f",metStr,met];
                    calStr = [NSString stringWithFormat:@"%@,%.0f",calStr,cal];
                    durStr = [NSString stringWithFormat:@"%@,%.0f",durStr,dur];
                }else{

                    metStr = [NSString stringWithFormat:@"%.0f",met];
                    calStr = [NSString stringWithFormat:@"%.0f",cal];
                    durStr = [NSString stringWithFormat:@"%.0f",dur];
                }

            }
           // NSLog(@"---->>>>>>+++>>>>%@,%@,%@,%@",metStr,calStr,durStr,[dic objectForKey:@"detail"]);
            //UPDATE t_stepDate_deviceid SET steps = '11,22,33' WHERE date = '2015-04-22'
            NSString *sql=[NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET steps = '%@',meters = '%@',calories = '%@',durations = '%@',totalDistance = '%@',sportDuration = '%@',totalSteps = '%@',totalCalories = '%@' WHERE date = '%@' and userId = '%@'",[dic objectForKey:@"detail"],metStr,calStr,durStr,[NSString stringWithFormat:@"%.2f",totalDistance],[NSString stringWithFormat:@"%.2f",sportDuration],[NSString stringWithFormat:@"%d",totalSteps],[NSString stringWithFormat:@"%d",(int)totalCal],[dic objectForKey:@"calendar"],[Singleton getUserID]];
            NSString *inserSql = [NSString stringWithFormat:@"insert into  t_stepDate_deviceid(userId,date,steps,meters,calories,durations,totalDistance,sportDuration,totalSteps,totalCalories,Flag) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],[dic objectForKey:@"calendar"],[dic objectForKey:@"detail"],metStr,calStr,durStr,[NSString stringWithFormat:@"%.2f",totalDistance],[NSString stringWithFormat:@"%.2f",sportDuration],[NSString stringWithFormat:@"%d",totalSteps],[NSString stringWithFormat:@"%d",(int)totalCal],@"1"];
            NSString *selectSql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where date = '%@' and userId = '%@'",[dic objectForKey:@"calendar"],[Singleton getUserID]];
            [DBOPERATOR insertDataToSQL:inserSql updatesql:sql withExsitSql:selectSql];
//            [insertArr addObject:inserSql];
//            [slectArr addObject:selectSql];
//            [resultArray addObject:sql];
        }
   // }
    
//    if ([DBOPERATOR.fmdb open]) {
//        //使用事务处理
//        [DBOPERATOR.fmdb beginTransaction];
//        for (int i =0 ;i<resultArray.count;i++){
//            NSString *selectSql = [slectArr objectAtIndex:i];
//            NSString *insertSql = [insertArr objectAtIndex:i];
//            NSString *updateSql = [resultArray objectAtIndex:i];
//         [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:selectSql];
//
//        }
//        
//        [DBOPERATOR.fmdb commit];
//        [DBOPERATOR.fmdb close];
//    }
   
}


+(NSArray *)getPageList:(int)pageId
{
    NSInteger fromRow=pageId*15;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_stepDate_deviceid order by id desc limit %ld,15",(long)fromRow];
    return [DBOPERATOR getDataForSQL:sql];
}


+(NSArray *)getAllStepDataWithUserID:(NSString *)userID
{
    NSString *sql = [NSString stringWithFormat:@"select * from t_stepDate_deviceid where userId = '%@' order by date desc ",userID];
    
    NSArray *resultArr = [DBOPERATOR getDataForSQL:sql];
    
    return  resultArr;
}


@end
