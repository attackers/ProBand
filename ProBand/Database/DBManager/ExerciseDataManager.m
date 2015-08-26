//
//  ExerciseDataManager.m
//  ProBand
//
//  Created by star.zxc on 15/7/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ExerciseDataManager.h"

@implementation ExerciseDataManager
SINGLETON_SYNTHE

- (id)init
{
    self= [super init];
    if (self) {
    }
    return self;
}
//将所有原始表中的数据汇总:一有数据过来马上更新汇总表，添加新的字段
+ (void)collectAllExerciseData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_exerciseData where isRead = 0 ORDER BY time"];
    NSArray *exerciseArray = [DBOPERATOR getDataForSQL:sql];
    if (exerciseArray.count > 0) {
        [self bleDataToTotalExerciseData:exerciseArray];
    }
    //需要将汇总过的数据isRead属性标记为1
    NSString *sqlExist = [NSString stringWithFormat:@"SELECT * FROM t_exerciseData where isRead = 0"];
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_exerciseData SET isRead = '%@'",@"1"];
    NSError *error =  [DBOPERATOR updateTheDataToDbWithExsitSql:sqlExist withSql:updateSql];
    if (error) {
        NSLog(@"更新日常标志位错误：%@",error);
    }
    else
    {
        NSLog(@"更新日常标志位成功");
    }
}

//将原始表的数据转化到汇总表中去：需要判断数据是否被读取过,而且要保证时间是按顺序的
//如果当天的数据已经存在则需要更新
+ (void)bleDataToTotalExerciseData:(NSArray *)exerciseArray
{
    NSDictionary *firstDic = [exerciseArray firstObject];
    NSDictionary *endDic = [exerciseArray lastObject];
    NSString *valideStart = [firstDic objectForKey:@"time"];
    NSString *valideEnd = [endDic objectForKey: @"time"];
    //计算开始时间和结束时间之间的天数，然后对中间每一天重新从数据库取值
    int startTime = [valideStart intValue];
    int endTime = [valideEnd intValue];//正确
    NSDate *startDay = [DateHandle getDateFromTimeStamp:startTime];
    NSDate *endDay = [DateHandle getDateFromTimeStamp:endTime];
    int intervalDay = [DateHandle calcDaysFromBegin:startDay end:endDay]+1;;//开始和结束时间相差天数
    int startDayTime = [DateHandle getStartTimeForDate:startDay];
    for (int count = 0; count < intervalDay; count ++)
    {
        //对当天的数据重新从数据库取值:如果减去8个小时还是正确的日期吗,还是解析时再换成正确的时间
        int sUTC = startDayTime+count*3600*24;//-8*3600
        int eUTC = startDayTime+(count+1)*3600*24;//-8*3600
        NSString *sUTCStr = [NSString stringWithFormat:@"%d",sUTC];
        NSString *eUTCStr = [NSString stringWithFormat:@"%d",eUTC];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_exerciseData where time >= '%@' and time < '%@' ORDER BY time",sUTCStr,eUTCStr];
        NSArray *singleDayArr = [DBOPERATOR getDataForSQL:sql];
        if (singleDayArr.count > 0)
        {
        //构造当天数据的汇总数据然后插入到汇总表中
        NSDictionary *todaySDic = [singleDayArr firstObject];
        NSDictionary *todayEDic = [singleDayArr lastObject];
        NSString *todayStartTime = [todaySDic objectForKey:@"time"];
        NSString *todatEndTime = [todayEDic objectForKey:@"time"];
        int sTime = [todayStartTime intValue];
        int eTime = [todatEndTime intValue];
        //时间戳转化为日期
        NSDate *startDate = [DateHandle getDateFromTimeStamp:sTime];
        NSDate *endDate = [DateHandle getDateFromTimeStamp:eTime];
        NSString *date = [DateHandle dateStringFromTimeStamp:sTime];//汇总数据的日期
        NSString *start_time = [NSString stringWithFormat:@"%d小时%d分钟",[DateHandle getTimeFromDate:startDate withType:3],[DateHandle getTimeFromDate:startDate withType:4]];
        NSString *end_time = [NSString stringWithFormat:@"%d小时%d分钟",[DateHandle getTimeFromDate:endDate withType:3],[DateHandle getTimeFromDate:endDate withType:4]];
        //构造当天所有从开始到结束时间的数据
        NSMutableString *exercises = [NSMutableString string];
        NSMutableString *steps = [NSMutableString string];
        NSMutableString *meters = [NSMutableString string];
        NSMutableString *kCalories = [NSMutableString string];
        int todayDataCount = (eTime-sTime)/60+1;//3分钟一条数据
        //查看是否有该条数据
        for (int k = 0; k < todayDataCount; k ++)
        {
            NSString *kTime = [NSString stringWithFormat:@"%d",sTime+k*60];
            int exercise = 0;
            int step = 0;
            int meter = 0;
            float kCalory = 0;
            for (NSDictionary *singleDic in singleDayArr)
            {
                NSString *nowTime = [singleDic objectForKey:@"time"];
                if ([nowTime isEqualToString:kTime])
                {
                    NSString *aexercise = [singleDic objectForKey:@"exercise"];
                    exercise = [aexercise intValue];
                    NSString *astep = [singleDic objectForKey:@"steps"];
                    step = [astep intValue];
                    NSString *ameter = [singleDic objectForKey:@"meters"];
                    meter = [ameter intValue];
                    NSString *akCalory = [singleDic objectForKey:@"kCalories"];
                    kCalory = [akCalory floatValue];
                }
            }
            [exercises appendFormat:@"%d,",exercise];
            [steps appendFormat:@"%d,",step];
            [meters appendFormat:@"%d,",meter];
            [kCalories appendFormat:@"%f,",kCalory];
        }
        //最后移除一个逗号
        [exercises deleteCharactersInRange:NSMakeRange(exercises.length-1, 1)];
        [steps deleteCharactersInRange:NSMakeRange(steps.length-1, 1)];
        [meters deleteCharactersInRange:NSMakeRange(meters.length-1, 1)];
        [kCalories deleteCharactersInRange:NSMakeRange(kCalories.length-1, 1)];
        
        int totalWalkMeter = 0;
        int totalWalkTime = 0;
        float totalWalkCalory = 0.0;
        int totalStep = 0;
        int totalMeter = 0;
        float totalKcalory = 0.0;
        for (NSDictionary *singleDic in singleDayArr)
        {
            NSString *stepState = [singleDic objectForKey:@"steps"];
            NSString *meterState = [singleDic objectForKey:@"meters"];
            NSString *kCaloriyState = [singleDic objectForKey:@"kCalories"];
            totalStep+= [stepState intValue];
            totalMeter+= [meterState intValue];
            totalKcalory+= [kCaloriyState floatValue];
            NSString *exerciseState = [singleDic objectForKey:@"exercise"];
            if ([exerciseState intValue]==2)//2代表步行
            {
                totalWalkMeter+= [meterState intValue];
                totalWalkTime+= 3;
                totalWalkCalory+= [kCaloriyState floatValue];
            }
        }
        NSString *total_walk_meter = [NSString stringWithFormat:@"%d",totalWalkMeter];
        NSString *total_walk_time = [NSString stringWithFormat:@"%d",totalWalkTime];
        NSString *total_walk_kCalory = [NSString stringWithFormat:@"%.1f",totalWalkCalory];
        NSString *total_step = [NSString stringWithFormat:@"%d",totalStep];
        NSString *total_meter = [NSString stringWithFormat:@"%d",totalMeter];
        NSString *total_kCalory = [NSString stringWithFormat:@"%.1f",totalKcalory];
        NSString *isUpload = [NSString stringWithFormat:@"%d",0];
        //汇总数据:如果该条数据已经存在则需要更新
        NSDictionary *totalDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"date":date,@"start_time":start_time,@"end_time":end_time,@"exercises":exercises,@"steps":steps,@"meters":meters,@"kCalories":kCalories,@"total_walk_meter":total_walk_meter,@"total_walk_time":total_walk_time,@"total_walk_kCalory":total_walk_kCalory,@"total_step":total_step,@"total_meter":total_meter,@"total_kCalory":total_kCalory,@"isUpload":isUpload};
        //                NSString *existString = [NSString stringWithFormat:@"select * from t_total_sleepData where date = '%@'",date];//存在语句
        //                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_total_sleepData(mac,date,start_time,end_time,sleeps,total_awake_sleep,total_light_sleep,total_deep_sleep,isUpload)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getDefaultMacSite],date,start_time,end_time,sleeps,total_awake_sleep,total_light_sleep,total_deep_sleep,isUpload];
        //如果有新增加的数据直接调用该方法即可
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_total_exerciseData SET userid = '%@',mac = '%@',start_time = '%@',end_time = '%@',exercises = '%@',steps = '%@',meters = '%@',kCalories = '%@',total_walk_meter = '%@',total_walk_time = '%@',total_walk_kCalory = '%@',total_step = '%@',total_meter = '%@',total_kCalory = '%@',isUpload = '%@' where date = '%@'",[Singleton getUserID],[Singleton getMacSite],start_time,end_time,exercises,steps,meters,kCalories,total_walk_meter,total_walk_time,total_walk_kCalory,total_step,total_meter,total_kCalory,isUpload,date];
        //判断该数据是否已经存在
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_exerciseData where date = '%@'",date];
        NSArray *totalExistArr = [DBOPERATOR getDataForSQL:selectSql];
        if (totalExistArr.count > 0)//如果该数据已存在,则更新该数据
        {
            NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:selectSql withSql:updateSql];
            if (error) {
                NSLog(@"锻炼表更新失败:%@",error);
            }
            else
            {
                NSLog(@"汇总锻炼表更新成功");
            }
        }
        else//不存在则插入该数据
        {
            [[FMDBManage shareFMDBManage]insertDataFromTable:ExerciseTotalTable insertValueDic:totalDic];
        }
        }
    }
}

//date格式为2015-07-13:就算没有数据仍然要保证model存在,保证
- (ExerciseDayModel *)exerciseDayModelForDate:(NSString *)date
{
    //构建一个新的model
    ExerciseDayModel *model = [[ExerciseDayModel alloc]init];
    //从汇总表中取出数据
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_exerciseData where date = '%@'",date];
    NSArray *dataArray = [DBOPERATOR getDataForSQL:selectSql];
    //构建480个点的valueArray
    NSMutableArray *valueArray = [NSMutableArray array];
    if (dataArray.count > 0)
    {
        NSDictionary *totalDic = [dataArray objectAtIndex:0];//只有一条数据
        NSString *startTime = [totalDic objectForKey:@"start_time"];
        //NSString *endTime = [totalDic objectForKey:@"end_time"];
        NSString *sleeps = [totalDic objectForKey:@"steps"];
        //转换为数值
        int startHour = [XlabTools timeFromDateString:startTime withType:0];
        int startMinute = [XlabTools timeFromDateString:startTime withType:1];
        //    int endHour = [XlabTools timeFromDateString:endTime withType:0];
        //    int endMinute = [XlabTools timeFromDateString:endTime withType:1];

        int startCount = startHour*60 + startMinute;//开始有多少个时间段是空白的
        for (int i = 0; i < startCount; i ++)
        {
            [valueArray addObject:@0];
        }
        NSArray *stepArray = [sleeps componentsSeparatedByString:@","];
        for (NSString *step in stepArray) {
            int stepValue = [step intValue];
            [valueArray addObject:[NSNumber numberWithInt:stepValue]];
        }
        int restValue = 1440-startCount-(int)stepArray.count;
        for (int j = 0; j < restValue; j ++)
        {
            [valueArray addObject:@0];
        }
    }
    else
    {
        for (int i = 0; i < 1440; i ++)
        {
            [valueArray addObject:@0];
        }
    }
    model.date = date;
    model.valueArray = [NSMutableArray arrayWithArray:valueArray];
    return model;
}

//date格式为2015-07-13,必须为周一的日期
- (ExerciseWeekModel *)exerciseWeekModelForDate:(NSString *)date
{
    ExerciseWeekModel *weekModel = [[ExerciseWeekModel alloc]init];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];
    int totalMiles = 0;//最终单位为千米
    int totalSteps = 0;
    float totalCalory = 0.0;
    int totalWalkMiles = 0;
    int totalWalkTime = 0;//行走时长：分钟
    float totalWalkCalory = 0.0;
    //先把字符串转日期，取得字符串后转回
    for (int i = 0; i < 7; i ++)
    {
        NSString *newDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:i withType:@"yyyy-MM-dd"];
        //分别获取7条数据：如果数据不全怎么办？异常处理
        
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_exerciseData where date = '%@'",newDate];
        NSArray *dataArray = [DBOPERATOR getDataForSQL:sql];
        //只保留月份和日期
        NSString *monString = [newDate substringFromIndex:5];
        [dateArray addObject:monString];
        if (dataArray && dataArray.count > 0)
        {
            NSDictionary *totalDic = dataArray[0];
            [valueArray addObject:[totalDic objectForKey:@"total_step"]];
            
            //添加新元素的值
            NSString *meter = [totalDic objectForKey:@"total_meter"];
            NSString *step = [totalDic objectForKey:@"total_step"];
            NSString *calory = [totalDic objectForKey:@"total_kCalory"];
            NSString *walkMeter = [totalDic objectForKey:@"total_walk_meter"];
            NSString *walkTime = [totalDic objectForKey:@"total_walk_time"];
            NSString *walkCalory = [totalDic objectForKey:@"total_walk_kCalory"];
            totalMiles+= [meter intValue];
            totalSteps+= [step intValue];
            totalCalory+= [calory floatValue];
            totalWalkMiles+= [walkMeter intValue];
            totalWalkTime+= [walkTime intValue];
            totalWalkCalory+= [walkCalory floatValue];
        }
        else
        {
            [valueArray addObject:@0];
        }
    }
    //换算为字符串
    NSString *avMile = [NSString stringWithFormat:@"%.1f",(totalMiles/7)/1000.0];
    NSString *avStep = [NSString stringWithFormat:@"%d",totalSteps/7];
    NSString *avCalory = [NSString stringWithFormat:@"%.1f",totalCalory/7];
    NSString *avWalkMile = [NSString stringWithFormat:@"%.1f",(totalWalkMiles/7)/1000.0];
    NSString *avWalkTime = [NSString stringWithFormat:@"%d",totalWalkTime/7];
    NSString *avWalkCalory = [NSString stringWithFormat:@"%.1f",totalWalkCalory/7];
    weekModel.dateArray = [NSArray arrayWithArray:dateArray];
    weekModel.valueArray = [NSArray arrayWithArray:valueArray];
    weekModel.upDescribeArray = @[LocalString(@"day_average_mile"),LocalString(@"day_average_step"),LocalString(@"day_average_calory")];
    weekModel.downDescribeArray = @[LocalString(@"day_average_walk_mile"),LocalString(@"day_average_walk_time"),LocalString(@"day_average_walk_calory")];
    weekModel.upValueArray = @[avMile,avStep,avCalory];
    weekModel.downValueArray = @[avWalkMile,avWalkTime,avWalkCalory];
    return weekModel;
}

//date必须为某个连续4个星期的初始日期:最后可以推到当前这个日期,该方法是否有效需要验证？
- (ExerciseMonthModel *)exerciseMonthModelForDate:(NSString *)date
{
    ExerciseMonthModel *monthModel = [[ExerciseMonthModel alloc] init];
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    int totalMiles = 0;//最终单位为千米
    int totalSteps = 0;
    float totalCalory = 0.0;
    int totalWalkMiles = 0;
    int totalWalkTime = 0;//行走时长：分钟
    float totalWalkCalory = 0.0;
    for (int i = 0; i < 4; i ++)
    {
        //计算每个星期的开始日期和最后一个日期
        NSString *firstDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i withType:@"yyyy-MM-dd"];
        NSString *lastDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i+6 withType:@"yyyy-MM-dd"];
        //构建日期的字符串：类似3/23-3/29
        NSMutableString *dateString = [NSMutableString string];
        [dateString appendFormat:@"%@/%@-%@/%@",[firstDate substringWithRange:NSMakeRange(5, 2)],[firstDate substringWithRange:NSMakeRange(8, 2)],[lastDate substringWithRange:NSMakeRange(5, 2)],[firstDate substringWithRange:NSMakeRange(8, 2)]];
        [dateArray addObject:dateString];
        int stepSum = 0;
        //获取一个星期内所有的数据汇总
        for (int j = 0; j < 7; j ++)
        {
            NSString *singleDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:firstDate byIndex:i withType:@"yyyy-MM-dd"];
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_exerciseData where date = '%@'",singleDate];
            NSArray *data = [DBOPERATOR getDataForSQL:sql];
            if (data && data.count > 0) {
                NSDictionary *exerciseDic = data[0];
                NSNumber *number = [exerciseDic objectForKey:@"total_step"];
                stepSum+= [number intValue];
                
                //添加新元素的值
                NSString *meter = [exerciseDic objectForKey:@"total_meter"];
                NSString *step = [exerciseDic objectForKey:@"total_step"];
                NSString *calory = [exerciseDic objectForKey:@"total_kCalory"];
                NSString *walkMeter = [exerciseDic objectForKey:@"total_walk_meter"];
                NSString *walkTime = [exerciseDic objectForKey:@"total_walk_time"];
                NSString *walkCalory = [exerciseDic objectForKey:@"total_walk_kCalory"];
                totalMiles+= [meter intValue];
                totalSteps+= [step intValue];
                totalCalory+= [calory floatValue];
                totalWalkMiles+= [walkMeter intValue];
                totalWalkTime+= [walkTime intValue];
                totalWalkCalory+= [walkCalory floatValue];
            }
        }
        [valueArray addObject:[NSNumber numberWithInt:stepSum]];
        //换算为字符串
        NSString *avMile = [NSString stringWithFormat:@"%.1f",(totalMiles/28)/1000.0];
        NSString *avStep = [NSString stringWithFormat:@"%d",totalSteps/28];
        NSString *avCalory = [NSString stringWithFormat:@"%.1f",totalCalory/28];
        NSString *avWalkMile = [NSString stringWithFormat:@"%.1f",(totalWalkMiles/28)/1000.0];
        NSString *avWalkTime = [NSString stringWithFormat:@"%d",totalWalkTime/28];
        NSString *avWalkCalory = [NSString stringWithFormat:@"%.1f",totalWalkCalory/28];
        monthModel.dateArray = [NSArray arrayWithArray:dateArray];
        monthModel.valueArray = [NSArray arrayWithArray:valueArray];
        monthModel.upDescribeArray = @[LocalString(@"day_average_mile"),LocalString(@"day_average_step"),LocalString(@"day_average_calory")];
        monthModel.downDescribeArray = @[LocalString(@"day_average_walk_mile"),LocalString(@"day_average_walk_time"),LocalString(@"day_average_walk_calory")];
        monthModel.upValueArray = @[avMile,avStep,avCalory];
        monthModel.downValueArray = @[avWalkMile,avWalkTime,avWalkCalory];
    }
    return monthModel;
}
//3表示静止，根据该数据进行统计
- (SectionModel *)exerciseSectionModelForDate:(NSString *)date
{
    SectionModel *model = [[SectionModel alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_exerciseData where date = '%@'",date];
    NSArray *data = [DBOPERATOR getDataForSQL:selectSql];
    if (data.count > 0)
    {
        NSDictionary *dic = data[0];
        NSString *exercises = dic[@"exercises"];
        NSString *steps = dic[@"steps"];
        NSArray *exerxiseArray = [exercises componentsSeparatedByString:@","];
        NSArray *stepArray = [steps componentsSeparatedByString:@","];
        int startPoint = 0;
        int endPoint = 0;
        BOOL isStep = NO;
        NSMutableArray *startArray = [NSMutableArray array];//记录各个时间段开始点的数组
        NSMutableArray *endArray = [NSMutableArray array];//记录各个时间段结束点的数组
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < exerxiseArray.count-1; i ++)
        {
            NSString *number = exerxiseArray[i];
            if ([number intValue]<3)
            {
                if (!isStep)
                {
                    startPoint = i;
                    [startArray addObject:[NSNumber numberWithInt:i]];
                    isStep = YES;
                }
            }
            else//否则为睡眠时间:0,连续的情况需要避免,结束时间点需要加上最后一个点
            {
                NSString *str;
                if (i > 1)
                {
                    str= exerxiseArray[i-1];
                }
                else
                {
                    str = @"3";
                }
                //连续两个为3
                if (i > startPoint && [str intValue]<3 && [exerxiseArray[i+1] intValue]>=3)
                {
                    endPoint = i-1;
                    [endArray addObject:[NSNumber numberWithInt:endPoint]];
                    isStep = NO;
                }
            }
        }
        int count = exerxiseArray.count;
        if ([[exerxiseArray lastObject] intValue]<3 || [exerxiseArray[count-2] intValue]<3)
        {
            endPoint = count-1;
            [endArray addObject:[NSNumber numberWithInt:endPoint]];
            isStep = NO;
        }
        if (endArray.count>startArray.count)
        {
            [endArray removeLastObject];
        }
        NSLog(@"开始数组为%d---%@",startArray.count,startArray);
        NSLog(@"结束数组为%d---%@",endArray.count,endArray);
        for (int j = 0; j < endArray.count; j ++)
        {
            int sum = 0;
            for (int k = [startArray[j] intValue]; k < [endArray[j] intValue]; k ++)
            {
                sum+= [stepArray[k] intValue];
            }
            [valueArray addObject:[NSNumber numberWithInt:sum]];
        }
        NSLog(@"数值数组为:%@",valueArray);
        
        model.startArray = [NSArray arrayWithArray:startArray];
        model.endArray = [NSArray arrayWithArray:endArray];
        model.valueArray = [NSArray arrayWithArray:valueArray];
    }
    return model;
}

- (ExerciseSectionModel *)exerciseSectionModelFromDate:(NSString *)date
{
    ExerciseSectionModel *model = [[ExerciseSectionModel alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_exerciseData where date = '%@'",date];
    NSArray *data = [DBOPERATOR getDataForSQL:selectSql];
    if (data.count > 0)
    {
        NSDictionary *dic = data[0];
        NSString *exercises = dic[@"exercises"];
        NSString *steps = dic[@"steps"];
        NSString *meters = dic[@"meters"];
        NSString *calory = dic[@"kCalories"];
        NSArray *exerxiseArray = [exercises componentsSeparatedByString:@","];
        NSArray *stepArray = [steps componentsSeparatedByString:@","];
        NSArray *meterArray = [meters componentsSeparatedByString:@","];
        NSArray *caloryArray = [calory componentsSeparatedByString:@","];
        int startPoint = 0;
        int endPoint = 0;
        BOOL isStep = NO;
        NSMutableArray *startArray = [NSMutableArray array];//记录各个时间段开始点的数组
        NSMutableArray *endArray = [NSMutableArray array];//记录各个时间段结束点的数组
        for (int i = 0; i < exerxiseArray.count-1; i ++)
        {
            NSString *number = exerxiseArray[i];
            if ([number intValue]<3)
            {
                if (!isStep)
                {
                    startPoint = i;
                    [startArray addObject:[NSNumber numberWithInt:i]];
                    isStep = YES;
                }
            }
            else//否则为睡眠时间:0,连续的情况需要避免,结束时间点需要加上最后一个点
            {
                NSString *str;
                if (i > 1)
                {
                    str= exerxiseArray[i-1];
                }
                else
                {
                    str = @"3";
                }
                //连续两个为3
                if (i > startPoint && [str intValue]<3 && [exerxiseArray[i+1] intValue]>=3)
                {
                    endPoint = i-1;
                    [endArray addObject:[NSNumber numberWithInt:endPoint]];
                    isStep = NO;
                }
            }
        }
        int count = exerxiseArray.count;
        if ([[exerxiseArray lastObject] intValue]<3 || [exerxiseArray[count-2] intValue]<3)
        {
            endPoint = count-1;
            [endArray addObject:[NSNumber numberWithInt:endPoint]];
            isStep = NO;
        }
        if (endArray.count>startArray.count)
        {
            [endArray removeLastObject];
        }
        NSLog(@"开始数组为%d---%@",startArray.count,startArray);
        NSLog(@"结束数组为%d---%@",endArray.count,endArray);
        
        //继续构建其他数组
        NSMutableArray *valueArray = [NSMutableArray array];
        NSMutableArray *mileArray = [NSMutableArray array];
        NSMutableArray *caloryArr = [NSMutableArray array];
        NSMutableArray *avSpeedArray = [NSMutableArray array];
        NSMutableArray *timeArray = [NSMutableArray array];
        for (int j = 0; j < endArray.count; j ++)
        {
            int sum = 0;
            int mileSum = 0;
            float calorySum = 0.0;
            int startInt = [startArray[j] intValue]*3;//分钟
            int endInt = [endArray[j] intValue]*3;

            float hour = ([endArray[j] intValue]-[startArray[j] intValue]+1)*3/60.0;
            for (int k = [startArray[j] intValue]; k < [endArray[j] intValue]; k ++)
            {
                sum+= [stepArray[k] intValue];
                mileSum+= [meterArray[k] intValue];
                calorySum+= [caloryArray[k] floatValue];
            }
            [valueArray addObject:[NSNumber numberWithInt:sum]];
            [mileArray addObject:[NSNumber numberWithFloat:mileSum/1000.0]];
            [caloryArr addObject:[NSNumber numberWithFloat:calorySum]];
            float avSpeed = mileSum/(1000.0*hour);
            [avSpeedArray addObject:[NSNumber numberWithFloat:avSpeed]];
            //时间的字符串
            NSString *timeStr = [NSString stringWithFormat:@"%.2d:%.2d-%.2d:%.2d",startInt/60,startInt%60,endInt/60,endInt%60];
            [timeArray addObject:timeStr];
        }
        NSLog(@"数值数组为:%@",valueArray);
        
        model.startArray = [NSArray arrayWithArray:startArray];
        model.endArray = [NSArray arrayWithArray:endArray];
        model.valueArray = [NSArray arrayWithArray:valueArray];
        model.mileArray = [NSArray arrayWithArray:mileArray];
        model.caloryArray = [NSArray arrayWithArray:caloryArray];
        model.speedArray = [NSArray arrayWithArray:avSpeedArray];
        model.timeArray = [NSArray arrayWithArray:timeArray];
    }
    return model;
}

/**************************添加by Star**************************************/
+ (void)insertStepData:(t_exerciseData *)stepModel
{
    NSDictionary *dic = [t_exerciseData dictionaryFromModel:stepModel];
    NSArray *array = [NSArray arrayWithObject:dic];
    [DBOPERATOR insertDataArrayToDB:@"t_exerciseData" withDataArray:array];
    //立即更新汇总表
    [self collectAllExerciseData];
}
@end
