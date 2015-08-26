//
//  SleepDetailManager.m
//  LenovoVB10
//
//  Created by 于苗 on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepDetailManager.h"
#import "SleepBaseModel.h"
#import "sleepDate_deviceid_Model.h"
#import "DateHandle.h"
#import "sleepDate_deviceidManage.h"
@implementation SleepDetailManager

+(NSArray *)getDaySleepDetail:(NSArray *)allSleepDetailArr
{
    
    NSMutableArray *reslutArray = [NSMutableArray array];
    if ([sleepDate_deviceidManage count]==0) {
        NSMutableArray *tempMutableArr = [NSMutableArray arrayWithCapacity:0];
        for (int i= 0; i<6; i++) {
            SleepBaseModel *baseObj = [[SleepBaseModel alloc]init];
            baseObj.sleepArr = @[@"0",@"0",@"0"];
            baseObj.date = [DateHandle getTomorrowAndYesterDayByCurrentDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO] byIndex:-i withType:@"yyyy-MM-dd"];
            baseObj.dreep = @"0";
            baseObj.light = @"0";
            baseObj.weak = @"0";
            baseObj.totalSleep = @"0";
            [tempMutableArr addObject:baseObj];
        }
        [reslutArray addObject:tempMutableArr];
        return reslutArray;
    }
    
    sleepDate_deviceid_Model *lastObj = [allSleepDetailArr lastObject];
    int k = 0;
    for (int i = 0;;i++) {
        
        NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO] byIndex:-i withType:@"yyyy-MM-dd"];
        sleepDate_deviceid_Model *obj = [SleepDetailManager judgeArrayContain:dateStr withArr:allSleepDetailArr];
        if (obj.date==nil) {
            obj.date = dateStr;
            obj.lightTime = @"0";
            obj.deepTime = @"0";
            obj.wakeTime = @"0";
            obj.totalSleep = @"0";
        }
        
        SleepBaseModel *baseObj = [[SleepBaseModel alloc]initWithSleepDate_deviceid_Model:obj];
        if (reslutArray.count>k) {
            
            NSMutableArray *mutableArr = reslutArray[k];
            if (mutableArr.count>0) {
                [mutableArr addObject:baseObj];
            }
            else
            {
                mutableArr = [NSMutableArray arrayWithObject:baseObj];
            }
            
            [reslutArray replaceObjectAtIndex:k withObject:mutableArr];
            
            if (mutableArr.count%6==0) {
                k++;
            }
            
            
        }
        else
        {
            [reslutArray addObject:[NSMutableArray arrayWithObjects:baseObj, nil]];
        }
        if ([dateStr isEqualToString:lastObj.date]) {
            
            break;
        }
        
    }
    //如果最后一个数组中的model少于7则补全
    NSMutableArray *tempArr = reslutArray[reslutArray.count - 1];
    if (tempArr.count<6) {
        
        SleepBaseModel *lastOBj = tempArr[tempArr.count -1];
        for (int i =0; i<6; i++) {
            SleepBaseModel *obj = [[SleepBaseModel alloc]init];
            obj.light = @"0";
            obj.totalSleep =@"0";
            obj.dreep = @"0";
            obj.weak =@"0";
            obj.sleepArr = [NSArray arrayWithObjects:obj.dreep,obj.light,obj.weak,nil];
            NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:lastOBj.date byIndex:-i-1 withType:@"yyyy-MM-dd"];
            obj.date = dateStr;
            if (tempArr.count<6) {
                [tempArr addObject:obj];
            }
            else
            {
                break;
            }
            
        }
    }
    
    return reslutArray;
}


+(NSArray *)getWeekSleepDetail:(NSArray *)allSleepArr
{
    NSMutableArray *resultMutableArray = [NSMutableArray array];
    if (allSleepArr.count==0) {
        NSMutableArray *tempMutableArr =[NSMutableArray array];
        for (int i =0 ; i<6; i++) {
            SleepBaseModel *baseObj = [[SleepBaseModel alloc]init];
            baseObj.dreep = @"0";
            baseObj.light = @"0";
            baseObj.weak = @"0";
            baseObj.totalSleep = @"0";
            baseObj.sleepArr = @[@"0",@"0",@"0"];
            
            NSString *lastWeekDate = ((SleepBaseModel*)[tempMutableArr lastObject]).date;
            NSString *todayStr = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO];
            if (lastWeekDate) {
                NSString *year = [lastWeekDate componentsSeparatedByString:@"/"][0];
                NSString *month = [lastWeekDate componentsSeparatedByString:@"/"][1];
                NSString *day = [([lastWeekDate componentsSeparatedByString:@"/"][2]) componentsSeparatedByString:@"-"][0];
                NSString *lastDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                todayStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:lastDate byIndex:-7 withType:@"yyyy-MM-dd"];
            }
            
            NSString *endWeek = [[[DateHandle getArrayByTheDate:todayStr index:0] firstObject] lastObject];
            
            NSString *beginWeek = [[[DateHandle getArrayByTheDate:todayStr index:0] lastObject] lastObject];
            NSString *beginMonth = [beginWeek componentsSeparatedByString:@"-"][1];
            if ([beginMonth integerValue]<10) {
                beginMonth = [beginMonth substringFromIndex:1];
            }
            NSString *beginDay = [beginWeek componentsSeparatedByString:@"-"][2];
            if ([beginDay integerValue]<10) {
                beginDay = [beginDay substringFromIndex:1];
            }
            NSString *day2 = [endWeek componentsSeparatedByString:@"-"][2];
            if ([day2 integerValue]<10) {
                
                day2 = [day2 substringFromIndex:1];
            }
            NSString *beginYear = [beginWeek componentsSeparatedByString:@"-"][0];
            NSString *NewBeginWeek = [NSString stringWithFormat:@"%@/%@/%@",beginYear,beginMonth,beginDay];
            baseObj.date = [NSString stringWithFormat:@"%@-%@",NewBeginWeek,day2];
            // NSLog(@"%@",baseObj.date);
            [tempMutableArr addObject:baseObj];
        }
        [resultMutableArray addObject:tempMutableArr];
        return resultMutableArray;
        
    }
    sleepDate_deviceid_Model *lastObj = [allSleepArr lastObject];
    int k = 0;
    for (int i = 0;; i++) {
        
        NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO] byIndex:-i withType:@"yyyy-MM-dd"];
        sleepDate_deviceid_Model *obj = [self judgeArrayContain:dateStr withArr:allSleepArr];
        if (obj.date==nil) {
            obj.date = dateStr;
            obj.deepTime = @"0";
            obj.lightTime = @"0";
            obj.wakeTime = @"0";
            obj.totalSleep = @"0";
        }
        NSString *weekendStr = [DateHandle getWeekFromDate:obj.date withType:@"yyyy-MM-dd"];
   
        if (resultMutableArray.count>k) {
            
            NSMutableArray *mutableArr = resultMutableArray[k];
            if (mutableArr.count>0) {
                [mutableArr addObject:obj];
            }
            else
            {
                mutableArr = [NSMutableArray arrayWithObject:obj];
            }
            
            [resultMutableArray replaceObjectAtIndex:k withObject:mutableArr];
            
            if ([weekendStr isEqualToString:@"周日"]) {
                k++;
            }
        }
        else
        {
            [resultMutableArray addObject:[NSMutableArray arrayWithObjects:obj, nil]];
        }
        
        if ([lastObj.date isEqualToString:dateStr]) {
            break;
        }
        
    }
    
    //NSLog(@"----%@--weekSleeps--",weekObj.weekSleeps);
    
    
    //由于原来的数组中的每个值是6个最基础的值,下面是把每个基础的变成深睡时间总和，浅睡总和，清醒总和
    NSMutableArray *resultArr = [NSMutableArray array];
    int m = 0;
    for (int i =0; i<resultMutableArray.count; i++) {
        NSArray *tempArr = resultMutableArray[i];
        SleepBaseModel *baseObj = [[SleepBaseModel alloc]init];
        NSInteger tempDeep = 0;
        NSInteger tempLight = 0;
        NSInteger tempWake = 0;
        for (sleepDate_deviceid_Model *tempObj in tempArr) {
            tempDeep +=[tempObj.deepTime integerValue];
            tempLight +=[tempObj.lightTime integerValue];
            tempWake +=[tempObj.wakeTime integerValue];
        }
        sleepDate_deviceid_Model *sleep_device_obj = tempArr[0];
        baseObj.dreep = [NSString stringWithFormat:@"%ld",tempDeep];
        baseObj.light = [NSString stringWithFormat:@"%ld",tempLight];
        baseObj.weak = [NSString stringWithFormat:@"%ld",tempWake];
        baseObj.sleepArr = @[baseObj.dreep,baseObj.light,baseObj.weak];
        
        // 格式化一周的日期
        baseObj.date =[self FromatStringDate:sleep_device_obj.date];
        if (resultArr.count>m) {
            NSMutableArray *tempMutableArr = [resultArr objectAtIndex:m];
            if (tempMutableArr.count>0) {
                [tempMutableArr addObject:baseObj];
            }
            else
            {
                tempMutableArr = [NSMutableArray arrayWithObject:baseObj];
            }
            
            [resultArr replaceObjectAtIndex:m withObject:tempMutableArr];
            if (tempMutableArr.count%6==0) {
                m++;
            }
            
        }
        else
        {
            [resultArr addObject:[NSMutableArray arrayWithObject:baseObj]];
        }
        
    }
    
    
    //把最后一个数组填充成6个
    NSMutableArray *tempArr = resultArr[resultArr.count - 1];
    if (tempArr.count<6) {
        
        SleepBaseModel *lastOBj = tempArr[tempArr.count -1];
        for (int i =0; i<6; i++) {
            SleepBaseModel *obj = [[SleepBaseModel alloc]init];
            obj.light = @"0";
            obj.totalSleep =@"0";
            obj.dreep = @"0";
            obj.weak =@"0";
            obj.sleepArr = [NSArray arrayWithObjects:obj.dreep,obj.light,obj.weak,nil];
            
            NSString *year = [lastOBj.date componentsSeparatedByString:@"/"][0];
            NSString *month = [lastOBj.date componentsSeparatedByString:@"/"][1];
            NSString *day = [([lastOBj.date componentsSeparatedByString:@"/"][2]) componentsSeparatedByString:@"-"][0];
            NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:[NSString stringWithFormat:@"%@-%@-%@",year,month,day] byIndex:-i*7-7 withType:@"yyyy-MM-dd"];
            obj.date = [self FromatStringDate:dateStr];
            if (tempArr.count<6) {
                [tempArr addObject:obj];
            }
            else
            {
                break;
            }
            
        }
    }
    
    [resultMutableArray removeAllObjects];
    resultMutableArray = [NSMutableArray arrayWithArray:resultArr];
    //NSLog(@"---%@---",weekObj.weekSleeps);
    return resultMutableArray;
}


//月数据
+(NSArray *)getMonthSleepDetail:(NSArray *)allSleepArr
{
    NSMutableArray *reslutMonthArray = [NSMutableArray array];
    //如果没有则插入默认的全零的数据
    if([sleepDate_deviceidManage count]==0)
    {
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (int i = 0; i< 6; i++) {
            
            SleepBaseModel *sleepBaseObj = [[SleepBaseModel alloc]init];
            sleepBaseObj.dreep = @"0";
            sleepBaseObj.light = @"0";
            sleepBaseObj.weak = @"0";
            sleepBaseObj.totalSleep = @"0";
            sleepBaseObj.sleepArr = @[@"0",@"0",@"0"];
            SleepBaseModel *baseModel = [mutableArr lastObject];
            if (baseModel.date==nil) {
                
                baseModel.date = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO];
            }
            
            NSString *firstStr = [[DateHandle getArrayByTheDate:baseModel.date index:1] firstObject];
            
            if (i!=0) {
                NSDate *date = [DateHandle getPriousorLaterDateFromDate:[DateHandle stringToDate:firstStr withtype:2] withMonth:-1];
                NSString *dateStr = [DateHandle dateToString:date withType:4];
                sleepBaseObj.date = dateStr;
            }
            
            if (mutableArr.count<6) {
                [mutableArr addObject:sleepBaseObj];
            }
            else
            {
                break;
            }
        }
        [reslutMonthArray addObject:mutableArr];
        return reslutMonthArray;
        
    }
    
    //从数据库中读取所有数据
   // NSArray *sqlAllInfo = [sleepDate_deviceidManage getAllSleepInfoByuserId:[Singleton getUserID]];
    sleepDate_deviceid_Model *lastObj = [allSleepArr lastObject];
    int k = 0;
    NSMutableArray *monthArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0;;i++) {
        NSString *dateStr = [DateHandle getTomorrowAndYesterDayByCurrentDate:[DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:NO] byIndex:-i withType:@"yyyy-MM-dd"];
        sleepDate_deviceid_Model *sleepDate_deviceid_obj = [self judgeArrayContain:dateStr withArr:allSleepArr];
        NSString *year = [dateStr componentsSeparatedByString:@"-"][0];
        NSString *month = [dateStr componentsSeparatedByString:@"-"][1];
        NSString *date = [NSString stringWithFormat:@"%@-%@-01",year,month];
        
        if (sleepDate_deviceid_obj.date==nil) {
            sleepDate_deviceid_obj.deepTime = @"0";
            sleepDate_deviceid_obj.lightTime = @"0";
            sleepDate_deviceid_obj.wakeTime = @"0";
            sleepDate_deviceid_obj.totalSleep = @"0";
            sleepDate_deviceid_obj.date = dateStr;
        }
        
        if (monthArr.count>k) {
            
            NSMutableArray *tempArray = monthArr[k];
            sleepDate_deviceid_Model *tempObj = [tempArray lastObject];
            NSString *year = [tempObj.date componentsSeparatedByString:@"-"][0];
            NSString *month = [tempObj.date componentsSeparatedByString:@"-"][1];
            NSString *tempDate = [NSString stringWithFormat:@"%@-%@-01",year,month];
            
            [monthArr replaceObjectAtIndex:k withObject:tempArray];
            
            // NSLog(@"%@======%@",tempObj,sleepDate_deviceid_obj.date);
            if (![tempDate isEqualToString:date]) {
                k++;
                //为了让另一个月的最后一天的数据进入另一个数组中才作此判断
                if (reslutMonthArray.count>k) {
                    tempArray = reslutMonthArray[k];
                }
                else
                {
                    [monthArr addObject:[NSMutableArray arrayWithObject:sleepDate_deviceid_obj]];
                }
                continue;
                
            }
            if (tempArray.count>0) {
                
                [tempArray addObject:sleepDate_deviceid_obj];
            }
            else
            {
                tempArray = [NSMutableArray arrayWithObject:sleepDate_deviceid_obj];
            }
            
        }
        else
        {
            [monthArr addObject:[NSMutableArray arrayWithObject:sleepDate_deviceid_obj]];
        }
        
        if ([lastObj.date isEqualToString:sleepDate_deviceid_obj.date]) {
            break;
        }
    }
    
    
    
    
    NSMutableArray *reslutArray = [NSMutableArray array];
    int n = 0;
    //合并同一个月的数据
    for (int i = 0; i<monthArr.count; i++) {
        
        SleepBaseModel *baseObj = [[SleepBaseModel alloc]init];
        NSMutableArray *mutableArr = monthArr[i];
        NSInteger tempDeep = 0;
        NSInteger tempLight = 0;
        NSInteger tempWake = 0;
        NSInteger total = 0;
        for (sleepDate_deviceid_Model *obj in mutableArr) {
            tempDeep +=[obj.deepTime integerValue];
            tempLight +=[obj.lightTime integerValue];
            tempWake += [obj.wakeTime integerValue];
            total += [obj.totalSleep integerValue];
        }
        baseObj.dreep = [NSString stringWithFormat:@"%ld",tempDeep];
        baseObj.light = [NSString stringWithFormat:@"%ld",tempLight];
        baseObj.weak = [NSString stringWithFormat:@"%ld",tempWake];
        baseObj.sleepArr = @[baseObj.dreep,baseObj.light,baseObj.weak];
        baseObj.totalSleep = [NSString stringWithFormat:@"%ld",total];
        sleepDate_deviceid_Model *dateObj = mutableArr[0];
        NSString *yearStr = [dateObj.date componentsSeparatedByString:@"-"][0];
        NSString *monthStr = [dateObj.date componentsSeparatedByString:@"-"][1];
        baseObj.date = [NSString stringWithFormat:@"%@-%@-01",yearStr,monthStr];
        // NSLog(@"==========%@",baseObj);
        if (reslutArray.count>n) {
            
            NSMutableArray *tempMutable = reslutArray[n];
            if (tempMutable.count>0) {
                [tempMutable addObject:baseObj];
            }
            else
            {
                tempMutable = [NSMutableArray arrayWithObject:baseObj];
            }
            [reslutArray replaceObjectAtIndex:n withObject:tempMutable];
            if (tempMutable.count%6==0) {
                n++;
            }
            
        }
        else
        {
            [reslutArray addObject:[NSMutableArray arrayWithObject:baseObj]];
        }
        
        
    }
    
    //NSLog(@"#####---reslutArray------>>>>%@",reslutArray);
    
    // 不够7个的补足7个
    NSMutableArray *tempArr = reslutArray[reslutArray.count - 1];
    if (tempArr.count<6) {
        
        for (int i =0; i<6; i++) {
            SleepBaseModel *sleepBaseObj = [[SleepBaseModel alloc]init];
            sleepBaseObj.dreep = @"0";
            sleepBaseObj.light = @"0";
            sleepBaseObj.weak = @"0";
            sleepBaseObj.totalSleep = @"0";
            sleepBaseObj.sleepArr = @[@"0",@"0",@"0"];
            SleepBaseModel *baseModel = [tempArr lastObject];
            NSString *firstStr = [[DateHandle getArrayByTheDate:baseModel.date index:1] firstObject];
            
            NSDate *date = [DateHandle getPriousorLaterDateFromDate:[DateHandle stringToDate:firstStr withtype:2] withMonth:-1];
            NSString *dateStr = [DateHandle dateToString:date withType:4];
            sleepBaseObj.date = dateStr;
            if (tempArr.count<6) {
                [tempArr addObject:sleepBaseObj];
            }
            else
            {
                break;
            }
        }
        
    }
    [reslutArray replaceObjectAtIndex:reslutArray.count-1 withObject:tempArr];
   // NSLog(@"########------->>>>>>%@",reslutArray);
    
    [reslutMonthArray addObjectsFromArray:reslutArray];
    
    
    return reslutMonthArray;

}


//查看从数据库中取出来的中的数据是否有当前日期的
+(sleepDate_deviceid_Model *)judgeArrayContain:(NSString *)dateStr withArr:(NSArray *)arr
{

    for (sleepDate_deviceid_Model *obj in arr) {
        if ([obj.date isEqualToString:dateStr]) {
            return obj;
        }
    }
    return [sleepDate_deviceid_Model new];
}


//格式化一周的日期
+(NSString *)FromatStringDate:(NSString *)dateStr
{
    NSArray *dateArr = [DateHandle getArrayByTheDate:dateStr index:0];
    NSArray *mondayArr = [dateArr firstObject];
    NSArray *sundayArr = [dateArr lastObject];
    NSString *monDayStr = mondayArr[2];
    NSString *sundayStr = sundayArr[2];
    NSString *yearStr = [monDayStr componentsSeparatedByString:@"-"][0];
    NSString *tempStr1 = [monDayStr componentsSeparatedByString:@"-"][1];
    NSString *tempStr2 = [monDayStr componentsSeparatedByString:@"-"][2];
    NSString *tempStr3 = [sundayStr componentsSeparatedByString:@"-"][2];
    if ([tempStr1 integerValue]<10) {
        tempStr1 = [tempStr1 substringFromIndex:1];
    }
    if ([tempStr2 integerValue]<10) {
        tempStr2 = [tempStr2 substringFromIndex:1];
    }
    if ([tempStr3 integerValue]<10) {
        tempStr3 = [tempStr3 substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@/%@/%@-%@",yearStr,tempStr1,tempStr2,tempStr3];
}

@end
