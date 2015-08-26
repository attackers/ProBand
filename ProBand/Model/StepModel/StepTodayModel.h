//
//  StepTodayModel.h
//  LenovoVB10
//
//  Created by fly on 15/4/27.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface StepTodayModel : BaseModel
@property (nonatomic, copy)NSString *stepDate;
@property(nonatomic,copy) NSString *stepDuration;
@property(nonatomic,copy) NSString *stepTotalCounts;
@property(nonatomic,copy) NSString *stepDistance;
@property(nonatomic,copy) NSString *stepCol;
@property (nonatomic, strong)NSArray *stepArray;
@property (nonatomic, strong)NSArray *colArray;
@property (nonatomic, strong)NSArray *distanceArray;
@property(nonatomic,strong) NSArray *stepDateArray;  //日期Array
@property(nonatomic,strong) NSArray *stepDurationArray;  //日期Array
//数据映射
+ (StepTodayModel *)instancesFromDictionary:(NSDictionary *)userinfoDic;
- (void)setAttributesFromDictionary:(NSDictionary *)userInfoDic;
@end
