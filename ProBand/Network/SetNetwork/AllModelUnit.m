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
#import "AlarmManager.h"
@implementation AllModelUnit

+ (AllModel *)getAllModel
{
    AllModel *allModel = [AllModel new];
    allModel.setStatusObj = [SettingStatusUnit getSettingStatusData];
    
    NSMutableArray *alarmArray = [NSMutableArray new];
    NSArray *temArray = [AlarmManager getAlarmDicFromDB];
    if ([temArray count]>0)
    {
        [temArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            t_alarmModel *alarmModel = [t_alarmModel convertDataToModel:obj];
            [alarmArray addObject:alarmModel];
        }];
    }
    
    allModel.clockModelArr = alarmArray;
    
    
    
    
    //allModel.tagetModelObj = [UserTargetUnit getUserTargetInfoObj];
    return allModel;
}


@end
