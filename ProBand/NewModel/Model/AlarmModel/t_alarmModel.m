//
//  t_alarmModel.m
//  ProBand
//
//  Created by DONGWANG on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_alarmModel.h"

@implementation t_alarmModel

+ (t_alarmModel *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_alarmModel *instance = [[t_alarmModel alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}

+ (NSDictionary *)dictionaryFromModel:(t_alarmModel *)model
{
//    NSDictionary *dic = @{@"userid":model.userid,
//                          @"mac":model.mac,
//                          @"alarmId":model.alarmId,
//                          @"from_device":model.from_device,
//                          @"startTimeMinute":model.startTimeMinute,
//                          @"days_of_week":model.days_of_week,
//                          @"interval_time":model.interval_time,
//                          @"notification":model.notification,
//                          @"repeat_switch":model.repeat_switch,
//                          @"interval_switch":model.interval_switch,
//                          @"alarm_switch":model.alarm_switch};
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:model.userid forKey:@"userid"];
    [mDic setValue:model.mac forKey:@"mac"];
    [mDic setValue:model.alarmId forKey:@"alarmId"];
    [mDic setValue:model.from_device forKey:@"from_device"];
    [mDic setValue:model.startTimeMinute forKey:@"startTimeMinute"];
    [mDic setValue:model.days_of_week forKey:@"days_of_week"];
    [mDic setValue:model.interval_time forKey:@"interval_time"];
    [mDic setValue:model.notification forKey:@"notification"];
    [mDic setValue:model.repeat_switch forKey:@"repeat_switch"];
    [mDic setValue:model.interval_switch forKey:@"interval_switch"];
    [mDic setValue:model.alarm_switch forKey:@"alarm_switch"];

    return mDic;
}
@end
