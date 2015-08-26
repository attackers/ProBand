//
//  StepTodayModel.m
//  LenovoVB10
//
//  Created by fly on 15/4/27.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "StepTodayModel.h"

@implementation StepTodayModel
//数据映射
+ (StepTodayModel *)instancesFromDictionary:(NSDictionary *)userinfoDic
{
    StepTodayModel *instance = [[StepTodayModel alloc] init];
    [instance setAttributesFromDictionary:userinfoDic];
    return instance;
    
}


- (void)setAttributesFromDictionary:(NSDictionary *)userInfoDic
{
    if (![userInfoDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    [self setValuesForKeysWithDictionary:userInfoDic];
}


- (NSString *)description
{
    return [NSString stringWithFormat: @"+>>>>>>>>%@+++++%d",self.stepDateArray,[self.stepDateArray count]];
}
@end
