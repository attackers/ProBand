//
//  stepDetailModel.m
//  LenovoVB10
//
//  Created by fly on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "stepDetailModel.h"

@implementation stepDetailModel
//数据映射
+ (stepDetailModel *)instancesFromDictionary:(NSDictionary *)userinfoDic
{
    stepDetailModel *instance = [[stepDetailModel alloc] init];
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
@end
