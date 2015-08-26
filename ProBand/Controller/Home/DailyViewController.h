//
//  DailyViewController.h
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//


#import "EShadeChartDataModel.h"

@interface DailyViewController : BaseViewController

- (void)drawShadeChartView:(EShadeChartDataModel *)data
             withLineWidth:(CGFloat)lineWidth
                  withShow:(BOOL)blean;

@end
