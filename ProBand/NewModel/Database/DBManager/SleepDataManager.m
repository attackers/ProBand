//
//  SleepDataManager.m
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepDataManager.h"

@implementation SleepDataManager
{
    
}
SINGLETON_SYNTHE

- (id)init
{
    self= [super init];
    if (self) {

    }
    return self;
}
//将所有原始表中的数据汇总:一有数据过来马上更新汇总表
+ (void)collectAllSleepData
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_sleepData where isRead = 0 ORDER BY time"];
    NSArray *sleepArray = [DBOPERATOR getDataForSQL:sql];
    if (sleepArray.count > 0) {
        [self bleDataToTotalSleepData:sleepArray];
        
        //需要将汇总过的数据isRead属性标记为1
        NSString *sqlExist = [NSString stringWithFormat:@"SELECT * FROM t_sleepData where isRead = 0"];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_sleepData SET isRead = '%@'",@"1"];
        NSError *error =  [DBOPERATOR updateTheDataToDbWithExsitSql:sqlExist withSql:updateSql];
        if (error) {
            NSLog(@"更新标志位错误：%@",error);
        }
        else
        {
            NSLog(@"更新睡眠标志位成功");
        }
    }
}

//将原始表的数据转化到汇总表中去：需要判断数据是否被读取过,而且要保证时间是按顺序的
//如果当天的数据已经存在则需要更新:汇总表总是1440个点，已有的点需要被包含进去,前后的数据不能有冲突
+ (void)bleDataToTotalSleepData:(NSArray *)sleepArray
{
            NSDictionary *firstDic = [sleepArray firstObject];
            NSDictionary *endDic = [sleepArray lastObject];
            NSString *valideStart = [firstDic objectForKey:@"time"];
            NSString *valideEnd = [endDic objectForKey: @"time"];
            //计算开始时间和结束时间之间的天数，然后对中间每一天重新从数据库取值
            long int startTime = [valideStart intValue];
            long int endTime = [valideEnd intValue];
    NSDate *startDay = [DateHandle getDateFromTimeStamp:startTime];
    NSDate *endDay = [DateHandle getDateFromTimeStamp:endTime];
    int intervalDay = [DateHandle calcDaysFromBegin:startDay end:endDay]+1;//开始和结束时间相差天数
    int startDayTime = [DateHandle getStartTimeForDate:startDay];
            for (int count = 0; count < intervalDay; count ++)
            {
                 //对当天的数据重新从数据库取值
                int sUTC = startDayTime+count*3600*24;//当天开始的时间
                int eUTC = startDayTime+(count+1)*3600*24;//当天结束的时间
                NSString *sUTCStr = [NSString stringWithFormat:@"%d",sUTC];
                NSString *eUTCStr = [NSString stringWithFormat:@"%d",eUTC];
                NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_sleepData where time >= '%@' and time < '%@' ORDER BY time",sUTCStr,eUTCStr];
                //获取到的数据可能为空
                NSArray *singleDayArr = [DBOPERATOR getDataForSQL:sql];
                if (singleDayArr.count > 0)
                {
                    //构造当天数据的汇总数据然后插入到汇总表中
                    NSDictionary *todaySDic = [singleDayArr firstObject];
                    NSDictionary *todayEDic = [singleDayArr lastObject];
                    NSString *todayStartTime = [todaySDic objectForKey:@"time"];
                    NSString *todatEndTime = [todayEDic objectForKey:@"time"];
                    int sTime = [todayStartTime intValue];//-8*3600
                    int eTime = [todatEndTime intValue];//-8*3600
                    //时间戳转化为日期
                    NSDate *startDate = [DateHandle getDateFromTimeStamp:sTime];
                    NSDate *endDate = [DateHandle getDateFromTimeStamp:eTime];
                    NSString *date = [DateHandle dateStringFromTimeStamp:sTime];//汇总数据的日期
                    NSString *start_time = [NSString stringWithFormat:@"%d小时%d分钟",(int)[DateHandle getTimeFromDate:startDate withType:3],(int)[DateHandle getTimeFromDate:startDate withType:4]];
                    NSString *end_time = [NSString stringWithFormat:@"%d小时%d分钟",(int)[DateHandle getTimeFromDate:endDate withType:3],(int)[DateHandle getTimeFromDate:endDate withType:4]];
                    //构造当天所有从开始到结束时间的数据
                    NSMutableString *sleeps = [NSMutableString string];
                    int todayDataCount = (eTime-sTime)/60+1;//3分钟一条数据
                    //查看是否有该条数据
                    for (int k = 0; k < todayDataCount; k ++)
                    {
                        NSString *kTime = [NSString stringWithFormat:@"%d",sTime+k*60];
                        int sleepState = 0;
                        for (NSDictionary *singleDic in singleDayArr)
                        {
                            NSString *nowTime = [singleDic objectForKey:@"time"];
                            if ([nowTime isEqualToString:kTime])
                            {
                                NSString *asleep = [singleDic objectForKey:@"sleeps"];
                                sleepState = [asleep intValue];
                            }
                        }
                        [sleeps appendFormat:@"%d,",sleepState];
                    }
                    //最后移除一个逗号
                    [sleeps deleteCharactersInRange:NSMakeRange(sleeps.length-1, 1)];
                    //1是深睡，2为浅睡，3为清醒
                    int awake = 0;
                    int lightSleep = 0;
                    int deepSleep = 0;
                    for (NSDictionary *singleDic in singleDayArr)
                    {
                        NSString *nowState = [singleDic objectForKey:@"sleeps"];
                        switch ([nowState intValue])
                        {
                            case 1:
                                deepSleep ++;
                                break;
                            case 2:
                                lightSleep ++;
                                break;
                            case 3:
                                awake ++;
                                break;
                            default:
                                break;
                        }
                    }
                    NSString *total_awake_sleep = [NSString stringWithFormat:@"%d",awake];
                    NSString *total_light_sleep = [NSString stringWithFormat:@"%d",lightSleep];
                    NSString *total_deep_sleep = [NSString stringWithFormat:@"%d",deepSleep];
                    NSString *isUpload = [NSString stringWithFormat:@"%d",0];
                    //汇总数据:如果该条数据已经存在则需要更新
                    NSDictionary *totalDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"date":date,@"start_time":start_time,@"end_time":end_time,@"sleeps":sleeps,@"total_awake_sleep":total_awake_sleep,@"total_light_sleep":total_light_sleep,@"total_deep_sleep":total_deep_sleep,@"isUpload":isUpload};
                    //                NSString *existString = [NSString stringWithFormat:@"select * from t_total_sleepData where date = '%@'",date];//存在语句
                    //                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_total_sleepData(mac,date,start_time,end_time,sleeps,total_awake_sleep,total_light_sleep,total_deep_sleep,isUpload)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getDefaultMacSite],date,start_time,end_time,sleeps,total_awake_sleep,total_light_sleep,total_deep_sleep,isUpload];
                    //如果有新增加的数据直接调用该方法即可
                    NSString *updateSql = [NSString stringWithFormat:@"UPDATE t_total_sleepData SET userid = '%@',mac = '%@',start_time = '%@',end_time = '%@',sleeps = '%@',total_awake_sleep = '%@',total_light_sleep = '%@',total_deep_sleep = '%@',isUpload = '%@' where date = '%@'",[Singleton getUserID],[Singleton getMacSite],start_time,end_time,sleeps,total_awake_sleep,total_light_sleep,total_deep_sleep,isUpload,date];
                    //判断该数据是否已经存在
                    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_sleepData where date = '%@'",date];
                    NSArray *totalExistArr = [DBOPERATOR getDataForSQL:selectSql];
                    if (totalExistArr.count > 0)//如果该数据已存在,则更新该数据
                    {
                        NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:selectSql withSql:updateSql];
                        if (error) {
                            NSLog(@"更新睡眠汇总表失败:%@",error);
                        }
                        else
                        {
                            NSLog(@"汇总睡眠表更新成功");
                        }
                    }
                    else//不存在则插入该数据:只插入了一次
                    {
                        [DBMANAGER insertSingleDataToDB:SleepTotalTable withDictionary:totalDic];
                    }
                }
            }
}

//date格式为2015-07-13
//需要按时间段将数据聚合起来:后期处理,进行时间统计
- (SleepDayModel *)sleepDayModelForDate:(NSString *)date
{
    //构建一个新的model
    SleepDayModel *model = [[SleepDayModel alloc]init];
    //构建480个点的valueArray
    NSMutableArray *valueArray = [NSMutableArray array];
    //从汇总表中取出数据
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_sleepData where date = '%@'",date];
    NSArray *dataArray = [DBOPERATOR getDataForSQL:selectSql];
    if (dataArray.count > 0)
    {
        NSDictionary *totalDic = [dataArray objectAtIndex:0];//只有一条数据
        NSString *startTime = [totalDic objectForKey:@"start_time"];
        NSString *endTime = [totalDic objectForKey:@"end_time"];
        NSString *sleeps = [totalDic objectForKey:@"sleeps"];
        //进行处理
        NSString *awakeSleep = [totalDic objectForKey:@"total_awake_sleep"];
        NSString *lightSleep = [totalDic objectForKey:@"total_light_sleep"];
        NSString *deepSleep = [totalDic objectForKey:@"total_deep_sleep"];
        int sleepTime = [awakeSleep intValue]+[lightSleep intValue]+[deepSleep intValue];
        NSString *totalSleepTime = [NSString stringWithFormat:@"%d小时%d分钟",sleepTime/60,sleepTime%60];
        NSString *deepSleepStr = [NSString stringWithFormat:@"%d小时%d分钟",[deepSleep intValue]/60,[deepSleep intValue]%60];
        NSString *lightSleepStr = [NSString stringWithFormat:@"%d小时%d分钟",[lightSleep intValue]/60,[lightSleep intValue]%60];
        NSString *start = [NSString stringWithFormat:@"%.2d:%.2d",[XlabTools timeFromDateString:startTime withType:0],[XlabTools timeFromDateString:startTime withType:1]];
        NSString *end = [NSString stringWithFormat:@"%.2d:%.2d",[XlabTools timeFromDateString:endTime withType:0],[XlabTools timeFromDateString:endTime withType:1]];
        
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
        model.upValueArray = @[totalSleepTime,deepSleepStr,lightSleepStr];
        model.downValueArray = @[start,end,awakeSleep];
    }
    else
    {
        for (int i =0; i < 1440; i ++)
        {
            [valueArray addObject:@0];
        }
        model.upValueArray = @[@"0小时0分钟",@"0小时0分钟",@"0小时0分钟"];
        model.downValueArray = @[@"00:00",@"00:00",@"0小时0分钟"];
    }
    model.date = date;
    model.valueArray = [NSMutableArray arrayWithArray:valueArray];
    model.upDescribeArray = @[LocalString(@"sleep_duration"),LocalString(@"deep_sleep_time"),LocalString(@"light_sleep_time")];
    model.downDescribeArray = @[LocalString(@"sleep_start_time"),LocalString(@"wake_up_time"),LocalString(@"awake_duration")];
    return model;
}

//date格式为2015-07-13,必须为周一的日期:计算汇总时出现了问题
- (SleepWeekModel *)sleepWeekModelForDate:(NSString *)date
{
    SleepWeekModel *weekModel = [[SleepWeekModel alloc]init];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];
    //构造下方的元素
    int totalSleep = 0;//总睡眠时间，单位为分钟
    int totalDeepSleep = 0;
    int totalLightSleep = 0;
    int totalStartTime = 0;//总入睡时间叠加:单位为分钟
    int totalEndTime = 0;
    int totalWake = 0;
    //先把字符串转日期，取得字符串后转回
    for (int i = 0; i < 7; i ++)
    {
        NSString *newDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:i withType:@"yyyy-MM-dd"];
        //分别获取7条数据：如果数据不全怎么办？异常处理
        
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_sleepData where date = '%@'",newDate];
        NSArray *dataArray = [DBOPERATOR getDataForSQL:sql];
        //只保留月份和日期
        NSString *monString = [newDate substringFromIndex:5];
        [dateArray addObject:monString];
        
        if (dataArray && dataArray.count > 0)
        {
            NSDictionary *totalDic = dataArray[0];
            NSString *light_sleep = [totalDic objectForKey:@"total_light_sleep"];
            NSString *awake_sleep = [totalDic objectForKey:@"total_awake_sleep"];
            NSString *deep_sleep = [totalDic objectForKey:@"total_deep_sleep"];
            NSString *start_time = [totalDic objectForKey:@"start_time"];
            NSString *end_time = [totalDic objectForKey:@"end_time"];
            [valueArray addObject:@[light_sleep,deep_sleep,awake_sleep]];
            totalSleep+= [light_sleep intValue]+[awake_sleep intValue]+[deep_sleep intValue];
            totalDeepSleep+=[deep_sleep intValue];
            totalLightSleep+=[light_sleep intValue];
            totalWake+=[awake_sleep intValue];
            totalStartTime+=[XlabTools timeFromDateString:start_time withType:0]*60+[XlabTools timeFromDateString:start_time withType:1];
            totalEndTime+= [XlabTools timeFromDateString:end_time withType:0]*60+[XlabTools timeFromDateString:end_time withType:1];
        }
        else
        {
            [valueArray addObject:@[@0,@0,@0]];
        }
    }
    NSString *avSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalSleep/7)/60,(totalSleep/7)%60];
    NSString *avDeepSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalDeepSleep/7)/60,(totalDeepSleep/7)%60];
    NSString *avLightSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalLightSleep/7)/60,(totalLightSleep/7)%60];
    NSString *avStart = [NSString stringWithFormat:@"%d:%d",(totalStartTime/7)/60,(totalStartTime/7)%60];
    NSString *avEnd = [NSString stringWithFormat:@"%d:%d",(totalEndTime/7)/60,(totalEndTime/7)%60];
    NSString *avAwake = [NSString stringWithFormat:@"%d小时%d分钟",(totalWake/7)/60,(totalWake/7)%60];
    weekModel.dateArray = [NSArray arrayWithArray:dateArray];
    weekModel.valueArray = [NSArray arrayWithArray:valueArray];
    weekModel.upDescribeArray = @[LocalString(@"average_sleep_time"),LocalString(@"average_deep_sleep_time"),LocalString(@"average_light_sleep_time")];
    weekModel.downDescribeArray = @[LocalString(@"average_sleep_start_time"),LocalString(@"average_sleep_end_time"),LocalString(@"average_sleep_awake_time")];
    weekModel.upValueArray = @[avSleep,avDeepSleep,avLightSleep];
    weekModel.downValueArray = @[avStart,avEnd,avAwake];
    return weekModel;
}

//date必须为某个连续4个星期的初始日期:最后可以推到当前这个日期,该方法是否有效需要验证？
- (SleepMonthModel *)sleepMonthModelForDate:(NSString *)date
{
    SleepMonthModel *monthModel = [[SleepMonthModel alloc] init];
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    //构造下方的元素
    int totalSleep = 0;//总睡眠时间，单位为分钟
    int totalDeepSleep = 0;
    int totalLightSleep = 0;
    int totalStartTime = 0;//总入睡时间叠加:单位为分钟
    int totalEndTime = 0;
    int totalWake = 0;
    for (int i = 0; i < 4; i ++)
    {
        //计算每个星期的开始日期和最后一个日期
        NSString *firstDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i withType:@"yyyy-MM-dd"];
        NSString *lastDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:7*i+6 withType:@"yyyy-MM-dd"];
        //构建日期的字符串：类似3/23-3/29
        NSMutableString *dateString = [NSMutableString string];
        [dateString appendFormat:@"%@/%@-%@/%@",[firstDate substringWithRange:NSMakeRange(5, 2)],[firstDate substringWithRange:NSMakeRange(8, 2)],[lastDate substringWithRange:NSMakeRange(5, 2)],[lastDate substringWithRange:NSMakeRange(8, 2)]];
        [dateArray addObject:dateString];
        int awakeSleep = 0;
        int lightSleep = 0;
        int deepSleep = 0;
        //获取一个星期内所有的数据汇总
        for (int j = 0; j < 7; j ++)
        {
            NSString *singleDate = [DateHandle getTomorrowAndYesterDayByCurrentDate:firstDate byIndex:i withType:@"yyyy-MM-dd"];
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_total_sleepData where date = '%@'",singleDate];
            NSArray *data = [DBOPERATOR getDataForSQL:sql];
            if (data && data.count > 0) {
                NSDictionary *sleepDic = data[0];
                NSString *awake = [sleepDic objectForKey:@"total_awake_sleep"];
                NSString *light = [sleepDic objectForKey:@"total_light_sleep"];
                NSString *deep = [sleepDic objectForKey:@"total_deep_sleep"];
                NSString *start_time = [sleepDic objectForKey:@"start_time"];
                NSString *end_time = [sleepDic objectForKey:@"end_time"];
                awakeSleep+= [awake intValue];
                lightSleep+= [light intValue];
                deepSleep+= [deep intValue];
                totalSleep+= [light intValue]+[awake intValue]+[deep intValue];
                totalDeepSleep+=[deep intValue];
                totalLightSleep+=[light intValue];
                totalWake+=[awake intValue];
                totalStartTime+=[XlabTools timeFromDateString:start_time withType:0]*60+[XlabTools timeFromDateString:start_time withType:1];
                totalEndTime+= [XlabTools timeFromDateString:end_time withType:0]*60+[XlabTools timeFromDateString:end_time withType:1];
            }
        }
        [valueArray addObject:@[[NSNumber numberWithInt:lightSleep],[NSNumber numberWithInt:deepSleep],[NSNumber numberWithInt:awakeSleep]]];
        
        NSString *avSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalSleep/28)/60,(totalSleep/28)%60];
        NSString *avDeepSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalDeepSleep/28)/60,(totalDeepSleep/28)%60];
        NSString *avLightSleep = [NSString stringWithFormat:@"%d小时%d分钟",(totalLightSleep/28)/60,(totalLightSleep/28)%60];
        NSString *avStart = [NSString stringWithFormat:@"%d:%d",(totalStartTime/28)/60,(totalStartTime/28)%60];
        NSString *avEnd = [NSString stringWithFormat:@"%d:%d",(totalEndTime/28)/60,(totalEndTime/28)%60];
        NSString *avAwake = [NSString stringWithFormat:@"%d小时%d分钟",(totalWake/28)/60,(totalWake/28)%60];
        monthModel.dateArray = [NSArray arrayWithArray:dateArray];
        monthModel.valueArray = [NSArray arrayWithArray:valueArray];
        monthModel.upDescribeArray = @[LocalString(@"average_sleep_time"),LocalString(@"average_deep_sleep_time"),LocalString(@"average_light_sleep_time")];
        monthModel.downDescribeArray = @[LocalString(@"average_sleep_start_time"),LocalString(@"average_sleep_end_time"),LocalString(@"average_sleep_awake_time")];
        monthModel.upValueArray = @[avSleep,avDeepSleep,avLightSleep];
        monthModel.downValueArray = @[avStart,avEnd,avAwake];
    }
    return monthModel;
}

- (SectionModel *)sleepSectionModelForDate:(NSString *)date
{
    int threshold = 0;
    SectionModel *model = [[SectionModel alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_sleepData where date = '%@'",date];
    NSArray *data = [DBOPERATOR getDataForSQL:selectSql];
    if (data.count > 0)
    {
        NSDictionary *dic = data[0];
        NSString *sleeps = dic[@"sleeps"];
        NSString *sleepStart = dic[@"start_time"];
        NSArray *stepArray = [sleeps componentsSeparatedByString:@","];
        NSMutableArray *sleepArray = [NSMutableArray array];
        int minutes = [DateHandle getMinutesFromTimeString:sleepStart];
        for (int i = 0; i < minutes; i ++)
        {
            [sleepArray addObject:@0];
        }
        [sleepArray addObjectsFromArray:stepArray];
        
        int startPoint = 0;
        int endPoint = 0;
        BOOL isSleep = NO;
        NSMutableArray *startArray = [NSMutableArray array];//记录各个时间段开始点的数组
        NSMutableArray *endArray = [NSMutableArray array];//记录各个时间段结束点的数组
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < sleepArray.count-1; i ++)
        {
            NSString *number = sleepArray[i];
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
                    str  = sleepArray[i-1];
                }
                else
                {
                    str = @"0";
                }
                //连续两个为0
                if (i > startPoint && [str intValue]>threshold && [sleepArray[i+1] intValue]<=threshold)
                {
                    endPoint = i-1;
                    [endArray addObject:[NSNumber numberWithInt:endPoint]];
                    isSleep = NO;
                }
            }
        }
        int count = sleepArray.count;
        if ([[sleepArray lastObject] intValue]>threshold || [sleepArray[count-1] intValue]>threshold)
        {
            endPoint = count-1;
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
                sum+= [sleepArray[k] intValue];
            }
            [valueArray addObject:[NSNumber numberWithInt:sum]];
        }
        
        
        model.startArray = [NSArray arrayWithArray:startArray];
        model.endArray = [NSArray arrayWithArray:endArray];
        model.valueArray = [NSArray arrayWithArray:valueArray];
    }
    return model;
}

/***************************添加by Star*******************************/
+ (void)insertSleepData:(t_sleepData *)model
{
    NSDictionary *dic = [t_sleepData dictionaryFromModel:model];
    NSArray *array = [NSArray arrayWithObject:dic];
    [DBOPERATOR insertDataArrayToDB:@"t_sleepData" withDataArray:array];
    //汇总数据
    [self collectAllSleepData];
}
//数组元素为字典:需要首先判断数据库中数据的最大值和最小值，然后插入不重复的数据
+ (void)insertSleepArray:(NSArray *)array
{
    NSArray *sleepArr = [DBOPERATOR queryAllDataForSQL:@"t_sleepData"];
    NSDictionary *lastDic = [sleepArr lastObject];
    int maxSleep = [lastDic[@"time"] intValue];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in array)
    {
        if ([dic[@"time" ] intValue]>maxSleep)
        {
            [resultArray addObject:dic];
        }
    }
    [DBOPERATOR insertDataArrayToDB:@"t_sleepData" withDataArray:resultArray];
    [self collectAllSleepData];
}
@end
