//
//  DateHandle.m
//  LenovoVB10
//
//  Created by jacy on 14/12/18.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "DateHandle.h"

@implementation DateHandle

//获取当前日期
+ (NSString *)getCurentDateByType:(NSString *)type withUTC:(BOOL)isuct{
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isuct) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
    }
    [dateFormatter setDateFormat:type];
    NSString *  locationString=[dateFormatter stringFromDate:senddate];
    NSLog(@"当前日期:%@",locationString);
    return locationString;
}
//日期格式转换
+ (NSString *)getTheDateFrom:(NSString *)date withBeforeType:(NSString *)beforeType withresultType:(NSString *)resultType{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:beforeType];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:resultType];
    NSString *resultDate = [outputFormatter stringFromDate:inputDate];
    //    NSLog(@"anyDate~~~~~~~~~~%@~~~%@",date,resultDate);
    
    return resultDate;
}
//当前日期的前后第几天,index值为正则是今天以后的日期
+ (NSString *)getTomorrowAndYesterDayByCurrentDate:(NSString *)date byIndex:(NSInteger)index withType:(NSString *)type
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60*index;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type];
    NSDate* today = [inputFormatter dateFromString:date];
    NSDate *tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    NSString * globalDate=[inputFormatter stringFromDate:tomorrow];
    
    return globalDate;
}
//计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
+ (NSInteger)daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    NSLog(@"~~~~~~~~两个日期之间的天数~~~~~~~%@~~~~~~%@",beforeDay,behindDay);
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* startDate = [inputFormatter dateFromString:beforeDay];
    NSDate *endDate = [inputFormatter dateFromString:behindDay];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", [components day]);
    return [components day];
}
//根据时间字符串获得当前星期几
+ (NSString *)getWeekFromDate:(NSString *)string withType:(NSString *)type
{
    //根据字符串转换成一种时间格式 供下面解析
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:inputDate];
    
    NSInteger week = [comps weekday];
    
    NSString*weekStr=nil;
    switch (week) {
        case 1:
        {
            weekStr = @"周日";
        }
            break;
        case 2:
        {
            weekStr = @"周一";
        }
            break;
        case 3:
        {
            weekStr = @"周二";
        }
            break;
        case 4:
        {
            weekStr = @"周三";
        }
            break;
        case 5:
        {
            weekStr = @"周四";
        }
            break;
        case 6:
        {
            weekStr = @"周五";
        }
            break;
        case 7:
        {
            weekStr = @"周六";
        }
            break;
        default:
            break;
    }
    
    return weekStr;
}
//根据日期获取该日期所在月的所有日期
+ (NSArray *)getdaysArrayByTheDate:(NSString *)dateStr withType:(NSString *)type{
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:type];
    NSDate* newDate = [inputFormatter dateFromString:dateStr];
    
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth;
    
    BOOL ok = [calendar rangeOfUnit:unitFlags startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:type];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];//一个月的第一天
    NSString *endString = [myDateFormatter stringFromDate:endDate];//一个月的最后一天
    
    NSInteger num = [self daysWithinEraFromDate:beginString toDate:endString];
    
    [dateArray addObject:[NSNumber numberWithInt:[[beginString componentsSeparatedByString:@"-"][2] intValue]]];
    
    for (int i = 1; i<=num; i++) {//当前日期所在月对应的日期
        NSString *dateString = [self getTomorrowAndYesterDayByCurrentDate:beginString byIndex:i withType:type];
        [dateArray addObject:[NSNumber numberWithInt:[[dateString componentsSeparatedByString:@"-"][2] intValue]]];
    }
    return dateArray;
}


//根据日期，获取该日期所在周，月，年的开始日期，结束日期
+ (NSArray *)getArrayByTheDate:(NSString *)dateStr index:(NSInteger)index{
    
    NSMutableArray *dateArray = [NSMutableArray new];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* newDate = [inputFormatter dateFromString:dateStr];
    
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSInteger unitFlags =0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    switch (index) {
        case 0://周
        {
            
            unitFlags =  NSCalendarUnitWeekOfYear;
            
        }
            break;
        case 1://月
        {
            unitFlags = NSCalendarUnitMonth;
        }
            break;
        case 2://年
        {
            unitFlags = NSCalendarUnitYear;
        }
            break;
            
        default:
            break;
    }
    
    BOOL ok = [calendar rangeOfUnit:unitFlags startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];//一周/一个月/一年的第一天
    NSString *endString = [myDateFormatter stringFromDate:endDate];//一周/一个月/一年的最后一天
    
    NSInteger num = [self daysWithinEraFromDate:beginString toDate:endString];
    
    if (index==0) {//周
        NSString *finalStrf = [beginString componentsSeparatedByString:@"-"][2];
        NSString *dateWeekf = [self getWeekFromDate:beginString withType:@"yyyy-MM-dd"];
        [dateArray addObject:@[finalStrf, dateWeekf,beginString]];
        
        for (int i = 1; i<=num; i++) {//当前日期所在周对应的日期和星期
            NSString *dateString = [self getTomorrowAndYesterDayByCurrentDate:beginString byIndex:i withType:@"yyyy-MM-dd"];
            NSString *finalStr = [dateString componentsSeparatedByString:@"-"][2];
            NSString *dateWeek = [self getWeekFromDate:dateString withType:@"yyyy-MM-dd"];
            [dateArray addObject:@[finalStr, dateWeek,dateString]];//天，星期，完整日期
        }
    }else if (index ==1){//月
        
        [dateArray addObject:beginString];
        for (int i = 1; i<=num; i++) {//当前日期所在月对应的日期
            NSString *dateString = [self getTomorrowAndYesterDayByCurrentDate:beginString byIndex:i withType:@"yyyy-MM-dd"];
            [dateArray addObject:dateString];
        }
    }else{//年
        
        NSMutableArray *datas = [NSMutableArray new];
        [datas addObject:beginString];
        for (int i = 1; i<=num; i++) {//当前日期一年对应的日期
            NSString *dateString = [self getTomorrowAndYesterDayByCurrentDate:beginString byIndex:i withType:@"yyyy-MM-dd"];
            [datas addObject:dateString];
        }
        
        
    }
    
    return dateArray;
}
//获取单个日期或时间，年、月、日、时、分、秒
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
     NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    NSDate *now =[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    switch (index) {
        case 0:
            return [comps year];
            break;
        case 1:
            return [comps month];
            break;
        case 2:
            return [comps day];
            break;
        case 3:
            return [comps hour];
            
            break;
        case 4:
            return [comps minute];
            break;
        case 5:
            return [comps second];
            break;
        default:
            break;
    }
    return 0;
}

+ (NSInteger)getTimeFromDate:(NSDate *)date withType:(int)type
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
    //NSDate *now =[NSDate date];
    comps = [calendar components:unitFlags fromDate:date];
    
    switch (type) {
        case 0:
            return [comps year];
            break;
        case 1:
            return [comps month];
            break;
        case 2:
            return [comps day];
            break;
        case 3:
            return [comps hour];
            
            break;
        case 4:
            return [comps minute];
            break;
        case 5:
            return [comps second];
            break;
        default:
            break;
    }
    return 0;
}
/********************添加的方法字符串与日期之间的转换************************/

#pragma mark - 日期转字符串

+(NSString *)dateToString:(NSDate *)aDate withType:(int)type{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (type == 0) {
        [formatter setDateFormat:@"a HH:mm"];
        [formatter setAMSymbol:@"上午"];
        [formatter setPMSymbol:@"下午"];
        NSString *dateStr = [formatter stringFromDate:aDate];
        return dateStr;
    }
    else if(type == 1){
        
        [formatter setDateFormat:@"HH:mm"];
        NSString *str = [formatter stringFromDate:aDate];
        return str;
    }
    else if(type == 2)
    {
       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 3)
    {
        [formatter setDateFormat:@"yyyyMMdd"];
        return [formatter stringFromDate:aDate];
    }
    else if (type == 4)
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter stringFromDate:aDate];
    }

    else
        return nil;
}

#pragma mark - 字符串转日期

+(NSDate *)stringToDate:(NSString *)timerStr withtype:(int)type{
    
    
    NSDateFormatter *inputFormatter = [NSDateFormatter new];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    
    if (type == 0) {
        
        [inputFormatter setDateFormat:@"HH:mm"];
    }
    else if(type == 1){
        [inputFormatter setDateFormat:@"HHmmss"];
    }
    else if (type==2)
    {
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (type == 3)
    {
        [inputFormatter setDateFormat:@"yyyyMMdd"];
    }
    else if (type == 4)
    {
       [inputFormatter setDateFormat:@"MM/dd"]; 
    }
    NSDate* inputDate = [inputFormatter dateFromString:timerStr];

    return inputDate;
}


+ (NSString*) stringOfCurrentTime
{
    
    NSDate* current = [NSDate date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* dateCp = [calendar components:
                                (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                           fromDate:current];
    return [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",
            (int)[dateCp year], (int)[dateCp month], (int)[dateCp day],
            (int)[dateCp hour], (int)[dateCp minute], (int)[dateCp second]];//此处的年月日一定要是整型不能时常整型

}
+(NSString *)getdateFomatMonthOrDay:(NSString *)dateStr withType:(NSString *)typeStr
{
    NSMutableString *resultStr = [[NSMutableString alloc]init];
    if ([typeStr isEqualToString:@"yyyy-MM-dd"]) {
        
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
        //NSLog(@"-----dateArr----%@",dateArr);
        NSString *monthStr = [NSString stringWithFormat:@"%d",[dateArr[1] intValue]];
        NSString *dayStr =[NSString stringWithFormat:@"%d",[dateArr[2] intValue]];
        
        [resultStr appendString:[NSString stringWithFormat:@"%@/%@",monthStr,dayStr]];
    }
    return resultStr;
}
/**
 *
 *获取某个日期的月份
 * 这个日期的格式是yyyy-MM-dd
 */

+(NSString *)getDateMonth:(NSString *)dateStr
{
    NSString *monthStr = [dateStr componentsSeparatedByString:@"-"][1];
    if ([monthStr integerValue]<10) {
        
        monthStr = [monthStr substringFromIndex:1];
    }
    return monthStr;
}



//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd
{
    NSLog(@"%@--开始时间and结束-%@",inBegin,inEnd);
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:inEnd];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];
  
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    return beginDays;
}


+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}


+ (NSString *)dateStringConbine:(NSString *)firstStr withString:(NSString *)nextStr
{
    
    NSArray *firstArray = [firstStr componentsSeparatedByString:@"/"];
    NSArray *nextArray = [nextStr componentsSeparatedByString:@"/"];
    NSMutableString *string = [NSMutableString new];
    [string appendString:[self judgeStringValue:firstArray[0]]];
    [string appendString:@"/"];
    [string appendString:[self judgeStringValue:firstArray[1]]];

    [string appendString:@"-"];
    [string appendString:[self judgeStringValue:nextArray[1]]];
    return string;
}

+ (NSString *)judgeStringValue:(NSString *)tempString
{
    NSMutableString *string = [NSMutableString new];
    
    if ([tempString intValue]>10)
    {
        [string appendString:tempString];
    }
    else
    {
        [string appendString:[tempString substringWithRange:NSMakeRange(1, 1)]];
    }
    
    return string;
}

+ (NSDate *)getDateFromTimeStamp:(long int)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return date;
}

+ (NSString *)dateStringFromTimeStamp:(int)timeStamp
{
    NSDate *date = [self getDateFromTimeStamp:timeStamp];
    NSString *dateString = [self dateToString:date withType:4];
    return dateString;
}

+ (NSString *)getLastWeek:(NSString *)date
{
    NSString *lastWeek = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:-7 withType:@"yyyy-MM-dd"];
    return lastWeek;
}

+ (NSString *)getNextWeek:(NSString *)date
{
    NSString *nextWeek = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:7 withType:@"yyyy-MM-dd"];
    return nextWeek;
}

+ (NSString *)getLastDay:(NSString *)date
{
    NSString *lastDay = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:-1 withType:@"yyyy-MM-dd"];
    return lastDay;
}

+ (NSString *)getNextDay:(NSString *)date
{
    NSString *nextDay = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:1 withType:@"yyyy-MM-dd"];
    return nextDay;
}

+ (NSString *)getLastMonth:(NSString *)date
{
    NSString *lastMonth = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:-28 withType:@"yyyy-MM-dd"];
    return lastMonth;
}

+ (NSString *)getNextMonth:(NSString *)date
{
    NSString *nextMonth = [self getTomorrowAndYesterDayByCurrentDate:date byIndex:28 withType:@"yyyy-MM-dd"];
    return nextMonth;
}
+ (NSString *)getTimeFromStartTime:(NSString *)startTime endTime:(NSString *)endTime validTime:(BOOL)valid
{
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
    if (valid) {
        return sportTime;
    }
    else
    {
        return staticTime;
    }
}
+ (NSString *)getAverageTimeFromStartTimes:(NSArray *)startTimes endTimes:(NSArray *)endTimes averageValidTime:(BOOL)valid
{
    int totalSport = 0;//分钟，最后换算回来
    int totalStatic = 0;
    for (NSInteger i = 0; i < startTimes.count; i++)
    {
        NSString *startTime = startTimes[i];
        NSString *endTime = endTimes[i];
        NSString *validString = [self getTimeFromStartTime:startTime endTime:endTime validTime:YES];
        NSString *invalidString = [self getTimeFromStartTime:startTime endTime:endTime validTime:NO];
        int validMinutes = [XlabTools timeFromDateString:validString withType:0]*60 + [XlabTools timeFromDateString:validString withType:1];
        totalSport+= validMinutes;
        int invalidMinutes = [XlabTools timeFromDateString:invalidString withType:0]*60 + [XlabTools timeFromDateString:invalidString withType:1];
        totalStatic+=invalidMinutes;
    }
    totalSport/= startTimes.count;
    totalStatic/= startTimes.count;
    NSString *result;
    if (valid)
    {
        result = [NSString stringWithFormat:@"%d小时%d分钟",totalSport/60,totalSport%60];
    }
    else
    {
        result = [NSString stringWithFormat:@"%d小时%d分钟",totalStatic/60,totalStatic%60];
    }
    return result;
}

+ (NSInteger)getStartTimeForDate:(NSDate *)date
{
    NSInteger year = [self getTimeFromDate:date withType:0];
    NSInteger month = [self getTimeFromDate:date withType:1];
    NSInteger day = [self getTimeFromDate:date withType:2];
    NSString *addDay = @"";
    NSString *addMonth = @"";
    if (day < 10)
    {
        addDay = @"0";
    }
    if (month< 10) {
        addMonth = @"0";
    }
    NSString *startDay = [NSString stringWithFormat:@"%d-%@%d-%@%d",year,addMonth,month,addDay,day];
    NSDate *date1 = [self stringToDate:startDay withtype:2];
    NSInteger time = [date1 timeIntervalSince1970];
    return time;
}

+ (NSInteger)getEndTimeForDate:(NSDate *)date
{
    NSInteger today = [self getStartTimeForDate:date];
    return today+24*3600;
}

+ (NSString *)sleepDurationFromSleepTime:(NSString *)sleepTime getupTime:(NSString *)getupTime
{
    int startHour = [XlabTools timeFromDateString:sleepTime withType:0];
    int startMin = [XlabTools timeFromDateString:sleepTime withType:1];
    int getupHour = [XlabTools timeFromDateString:getupTime withType:0];
    int getupMin = [XlabTools timeFromDateString:getupTime withType:1];
    NSString *duration;
    //默认总是从第一天睡到第二天
    if (startHour>getupHour)
    {
        //还要考虑分钟值
        if (getupMin>=startMin)
        {
            int min = getupMin-startMin;
            int hour = getupHour+24-startHour;
            duration = [NSString stringWithFormat:@"%d小时%d分钟",hour,min];
        }
        else
        {
            int min = getupMin+60-startMin;
            int hour = getupHour+23-startHour;
            duration = [NSString stringWithFormat:@"%d小时%d分钟",hour,min];
        }
    }
    else
    {
        //考虑分钟值
        if (getupMin>=startMin)
        {
            int min = getupMin-startMin;
            int hour = getupHour-startHour;
            duration = [NSString stringWithFormat:@"%d小时%d分钟",hour,min];
        }
        else
        {
            int min = getupMin+60-startMin;
            int hour = getupHour-1-startHour;
            duration = [NSString stringWithFormat:@"%d小时%d分钟",hour,min];
        }
    }
    return duration;
}

+ (NSString *)timeFromTimeString:(NSString *)timeString
{
    int hour = [XlabTools timeFromDateString:timeString withType:0];
    int min = [XlabTools timeFromDateString:timeString withType:1];
    NSString *time = [NSString stringWithFormat:@"%.2d:%.2d",hour,min];
    
    return time;
}

+ (NSString *)currentDate
{
    NSDate *date = [NSDate date];
    NSString *current = [self dateToString:date withType:4];
    return current;
}
+ (NSString *)timeStringFromTime:(NSString *)time
{
    NSArray *strArray = [time componentsSeparatedByString:@":"];
    NSString *hour = strArray[0];
    NSString *minute = strArray[1];
    NSString *timeString = [NSString stringWithFormat:@"%d小时%d分钟",[hour intValue],[minute intValue]];
    return timeString;
}
@end
