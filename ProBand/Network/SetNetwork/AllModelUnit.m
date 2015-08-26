//
//  AllModelUnit.m
//  LenovoVB10
//
//  Created by Echo on 15/5/7.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AllModelUnit.h"
#import "SettingStatusUnit.h"
#import "UserTargetUnit.h"
#import "ClockUnit.h"

@implementation AllModelUnit

+ (AllModel *)getAllModel
{
    AllModel *allModel = [AllModel new];
    allModel.setStatusObj = [SettingStatusUnit getSettingStatusData];
    allModel.clockModelArr = [ClockUnit getClockModel];
    allModel.tagetModelObj = [UserTargetUnit getUserTargetInfoObj];
    return allModel;
}


@end
