//
//  t_alarmModel.h
//  ProBand
//
//  Created by DONGWANG on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface t_alarmModel : BaseModel


@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *alarmId;
@property (nonatomic, strong) NSString *from_device;
@property (nonatomic, strong) NSString *startTimeMinute;
@property (nonatomic, strong) NSString *days_of_week;
@property (nonatomic, strong) NSString *interval_time;
@property (nonatomic, strong) NSString *notification;
//@property (nonatomic, strong) NSString *smart_switch;
@property (nonatomic, strong) NSString *repeat_switch;
@property (nonatomic, strong) NSString *interval_switch;
@property (nonatomic, copy)NSString *alarm_switch;


+ (t_alarmModel *)convertDataToModel:(NSDictionary *)aDcitionary;

+ (NSDictionary *)dictionaryFromModel:(t_alarmModel *)model;
@end
