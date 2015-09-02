//
//  AlarmManager.m
//  ProBand
//
//  Created by DONGWANG on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AlarmManager.h"

@implementation AlarmManager


+ (void)insertOrUpdateAlarmData:(t_alarmModel *)alarmModel
{
    
    NSString *selectStr = [NSString stringWithFormat:@"select count(*) from t_alarm where alarmId = '%@'",alarmModel.alarmId];
    
    NSString *Updatesql = [NSString stringWithFormat:@"UPDATE t_alarm SET  from_device = '%@', startTimeMinute = '%@', days_of_week = '%@', interval_time = '%@', notification = '%@', repeat_switch = '%@', interval_switch = '%@', alarm_switch = '%@',userid= '%@' ,mac = '%@' where alarmId = '%@'",
                     alarmModel.from_device,
                     alarmModel.startTimeMinute,
                     alarmModel.days_of_week,
                     alarmModel.interval_time,
                     alarmModel.notification,
                     alarmModel.repeat_switch,
                     alarmModel.interval_switch,
                     alarmModel.alarm_switch,
                     [Singleton getUserID],
                     alarmModel.mac,
                    alarmModel.alarmId];
    
    NSString *Insertsql = [NSString stringWithFormat:@"INSERT INTO  t_alarm (userid, mac, alarm_switch, interval_switch, repeat_switch, notification, interval_time, days_of_week, startTimeMinute, from_device,alarmId) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@') ",
                           alarmModel.userid,
                           alarmModel.mac,
                           alarmModel.alarm_switch,
                           alarmModel.interval_switch,
                           alarmModel.repeat_switch,
                           alarmModel.notification,
                           alarmModel.interval_time,
                           alarmModel.days_of_week,
                           alarmModel.startTimeMinute,
                           alarmModel.from_device,
                           alarmModel.alarmId];
    
    [DBOPERATOR insertDataToSQL:Insertsql updatesql:Updatesql withExsitSql:selectStr];
}


+ (NSDictionary *)dictionaryFromModel:(t_alarmModel *)model
{
    NSDictionary *dic = @{@"userid":model.userid,
                          @"mac":model.mac,
                          @"alarmId":model.alarmId,
                          @"from_device":model.from_device,
                          @"startTimeMinute":model.startTimeMinute,
                          @"days_of_week":model.days_of_week,
                          @"interval_time":model.interval_time,
                          @"notification":model.notification,
                          @"repeat_switch":model.repeat_switch,
                          @"interval_switch":model.interval_switch,
                          @"alarm_switch":model.alarm_switch
                          };
    return dic;
}


+ (NSArray *)getAlarmDicFromDB
{
    NSArray *alarmData = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_alarm where userid = '%@'",[Singleton getUserID]]];
    if ([alarmData count]>0)
    {
        return alarmData;
    }
    return nil;
}

+ (NSString *)minuteToTime:(NSString *)minuteStr
{
    NSString *hour = [NSString stringWithFormat:@"%.2d", [minuteStr intValue]/60];
    NSString *min = [NSString stringWithFormat:@"%.2d", [minuteStr intValue]%60];
    NSString *time = [NSString stringWithFormat:@"%@:%@",hour,min];
    return time;
}

//删除单个的闹钟
+ (void)removeAlarm:(NSString *) ID
{
    [DBOPERATOR deleteDataToSqlitewithSqlexsit:
     [NSString stringWithFormat:@"select * from t_alarm where userid = '%@' and alarmId = '%@'",[Singleton getUserID],ID]
    deleteSql:[NSString stringWithFormat:@"DELETE FROM t_userInfo WHERE ID = %@",ID]];
}


//将星期转化为从高到低的零一（从星期日到星期一）
+(NSArray *)sortWeek:(NSString *)str
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i<str.length; i++) {
        
        NSString *s = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
        [arr addObject:s];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:arr[0], nil];
    for (int i = (int)(arr.count - 1); i>=1; i--) {
        [tempArray addObject:arr[i]];
    }
    [arr removeAllObjects];
    arr = [NSMutableArray array];
    for (int i = 0; i <tempArray.count; i++) {
        
        if ([[tempArray objectAtIndex:i] isEqualToString:@"1"]) {
            [arr addObject:@YES];
        }
        else
        {
            [arr addObject:@NO];
        }
    }
    
    // NSLog(@"---星期转换---%@",arr);
    return arr;
}
//添加by Star
+ (void)insertNewAlarm:(t_alarmModel *)alarmModel
{
    if (alarmModel) {
        NSDictionary *dic = [t_alarmModel dictionaryFromModel:alarmModel];
        [DBMANAGER insertSingleDataToDB:@"t_alarm" withDictionary:dic];
    }
}
+ (int)getMaxAlarmId
{
    NSArray *array = [DBMANAGER allDataFromDB:@"t_alarm"];
    int alarmId = 1;
    for (NSDictionary *dic in array)
    {
        int newId = [dic[@"alarmId"] intValue];
        if (newId>alarmId) {
            alarmId = newId;
        }
    }
    return alarmId;
}

@end
