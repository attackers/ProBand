//
//  t_total_exerciseData.m
//  ProBand
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_total_exerciseData.h"

@implementation t_total_exerciseData

+ (t_total_exerciseData *)convertDataToModel:(NSDictionary *)aDictionary
{
    t_total_exerciseData *model = [[t_total_exerciseData alloc]init];
    if (aDictionary) {
        [model setAttributesFromDictionary:aDictionary];
    }
    return model;
}
@end
