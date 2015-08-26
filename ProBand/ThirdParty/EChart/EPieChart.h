//
//  EPieChart.h
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPieChartDataModel.h"
#import "EPie.h"
@class EPie;
@class EPieChart;

@protocol EPieChartDataSource <NSObject>

@optional
//DataSource方法，定制前视图，没有实现则为默认
- (UIView *) frontViewForEPieChart:(EPieChart *) ePieChart;

//DataSource方法，定制后视图，没有实现则为默认
- (UIView *) backViewForEPieChart:(EPieChart *) ePieChart;

@end

@protocol EPieChartDelegate <NSObject>

@optional
//返回饼图前面修改界面在此操作
- (void)ePieChart:(EPieChart *)ePieChart
  didTurnToFrontViewWithFrontView:(UIView *)frontView;

//返回饼图后面修改界面在此操作
- (void)ePieChart:(EPieChart *)ePieChart
    didTurnToBackViewWithBackView:(UIView *)backView;

@end


@interface EPieChart : UIView

@property (strong, nonatomic) EPie *frontPie;

@property (strong, nonatomic) EPie *backPie;

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

@property (nonatomic) BOOL isUpsideDown;

@property (weak, nonatomic) id <EPieChartDelegate> delegate;

@property (weak ,nonatomic) id <EPieChartDataSource> dataSource;
@property (nonatomic)BOOL isSleep;

- (id)initWithFrame:(CGRect)frame
 ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel withIsSleep:(BOOL)b;

//饼图前后反转
- (void) turnPie;

@end




