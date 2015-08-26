//
//  t_goal_sleep.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_goal_sleep.h"

@implementation t_goal_sleep

+ (t_goal_sleep *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_goal_sleep *instance = [[t_goal_sleep alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}
@end
