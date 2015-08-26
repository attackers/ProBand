//
//  DetailChartView.m
//  ProBand
//
//  Created by star.zxc on 15/6/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DetailChartView.h"
typedef enum
{
    EQUALBLY_CHART,//均匀纯色的图表
    UNQUALBLY_CHART,//不均匀但是纯色的图表
    UNPURE_EQUALBLY_CHART,//均匀但是三色的图表
    PURE_UNEQUALBLY_CHART,//既不均匀也不纯色的图表
    DIFFERENT_COLOR_COLUMN_CHART,//柱子颜色不同的图表
}chartType;
@interface DetailChartView ()<EColumnChartDelegate,EColumnChartDataSource>
{
    NSMutableArray *_data;
    NSArray *_columnColorArray;//不同柱子的颜色
}
@end
@implementation DetailChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//绘制均匀的纯色图:加入渐变效果
- (void)drawChartViewWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray pillarWidth:(CGFloat)pillarWidth spaceWidth:(CGFloat)spaceWidth columnLabelType:(int)columnLabelType chartColor:(UIColor *)chartColor
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i ++)
    {
        NSNumber *value = valueArray[i];
        if (columnLabelType == 1)
        {
            EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithValue:[value floatValue] index:i unit:nil];
            [temp addObject:dataModel];
        }
        else
        {
        EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithLabel:dateArray[i] value:[value floatValue] index:i unit:nil];
            [temp addObject:dataModel];
        }
    }
    _data = [NSMutableArray arrayWithArray:temp];
    _eColumnChart = [[EColumnChart alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_eColumnChart setDelegate:self];
    _eColumnChart.tag = EQUALBLY_CHART;
    
    _eColumnChart.normalColumnColor = chartColor;
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    _eColumnChart.pillarWidth = pillarWidth;
    _eColumnChart.spaceWidth = spaceWidth;
    _eColumnChart.columnLabelType = columnLabelType;
    if (columnLabelType == 1 && dateArray.count > 1)//自己添加下方的label
    {
        for (int i = 0; i < dateArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-50)*i/(dateArray.count-1), self.frame.size.height, 50, 20)];
            label.text = dateArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.8;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    [_eColumnChart setDataSource:self];
    [self addSubview:_eColumnChart];
}
//绘制三色的柱状图:colorArray每个元素为包含3种颜色的数组,valueArray的元素为包含3个元素的数组
- (void)drawUnpureChartViewWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType
{
    
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i ++)
    {
         NSArray *values = valueArray[i];
        float value = 0;
        for (int j = 0; j < 3; j ++)
        {
            NSNumber *number = values[j];
            value+= [number floatValue];
        }
        EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithLabel:dateArray[i] value:value index:i unit:nil];
        [temp addObject:dataModel];
    }
    _data = [NSMutableArray arrayWithArray:temp];
    _eColumnChart = [[EColumnChart alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_eColumnChart setDelegate:self];
    _eColumnChart.tag = PURE_UNEQUALBLY_CHART;
    //添加各种属性
    _eColumnChart.pillarWidths = [NSArray arrayWithArray:pillarWidths];
    _eColumnChart.spaceWidths = [NSArray arrayWithArray:spaceWidths];
    _eColumnChart.valueArray = [NSArray arrayWithArray:valueArray];
    _eColumnChart.colorArray = [NSArray arrayWithArray:colorArray];
    _eColumnChart.columnLabelType = columnLabelType;
    _eColumnChart.normalColumnColor = [UIColor brownColor];
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    if (columnLabelType == 1 && dateArray.count > 1)//自己添加下方的label
    {
        for (int i = 0; i < dateArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-50)*i/(dateArray.count-1), self.frame.size.height, 50, 20)];
            label.text = dateArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.8;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    [_eColumnChart setDataSource:self];
    [self addSubview:_eColumnChart];
}
//绘制均匀的三色图
- (void)drawColorfulChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray pillarWidth:(CGFloat)pillarWidth spaceWidth:(CGFloat)spaceWidth columnLabelType:(int)columnLabelType
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i ++)
    {
        NSArray *values = valueArray[i];
        float value = 0;
        //int value = 0;
        for (int j = 0; j < 3; j ++)
        {
            NSNumber *number = values[j];
            //value+= [number floatValue];
            value+=[number intValue];
        }
        EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithLabel:dateArray[i] value:value index:i unit:nil];
        [temp addObject:dataModel];
    }
    _data = [NSMutableArray arrayWithArray:temp];
    _eColumnChart = [[EColumnChart alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_eColumnChart setDelegate:self];
    _eColumnChart.tag = UNPURE_EQUALBLY_CHART;
    //添加各种属性
    _eColumnChart.valueArray = [NSArray arrayWithArray:valueArray];
    _eColumnChart.colorArray = [NSArray arrayWithArray:colorArray];
    _eColumnChart.pillarWidth = pillarWidth;
    _eColumnChart.spaceWidth = spaceWidth;
    _eColumnChart.columnLabelType = columnLabelType;
    _eColumnChart.normalColumnColor = [UIColor brownColor];
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    if (columnLabelType == 1 && dateArray.count > 1)//自己添加下方的label
    {
        for (int i = 0; i < dateArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-50)*i/(dateArray.count-1), self.frame.size.height, 50, 20)];
            label.text = dateArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.8;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    [_eColumnChart setDataSource:self];
    [self addSubview:_eColumnChart];
}

- (void)drawUnQualblyChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType chartColor:(UIColor *)chartColor
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i ++)
    {
        NSNumber *value = valueArray[i];
        if (columnLabelType != 1) {
            EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithLabel:dateArray[i] value:[value floatValue] index:i unit:nil];
            
            [temp addObject:dataModel];
        }
        else
        {
            EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithValue:[value floatValue] index:i unit:nil];
            [temp addObject:dataModel];
        }
    }
    _data = [NSMutableArray arrayWithArray:temp];
    _eColumnChart = [[EColumnChart alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_eColumnChart setDelegate:self];
    _eColumnChart.tag = UNQUALBLY_CHART;
    
    _eColumnChart.normalColumnColor = chartColor;//COLOR(28, 209, 117)
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    _eColumnChart.pillarWidths = pillarWidths;
    _eColumnChart.spaceWidths = spaceWidths;
    _eColumnChart.columnLabelType = columnLabelType;
    if (columnLabelType == 1 && dateArray.count > 1)//自己添加下方的label
    {
        for (int i = 0; i < dateArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-50)*i/(dateArray.count-1), self.frame.size.height, 50, 20)];
            label.text = dateArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.8;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    [_eColumnChart setDataSource:self];
    [self addSubview:_eColumnChart];
}

- (void)drawDifferentColorColumnChartWithDateArray:(NSArray *)dateArray valueArray:(NSArray *)valueArray columnColorArray:(NSArray *)columnColorArray pillarWidths:(NSArray *)pillarWidths spaceWidths:(NSArray *)spaceWidths columnLabelType:(int)columnLabelType
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i ++)
    {
        NSNumber *value = valueArray[i];
        EColumnDataModel *dataModel = [[EColumnDataModel alloc]initWithLabel:dateArray[i] value:[value floatValue] index:i unit:nil];
        [temp addObject:dataModel];
    }
    _data = [NSMutableArray arrayWithArray:temp];
    _columnColorArray = [NSArray arrayWithArray:columnColorArray];
    _eColumnChart = [[EColumnChart alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_eColumnChart setDelegate:self];
    _eColumnChart.tag = DIFFERENT_COLOR_COLUMN_CHART;
    _eColumnChart.normalColumnColor = [UIColor brownColor];
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    _eColumnChart.pillarWidths = pillarWidths;
    _eColumnChart.spaceWidths = spaceWidths;
    _eColumnChart.columnLabelType = columnLabelType;
    if (columnLabelType == 1 && dateArray.count > 1)//自己添加下方的label
    {
        for (int i = 0; i < dateArray.count; i ++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-50)*i/(dateArray.count-1), self.frame.size.height, 50, 20)];
            label.text = dateArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.alpha = 0.8;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    [_eColumnChart setDataSource:self];
    [self addSubview:_eColumnChart];
}
//总共多少列
- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return _data.count;
}
//在屏幕上显示多少列
- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return _data.count;
}
//最大值
- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data) {
        if (dataModel.value > maxValue) {
            maxValue = dataModel.value;
            maxDataModel =dataModel;
        }
        
    }
    return maxDataModel;
}
//每个图柱的值
- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0)
    {
        return nil;
    }
    return [_data objectAtIndex:index];
}
//定义每根柱子的颜色
- (UIColor*)colorForEColumn:(EColumn *)eColumn
{
    if (_eColumnChart.tag != DIFFERENT_COLOR_COLUMN_CHART) {
        return _eColumnChart.normalColumnColor;
    }
    else if (_columnColorArray && _columnColorArray.count > 0)
    {
        NSInteger index = eColumn.eColumnDataModel.index;
        UIColor *color = _columnColorArray[index];
        return color;
    }
    else
    {
        return nil;
    }
}
- (void)eColumnChart:(EColumnChart *)eColumnChart didSelectColumn:(EColumn *)eColumn
{
    
}
- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidEnterColumn:(EColumn *)eColumn
{
    
}
- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidLeaveColumn:(EColumn *)eColumn
{
    
}
- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    
}
@end
