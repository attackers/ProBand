//
//  DailyStepDetailModel.h
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface DailyStepDetailModel : BaseModel

@property (nonatomic, strong)NSString *mac;
@property (nonatomic, strong)NSString *time;//时间戳
@property (nonatomic, strong)NSString *steps;//3分钟步数
@property (nonatomic, strong)NSString *meters;
@property (nonatomic, strong)NSString *kCalories;
@property (nonatomic, assign)BOOL isUpload;//是否上传过

+ (DailyStepDetailModel *)convertDataToModel:(NSDictionary *)aDictionary;

@end
