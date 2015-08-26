//
//  t_goal_step.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_goal_step.h"

@implementation t_goal_step

+ (t_goal_step *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_goal_step *instance = [[t_goal_step alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}
@end
