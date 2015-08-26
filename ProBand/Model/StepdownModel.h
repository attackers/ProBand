//
//  StepdownModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface StepdownModel : BaseModel
//计步下半页对应的数据
@property (nonatomic, strong) NSString *Id;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *mac;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *steps;//步数详情
@property(nonatomic,strong) NSString *meters;//距离详情
@property(nonatomic,strong) NSString *calories;//卡路里详情
@property(nonatomic,strong) NSString *totalSteps;
@property(nonatomic,strong) NSString *totalDistance;
@property(nonatomic,strong) NSString *totalCalories;
@property(nonatomic,strong) NSString *sportDuration;//运动总耗时

+(StepdownModel *)convertDataToModel:(NSDictionary *)aDictionary;
@end
