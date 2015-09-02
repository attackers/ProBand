//
//  ExerciseMonthModel.h
//  ProBand
//
//  Created by star.zxc on 15/7/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseMonthModel : NSObject

//元素为：3/23-3/29这样的一个星期
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
