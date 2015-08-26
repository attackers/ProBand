//
//  EPieChartDataModel.m
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import "EPieChartDataModel.h"

@implementation EPieChartDataModel
@synthesize current = _current;
@synthesize budget = _budget;
@synthesize estimate = _estimate;


- (id)init
{
    self = [super init];
    if (self)
    {
        _budget = 100;
        _current = 40;
        _estimate = 80;
    }
    return self;
}
/**
 *
 *
 *  @param budget   目标值（总值）
 *  @param current  当前值
 *  @param estimate 预计值 
 *
 *  @return id
 */
- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate bgimageOne:(NSString *)str1 bgimageTwo:(NSString *)str2 bgimageThree:(NSString *)str3
{
    self = [self init];
    if (self)
    {
        _budget = budget;
        _current = current;
        _estimate = estimate;
        _bgImageNameOne = str1;
        _bgImageNameTwo = str2;
        _bgImageNameThree = str3;
    }
    return self;
}

@end
