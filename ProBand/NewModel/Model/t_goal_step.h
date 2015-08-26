//
//  t_goal_step.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_goal_step : BaseModel

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *mac;

@property (nonatomic, copy)NSString *goal_step;

@property (nonatomic, copy)NSString *goal_kcal;

@property (nonatomic, copy)NSString *goal_time;

@property (nonatomic, copy)NSString *goal_distance;

+ (t_goal_step *)convertDataToModel:(NSDictionary *)aDcitionary;

@end
