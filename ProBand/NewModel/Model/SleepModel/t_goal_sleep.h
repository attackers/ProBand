//
//  t_goal_sleep.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_goal_sleep : BaseModel

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *mac;

@property (nonatomic, copy)NSString *goal_sleep_time;

@property (nonatomic, copy)NSString *goal_getup_time;

@property (nonatomic, copy)NSString *goal_auto_sleep_switch;

+ (t_goal_sleep *)convertDataToModel:(NSDictionary *)aDcitionary;
@end
