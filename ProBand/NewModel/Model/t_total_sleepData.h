//
//  t_total_sleepData.h
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_total_sleepData : BaseModel

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *mac;

@property (nonatomic, copy)NSString *date;

@property (nonatomic, copy)NSString *sleeps;

@property (nonatomic, copy)NSString *total_awake_sleep;

@property (nonatomic, copy)NSString *total_light_sleep;

@property (nonatomic, copy)NSString *total_deep_sleep;

@property (nonatomic, copy)NSString *start_time;

@property (nonatomic, copy)NSString *end_time;

@property (nonatomic, copy)NSString *isUpload;

+ (t_total_sleepData *)convertDataToModel:(NSDictionary *)aDcitionary;
@end
