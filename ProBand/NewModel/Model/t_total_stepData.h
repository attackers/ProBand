//
//  t_total_stepData.h
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_total_stepData : BaseModel

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *mac;

@property (nonatomic, copy)NSString *date;

@property (nonatomic, copy)NSString *steps;

@property (nonatomic, copy)NSString *meters;

@property (nonatomic, copy)NSString *kCalories;

@property (nonatomic, copy)NSString *total_step;

@property (nonatomic, copy)NSString *total_meter;

@property (nonatomic, copy)NSString *total_kCalory;

@property (nonatomic, copy)NSString *start_time;

@property (nonatomic, copy)NSString *end_time;

@property (nonatomic, copy)NSString *isUpload;

+ (t_total_stepData *)convertDataToModel:(NSDictionary *)aDcitionary;
@end
