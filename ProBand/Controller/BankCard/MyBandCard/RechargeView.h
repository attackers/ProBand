//
//  RechargeView.h
//  ProBand
//
//  Created by star.zxc on 15/7/8.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeView : UIView

- (void)drawShadeChartViewWithScale:(NSInteger)scale;
@property (nonatomic, assign)NSInteger currentScale;
@end
