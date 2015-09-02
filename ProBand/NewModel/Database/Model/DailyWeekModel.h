//
//  DailyWeekModel.h
//  ProBand
//
//  Created by star.zxc on 15/7/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyWeekModel : NSObject
//7天的日期:最新日期为今天所在的星期
@property (nonatomic, strong)NSArray *dateArray;

@property (nonatomic, strong)NSArray *valueArray;

//上半部分的描述语句
@property (nonatomic, strong)NSArray *upDescribeArray;
//下半部分的描述语句
@property (nonatomic, strong)NSArray *downDescribeArray;
//上半部分的取值：元素为字符串
@property (nonatomic, strong)NSArray *upValueArray;
//下半部分的取值：元素为字符串
@property (nonatomic, strong)NSArray *downValueArray;
@end
