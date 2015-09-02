//
//  DailyDataManager.m
//  ProBand
//
//  Created by star.zxc on 15/7/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DailyDataManager.h"

@implementation DailyDataManager
SINGLETON_SYNTHE

- (id)init
{
    self= [super init];
    if (self) {
        
    }
    return self;
}
//将所有原始表中的数据汇总:一有数据过来马上更新汇总表
+ (void)collectAllDailyData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_stepData where isRead = 0 ORDER BY time"];
    NSArray *dailyArray = [DBOPERATOR getDataForSQL:sql];
    if (dailyArray.count > 0) {
        [self bleDataToTotalDailyData:dailyArray];
        
        //需要将汇总过的数据isRead属性标记为1
        NSString *sqlExist = [NSString stringWithFormat:@"SELECT * FROM t_stepData where isRead = 0"];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_stepData SET isRead = '%@'",@"1"];
        NSError *error =  [DBOPERATOR updateTheDataToDbWithExsitSql:sqlExist withSql:updateSql];
        if (error) {
            NSLog(@"更新日常标志位错误：%@",error);
        }
        else
        {
            NSLog(@"更新日常标志位成功");
        }
    }

}

//将原始表的数据转化到汇总表中去：需要判断数据是否被读取过,而且要保证时间是按顺序的
//如果当天的数据已经存在则需要更新:一天中多次同步，需要考虑该情况
+ (void)bleDataToTotalDailyData:(NSArray *)dailyArray
{
    NSDictionary *firstDic = [dailyArray firstObject];
    NSDictionary *endDic = [dailyArray lastObject];
    NSString *valideStart = [firstDic objectForKey:@"time"];
    NSString *valideEnd = [endDic objectForKey: @"time"];
    //计算开始时间和结束时间之间的天数，然后对中间每一天重新从数据库取值
    //规划开始时间和最后时间分别属于哪一天:首先修改日常的情况
    long int startTime = [valideStart intValue];
    long int endTime = [valideEnd intValue];
    NSDate *startDay = [DateHandle getDateFromTimeStamp:startTime];
    NSDate *endDay = [DateHandle getDateFromTimeStamp:endTime];
    int intervalDay = [DateHandle calcDaysFromBegin:startDay end:endDay]+1;//开始和结束时间相差天数
    int startDayTime = [DateHandle getStartTimeForDate:startDay];
    for (int count = 0; count < intervalDay; count ++)
    {
        //对当天的数据重新从数据库取值: 需要考虑UTC时间与北京时间的差别,这种每次选择3600*24范围内的数据的做法是错误的
        int sUTC = startDayTime+count*3600*24;//当天开始的时间
        int eUTC = startDayTime+(count+1)*3600*24;//当天结束的时间
        NSString *sUTCStr = [NSString stringWithFormat:@"%d",sUTC];
        NSString *eUTCStr = [NSString stringWithFormat:@"%d",eUTC];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_stepData where time >= '%@' and time < '%@' ORDER BY time",sUTCStr,eUTCStr];
        NSArray *singleDayArr = [DBOPERATOR getDataForSQL:sql];
        if (singleDayArr.count>0)
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
        //转化字符串出现问题了
        NSInteger startHour = [DateHandle getTimeFromDate:startDate withType:3];
        NSInteger startMinute = [DateHandle getTimeFromDate:startDate withType:4];
        NSInteger endHour = [DateHandle getTimeFromDate:endDate withType:3];
        NSInteger endMinute = [DateHandle getTimeFromDate:endDate withType:4];
        NSString *start_time = [NSString stringWithFormat:@"%d小时%d分钟",(int)startHour,(int)startMinute];
        NSString *end_time = [NSString stringWithFormat:@"%d小时%d分钟",(int)endHour,(int)endMinute];
        //构造当天所有从开始到结束时间的数据
        NSMutableString *steps = [NSMutableString string];
        NSMutableString *meters = [NSMutableString string];
        NSMutableString *kCalories = [NSMutableString string];
        int todayDataCount = (eTime-sTime)/60+1;//3分钟一条数据:改为1分钟
        //查看是否有该条数据:暂时修改一下，如果不行就改回来
//        for (int k = 0; k < todayDataCount; k ++)
//        {
//            NSString *kTime = [NSString stringWithFormat:@"%d",sTime+k*60];
//            int step = 0;
//            int meter = 0;
//            float kCalory = 0;
//            for (NSDictionary *singleDic in singleDayArr)
//            {
//                NSString *nowTime = [singleDic objectForKey:@"time"];
//                if ([nowTime isEqualToString:kTime])
//                {
//                    NSString *astep = [singleDic objectForKey:@"steps"];
//                    step = [astep intValue];
//                    NSString *ameter = [singleDic objectForKey:@"meters"];
//                    meter = [ameter intValue];
//                    NSString *akCalory = [singleDic objectForKey:@"kCalories"];
//                    kCalory = [akCalory floatValue];
//                }
//                //该需要构建每天的开始时间和
//            }
//            [steps appendFormat:@"%d,",step];
//            [meters appendFormat:@"%d,",meter];
//            [kCalories appendFormat:@"%f,",kCalory];
//        }
        //1是深睡，2为浅睡，3为清醒
        int totalStep = 0;
        int totalMeter = 0;
        float totalKcalory = 0.0;
        for (NSDictionary *singleDic in singleDayArr)
        {
            NSString *stepState = [singleDic objectForKey:@"steps"];
            NSString *meterState = [singleDic objectForKey:@"meters"];
            NSString *kCaloriyState = [singleDic objectForKey:@"kCalories"];
            
            [steps appendFormat:@"%@,",stepState];
            [meters appendFormat:@"%@,",meterState];
            [kCalories appendFormat:@"%@,",kCaloriyState];
            
            totalStep+= [stepState intValue];
            totalMeter+= [meterState intValue];
            totalKcalory+= [kCaloriyState floatValue];
            if ([stepState intValue]>0) {
                NSLog(@"有效数据为%@",singleDic);
            }
        }
            //最后移除一个逗号
            [steps deleteCharactersInRange:NSMakeRange(steps.length-1, 1)];
            [meters deleteCharactersInRange:NSMakeRange(meters.length-1, 1)];
            [kCalories deleteCharactersInRange:NSMakeRange(kCalories.length-1, 1)];
        NSString *total_step = [NSString stringWithFormat:@"%d",totalStep];
        NSString *total_meter = [NSString stringWithFormat:@"%d",totalMeter];
        NSString *total_kCalory = [NSString stringWithFormat:@"%f",totalKcalory];
        NSString *isUpload = [NSString stringWithFormat:@"%d",0];
        //汇总数据:如果该条数据已经存在则需要更新
        NSDictionary *totalDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"date":date,@"start_time":start_time,@"end_time":end_time,@"steps":steps,@"meters":meters,@"kCalories":kCalories,@"total_step":total_step,@"total_meter":total_meter,@"total_kCalory":total_kCalory,@"isUpload":isUpload};

        //如果有新增加的数据直接调用该方法即可
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_total_stepData SET userid = '%@',mac = '%@',start_time = '%@',end_time = '%@',steps = '%@',meters = '%@',kCalories = '%@',total_step = '%@',total_meter = '%@',total_kCalory = '%@',isUpload = '%@' where date = '%@'",[Singleton getUserID],[Singleton getMacSite],start_time,end_time,steps,meters,kCalories,total_step,total_meter,total_kCalory,isUpload,date];
        //判断该数据是否已经存在
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_stepData where date = '%@'",date];
        NSArray *totalExistArr = [DBOPERATOR getDataForSQL:selectSql];
        if (totalExistArr.count > 0)//如果该数据已存在,则更新该数据
        {
            NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:selectSql withSql:updateSql];
            if (error) {
                NSLog(@"更新日常汇总表失败:%@",error);
            }
            else
            {
                NSLog(@"汇总计步表更新成功");
            }
        }
        else//不存在则插入该数据:为什么插入的第一条数据是1970年的？
        {
            [DBMANAGER insertSingleDataToDB:StepTotalTable withDictionary:totalDic];
        }
        }
    }
}
//date格式为2015-07-13
//需要按时间段将数据聚合起来:如果没有数据呢？1440个点
- (DailyDayModel *)dailyDayModelForDate:(NSString *)date
{
    //构建一个新的model
    DailyDayModel *model = [[DailyDayModel alloc]init];
    //从汇总表中取出数据
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_stepData where date = '%@'",date];
    NSArray *dataArray = [DBOPERATOR getDataForSQL:selectSql];
    //构建480个点的valueArray
    NSMutableArray *valueArray = [NSMutableArray array];
    if (dataArray.count > 0)
    {
        NSDictionary *totalDic = [dataArray objectAtIndex:0];//只有一条数据
        NSString *startTime = [totalDic objectForKey:@"start_time"];
        NSString *endTime = [totalDic objectForKey:@"end_time"];
        NSString *sleeps = [totalDic objectForKey:@"steps"];
        NSString *totalStep = [totalDic objectForKey:@"total_step"];
        NSString *totalMeter = [totalDic objectForKey:@"total_meter"];
        //需要转化为千米
        NSString *totalKm = [NSString stringWithFormat:@"%.1f",[totalMeter intValue]/1000.0];
        NSString *totalCalory  = [totalDic objectForKey:@"total_kCalory"];
        NSString *kCalorys = [NSString stringWithFormat:@"%.1f",[totalCalory floatValue]];
        //转换为数值
        int startHour = [XlabTools timeFromDateString:startTime withType:0];
        int startMinute = [XlabTools timeFromDateString:startTime withType:1];
        int endHour = [XlabTools timeFromDateString:endTime withType:0];
        int endMinute = [XlabTools timeFromDateString:endTime withType:1];
        NSString *sportTime;
        NSString *staticTime;
        if (endMinute >= startMinute)
        {
            sportTime = [NSString stringWithFormat:@"%d小时%d分钟",endHour-startHour,endMinute-startMinute];
            if (endMinute == startMinute) {
                staticTime = [NSString stringWithFormat:@"%d小时%d分钟",24-(endHour-startHour),0];
            }
            else
            {
                staticTime = [NSString stringWithFormat:@"%d小时%d分钟",23-(endHour-startHour),60-(endMinute-startMinute)];
            }
        }
        else
        {
            sportTime = [NSString stringWithFormat:@"%d小时%d分钟",endHour-startHour-1,endMinute+60-startMinute];
            if (endMinute == startMinute) {
                staticTime = [NSString stringWithFormat:@"%d小时%d分钟",24-(endHour-startHour-1),0];
            }
            else
            {
                staticTime = [NSString stringWithFormat:@"%d小时%d分钟",23-(endHour-startHour-1),60-(endMinute+60-startMinute)];
            }
        }
 
        int startCount = startHour*60 + startMinute;//开始有多少个时间段是空白的,
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
        //valueArray会添加到640个值？
        model.upValueArray = @[totalKm,totalStep,kCalorys];
        model.downValueArray = @[sportTime,staticTime];
    }
    else
    {
        for (int i = 0; i < 1440; i ++)
        {
            [valueArray addObject:@0];
        }
        model.upValueArray = @[@"0.0",@"0",@"0.0"];
        model.downValueArray = @[@"0小时0分钟",@"0小时0分钟"];
    }
    model.date = date;
    model.valueArray = [NSMutableArray arrayWithArray:valueArray];
    model.upDescribeArray = @[NSLocalizedString(@"day_mileage_day", nil),NSLocalizedString(@"day_steps_day", nil),NSLocalizedString(@"day_consumption_kcal", nil)];
    model.downDescribeArray = @[NSLocalizedString(@"sport_time", nil),NSLocalizedString(@"static_time", nil)];
    return model;
}

//date格式为2015-07-13,必须为周一的日期
- (DailyWeekModel *)dailyWeekModelForDate:(NSString *)date
{
    DailyWeekModel *weekModel = [[DailyWeekModel alloc]init];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *startTimes = [NSMutableArray array];
    NSMutableArray *endTimes = [NSMutableArray array];
    int miles = 0;
    int steps = 0;
    float calories = 0.0;
    //先把字符串转日期，取得字符串后转回
    for (int i = 0; i < 7; i ++)
    {
        NSString *newDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:i withType:@"yyyy-MM-dd"];
        //分别获取7条数据：如果数据不全怎么办？异常处理
        
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_stepData where date = '%@'",newDate];
        NSArray *dataArray = [DBOPERATOR getDataForSQL:sql];
        //只保留月份和日期
        NSString *monString = [newDate substringFromIndex:5];
        [dateArray addObject:monString];
        if (dataArray && dataArray.count > 0)
        {
            NSDictionary *totalDic = dataArray[0];
            [valueArray addObject:[totalDic objectForKey:@"total_step"]];
            NSString *totalStep = [totalDic objectForKey:@"total_step"];
            NSString *totalMeter = [totalDic objectForKey:@"total_meter"];
            NSString *totalCalory = [totalDic objectForKey:@"total_kCalory"];
            steps+= [totalStep intValue];
            miles+= [totalMeter intValue];
            calories+= [totalCalory floatValue];
            
            [startTimes addObject:[totalDic objectForKey:@"start_time"]];
            [endTimes addObject:[totalDic objectForKey:@"end_time"]];
        }
        else
        {
            [valueArray addObject:@0];
            
            [startTimes addObject:@"0小时0分钟"];
            [endTimes addObject:@"0小时0分钟"];
        }
    }
    weekModel.dateArray = [NSArray arrayWithArray:dateArray];
    weekModel.valueArray = [NSArray arrayWithArray:valueArray];
    weekModel.upDescribeArray = @[LocalString(@"day_average_mile"),LocalString(@"day_average_step"),LocalString(@"day_average_calory")];
    weekModel.downDescribeArray = @[LocalString(@"day_average_sport_time"),LocalString(@"day_average_static_time")];
    weekModel.upValueArray = @[[NSString stringWithFormat:@"%.1f",miles/(7*1000.0)],[NSString stringWithFormat:@"%d",steps/7],[NSString stringWithFormat:@"%.1f",calories/(7*1000.0)]];
    weekModel.downValueArray = @[[DateHandle getAverageTimeFromStartTimes:startTimes endTimes:endTimes averageValidTime:YES],[DateHandle getAverageTimeFromStartTimes:startTimes endTimes:endTimes averageValidTime:NO]];

    return weekModel;
}
//date必须为某个连续4个星期的初始日期:最后可以推到当前这个日期,该方法是否有效需要验证？
- (DailyMonthModel *)dailyMonthModelForDate:(NSString *)date
{
    DailyMonthModel *monthModel = [[DailyMonthModel alloc] init];
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableArray *startTimes = [NSMutableArray array];
    NSMutableArray *endTimes = [NSMutableArray array];
    int miles = 0;
    int step1 = 0;
    float calories = 0.0;
    for (int i = 0; i < 4; i ++)
    {
        //计算每个星期的开始日期和最后一个日期
        NSString *firstDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i withType:@"yyyy-MM-dd"];
        NSString *lastDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i+6 withType:@"yyyy-MM-dd"];
        //构建日期的字符串：类似3/23-3/29
        NSMutableString *dateString = [NSMutableString string];
        [dateString appendFormat:@"%@/%@-%@/%@",[firstDate substringWithRange:NSMakeRange(5, 2)],[firstDate substringWithRange:NSMakeRange(8, 2)],[lastDate substringWithRange:NSMakeRange(5, 2)],[lastDate substringWithRange:NSMakeRange(8, 2)]];
        [dateArray addObject:dateString];
        int stepSum = 0;
        //获取一个星期内所有的数据汇总:为什么会跑到之前的时间去,日期对不上
        for (int j = 0; j < 7; j ++)
        {
            NSString *singleDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:firstDate byIndex:i withType:@"yyyy-MM-dd"];
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_stepData where date = '%@'",singleDate];
            NSArray *data = [DBOPERATOR getDataForSQL:sql];
            if (data && data.count > 0) {
                NSDictionary *steps = data[0];
                NSNumber *total_step = [steps objectForKey:@"total_step"];
                stepSum+= [total_step intValue];
                
                NSString *totalStep = [steps objectForKey:@"total_step"];
                NSString *totalMeter = [steps objectForKey:@"total_meter"];
                NSString *totalCalory = [steps objectForKey:@"total_kCalory"];
                step1+= [totalStep intValue];
                miles+= [totalMeter intValue];
                calories+= [totalCalory intValue];

                [startTimes addObject:[steps objectForKey:@"start_time"]];
                [endTimes addObject:[steps objectForKey:@"end_time"]];
            }
            else
            {
                [startTimes addObject:@"0小时0分钟"];
                [endTimes addObject:@"0小时0分钟"];
            }
        }
        [valueArray addObject:[NSNumber numberWithInt:stepSum]];
        
        monthModel.dateArray = [NSArray arrayWithArray:dateArray];
        monthModel.valueArray = [NSArray arrayWithArray:valueArray];
        monthModel.upDescribeArray = @[LocalString(@"day_average_mile"),LocalString(@"day_average_step"),LocalString(@"day_average_calory")];
        monthModel.downDescribeArray = @[LocalString(@"day_average_sport_time"),LocalString(@"day_average_static_time")];
        monthModel.upValueArray = @[[NSString stringWithFormat:@"%.1f",miles/(28*1000.0)],[NSString stringWithFormat:@"%d",step1/7],[NSString stringWithFormat:@"%.1f",calories/(28*1000.0)]];
        monthModel.downValueArray = @[[DateHandle getAverageTimeFromStartTimes:startTimes endTimes:endTimes averageValidTime:YES],[DateHandle getAverageTimeFromStartTimes:startTimes endTimes:endTimes averageValidTime:NO]];
    }
    return monthModel;
}
//自己补全为0的数据，目前测试数据阀值为50,先还原到1440个点
- (SectionModel *)dailySectionModelForDate:(NSString *)date
{
    int threshold = 0;
    SectionModel *model = [[SectionModel alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_stepData where date = '%@'",date];
    NSArray *data = [DBOPERATOR getDataForSQL:selectSql];
    if (data.count > 0)
    {
        NSDictionary *dic = data[0];
        NSString *steps = dic[@"steps"];
        NSString *start_time = dic[@"start_time"];
        NSArray *stepArray = [steps componentsSeparatedByString:@","];
        NSMutableArray *stepArray0 = [NSMutableArray array];
        int minutes = [DateHandle getMinutesFromTimeString:start_time];
        for (int i = 0; i < minutes; i ++)
        {
            [stepArray0 addObject:@0];
        }
        [stepArray0 addObjectsFromArray:stepArray];
        
        int startPoint = 0;
        int endPoint = 0;
        BOOL isSleep = NO;
        NSMutableArray *startArray = [NSMutableArray array];//记录各个时间段开始点的数组
        NSMutableArray *endArray = [NSMutableArray array];//记录各个时间段结束点的数组
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < stepArray0.count-1; i ++)
        {
            NSString *number = stepArray0[i];
            if ([number intValue]>threshold)
            {
                if (!isSleep)
                {
                    startPoint = i;
                    [startArray addObject:[NSNumber numberWithInt:i]];//添加第一个开始点
                    isSleep = YES;
                }
            }
            else//否则为睡眠时间:0,连续的情况需要避免,结束时间点需要加上最后一个点
            {
                NSString *str;
                if (i>1) {
                    str  = stepArray0[i-1];
                }
                else
                {
                    str = @"0";
                }
                //连续3个为0:不要求这样，只要有一个小于阀值即可
                if (i > startPoint && [str intValue]>threshold && [stepArray0[i+1] intValue]<=threshold)
                {
                    endPoint = i;//i-1
                    [endArray addObject:[NSNumber numberWithInt:endPoint]];
                    isSleep = NO;
                }
            }
        }
        int count = stepArray0.count;
        if ([[stepArray0 lastObject] intValue]>threshold || [stepArray0[count-1] intValue]>threshold)
        {
            endPoint = count;//count-1
            [endArray addObject:[NSNumber numberWithInt:endPoint]];
            isSleep = NO;
        }
        if (endArray.count > startArray.count)
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
                sum+= [stepArray0[k] intValue];
            }
            [valueArray addObject:[NSNumber numberWithInt:sum]];
        }
     
        //需要避免开始时间和结束时间相同：如果只有独立的一分钟的数据也应该显示
        model.startArray = [NSArray arrayWithArray:startArray];
        model.endArray = [NSArray arrayWithArray:endArray];
        model.valueArray = [NSArray arrayWithArray:valueArray];
    }
    return model;
}

/**************************添加by Star**************************************/
+ (void)insertStepData:(t_stepData *)stepModel
{
    NSDictionary *dic = [t_stepData dictionaryFromModel:stepModel];
    NSArray *array = [NSArray arrayWithObject:dic];
    [DBOPERATOR insertDataArrayToDB:@"t_stepData" withDataArray:array];
    //立即更新汇总表：应该放在后台运行
    [self collectAllDailyData];
}
//数组元素为字典
+ (void)insertStepArray:(NSArray *)array
{
    [DBOPERATOR insertDataArrayToDB:@"t_stepData" withDataArray:array];
    [self collectAllDailyData];
}
@end
