//
//  DetailChartView.h
//  ProBand
//
//  Created by star.zxc on 15/6/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
@interface DetailChartView : UIView
@property (nonatomic, strong)EColumnChart *eColumnChart;
//图表的颜色:分段的怎么表示
//@property (nonatomic, strong)UIColor *chartColor;
/**
 *  两根柱子之间的空间：不均匀分布
 */
@property (nonatomic, strong)NSArray *spaceArray;
/**
 *  每根柱子的宽度
 */
@property (nonatomic, strong)NSArray *widthArray;
/**
 *  图表类型：0纯色柱状图、1分段色柱状图、2多色柱状图
 */
@property (nonatomic, assign)int chartType;
/**
 *  绘制新的柱状图:均匀分布,是否可能没有完全显示
 *
 *  @param dateArray   日期数组
 *  @param valueArray  每个柱子的高度：屏幕上需要显示多少列
 *  @param pillarWidth 均匀绘制的情况下每个柱子的宽度
 *  @param spaceWidth  两根柱子的间距
 *  @param columnLabelType 下方label的类型：0为标准类型，1会从最左边开始,2在每个柱子正下方
 */
- (void)drawChartViewWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray pillarWidth:(CGFloat)pillarWidth spaceWidth:(CGFloat)spaceWidth columnLabelType:(int)columnLabelType chartColor:(UIColor *)chartColor;
/**
 *  绘制不均匀分布的三色图
 *
 *  @param dateArray    日期数组：屏幕上需要显示多少列
 *  @param valueArray   每个柱子的高度以及各部分的高度:元素为3个元素的数组
 *  @param colorArray   三色柱子各部分的颜色
 *  @param pillarWidths 各个柱子的宽度
 *  @param spaceWidths  各个柱子的间距
 */
- (void)drawUnpureChartViewWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType;
/**
 *  绘制均匀分布的三色图
 *
 *  @param dateArray   日期数组：屏幕上需要显示多少列
 *  @param valueArray  每个柱子的高度以及各部分的高度:元素为3个元素的数组
 *  @param colorArray  三色柱子各部分的颜色
 *  @param pillarWidth 各个柱子的宽度
 *  @param spaceWidth  各个柱子的间距
 */
- (void)drawColorfulChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray pillarWidth:(CGFloat)pillarWidth spaceWidth:(CGFloat)spaceWidth columnLabelType:(int)columnLabelType;
/**
 *  绘制不均匀分布的纯色图
 *
 *  @param dateArray    日期数组
 *  @param valueArray   每个柱子的高度
 *  @param pillarWidths 各个柱子的宽度
 *  @param spaceWidths  各个柱子的间距
 */
- (void)drawUnQualblyChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType chartColor:(UIColor *)chartColor;
/**
 *  绘制各个柱子颜色不同的图
 *
 *  @param dateArray        日期数组
 *  @param valueArray       每个柱子的高度
 *  @param columnColorArray 各个柱子的颜色
 *  @param pillarWidths     各个柱子的宽度
 *  @param spaceWidths      柱子的间距
 */
- (void)drawDifferentColorColumnChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray columnColorArray:(NSArray *)columnColorArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType;
@end
