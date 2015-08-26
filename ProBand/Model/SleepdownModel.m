//
//  SleepdownModel.m
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "SleepdownModel.h"

@implementation SleepdownModel


+(SleepdownModel *)convertDataToModel:(NSDictionary *)aDictionary;
{
    SleepdownModel *instance = [[SleepdownModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}
@end
