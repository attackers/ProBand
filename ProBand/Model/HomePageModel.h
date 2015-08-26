//
//  HomePageModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/13.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"
#import "StepdownModel.h"
#import "SleepdownModel.h"

@interface HomePageModel : BaseModel

@property(nonatomic, strong) StepdownModel *stepdownModel;
@property(nonatomic, strong) SleepdownModel *sleepdownModel;

+(NSArray *)getDataModelArrayWIthDate:(NSString *)date;

@end
