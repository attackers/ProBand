//
//  AlarmManager.h
//  ProBand
//
//  Created by DONGWANG on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "t_alarmModel.h"

@interface AlarmManager : NSObject

//插入或者更新闹钟数据
+ (void)insertOrUpdateAlarmData:(t_alarmModel *)alarmModel;

+ (NSDictionary *)dictionaryFromModel:(t_alarmModel *)model;

//获取数据库中所有的闹钟数据
+ (NSArray *)getAlarmDicFromDB;
//总分钟数转换成格式时间
+ (NSString *)minuteToTime:(NSString *)minuteStr;
//删除单个的闹钟
+ (void)removeAlarm:(NSString *) ID;
//将星期转化为从高到低的零一（从星期日到星期一）
+(NSArray *)sortWeek:(NSString *)str;

//直接插入新的闹钟:添加by Star
+ (void)insertNewAlarm:(t_alarmModel *)alarmModel;
//获取目前闹钟id的最大值
+ (int)getMaxAlarmId;
@end
