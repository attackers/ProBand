//
//  DailyStepDetailModel.m
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DailyStepDetailModel.h"

@implementation DailyStepDetailModel

+ (DailyStepDetailModel *)convertDataToModel:(NSDictionary *)aDictionary
{
    DailyStepDetailModel *instance = [[DailyStepDetailModel alloc]init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}
@end
