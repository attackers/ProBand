//
//  StepDataModel.m
//  LenovoVB10
//
//  Created by jacy on 14/12/18.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "StepDataModel.h"

@implementation StepDataModel

+(NSArray *)getDaysStepDatawithCurrentDayUpdata:(NSArray *)homeArray withindex:(NSInteger)index{
     NSMutableArray *tempArray = [NSMutableArray new];
    switch (index) {
        case 0://日
        {
            for (int n = 0; n<homeArray.count; n++) {
                StepDataModel *stepmodel = [StepDataModel new];
                StepdownModel *stepdownModel = [StepdownModel convertDataToModel:homeArray[n]];
                NSArray *datas = [[NSArray alloc] initWithArray:[stepdownModel.steps componentsSeparatedByString:@","]];
                NSMutableArray *temps = [NSMutableArray new];
                //480个点分为24组，每组20个点的汇总
                __block int count = 0;
                [datas enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                    
                    count = count +[obj intValue];
                    if (idx%24==0) {
                        [temps addObject:[NSNumber numberWithInt:count]];
                        count = 0;
                    }
                 
                    if (idx == datas.count-1) {
                        stepmodel.everyDayStepArray = temps;
                        stepmodel.everydayTitle = stepdownModel.date;
                        stepmodel.stepdownModel = stepdownModel;
                        [tempArray addObject:stepmodel];
                        *stop = YES;
                    }
                }];
            }
 
        }
            break;
        case 1://周
        {
            StepdownModel *stepdownModel1 = [StepdownModel convertDataToModel:homeArray.firstObject];
            NSArray *datesArray1 = [DateHandle getArrayByTheDate:stepdownModel1.date index:0];//返回数据@［@[],.....］天，星期，完整日期
            StepdownModel *stepdownModel2 = [StepdownModel convertDataToModel:homeArray.lastObject];
            NSArray *datesArray2 = [DateHandle getArrayByTheDate:stepdownModel2.date index:0];//返回数据@［@[],.....］天，星期，完整日期
            NSLog(@"%@%@",datesArray1[1],datesArray2[2]);
            NSString *startDate = datesArray1.firstObject[2];
            NSString *endDate = datesArray2.lastObject[2];
//            NSLog(@"~~~自然周的开始日期%@,结束日期%@",startDate,endDate);
            NSInteger num = [DateHandle daysWithinEraFromDate:startDate toDate:endDate];
//            NSLog(@"~~~自然周相隔%d周",(num+2)/7);
            for (int n = 0; n<(num+2)/7; n++) {//多少周
                StepDataModel *stepmodel = [StepDataModel new];
                NSMutableArray *temps = [NSMutableArray new];
                stepmodel.weekDayTitleArray = [DateHandle  getArrayByTheDate:startDate index:0];
                StepdownModel *stepdownModel = [StepdownModel new];
                CGFloat totalCal = 0;
                CGFloat totaldis = 0;
                CGFloat totalTime = 0;
                for (int j = 0; j<7; j++)  {//每周7天
                    NSArray *array = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where userid = '%@' and date = '%@'",[Singleton getUserID],startDate]];
                    if (array.count>0) {
                        stepdownModel = [StepdownModel convertDataToModel:array[0]];
                        [temps addObject:[NSNumber numberWithInt:[stepdownModel.totalSteps intValue]]];
                        totalCal = totalCal + [stepdownModel.totalCalories floatValue];
                        totaldis = totaldis + [stepdownModel.totalDistance floatValue];
                        totalTime = totalTime + [stepdownModel.sportDuration floatValue];
                    }else{
                        [temps addObject:[NSNumber numberWithInt:0]];
                    }
                    
                    startDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:startDate byIndex:1  withType:@"yyyy-MM-dd"];
                }
                
                stepmodel.weekDayStepArray = temps;
                stepdownModel.totalCalories = [NSString stringWithFormat:@"%.0f",totalCal];
                stepdownModel.totalDistance = [NSString stringWithFormat:@"%.0f",totaldis];
                stepdownModel.sportDuration = [NSString stringWithFormat:@"%.0f",totalTime];
                stepmodel.stepdownModel = stepdownModel;
                
                [tempArray addObject:stepmodel];
            }
        }
            break;
        case 2://月
        {
            StepdownModel *stepdownModel1 = [StepdownModel convertDataToModel:homeArray.firstObject];
            NSArray *datesArray1 = [DateHandle getArrayByTheDate:stepdownModel1.date index:1];//当前日期所在月对应的日期
            
            StepdownModel *stepdownModel2 = [StepdownModel convertDataToModel:homeArray.lastObject];
            NSArray *datesArray2 = [DateHandle getArrayByTheDate:stepdownModel2.date index:1];//当前日期所在月对应的日期
            
            __block NSString *startDate = datesArray1.firstObject;
            NSString *endDate = datesArray2.lastObject;
            NSInteger num = [[endDate componentsSeparatedByString:@"-"][1] intValue] - [[startDate componentsSeparatedByString:@"-"][1] intValue]+1;
            NSLog(@"开始时间%@-结束时间%@～～～～相隔%d个月",startDate,endDate,num);
            for (int y = 0; y <num; y++) {//多少月
                StepDataModel *stepmodel = [StepDataModel new];
                
                NSMutableArray *temps = [NSMutableArray new];
                NSMutableArray *titleArray = [NSMutableArray new];
                stepmodel.monthStr = [startDate componentsSeparatedByString:@"-"][1];
                NSArray *days = [DateHandle getArrayByTheDate:startDate index:1];
    
                __block StepdownModel *stepdownModel = [StepdownModel new];
                __block int count = 0;
                __block CGFloat totalCal = 0;
                __block CGFloat totaldis = 0;
                __block CGFloat totalTime = 0;
                [days enumerateObjectsUsingBlock:^(NSString *date, NSUInteger idx, BOOL *stop) {
                    
                     NSArray *array = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where userid = '%@' and date = '%@'",[Singleton getUserID],date]];
                    
                    if(array.count>0){
                        stepdownModel = [StepdownModel convertDataToModel:array[0]];
                        count = count + [stepdownModel.totalSteps intValue];
                        totalCal = totalCal + [stepdownModel.totalCalories floatValue];
                        totaldis = totaldis + [stepdownModel.totalDistance floatValue];
                        totalTime = totalTime + [stepdownModel.sportDuration floatValue];
                    }
                    if ((idx+1)%6 == 0 || idx == days.count-1) {
                        
                        [temps addObject:[NSNumber numberWithInt:count]];
                        NSString *dategroup = [NSString stringWithFormat:@"%@-%@",[startDate componentsSeparatedByString:@"-"][2],[date componentsSeparatedByString:@"-"][2]];
                        startDate = date;
                        count = 0;
                        [titleArray addObject:dategroup];

                        if (idx == days.count-1) {
                            startDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:startDate byIndex:1  withType:@"yyyy-MM-dd"];
                            stepmodel.monthStepArray = temps;
                            stepmodel.monthTitleArray = titleArray;
                            stepdownModel.totalCalories = [NSString stringWithFormat:@"%.0f",totalCal];
                            stepdownModel.totalDistance = [NSString stringWithFormat:@"%.0f",totaldis];
                            stepdownModel.sportDuration = [NSString stringWithFormat:@"%.0f",totalTime];
                            stepmodel.stepdownModel = stepdownModel;
                            [tempArray addObject:stepmodel];
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
    
    return tempArray;
}
@end
