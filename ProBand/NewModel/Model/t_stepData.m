//
//  t_stepData.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_stepData.h"

@implementation t_stepData

+ (t_stepData *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_stepData *instance = [[t_stepData alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}

+ (NSDictionary *)dictionaryFromModel:(t_stepData *)model
{
    NSDictionary *dic = @{@"userid":model.userid,
                          @"mac":model.mac,
                          @"time":model.time,
                          @"steps":model.steps,
                          @"meters":model.meters,
                          @"kCalories":model.kCalories,
                          @"isRead":model.isRead};
    return dic;
}
@end
