//
//  SectionModel.h
//  ProBand
//
//  Created by star.zxc on 15/8/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//对一天的数据进行分段的model，分为开始时间点的数组，结束时间点的数组，和数值的数组

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject

@property (nonatomic, strong)NSArray *startArray;

@property (nonatomic, strong)NSArray *endArray;

@property (nonatomic, strong)NSArray *valueArray;
@end
