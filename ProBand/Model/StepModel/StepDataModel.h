//
//  StepDataModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/18.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"
#import "StepdownModel.h"
@interface StepDataModel : BaseModel
@property (nonatomic, strong) NSString *Id;

//补全后的日期存放的数组，方便后面处理.
@property (nonatomic, strong)NSArray *originalFullStepArray;

//日
@property(nonatomic,strong) NSArray *everyDayStepArray;
@property(nonatomic,strong) NSString *everydayTitle;
//周
@property(nonatomic,strong) NSArray *weekDayStepArray;
@property(nonatomic,strong) NSArray *weekDayTitleArray;
//月
@property(nonatomic,strong) NSArray *monthStepArray;
@property(nonatomic,strong) NSArray *monthTitleArray;
@property(nonatomic,strong) NSString *monthStr;

@property(nonatomic, strong) StepdownModel *stepdownModel;

+(NSArray *)getDaysStepDatawithCurrentDayUpdata:(NSArray *)homeArray withindex:(NSInteger)index;
@end
