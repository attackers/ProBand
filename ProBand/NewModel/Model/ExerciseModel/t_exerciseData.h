//
//  t_exerciseData.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_exerciseData : BaseModel

@property (nonatomic, copy)NSString  *userid;

@property (nonatomic, copy)NSString  *mac;

@property (nonatomic, copy)NSString  *time;

@property (nonatomic, copy)NSString  *exercise;

@property (nonatomic, copy)NSString  *steps;

@property (nonatomic, copy)NSString  *meters;

@property (nonatomic, copy)NSString  *kCalories;

@property (nonatomic, copy)NSString  *isRead;

+ (t_exerciseData *)convertDataToModel:(NSDictionary *)aDcitionary;

+ (NSDictionary *)dictionaryFromModel:(t_exerciseData *)model;
@end
