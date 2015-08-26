//
//  t_total_sleepData.m
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_total_sleepData.h"

@implementation t_total_sleepData

+ (t_total_sleepData *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_total_sleepData *instance = [[t_total_sleepData alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}
@end
