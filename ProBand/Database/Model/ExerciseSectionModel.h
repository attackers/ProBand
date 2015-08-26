//
//  ExerciseSectionModel.h
//  ProBand
//
//  Created by star.zxc on 15/8/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseSectionModel : NSObject

@property (nonatomic, strong)NSArray *startArray;

@property (nonatomic, strong)NSArray *endArray;

@property (nonatomic, strong)NSArray *valueArray;

//元素保留一位小数
@property (nonatomic, strong)NSArray *mileArray;
//元素保留一位小数
@property (nonatomic, strong)NSArray *caloryArray;
//保留一位小数
@property (nonatomic, strong)NSArray *speedArray;

//每个时间段：元素为10:30-11:43这样的字符串
@property (nonatomic,strong)NSArray *timeArray;

@end
