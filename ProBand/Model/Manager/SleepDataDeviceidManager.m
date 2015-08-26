//
//  SleepDataDeviceidManager.m
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepDataDeviceidManager.h"

@implementation SleepDataDeviceidManager

//更新标志位
+(void)updateFlag:(NSString *)Flag
{
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET Flag = '%@' ",Flag];
    NSString *exiteStr = @"select * from t_sleepDate_deviceid where Flag = 1";
    [DBOPERATOR updateTheDataToDbWithExsitSql:exiteStr withSql:sql];
}

+(NSArray *)getUnUploadSleep
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_sleepDate_deviceid where Flag=0  order by id desc"];
    return [DBOPERATOR getDataForSQL:sql];
}


+ (void)updateFlag:(NSString *)flag withArray:(NSArray *)array
{
    if ([array count] <= 0) return;
    
    //NSMutableArray *resultArray = [NSMutableArray new];
    for (int number = 0; number < array.count; number++){
        
        NSString *sql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET Flag = '%@' WHERE date = '%@'",[NSNumber numberWithInteger:[flag integerValue]],[array[number] valueForKey:@"date"]];
        NSString *selectSql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where date = '%@'",[array[number] valueForKey:@"date"]];
        [DBOPERATOR updateTheDataToDbWithExsitSql:selectSql withSql:sql];
        
        
       // [resultArray addObject:sql];
    }
//    if ([DBOPERATOR.fmdb open]) {
//        //使用事务处理
//        [DBOPERATOR.fmdb beginTransaction];
//        
//        for (NSString *sql in resultArray)
//        {
//            NSLog(@"%@---sql--",sql);
//            if (![DBOPERATOR.fmdb executeUpdate:sql])
//            {
//                NSLog(@"～～～～～～～～更新失败,sql=%@",sql);
//            }
//            else
//            {
//                NSLog(@"更新成功！！！！！ sql=%@",sql);
//            }
//        }
//        
//        [DBOPERATOR.fmdb commit];
//        [DBOPERATOR.fmdb close];
//    }
    
}


+(sleepDate_deviceid_Model *)getModelByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString *selectStr = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId='%@' and date='%@'",UserId,date];
    
    NSArray *array = [DBOPERATOR getDataForSQL:selectStr];
    if ([array count]>0)
    {
        sleepDate_deviceid_Model *sleepModel = [sleepDate_deviceid_Model convertDataToModel:[array firstObject]];
        return sleepModel;
    }

    return  nil;
}



+(void)insertWithSleepDateArray:(NSArray *)sleepDateArray withFlag:(NSString *)flag
{
    if ([sleepDateArray count] <= 0) return;
    
    //NSMutableArray *resultArray = [NSMutableArray new];
    NSString *userid=[Singleton getUserID];
    for (int number = 0; number < sleepDateArray.count; number++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[sleepDateArray objectAtIndex:number]];
        //select count(*) from t_sleepDate_deviceid where userId = '10046629912' and date='2015-04-22'
        NSString *sql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date='%@'",userid,[dic objectForKey:@"calendar"]];

        
//        NSArray *array = [DBOPERATOR getDataForSQL:sql];
//
//        if ([array count]<=0){
            //INSERT INTO t_sleepDate_deviceid (userId,date,lightTime,deepTime,wakeTime,quality,totalSleep,Flag) VALUES ('10046629912','2015-05-27','20','50','10','1','100',0);
            //{\n      \"awake\" : \"45.00\",\n      \"calendar\" : \"2015-04-16\",\n      \"deep\" : \"60.00\",\n      \"light\" : \"50.00\",\n      \"quality\" : \"??\",\n      \"reached\" : \"2\",\n      \"total\" : \"155.00\"\n   }
            int quality =  [[dic objectForKey:@"deep"] integerValue]/[[dic objectForKey:@"total"] floatValue];
            NSString *qualityStr = nil;
            if (quality>6) {
                qualityStr = NSLocalizedString(@"good", nil);
            }
            else if (quality>4)
            {
              qualityStr = NSLocalizedString(@"normal", nil);
            }
            else
            {
               qualityStr = NSLocalizedString(@"bad", nil);
            }
            NSString *insertSql=[NSString stringWithFormat:@"insert into  t_sleepDate_deviceid (userId,date,lightTime,deepTime,wakeTime,quality,totalSleep,Flag)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@') ",userid,[dic objectForKey:@"calendar"],[dic objectForKey:@"light"],[dic objectForKey:@"deep"],[dic objectForKey:@"awake"],qualityStr,[dic objectForKey:@"total"],[NSNumber numberWithInteger:[flag integerValue]]];
            
            NSString *updateSql = [NSString stringWithFormat:@"update t_sleepDate_deviceid set lightTime = '%@',deepTime = '%@',wakeTime='%@',totalSleep = '%@',quality = '%@',Flag = '%@' where date = '%@' and userId = '%@'",[dic objectForKey:@"light"],[dic objectForKey:@"deep"],[dic objectForKey:@"awake"],[dic objectForKey:@"total"],qualityStr,[NSNumber numberWithInteger:[flag integerValue]],[dic objectForKey:@"calendar"],userid];
            [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:sql];
          //  [resultArray addObject:sql];
        //}
    }
    
//    if ([DBOPERATOR.fmdb open]) {
//        //使用事务处理
//        [DBOPERATOR.fmdb beginTransaction];
//        for (NSString *sql in resultArray)
//        {
//            NSLog(@"%@---sql--",sql);
//            if (![DBOPERATOR.fmdb executeUpdate:sql])
//            {
//                NSLog(@"～～～～～～～～插入失败,sql=%@",sql);
//            }
//            else
//            {
//                NSLog(@"插入成功！！！！！ sql=%@",sql);
//            }
//        }
//        
//        [DBOPERATOR.fmdb commit];
//        [DBOPERATOR.fmdb close];
//    }
    
}

+(void)updateWithSleepDetailArray:(NSArray *)sleepDetailArray
{
    if ([sleepDetailArray count] <= 0) return;

    NSMutableArray *resultArray = [NSMutableArray new];
    NSString *userid=[Singleton getUserID];
    for (int number = 0; number < sleepDetailArray.count; number++){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[sleepDetailArray objectAtIndex:number]];
        //SELECT sleeps FROM t_sleepDate_deviceid WHERE userId = '10046629912' and date='2015-04-22'
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_sleepDate_deviceid WHERE userId = '%@' and date='%@'",userid,[dic objectForKey:@"calendar"]];

//        NSArray *array = [DBOPERATOR getDataForSQL:sql];
//        
//        if ([array count]<=0)
//        {
            //UPDATE t_sleepDate_deviceid SET sleeps = '11,22,33' WHERE date = '2015-04-22'
            NSString *updateSql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET sleeps = '%@' WHERE date = '%@' and userId = '%@'",[dic objectForKey:@"detail"],[dic objectForKey:@"calendar"],userid];
            NSString *insertSql = [NSString stringWithFormat:@"insert into t_sleepDate_deviceid (date,sleeps,userId) values('%@','%@','%@')",[dic objectForKey:@"calendar"],[dic objectForKey:@"detail"],userid];
        [DBOPERATOR insertDataToSQL:insertSql updatesql:updateSql withExsitSql:sql];
       // }
    }
    
//    if ([DBOPERATOR.fmdb open]) {
//        //使用事务处理
//        [DBOPERATOR.fmdb beginTransaction];
//        for (NSString *sql in resultArray){
//            NSLog(@"%@---sql--",sql);
//            if (![DBOPERATOR.fmdb executeUpdate:sql]) {
//                NSLog(@"～～～～～～～～更新失败,sql=%@",sql);
//            }else{
//                NSLog(@"更新成功！！！！！ sql=%@",sql);
//            }
//        }
//        
//        [DBOPERATOR.fmdb commit];
//        [DBOPERATOR.fmdb close];

    //}
}


+(void)insertSleepDetailInfo:(sleepDate_deviceid_Model *)sleepObj
{
    NSString *selectSql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date = '%@'",sleepObj.userId,sleepObj.date];

     NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO  t_sleepDate_deviceid (userId,date,sleeps,lightTime,deepTime,wakeTime,quality,totalSleep)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@') ",sleepObj.userId,sleepObj.date,sleepObj.sleeps,sleepObj.lightTime,sleepObj.deepTime,sleepObj.wakeTime,sleepObj.quality ,sleepObj.totalSleep];
    
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET sleeps = '%@' , lightTime = '%@' , deepTime = '%@' , wakeTime = '%@' , quality = '%@' , totalSleep = '%@'    where userId= '%@' and date = '%@'",sleepObj.sleeps,sleepObj.lightTime,sleepObj.deepTime,sleepObj.wakeTime,sleepObj.quality,sleepObj.totalSleep,sleepObj.userId,sleepObj.date
                   ];
    
    [DBOPERATOR insertDataToSQL:insertSql updatesql:sql withExsitSql:selectSql];
    
    
}


+(NSArray *)getAllSleepInfoByuserId:(NSString *)userID
{ 
    NSString *sql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' order by date desc ",userID];

    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:0];
    
    if ([array count]>0)
    {
        for (int i = 0; i<[array count]; i++)
        {
            sleepDate_deviceid_Model *model = [sleepDate_deviceid_Model convertDataToModel:array[i]];
            [resultArr addObject:model];
        }
        
    }
    return  resultArr;
}


+ (int) count
{
    return [[DBOPERATOR getDataForSQL:@"SELECT * FROM t_sleepDate_deviceid"] count];
}



@end
