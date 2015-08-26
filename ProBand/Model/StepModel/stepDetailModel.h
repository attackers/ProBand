//
//  stepDetailModel.h
//  LenovoVB10
//
//  Created by fly on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stepDetailModel : NSObject
@property(nonatomic,copy) NSString *stepTotalCounts;
@property(nonatomic,copy) NSString *stepTotalCol;
@property(nonatomic,copy) NSString *stepTotalDistance;
@property(nonatomic,copy) NSString *stepTotalDuration;
@property(nonatomic,copy) NSString *stepDate;

//数据映射
+ (stepDetailModel *)instancesFromDictionary:(NSDictionary *)userinfoDic;
- (void)setAttributesFromDictionary:(NSDictionary *)userInfoDic;

@end
