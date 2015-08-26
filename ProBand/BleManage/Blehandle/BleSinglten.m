//
//  BleSinglten.m
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BleSinglten.h"

@implementation BleSinglten

//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] setBool:loginState forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolState:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultKey];
}

/**
 *  持久话objc对象类型
 *
 *  @param stringValue 持久化对象类型
 *  @param key         持久话对应的Key
 */
+(void)savePeripheralUUID:(CFUUIDRef)UUID
{
    CFStringRef uuidString = NULL;
    uuidString = CFUUIDCreateString(NULL, UUID);
    
    if (uuidString)
    {
        [[NSUserDefaults standardUserDefaults] setObject:(__bridge id)(uuidString) forKey:@"PeripheraUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CFRelease(uuidString);
}

+(CFUUIDRef)getSavePeripheralUUID
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    
    CFStringRef uuidString = (__bridge CFStringRef)([SaveDefaults objectForKey:@"PeripheraUUID"]);
    CFUUIDRef UUID = CFUUIDCreateFromString(NULL, (CFStringRef)uuidString);
    
    return UUID;
    
}

+ (void)setIDValue:(id)IDValue withKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:IDValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getIDFromKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

/**
 *  NSUUID转换成NSString
 *
 *  @param identifier 需要转换的NSUUID
 *
 *  @return 转换好的NSString
 */

+(NSString *)peripheralIdentiferToStringFromNsuuid:(NSUUID *)identifier{
    
    NSString *identifierString = [identifier UUIDString];
    return identifierString;
}


//把星期转化为一个字节
+(char)weekOfDayDistribution:(NSArray *)array
{
    
    char weekDay = 0;
    for (int i = 0; i<7; i++)
    {
        if ([[array objectAtIndex:i]  isEqual: @YES])
        {
            int n = (int)array.count - 1 - i;
            weekDay = weekDay | (([[array objectAtIndex:i] intValue] &0xFF) << n);
        }
    }
    return weekDay;
}

/**
 *  给字符串特定的位置假如特定的符号
 *
 *  @param insertStr 需要处理的字符串
 *
 *  @return 返回处理好的字符串
 */
+(NSString *)stringConvertAndInsert:(NSString *)insertStr
{
    
    NSMutableString *testString = [NSMutableString new];
    for (int i = 0; i<[insertStr length]/2; i++)
    {
        [testString appendString:[insertStr substringWithRange:NSMakeRange([insertStr length]-i*2-2, 2)]];
    }
    NSMutableString *resultString = [NSMutableString stringWithString:[testString uppercaseString]];
    for (int i = 0; i<[insertStr length]/2 - 1; i++)
    {
        [resultString insertString:@":" atIndex:i*3+2];
    }
    
    return resultString;
}
/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype withReserved:(BOOL)ishave
{
    NSNumber *data = [NSNumber numberWithChar:operatetype];
    char value = [data charValue];
    NSMutableData *charData = [NSMutableData dataWithBytes:&value length:sizeof(char)];
    if (ishave) {
        [charData appendData:[BleSinglten intTochar:SET_RESERVED withReserved:NO]];
    }
    
    return charData;
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
//UTC时间转成本地时间撮
+(NSTimeInterval)getNSTimeIntervalLocalTimeFromUTC:(NSString *)utcTime
{
    //UTC时间转本地时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *anyDate = [dateFormatter dateFromString:utcTime];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval intervalnum = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:intervalnum sinceDate:anyDate];
    //本地时间
    NSString *localTimeStr = [dateFormatter stringFromDate:destinationDateNow];
    
    NSDate *date = [dateFormatter dateFromString:localTimeStr];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    NSLog(@"+>>>utc%@>>>local:%@>>>>%f",utcTime,localTimeStr,interval);
    return interval;
}
//把UTC时间转换成本地时间
+ (NSString *)getNowDateFromatAnDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *anyDate = [dateFormatter dateFromString:dateStr];
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset ;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    NSString *localTimeStr = [dateFormatter stringFromDate:destinationDateNow];
    //    NSLog(@"~~~~~~当前utc时间~~%@~~~对应的本地时间~~~%@",dateStr,localTimeStr);
    
    return localTimeStr;
    
}
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
//计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
+ (NSInteger)daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay
{
    
    //NSLog(@"~~~~~~~~两个日期之间的天数~~~~~~~%@~~~~~~%@",beforeDay,behindDay);
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* startDate = [inputFormatter dateFromString:beforeDay];
    NSDate *endDate = [inputFormatter dateFromString:behindDay];
   // NSLog(@"~~~~~~~~转换后的日期~~~~~~~%@~~~~~~%@",startDate,endDate);
    NSLog(@"计算两个日期午夜之间的天数");

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", [components day]);
    return [components day];
    
}
//蓝牙UTC时间
+ (synchronism_dateAndTime)getCurrentTimeUTC
{
    synchronism_dateAndTime synchronismDateAndTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.yesr = [dateString integerValue];
    
    [dateFormatter setDateFormat:@"MM"];
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.month = [dateString integerValue];
    
    [dateFormatter setDateFormat:@"dd"];
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.date = [dateString integerValue];
    
    [dateFormatter setDateFormat:@"HH"];
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.hour = [dateString integerValue];
    
    
    [dateFormatter setDateFormat:@"mm"];
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.minute = [dateString integerValue];
    
    [dateFormatter setDateFormat:@"ss"];
    dateString = [dateFormatter stringFromDate:[NSDate date]];
    synchronismDateAndTime.seconds = [dateString integerValue];
    
    return synchronismDateAndTime;
}
@end
