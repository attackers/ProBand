//
//  BleSinglten.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleMecro.h"
@interface BleSinglten : NSObject
//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey;
+(BOOL)getBoolState:(NSString *)defaultKey;

/**
 *  持久话objc对象类型
 *
 *  @param stringValue 持久化对象类型
 *  @param key         持久话对应的Key
 */
+(void)savePeripheralUUID:(CFUUIDRef)UUID;

+(CFUUIDRef)getSavePeripheralUUID;


+ (void)setIDValue:(id)IDValue withKey:(NSString *)key;
+ (id)getIDFromKey:(NSString *)key;

/**
 *  NSUUID转换成NSString
 *
 *  @param identifier 需要转换的NSUUID
 *
 *  @return 转换好的NSString
 */

+(NSString *)peripheralIdentiferToStringFromNsuuid:(NSUUID *)identifier;



//把星期转化为一个字节
+(char)weekOfDayDistribution:(NSArray *)array;
/**
 *  给字符串特定的位置假如特定的符号
 *
 *  @param insertStr 需要处理的字符串
 *
 *  @return 返回处理好的字符串
 */
+(NSString *)stringConvertAndInsert:(NSString *)insertStr;
/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *  @param ishave 是否需要插入预留位
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype withReserved:(BOOL)ishave;
//获取单个日期或时间，年、月、日、时、分、秒
+ (NSInteger)getCurrentDateorTimeWithIndex:(NSInteger)index;
//UTC时间转成本地时间撮
+(NSTimeInterval)getNSTimeIntervalLocalTimeFromUTC:(NSString *)utcTime;
//把UTC时间转换成本地时间
+ (NSString *)getNowDateFromatAnDate:(NSString *)dateStr;
//获取当前日期
+ (NSString *)getCurentDateByType:(NSString *)type withUTC:(BOOL)isuct;
//计算同一时代（AD|BC）两个日期午夜之间的天数，参数格式必须为yyyy-MM-dd
+ (NSInteger)daysWithinEraFromDate:(NSString *)beforeDay toDate:(NSString *)behindDay;
//蓝牙UTC时间
+ (synchronism_dateAndTime)getCurrentTimeUTC;
@end
