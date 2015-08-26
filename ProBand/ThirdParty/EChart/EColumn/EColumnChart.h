//
//  EColumnChart.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumn.h"
#import "EColumnDataModel.h"
@class EColumnChart;

@protocol EColumnChartDataSource <NSObject>

/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart;

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart;

/** The hightest vaule among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart;

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                        valueForIndex:(NSInteger)index;

@optional
/** Allow you to customize the color of every coloum as you wish.*/
- (UIColor *) colorForEColumn:(EColumn *)eColumn;

/** New protocals coming soon, will allow you to customize column*/



@end


@protocol EColumnChartDelegate <NSObject>

/** When finger single taped the column*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
             didSelectColumn:(EColumn *) eColumn;

/** When finger enter specific column, this is dif from tap*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn;

/** When finger leaves certain column, will
 tell you which column you are leaving*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn;

/** When finger leaves wherever in the chart,
 will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart;

@end



@interface EColumnChart : UIView <EColumnDelegate>
@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

@property (nonatomic, strong) UIColor *minColumnColor;
@property (nonatomic, strong) UIColor *maxColumnColor;
@property (nonatomic, strong) UIColor *normalColumnColor;

@property (nonatomic) BOOL showHighAndLowColumnWithColor;

/** If this switch in on, all horizontal labels will show in Integer. */
@property (nonatomic) BOOL showHorizontalLabelsWithInteger;

/** IMPORTANT: 
    This should be setted before datasoucre has been set.*/
@property (nonatomic) BOOL columnsIndexStartFromLeft;

/** Pull out the columns hidden in the left*/
- (void)moveLeft;

/** Pull out the columns hidden in the right*/
- (void)moveRight;

- (void)initData;

/** Call to redraw the whole chart*/
- (void)reloadData;

@property (weak, nonatomic) id <EColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <EColumnChartDelegate> delegate;

//添加by Star
@property (nonatomic, strong)NSArray *pillarWidths;
@property (nonatomic, strong)NSArray *spaceWidths;
//各个图柱的间距
@property (nonatomic, assign)CGFloat spaceWidth;
//各个图柱的宽度
@property (nonatomic, assign)CGFloat pillarWidth;
//各个图柱三色值:每个元素为包含3个元素的数组
@property (nonatomic, strong)NSArray *valueArray;
//各个图柱各部分颜色
@property (nonatomic, strong)NSArray *colorArray;
//下面label的类型：0表示标准类型，1表示从最最端到最右端均匀分布，2表示位于每个柱子下方
@property (nonatomic, assign)int columnLabelType;
@end
