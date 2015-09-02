//
//  SleepDayModel.h
//  ProBand
//
//  Created by star.zxc on 15/7/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepDayModel : NSObject

//是480个点or处理过的数据？首先是480个点,后期进行处理
@property (nonatomic, strong)NSArray *valueArray;
//当日日期
@property (nonatomic, copy)NSString *date;

//上半部分的描述语句
@property (nonatomic, strong)NSArray *upDescribeArray;
//下半部分的描述语句
@property (nonatomic, strong)NSArray *downDescribeArray;
//上半部分的取值：元素为字符串
@property (nonatomic, strong)NSArray *upValueArray;
//下半部分的取值：元素为字符串
@property (nonatomic, strong)NSArray *downValueArray;
@end
