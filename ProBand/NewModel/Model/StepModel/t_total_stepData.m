//
//  t_total_stepData.m
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_total_stepData.h"

@implementation t_total_stepData

+ (t_total_stepData *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_total_stepData *instance = [[t_total_stepData alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}
@end
