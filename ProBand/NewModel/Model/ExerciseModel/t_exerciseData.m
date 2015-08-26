//
//  t_exerciseData.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_exerciseData.h"

@implementation t_exerciseData

+ (t_exerciseData *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_exerciseData *instance = [[t_exerciseData alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}

+ (NSDictionary *)dictionaryFromModel:(t_exerciseData *)model
{
    NSDictionary *dic = @{@"userid":model.userid,
                          @"mac":model.mac,
                          @"time":model.time,
                          @"exercise":model.exercise,
                          @"steps":model.steps,
                          @"meters":model.meters,
                          @"kCalories":model.kCalories,
                          @"isRead":model.isRead};
    return dic;
}
@end
