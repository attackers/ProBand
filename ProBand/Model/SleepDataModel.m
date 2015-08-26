//
//  SleepDataModel.m
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "SleepDataModel.h"

@implementation SleepDataModel
@synthesize everyDaySleepArray = _everyDaySleepArray;
@synthesize everydayTitle = _everydayTitle;
@synthesize weekDaySleepArray = _weekDaySleepArray;
@synthesize weekDayTitleArray = _weekDayTitleArray;
@synthesize monthSleepArray = _monthSleepArray;
@synthesize monthTitleArray =_monthTitleArray;
@synthesize monthStr =_monthStr;
@synthesize sleepdownModel =_sleepdownModel;
//此处数据全为测试数据
+(NSArray *)getDaysSleepDatawithCurrentDayUpdata:(NSArray *)homeArray withindex:(NSInteger)index
{
    NSMutableArray *tempArray = [NSMutableArray new];
    switch (index) {
        case 0://日
        {
            for (int n = 0; n<homeArray.count; n++) {
                SleepDataModel *sleepmodel = [SleepDataModel new];;
                SleepdownModel *sleepdownModel = [SleepdownModel convertDataToModel:homeArray[n]];
                NSArray *sleeps = [[NSArray alloc] initWithArray:[sleepdownModel.sleeps componentsSeparatedByString:@","]];
                NSMutableArray *temps = [NSMutableArray new];
                //480个点分为24组，每组20个点的汇总
                __block int count = 0;
                [sleeps enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                    
                    count = [obj integerValue];
                    [temps addObject:[NSNumber numberWithInt:count]];
                    
                    
                    if (idx == sleeps.count-1) {
                        sleepmodel.everyDaySleepArray = temps;
                        sleepmodel.everydayTitle = sleepdownModel.date;
                        sleepmodel.sleepdownModel = sleepdownModel;
                        [tempArray addObject:sleepmodel];
                        *stop = YES;
                    }
                }];
            }
            break;
        case 1://周
            {
                SleepdownModel *sleepdownModel1 = [SleepdownModel convertDataToModel:homeArray.firstObject];
                NSArray *datesArray1 = [DateHandle getArrayByTheDate:sleepdownModel1.date index:0];//返回数据@［@[],.....］天，星期，完整日期
                SleepdownModel *sleepdownModel2 = [SleepdownModel convertDataToModel:homeArray.lastObject];
                NSArray *datesArray2 = [DateHandle getArrayByTheDate:sleepdownModel2.date index:0];//返回数据@［@[],.....］天，星期，完整日期
                NSString *startDate = datesArray1.firstObject[2];
                NSString *endDate = datesArray2.lastObject[2];
                //            NSLog(@"~~~自然周的开始日期%@,结束日期%@",startDate,endDate);
                NSInteger num = [DateHandle daysWithinEraFromDate:startDate toDate:endDate];
                //            NSLog(@"~~~自然周相隔%d周",(num+2)/7);
                for (int n = 0; n<(num+2)/7; n++) {//多少周
                    SleepDataModel *sleepmodel = [SleepDataModel new];
                    NSMutableArray *temps = [NSMutableArray new];
                    sleepmodel.weekDayTitleArray = [DateHandle  getArrayByTheDate:startDate index:0];
                    SleepdownModel *sleepdownModel = [SleepdownModel new];
                    
                    CGFloat totalDeep = 0;
                    CGFloat totalLight = 0;
                    CGFloat totalWake = 0;
                    for (int j = 0; j<7; j++)  {//每周7天
                        NSInteger a=0,b=0,c=0;
                        NSArray *array = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userid = '%@' and date = '%@'",[Singleton getUserID],startDate]];
                        if (array.count>0) {
                            sleepdownModel = [SleepdownModel convertDataToModel:array[0]];
                            a = [sleepdownModel.DeepTime integerValue];
                            b = [sleepdownModel.lightTime integerValue];
                            c = [sleepdownModel.wakeTime integerValue];
                            totalDeep = totalDeep + a;
                            totalLight = totalLight + b;
                            totalWake = totalWake + c;
                        }
                        [temps addObject:@[[NSNumber numberWithInteger:a],[NSNumber numberWithInteger:b],[NSNumber numberWithInteger:c]]];
                        
                        
                        startDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:startDate byIndex:1  withType:@"yyyy-MM-dd"];
                    }
                    
                    sleepmodel.weekDaySleepArray = temps;
                    sleepdownModel.DeepTime = [NSString stringWithFormat:@"%.0f",totalDeep];
                    sleepdownModel.lightTime = [NSString stringWithFormat:@"%.0f",totalLight];
                    sleepdownModel.wakeTime = [NSString stringWithFormat:@"%.0f",totalWake];
                    sleepmodel.sleepdownModel = sleepdownModel;
                    
                    [tempArray addObject:sleepmodel];
                }
                
            }
            break;
        case 2://月
            {
                SleepdownModel *sleepdownModel1 = [SleepdownModel convertDataToModel:homeArray.firstObject];
                NSArray *datesArray1 = [DateHandle getArrayByTheDate:sleepdownModel1.date index:1];//当前日期所在月对应的日期
                
                SleepdownModel *sleepdownModel2 = [SleepdownModel convertDataToModel:homeArray.lastObject];
                NSArray *datesArray2 = [DateHandle getArrayByTheDate:sleepdownModel2.date index:1];//当前日期所在月对应的日期
                
                __block NSString *startDate = datesArray1.firstObject;
                NSString *endDate = datesArray2.lastObject;
                NSInteger num = [[endDate componentsSeparatedByString:@"-"][1] intValue] - [[startDate componentsSeparatedByString:@"-"][1] intValue]+1;
                NSLog(@"开始时间%@-结束时间%@～～～～相隔%d个月",startDate,endDate,num);
                for (int y = 0; y <num; y++) {//多少月
                    SleepDataModel *sleepmodel = [SleepDataModel new];
                    
                    NSMutableArray *temps = [NSMutableArray new];
                    NSMutableArray *titleArray = [NSMutableArray new];
                    sleepmodel.monthStr = [startDate componentsSeparatedByString:@"-"][1];
                    NSArray *days = [DateHandle getArrayByTheDate:startDate index:1];
                    
                    __block SleepdownModel *sleepdownModel = [SleepdownModel new];
                    __block NSInteger a=0,b=0,c=0;
                    __block CGFloat totalDeep = 0;
                    __block CGFloat totalLight = 0;
                    __block CGFloat totalWake = 0;
                    [days enumerateObjectsUsingBlock:^(NSString *date, NSUInteger idx, BOOL *stop) {
                        
                        NSArray *array = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userid = '%@' and date = '%@'",[Singleton getUserID],date]];
                        
                        if(array.count>0){
                            sleepdownModel = [SleepdownModel convertDataToModel:array[0]];
                            a = a + [sleepdownModel.DeepTime floatValue];
                            b = b + [sleepdownModel.lightTime floatValue];
                            c = c + [sleepdownModel.wakeTime floatValue];
                            
                        }
                        if ((idx+1)%6 == 0 || idx == days.count-1) {
                            
                            totalDeep = totalDeep + a;
                            totalLight = totalLight + b;
                            totalWake = totalWake + c;
                            
                            [temps addObject:@[[NSNumber numberWithInteger:a],[NSNumber numberWithInteger:b],[NSNumber numberWithInteger:c]]];
                            NSString *dategroup = [NSString stringWithFormat:@"%@-%@",[startDate componentsSeparatedByString:@"-"][2],[date componentsSeparatedByString:@"-"][2]];
                            startDate = date;
                            a=0,b=0,c=0;
                            [titleArray addObject:dategroup];
                            
                            if (idx == days.count-1) {
                                startDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:startDate byIndex:1  withType:@"yyyy-MM-dd"];
                                sleepmodel.monthSleepArray = temps;
                                sleepmodel.monthTitleArray = titleArray;
                                sleepdownModel.DeepTime = [NSString stringWithFormat:@"%.0f",totalDeep];
                                sleepdownModel.lightTime = [NSString stringWithFormat:@"%.0f",totalLight];
                                sleepdownModel.wakeTime = [NSString stringWithFormat:@"%.0f",totalWake];
                                sleepmodel.sleepdownModel = sleepdownModel;
                                [tempArray addObject:sleepmodel];
                                *stop = YES;
                            }
                        }
                        
                    }];
                }
                
            }
            break;
        default:
            break;
        }
    }
     return tempArray;
}

+(NSArray *)getDaysSleepInfo
{
    NSMutableArray *tempArry = [NSMutableArray new];
    NSMutableArray *temps = [NSMutableArray new];
    for(int j = 0; j<3;j++)
    {
        NSMutableArray *temps = [NSMutableArray new];
        //SleepDataModel *sleepmodel = [SleepDataModel new];
        NSInteger a=0;
        for(int i = 0;i<480;i++){
            if(i<100){
                a = arc4random() % 60;
            }else if(i>=100&& i <300){
                a = arc4random() % 30+61;
            }else if(i>=300 &&i<400){
                a = arc4random() % 60+91;
            }else{
                a = arc4random() % 60;
                
            }
            [temps addObject:[NSNumber numberWithInteger:a]];
        }
        //sleepmodel.everyDaySleepArray = temps;
       // sleepmodel.everydayTitle = [DateHandle getTomorrowAndYesterDayByCurrentDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO] byIndex:(j-2)  withType:@"yyyy-MM-dd"];
        [tempArry addObject:temps];
    }
    

    
    
    
    return temps;
}
@end

