//
//  SleepDataModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"
#import "SleepdownModel.h"

@interface SleepDataModel : BaseModel
//日
@property (nonatomic, strong) NSString *Id;
@property(nonatomic,strong) NSArray *everyDaySleepArray;
@property(nonatomic,strong) NSString *everydayTitle;
//周
@property(nonatomic,strong) NSArray *weekDaySleepArray;
@property(nonatomic,strong) NSArray *weekDayTitleArray;
//月
@property(nonatomic,strong) NSArray *monthSleepArray;
@property(nonatomic,strong) NSArray *monthTitleArray;
@property(nonatomic,strong) NSString *monthStr;

@property(nonatomic, strong) SleepdownModel *sleepdownModel;
//此处数据全为测试数据
+(NSArray *)getDaysSleepDatawithCurrentDayUpdata:(NSArray *)homeArray withindex:(NSInteger)index;

+(NSArray *)getDaysSleepInfo;
@end
