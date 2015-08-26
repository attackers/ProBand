//
//  t_goal_exercise.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_goal_exercise.h"

@implementation t_goal_exercise

+ (t_goal_exercise *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_goal_exercise *instance = [[t_goal_exercise alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}
@end
