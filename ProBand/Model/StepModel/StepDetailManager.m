//
//  StepDetailManager.m
//  LenovoVB10
//
//  Created by fly on 15/4/27.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "StepDetailManager.h"
#import "stepDate_deviceidManage.h"
#import "DateHandle.h"
#define ColumnNumber  6

@implementation StepDetailManager


+(StepTodayModel *)getTodayData
{
    NSString *curDate = [PublicFunction getCurDay];
    stepDate_deviceid_Model *stepTemp = [stepDate_deviceidManage getModelByDate:curDate];
    
    
    NSMutableArray *stepArray = [NSMutableArray new];
    NSMutableArray *colArray = [NSMutableArray new];
    NSMutableArray *distanceArray = [NSMutableArray new];
    
    if (stepTemp.Id)
    {
        NSArray *orignalStepArray = [stepTemp.steps componentsSeparatedByString:@","];
        NSArray *orignalColArray = [stepTemp.calories componentsSeparatedByString:@","];
        NSArray *orignalKmArray = [stepTemp.meters componentsSeparatedByString:@","];
        int totalSteps = 0;
        float totalCol = 0;
        float totalKm = 0;
        
        for (int i = 0; i<[orignalStepArray count]; i++)
        {
            totalSteps += [orignalStepArray[i] intValue];
            totalCol += [orignalColArray[i] intValue];
            totalKm += [orignalKmArray[i] intValue];
            if ((i+1)%((int)[orignalStepArray count]/ColumnNumber) == 0)
            {
                
                [stepArray addObject:[NSString stringWithFormat:@"%d",totalSteps]];
                [colArray addObject:[NSString stringWithFormat:@"%.2f",totalCol]];
                [distanceArray addObject:[NSString stringWithFormat:@"%.2f",totalKm]];
                
                totalSteps = 0;
                totalCol = 0;
                totalKm = 0;
            }
        }
        
        
        
        StepTodayModel *stepToday = [StepTodayModel instancesFromDictionary:@{@"stepDuration":stepTemp.sportDuration,
                                                                         @"stepTotalCounts":stepTemp.totalSteps,
                                                                         @"stepDistance":stepTemp.totalDistance,
                                                                         @"stepArray":stepArray,
                                                                         @"colArray":colArray,
                                                                         @"distanceArray":distanceArray,
                                                                         @"stepDate":stepTemp.date
                                                                         }];
        return stepToday;
    }
    else
    {
        for (int i = 0; i<ColumnNumber; i++)
        {
            [stepArray addObject:@"0"];
            [colArray addObject:@"0"];
            [distanceArray addObject:@"0"];
        }
        
        
        StepTodayModel *stepToday = [StepTodayModel instancesFromDictionary:@{@"stepDuration":@"0",
                                                                         @"stepTotalCounts":@"0",
                                                                         @"stepDistance":@"0",
                                                                         @"stepArray":stepArray,
                                                                         @"colArray":colArray,
                                                                         @"distanceArray":distanceArray,
                                                                         @"stepDate":@"0"
                                                                         }];
        return stepToday;
    }

}


+(StepDataModel *)getEveryDayFullWithoriginalArray:(NSArray *)originalSteps withStepDataModel:(StepDataModel *)stepDataModel
{
    
    NSMutableArray *allDataArray = [NSMutableArray new];
    for (int i = 0; i<[originalSteps count]-1; i++)
    {
        stepDetailModel *firstModel = originalSteps[i];
        if (![allDataArray containsObject:firstModel])
        {
            [allDataArray addObject:firstModel];
        }
   
        stepDetailModel *nextModel = originalSteps[i+1];
        int intervalDays = [DateHandle daysWithinEraFromDate:nextModel.stepDate toDate:firstModel.stepDate];

        for (int i = 1; i<intervalDays; i++)
        {
            [allDataArray addObject:[self getDefaultStepModelWithDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:firstModel.stepDate byIndex:-i withType:@"yyyy-MM-dd"]]];
        }
        
        if (![allDataArray containsObject:nextModel])
        {
            [allDataArray addObject:nextModel];
        }

    }
    
    stepDataModel.originalFullStepArray = allDataArray;
    return stepDataModel;
}


+(StepDataModel *)getEveryDayDataWithStepDataModel:(StepDataModel *)stepDataModel
{
    NSArray *fullDataArray = stepDataModel.originalFullStepArray;
    
    NSMutableArray *groupArray = [NSMutableArray new];
    
    NSMutableArray *stepArray = [NSMutableArray new];
    NSMutableArray *colArray = [NSMutableArray new];
    NSMutableArray *distanceArray = [NSMutableArray new];
    NSMutableArray *durationArray = [NSMutableArray new];
    NSMutableArray *dateArray = [NSMutableArray new];
    
    
    int stepCounts = 0;
    float stepCol = 0;
    float stepDis = 0;
    int stepDur = 0;
    
    for (int i = 0; i<[fullDataArray count]; i++)
    {
        stepDetailModel *tempModel = fullDataArray[i];
        [stepArray addObject:tempModel.stepTotalCounts];
        [colArray addObject:tempModel.stepTotalCol];
        [distanceArray addObject:tempModel.stepTotalDistance];
        [durationArray addObject:tempModel.stepTotalDuration];
        [dateArray addObject:[DateHandle getTheDateFrom:tempModel.stepDate withBeforeType:@"yyyy-MM-dd" withresultType:@"MM/dd"]];
        
        stepCounts += [tempModel.stepTotalCounts intValue];
        stepCol += [tempModel.stepTotalCol floatValue];
        stepDis += [tempModel.stepTotalDistance floatValue];
        stepDur += [tempModel.stepTotalDuration intValue];
        
        
        if ((i+1)%ColumnNumber == 0)
        {
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel = [StepTodayModel instancesFromDictionary:dic];
            [groupArray addObject:stepmodel];

            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
        }
        
        //处理不能被六整除的剩余数据
        if (i == [fullDataArray count]-1 && [dateArray count]!=0)
        {
            int dValue = ColumnNumber-[stepArray count];
            for (int j = 0; j< dValue; j++)
            {
                [stepArray addObject:@"0"];
                [colArray addObject:@"0"];
                [distanceArray addObject:@"0"];
                [durationArray addObject:@"0"];
                [dateArray addObject:[DateHandle getTomorrowAndYesterDayByCurrentDate:[dateArray lastObject] byIndex:-1 withType:@"MM/dd"]];
            }
            
            
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel = [StepTodayModel instancesFromDictionary:dic];
            [groupArray addObject:stepmodel];
            
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;

        }
        
    }

    stepDataModel.everyDayStepArray = groupArray;
    
    return stepDataModel;
}


+(StepDataModel *)getEveryWeekDataWithStepDataModel:(StepDataModel *)stepDataModel
{
    NSMutableArray *fullDataArray = [NSMutableArray arrayWithArray:stepDataModel.originalFullStepArray];
    NSMutableArray *groupArray = [NSMutableArray new];
    NSMutableArray *weekArray = [NSMutableArray new];
    
    for (int i = 0; i<[fullDataArray count]; i++)
    {
        stepDetailModel *temDetailModel = fullDataArray[i];
       NSArray *temWeek = [DateHandle getArrayByTheDate:temDetailModel.stepDate index:0];
        if (![weekArray containsObject:temWeek])
        {
          [weekArray addObject:temWeek];
        }
    }
    
    stepDetailModel *firstDetailModel = [fullDataArray firstObject];
    stepDetailModel *lastDetailModel = [fullDataArray lastObject];
    
    NSString *firstWeekDate = [[[weekArray lastObject] firstObject] lastObject];
    NSString *lastWeekDate = [[[weekArray firstObject] lastObject] lastObject];
    NSLog(@"+>>>>-----%@----->>>>>%@",firstWeekDate,lastWeekDate);
    
    int firstIntervale = [DateHandle daysWithinEraFromDate:firstWeekDate toDate:lastDetailModel.stepDate];
    int lastIntervale = [DateHandle daysWithinEraFromDate:firstDetailModel.stepDate toDate:lastWeekDate];
    
    for (int i = 0; i<firstIntervale; i++)
    {
        stepDetailModel *tempDeaModel = [self getDefaultStepModelWithDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:lastDetailModel.stepDate byIndex:-(i+1) withType:@"yyyy-MM-dd"]];
        if (![fullDataArray containsObject:tempDeaModel])
        {
            [fullDataArray addObject:tempDeaModel];
        }
    }
    
    
    for (int i = 0; i<lastIntervale; i++)
    {
        stepDetailModel *tempDeaModel = [self getDefaultStepModelWithDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:firstDetailModel.stepDate byIndex:(i+1) withType:@"yyyy-MM-dd"]];
        if (![fullDataArray containsObject:tempDeaModel])
        {
            [fullDataArray insertObject:tempDeaModel atIndex:0];
        }
    }
    
    
    
    NSMutableArray *stepArray = [NSMutableArray new];
    NSMutableArray *colArray = [NSMutableArray new];
    NSMutableArray *distanceArray = [NSMutableArray new];
    NSMutableArray *durationArray = [NSMutableArray new];
    NSMutableArray *dateArray = [NSMutableArray new];
    
    
    int stepCounts = 0;
    float stepCol = 0;
    float stepDis = 0;
    int stepDur = 0;
    
    NSMutableArray *tempWeekDateArray = [NSMutableArray new];
    
    for (int i = 0; i<[fullDataArray count]; i++)
    {
        stepDetailModel *tempModel = fullDataArray[i];
        [stepArray addObject:tempModel.stepTotalCounts];
        [colArray addObject:tempModel.stepTotalCol];
        [distanceArray addObject:tempModel.stepTotalDistance];
        [durationArray addObject:tempModel.stepTotalDuration];
        [dateArray addObject:[DateHandle getTheDateFrom:tempModel.stepDate withBeforeType:@"yyyy-MM-dd" withresultType:@"MM/dd"]];
        
        stepCounts += [tempModel.stepTotalCounts intValue];
        stepCol += [tempModel.stepTotalCol floatValue];
        stepDis += [tempModel.stepTotalDistance floatValue];
        stepDur += [tempModel.stepTotalDuration intValue];
        
        if ((i+1)%7 == 0)
        {
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel = [StepTodayModel instancesFromDictionary:dic];
            [tempWeekDateArray addObject:stepmodel];
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;

        }
    }
    
        stepCounts = 0;
        stepCol = 0;
        stepDis = 0;
        stepDur = 0;
    
    
    
    
    for (int i = 0; i<[tempWeekDateArray count]; i++)
    {
         StepTodayModel *stepmodel = tempWeekDateArray[i];
        
        NSString *weekDateStr = [NSString new];
        for (int j = 0; j<7; j++)
        {
            stepCounts += [stepmodel.stepArray[j] intValue];
            stepCol += [stepmodel.colArray[j] floatValue];
            stepDis += [stepmodel.distanceArray[j] floatValue];
            stepDur += [stepmodel.stepDurationArray[j] intValue];
            weekDateStr = [DateHandle dateStringConbine:stepmodel.stepDateArray[6] withString:stepmodel.stepDateArray[0]];
        }
        [stepArray addObject:[NSString stringWithFormat:@"%d",stepCounts]];
        [colArray addObject:[NSString stringWithFormat:@"%.2f",stepCol]];
        [distanceArray addObject:[NSString stringWithFormat:@"%.2f",stepDis]];
        [durationArray addObject:[NSString stringWithFormat:@"%d",stepDur]];
        [dateArray addObject:weekDateStr];
        
        stepCounts = 0;
        stepCol = 0;
        stepDis = 0;
        stepDur = 0;
        
        if ((i+1)%ColumnNumber == 0)
        {
            
            stepmodel.stepArray = [stepArray copy];
            stepmodel.colArray = [colArray copy];
            stepmodel.distanceArray = [distanceArray copy];
            stepmodel.stepDuration = [durationArray copy];
            stepmodel.stepDateArray = [dateArray copy];
            
            [groupArray addObject:stepmodel];
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
        }
        
        //处理不能被六整除的剩余数据
        if ((i == [tempWeekDateArray count]-1) && ([dateArray count]!=0))
        {
            int dValue = ColumnNumber-[stepArray count];
            for (int j = 0; j< dValue; j++)
            {
                [stepArray addObject:@"0"];
                [colArray addObject:@"0"];
                [distanceArray addObject:@"0"];
                [durationArray addObject:@"0"];
                [dateArray addObject:[DateHandle dateStringConbine:[DateHandle getTomorrowAndYesterDayByCurrentDate:stepmodel.stepDateArray[0] byIndex:(j+2)*(-7)+1 withType:@"MM/dd"] withString:[DateHandle getTomorrowAndYesterDayByCurrentDate:stepmodel.stepDateArray[0] byIndex:(j+1)*(-7) withType:@"MM/dd"]]];
            }
            
            
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel1 = [StepTodayModel instancesFromDictionary:dic];
            [groupArray addObject:stepmodel1];
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
            
        }

        
    }
    
    stepDataModel.weekDayStepArray = groupArray;
    
    
    return stepDataModel;
}


+(StepDataModel *)getEveryMonthDataWithStepDataModel:(StepDataModel *)stepDataModel
{
    NSMutableArray *fullDataArray = [NSMutableArray arrayWithArray:stepDataModel.originalFullStepArray];
    NSMutableArray *groupArray = [NSMutableArray new];
    NSMutableArray *monthArray = [NSMutableArray new];
    
    for (int i = 0; i<[fullDataArray count]; i++)
    {
        stepDetailModel *temDetailModel = fullDataArray[i];
        NSArray *temMonth = [DateHandle getArrayByTheDate:temDetailModel.stepDate index:1];
        if (![monthArray containsObject:temMonth])
        {
            [monthArray addObject:temMonth];
        }
    }
    
    stepDetailModel *firstDetailModel = [fullDataArray firstObject];
    stepDetailModel *lastDetailModel = [fullDataArray lastObject];
    
    NSString *firstWeekDate = [[monthArray lastObject] firstObject];
    NSString *lastWeekDate = [[monthArray firstObject] lastObject];
    NSLog(@"+>>>>-----%@----->>>>>%@",firstWeekDate,lastWeekDate);
    
    int firstIntervale = [DateHandle daysWithinEraFromDate:firstWeekDate toDate:lastDetailModel.stepDate];
    int lastIntervale = [DateHandle daysWithinEraFromDate:firstDetailModel.stepDate toDate:lastWeekDate];
    
    for (int i = 0; i<firstIntervale; i++)
    {
        stepDetailModel *tempDeaModel = [self getDefaultStepModelWithDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:lastDetailModel.stepDate byIndex:-(i+1) withType:@"yyyy-MM-dd"]];
        if (![fullDataArray containsObject:tempDeaModel])
        {
            [fullDataArray addObject:tempDeaModel];
        }
    }
    
    
    for (int i = 0; i<lastIntervale; i++)
    {
        stepDetailModel *tempDeaModel = [self getDefaultStepModelWithDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:firstDetailModel.stepDate byIndex:(i+1) withType:@"yyyy-MM-dd"]];
        if (![fullDataArray containsObject:tempDeaModel])
        {
            [fullDataArray insertObject:tempDeaModel atIndex:0];
        }
    }
    
    
    NSMutableArray *stepArray = [NSMutableArray new];
    NSMutableArray *colArray = [NSMutableArray new];
    NSMutableArray *distanceArray = [NSMutableArray new];
    NSMutableArray *durationArray = [NSMutableArray new];
    NSMutableArray *dateArray = [NSMutableArray new];
    
    
    int stepCounts = 0;
    float stepCol = 0;
    float stepDis = 0;
    int stepDur = 0;
    
    NSMutableArray *tempWeekDateArray = [NSMutableArray new];
    int months = 0;  //取每个月的索引
    int monthNumber = 0;//判断每个月有多少天
    for (int i = 0; i<[fullDataArray count]; i++)
    {
        monthNumber ++;
        stepDetailModel *tempModel = fullDataArray[i];
        [stepArray addObject:tempModel.stepTotalCounts];
        [colArray addObject:tempModel.stepTotalCol];
        [distanceArray addObject:tempModel.stepTotalDistance];
        [durationArray addObject:tempModel.stepTotalDuration];
        [dateArray addObject:tempModel.stepDate];
        
        stepCounts += [tempModel.stepTotalCounts intValue];
        stepCol += [tempModel.stepTotalCol floatValue];
        stepDis += [tempModel.stepTotalDistance floatValue];
        stepDur += [tempModel.stepTotalDuration intValue];
        
        if (monthNumber%[monthArray[months] count] == 0)
        {
            monthNumber = 0;
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel = [StepTodayModel instancesFromDictionary:dic];
            [tempWeekDateArray addObject:stepmodel];
            
            stepArray = [NSMutableArray new];
            colArray = [NSMutableArray new];
            distanceArray = [NSMutableArray new];
            durationArray = [NSMutableArray new];
            dateArray = [NSMutableArray new];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
            months++;
            if (months>[monthArray count]-1)
            {
                months = [monthArray count]-1;
            }
            
            
        }
        
    }
    
    
    [stepArray removeAllObjects];
    [colArray removeAllObjects];
    [distanceArray removeAllObjects];
    [durationArray removeAllObjects];
    [dateArray removeAllObjects];
    
    stepCounts = 0;
    stepCol = 0;
    stepDis = 0;
    stepDur = 0;
    
    for (int i = 0; i<[tempWeekDateArray count]; i++)
    {
        StepTodayModel *stepmodel = tempWeekDateArray[i];
        
        NSString *monthDateStr = [NSString new];
        for (int j = 0; j<[stepmodel.stepDateArray count]; j++)
        {
            stepCounts += [stepmodel.stepArray[j] intValue];
            stepCol += [stepmodel.colArray[j] floatValue];
            stepDis += [stepmodel.distanceArray[j] floatValue];
            stepDur += [stepmodel.stepDurationArray[j] intValue];
            monthDateStr = stepmodel.stepDateArray[0];
        }
        [stepArray addObject:[NSString stringWithFormat:@"%d",stepCounts]];
        [colArray addObject:[NSString stringWithFormat:@"%.2f",stepCol]];
        [distanceArray addObject:[NSString stringWithFormat:@"%.2f",stepDis]];
        [durationArray addObject:[NSString stringWithFormat:@"%d",stepDur]];
        [dateArray addObject:monthDateStr];
        
        stepCounts = 0;
        stepCol = 0;
        stepDis = 0;
        stepDur = 0;
        
        if ((i+1)%ColumnNumber == 0)
        {
            
            stepmodel.stepArray = [stepArray copy];
            stepmodel.colArray = [colArray copy];
            stepmodel.distanceArray = [distanceArray copy];
            stepmodel.stepDuration = [durationArray copy];
            stepmodel.stepDateArray = [dateArray copy];
            
            [groupArray addObject:stepmodel];
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
        }
        
        //处理不能被六整除的剩余数据
        if ((i == [tempWeekDateArray count]-1) && ([dateArray count]!=0))
        {
            int dValue = ColumnNumber-[stepArray count];
            
            NSArray *priouserMonth = [DateHandle getArrayByTheDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:stepmodel.stepDateArray[0] byIndex:-5 withType:@"yyyy-MM-dd"] index:1];
            
            NSMutableArray *dValueMonth = [NSMutableArray new];
            [dValueMonth addObject:priouserMonth];
            for (int j = 0; j< dValue; j++)
            {
                [stepArray addObject:@"0"];
                [colArray addObject:@"0"];
                [distanceArray addObject:@"0"];
                [durationArray addObject:@"0"];
                
                priouserMonth = dValueMonth[j];
                NSDate *date = [DateHandle stringToDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:priouserMonth[0] byIndex:-1 withType:@"yyyy-MM-dd"] withtype:2];
                
                [dateArray addObject:[DateHandle dateToString:date withType:4]];
                
                [dValueMonth addObject:[DateHandle getArrayByTheDate:[DateHandle getTomorrowAndYesterDayByCurrentDate:priouserMonth[0] byIndex:-5 withType:@"yyyy-MM-dd"] index:1]];
            }
            
            
            NSDictionary *dic = @{@"stepDuration":[NSString stringWithFormat:@"%d",stepDur],
                                  @"stepTotalCounts":[NSString stringWithFormat:@"%d",stepCounts],
                                  @"stepDistance":[NSString stringWithFormat:@"%.2f",stepDis],
                                  @"stepCol":[NSString stringWithFormat:@"%.2f",stepCol],
                                  @"stepArray":[stepArray copy],
                                  @"colArray":[colArray copy],
                                  @"distanceArray":[distanceArray copy],
                                  @"stepDateArray":[dateArray copy],
                                  @"stepDurationArray":[durationArray copy]
                                  };
            
            StepTodayModel *stepmodel1 = [StepTodayModel instancesFromDictionary:dic];
            [groupArray addObject:stepmodel1];
            
            [stepArray removeAllObjects];
            [colArray removeAllObjects];
            [distanceArray removeAllObjects];
            [durationArray removeAllObjects];
            [dateArray removeAllObjects];
            
            stepCounts = 0;
            stepCol = 0;
            stepDis = 0;
            stepDur = 0;
            
        }
        
        
    }
    stepDataModel.monthStepArray = groupArray;

    return stepDataModel;
}






+(stepDetailModel *)conventModelFrom:(stepDate_deviceid_Model *)originalModel
{
    if (originalModel.date)
    {
        NSDictionary *temDic = @{@"stepTotalCounts":originalModel.totalSteps,
                                 @"stepTotalCol":originalModel.totalCalories,
                                 @"stepTotalDistance":originalModel.totalDistance,
                                 @"stepTotalDuration":originalModel.sportDuration,
                                 @"stepDate":originalModel.date
                                 };
        stepDetailModel *stepDetailMod = [stepDetailModel instancesFromDictionary:temDic];
        return stepDetailMod;
    }
    else
    {
    stepDetailModel *stepDetailMod = [self getDefaultStepModelWithDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO]];
        return stepDetailMod;
    }

}

+(stepDetailModel *)getDefaultStepModelWithDate:(NSString *)dateStr
{
    stepDetailModel *stepModel = [stepDetailModel instancesFromDictionary:@{@"stepTotalCounts":@"0",
                                                                            @"stepTotalCol":@"0",
                                                                            @"stepTotalDistance":@"0",
                                                                            @"stepTotalDuration":@"0",
                                                                            @"stepDate":dateStr
                                                                            }];
    return stepModel;
}


+ (NSArray *)changeArrayValue:(NSArray *)originalArray
{
    NSMutableArray *resultArray = [NSMutableArray new];
    
    [originalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *tempArray = [obj componentsSeparatedByString:@"-"];
        NSString *str = [[NSString alloc] initWithFormat:@"%d月",[tempArray[1] intValue]];
        [resultArray addObject:str];
    }];
    
    return resultArray;
}


@end
