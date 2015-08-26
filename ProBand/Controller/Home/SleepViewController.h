//
//  SleepViewController.h
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "EPieChartDataModel.h"
#import "EPieChart.h"

@interface SleepViewController : BaseViewController<EPieChartDelegate, EPieChartDataSource>

@property (strong, nonatomic) EPieChart *ePieChart;

- (void)drawViewwithData:(EPieChartDataModel *)dataModel showColor:(BOOL)blean;

@end
