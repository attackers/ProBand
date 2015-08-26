//
//  t_sleepData.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_sleepData.h"

@implementation t_sleepData

+ (t_sleepData *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_sleepData *instance = [[t_sleepData alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}

+ (NSDictionary *)dictionaryFromModel:(t_sleepData *)model
{
    NSDictionary *dic = @{@"userid":model.userid,
                          @"mac":model.mac,
                          @"time":model.time,
                          @"sleeps":model.sleeps,
                          @"isRead":model.isRead};
    return dic;
}
@end
