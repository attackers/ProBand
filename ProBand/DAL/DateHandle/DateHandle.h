//
//  DateHandle.h
//  LenovoVB10
//
//  Created by jacy on 14/12/18.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandle : NSObject

/**
 *  获取当前日期
 *
 *  @param type  日期格式
 *  @param isuct 是否为utc日期
 *
 *  @return NSString
 */
+ (NSString *)getCurentDateByType:(NSString *)type withUTC:(BOOL)isuct;

/**
 *  日期格式转换 yyyy-MM-dd/yyyyMMdd/yyyy:MM:dd的相互转换
 *
 *  @param date       日期参数
 *  @param beforeType 需要转换的日期格式
 *  @param resultType 转换后的日期格式
 *
 *  @return 返回需要的日期格式
 */
+ (NSString *)getTheDateFrom:(NSString *)date withBeforeType:(NSString *)beforeType withresultType:(NSString *)resultType;
//当前日期的前后第几天,index值为正则是今天以后的日期
/**
 *  当前日期的前后第几天
 *
 *  @param date  当前日期
 *  @param index date的前后第index天，正整数表示后面的第几天，负整数表示前面的第几天
 *  @param type  日期格式 yyyy-MM-dd/yyyyMMdd/yyyy:MM:dd
 *
 *  @return NSString
 */
+ (NSString *)getTomorrowAndYesterDayByCurrentDate:(NSString *)date byIndex:(NSInteger)index  withType:(NSString*)type;

/**
 *  计算同一时代（AD|BC）两个日期午夜之间的相隔天数，参数格式必须为yyyy-MM-dd
 *
 *  @param beforeDay 第一天
 *  @param behindDay 作差的第二天
 *
 *  @return NSInteger
 */
+ (NSInteger)daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;

/**
 *  根据时间字符串获得当前星期几
 *
 *  @param string 日期参数
 *  @param type   日期格式 yyyy-MM-dd/yyyyMMdd/yyyy:MM:dd
 *
 *  @return NSString 星期
 */
+ (NSString *)getWeekFromDate:(NSString *)string withType:(NSString *)type;

/**
 *  根据日期获取该日期所在月的所有日期
 *
 *  @param dateStr 日期参数
 *  @param type    日期格式 yyyy-MM-dd/yyyyMMdd/yyyy:MM:dd
 *
 *  @return NSArray 该日期所对应的月份所有的日期
 */
+ (NSArray *)getdaysArrayByTheDate:(NSString *)dateStr withType:(NSString *)type;

/**
 *  根据日期，获取该日期所在周，月，年的开始日期，结束日期
 *
 *  @param dateStr 日期参数
 *  @param index   0,表示获取改日期对应的周，1表示表示获取改日期对应的月，2表示表示获取改日期对应的年
 *
 *  @return NSArray index为0返回数组所包含的数组为对应该周每天的天、星期、完整日期;index为1返回数组所包含该月所有的日期；index为2返回数组所包含该年所有的日期
 */
+ (NSArray *)getArrayByTheDate:(NSString *)dateStr index:(NSInteger)index;

/**
 *  获取单个日期或时间，年、月、日、时、分、秒
 *
 *  @param index 0,1,2,3,4,5分别表示对应的年、月、日、时、分、秒
 *
 *  @return NSInteger
 */
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index;


/********************添加的方法字符串与日期之间的转换************************/

+(NSString *)dateToString:(NSDate *)aDate withType:(int)type;

//type是转换的格式不一样0是HH:mm其他数是yyyyMMddHHmmss
+(NSDate *)stringToDate:(NSString *)timerStr withtype:(int)type;

//获取当前时间来填充登陆时的model
+ (NSString*) stringOfCurrentTime;

/**
 *  获取某个日期的单个日期或时间，月、日
 *
 *typeStr 原来的日期的格式
 *
 *  @return NSString
 */
+(NSString *)getdateFomatMonthOrDay:(NSString *)dateStr withType:(NSString *)typeStr;


/**
 *
 *获取某个日期的月份
 * 这个日期的格式是yyyy-MM-dd
 */
+(NSString *)getDateMonth:(NSString *)dateStr;

//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd;

//获取某个日期前后几个月的日期
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

/**
 *  合并两个日期的格式，yyyy-MM-dd 转换为 MM/dd-dd
 *
 *  @param firstStr 第一个日期
 *  @param nextStr  第二个日期
 *
 *  @return 返回合并好的日期
 */
+ (NSString *)dateStringConbine:(NSString *)firstStr withString:(NSString *)nextStr;

//下面方法均由Star添加

/**
 *  获取单个日期的年，月，日，时，分，秒
 *
 *  @param date 日期
 *  @param type 0，1，2，3，4，5分别对应年月日时分秒
 *
 *  @return 各分量的值
 */
+ (NSInteger)getTimeFromDate:(NSDate *)date withType:(int)type;

//时间戳转日期
+ (NSDate *)getDateFromTimeStamp:(long int)timeStamp;

//时间戳转日期的字符串:添加by Star
+ (NSString *)dateStringFromTimeStamp:(int)timeStamp;
//根据日期获取一个星期前的日期:日期格式yyyy-MM-dd
+ (NSString *)getLastWeek:(NSString *)date;
//根据日期获取一个星期后的日期
+ (NSString *)getNextWeek:(NSString *)date;
//根据日期获取前一天的日期
+ (NSString *)getLastDay:(NSString *)date;
//获取后一天的日期
+ (NSString *)getNextDay:(NSString *)date;
//获取4个星期前的日期
+ (NSString *)getLastMonth:(NSString *)date;
//获取4个星期后的日期
+ (NSString *)getNextMonth:(NSString *)date;
//从一天的数据开始时间和结束时间得到当天的有效时间和无效时间（静止时间）,valid为yes就是有效时间，否则为无效时间
+ (NSString *)getTimeFromStartTime:(NSString *)startTime endTime:(NSString *)endTime validTime:(BOOL)valid;
//从一段时间的开始时间和结束时间获得该时间段的平均有效时间和平均无效时间,数组元素为字符串
+ (NSString *)getAverageTimeFromStartTimes:(NSArray *)startTimes endTimes:(NSArray *)endTimes averageValidTime:(BOOL)valid;
//获取一天开始的时间戳
+ (NSInteger)getStartTimeForDate:(NSDate *)date;
//获取一天结束的时间戳:就是第二天的开始时间
+ (NSInteger)getEndTimeForDate:(NSDate *)date;
//从入睡时间和出睡时间判断睡眠时间:格式均为xx小时xx分钟
+ (NSString *)sleepDurationFromSleepTime:(NSString *)sleepTime getupTime:(NSString *)getupTime;
//将xx小时xx分钟转化为xx:xx格式
+ (NSString *)timeFromTimeString:(NSString *)timeString;
//yyyy-MM-dd格式的当前日期
+ (NSString *)currentDate;
//将xx:xx格式转化为xx小时xx分钟
+ (NSString *)timeStringFromTime:(NSString *)time;
@end
