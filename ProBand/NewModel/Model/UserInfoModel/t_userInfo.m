//
//  t_userInfo.m
//  ProBand
//
//  Created by star.zxc on 15/8/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "t_userInfo.h"

@implementation t_userInfo

+ (t_userInfo *)convertDataToModel:(NSDictionary *)aDcitionary
{
    t_userInfo *instance = [[t_userInfo alloc]init];
    [instance setAttributesFromDictionary:aDcitionary];
    return instance;
}

@end
