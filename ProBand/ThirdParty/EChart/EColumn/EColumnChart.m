//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#define BOTTOM_LINE_HEIGHT 2
#define HORIZONTAL_LINE_HEIGHT 0.5
#define Y_COORDINATE_LABEL_WIDTH 30
#define DIRECTION  (_columnsIndexStartFromLeft? - 1 : 1)


@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;
@property (strong, nonatomic) EColumn *fingerIsInThisEColumn;
@property (nonatomic) float fullValueOfTheGraph;

@end

@implementation EColumnChart
@synthesize columnsIndexStartFromLeft = _columnsIndexStartFromLeft;
@synthesize showHighAndLowColumnWithColor = _showHighAndLowColumnWithColor;
@synthesize fingerIsInThisEColumn = _fingerIsInThisEColumn;
@synthesize minColumnColor = _minColumnColor;
@synthesize maxColumnColor = _maxColumnColor;
@synthesize normalColumnColor = _normalColumnColor;
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize showHorizontalLabelsWithInteger = _showHorizontalLabelsWithInteger;
@synthesize fullValueOfTheGraph = _fullValueOfTheGraph;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;


#pragma -mark- Setter and Getter
- (void)setDelegate:(id<EColumnChartDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        if (![_delegate respondsToSelector:@selector(eColumnChart: didSelectColumn:)])
        {
            NSLog(@"@selector(eColumnChart: didSelectColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidEnterColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidEnterColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidLeaveColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidLeaveColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(fingerDidLeaveEColumnChart:)])
        {
            NSLog(@"@selector(fingerDidLeaveEColumnChart:) Not Implemented!");
            return;
        }
    }
}

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsInEColumnChart:)])
        {
            NSLog(@"@selector(numberOfColumnsInEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsPresentedEveryTime:)])
        {
            NSLog(@"@selector(numberOfColumnsPresentedEveryTime:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(highestValueEColumnChart:)])
        {
            NSLog(@"@selector(highestValueEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(eColumnChart:valueForIndex:)])
        {
            NSLog(@"@selector(eColumnChart:valueForIndex:) Not Implemented!");
            return;
        }
        
        {
            NSInteger totalColumnsRequired = 0;
            totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
            NSInteger totalColumns = 0;
            totalColumns = [_dataSource numberOfColumnsInEColumnChart:self];
            /** Currently only support columns layout from right to left, WILL ADD OPTIONS LATER*/
            if (_columnsIndexStartFromLeft)
            {
                _leftMostIndex = 0;
                _rightMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            else
            {
                _rightMostIndex = 0;
                _leftMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            
            /** Start construct horizontal lines*/
            /** Start construct value labels for horizontal lines*/
            if (_showHorizontalLabelsWithInteger)
            {
                NSInteger valueGap = [_dataSource highestValueEColumnChart:self].value / 10 + 1;
                NSInteger horizontalLabelsCount = [_dataSource highestValueEColumnChart:self].value / valueGap + 1;
                float heightGap = self.frame.size.height / (float)horizontalLabelsCount;
                _fullValueOfTheGraph = valueGap * horizontalLabelsCount;
                for (int i = 0; i <= horizontalLabelsCount; i ++)
                {
                    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
                    horizontalLine.backgroundColor = ELightGrey;
                    //[self addSubview:horizontalLine];
                    
                    EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                    eColumnChartLabel.text = [[NSString stringWithFormat:@"%d ", valueGap * (horizontalLabelsCount - i)] stringByAppendingString:[_dataSource highestValueEColumnChart:self].unit];;
                    //[self addSubview:eColumnChartLabel];
                }
                
                
            }
            else
            {
                /** In order to leave some space for the heightest column */
                _fullValueOfTheGraph = [_dataSource highestValueEColumnChart:self].value * 1.1;
                if (_fullValueOfTheGraph < 0.01) {
                    _fullValueOfTheGraph = 1;
                }
                float heightGap = self.frame.size.height / 10.0;
                float valueGap = _fullValueOfTheGraph / 10.0;
                for (int i = 0; i < 11; i++)
                {
                    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
                    horizontalLine.backgroundColor = ELightGrey;
                    //[self addSubview:horizontalLine];
                    
                    EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
//                    eColumnChartLabel.text = [[NSString stringWithFormat:@"%.1f ", valueGap * (10 - i)] stringByAppendingString:[_dataSource highestValueEColumnChart:self].unit];
                    
                    //eColumnChartLabel.backgroundColor = ELightBlue;
                    //[self addSubview:eColumnChartLabel];
                }
            }
            
        }
        
        [self reloadData];
    }
}
- (void)setMaxColumnColor:(UIColor *)maxColumnColor
{
    _maxColumnColor = maxColumnColor;
    [self reloadData];
}

- (void)setMinColumnColor:(UIColor *)minColumnColor
{
    _minColumnColor = minColumnColor;
    [self reloadData];
}

- (void)setShowHighAndLowColumnWithColor:(BOOL)showHighAndLowColumnWithColor
{
    _showHighAndLowColumnWithColor = showHighAndLowColumnWithColor;
    [self reloadData];
}

- (void)setColumnsIndexStartFromLeft:(BOOL)columnsIndexStartFromLeft
{
    if (_dataSource)
    {
        NSLog(@"setColumnsIndexStartFromLeft Should Be Called Before Setting Datasource!");
        return;
    }
    _columnsIndexStartFromLeft = columnsIndexStartFromLeft;
}


#pragma -mark- Custom Methed
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /** Should i release these two objects before self have been destroyed*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
        
        [self initData];
    }
    return self;
}



- (void)initData
{
    /** Initialize colors for max and min column*/
    _minColumnColor = EMinValueColor;
    _maxColumnColor = EMaxValueColor;
    _normalColumnColor = EGrey;
    _showHighAndLowColumnWithColor = YES;
    
    //add by Star
    _columnLabelType = 0;
}

- (void)reloadData
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    
    NSInteger totalColumnsRequired = 0;
    totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    
    float widthOfTheColumnShouldBe = self.frame.size.width / (float)(totalColumnsRequired + (totalColumnsRequired + 1) * 0.5);
    float minValue = 1000000.0;
    float maxValue = 0.0;
    NSInteger minIndex = 0;
    NSInteger maxIndex = 0;
    NSLog(@"显示的柱子为：%d",totalColumnsRequired);
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        NSInteger currentIndex = _leftMostIndex - i * DIRECTION;
        EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:currentIndex];
        if (eColumnDataModel == nil)
            eColumnDataModel = [[EColumnDataModel alloc] init];
        /** Judge which is the max value and which is min, then set color correspondingly */
        if (eColumnDataModel.value > maxValue) {
            maxIndex =  currentIndex;
            maxValue = eColumnDataModel.value;
        }
        if (eColumnDataModel.value < minValue) {
            minIndex = currentIndex;
            minValue = eColumnDataModel.value;
        }
        
        /** Construct Columns*/
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex ]];
        if (nil == eColumn)
        {
            //调整图柱的宽度
           // eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe, self.frame.size.height)];
            //自己设定每个图柱的宽度和间距
            if (_pillarWidth > 0 && _pillarWidths == nil) {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(i*(_spaceWidth +_pillarWidth)+_spaceWidth, 0, _pillarWidth, self.frame.size.height)];
            }
            else if (_pillarWidths && _spaceWidths)
            {
                float lastWidth = 0;
                for (int k = 0; k <= i-1; k ++)
                {
                    NSNumber *pilWidth = _pillarWidths[k];
                    NSNumber *space = _spaceWidths[k];
                    lastWidth+= [pilWidth floatValue] + [space floatValue];
                }
                NSNumber *currentWidth = _pillarWidths[i];
                eColumn = [[EColumn alloc]initWithFrame:CGRectMake(lastWidth, 0, [currentWidth floatValue], self.frame.size.height)];
            }
            else
            {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, _pillarWidth, self.frame.size.height)];
            }
//            if ([_dataSource respondsToSelector:@selector(colorForEColumn:)])
//            {
//                eColumn.barColor = [_dataSource colorForEColumn:eColumn];
//            }
//            else
//            {
//                eColumn.barColor = _normalColumnColor;
//            }

//            [eColumn setPillarColor:@[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]] colorValue:@[@0.2,@0.3,@0.5]];
            eColumn.backgroundColor = [UIColor clearColor];
            eColumn.grade = eColumnDataModel.value / _fullValueOfTheGraph;
            eColumn.eColumnDataModel = eColumnDataModel;
            [eColumn setDelegate:self];
            if (_valueArray && _colorArray)
            {
                NSArray *valuess = _valueArray[i];
                [eColumn setPillarColor:_colorArray colorValue:valuess];
            }
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex]];
        }
        if ([_dataSource respondsToSelector:@selector(colorForEColumn:)])
        {
            eColumn.barColor = [_dataSource colorForEColumn:eColumn];
            
        }
        else
        {
            eColumn.barColor = _normalColumnColor;
        }
        
//        //添加颜色渲染
//        if (self.valueArray == nil) {
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = eColumn.chartLine.bounds;
//            gradient.colors = [NSArray arrayWithObjects:(id)[_normalColumnColor CGColor],(id)[UIColor clearColor].CGColor, nil];
//            [eColumn.chartLine insertSublayer:gradient atIndex:0];
//        }

        /** Construct labels for corresponding columns */
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
            //自定义图表下方label的位置:几种情况
            //eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height, widthOfTheColumnShouldBe, 20)];
            CGFloat labelX = widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5);
            switch (_columnLabelType) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    NSInteger total = totalColumnsRequired;
                    if (total>1)
                    {
                        labelX = (self.frame.size.width-widthOfTheColumnShouldBe)*i/(total-1);
                    }
                        eColumnChartLabel.hidden = YES;
                }
                    break;
                case 2://对应于每个柱子的正下方
                {
                    NSInteger total = totalColumnsRequired;
                    if (total>1 && _pillarWidths && _spaceWidths)
                    {
                        float lastWidth = 0;
                        for (int k = 0; k <= i-1; k ++)
                        {
                            NSNumber *pilWidth = _pillarWidths[k];
                            NSNumber *space = _spaceWidths[k];
                            lastWidth+= [pilWidth floatValue] + [space floatValue];
                        }
                        NSNumber *widthi = _pillarWidths[i];
                        labelX = lastWidth+[widthi floatValue]/2-widthOfTheColumnShouldBe/2;
                    }
                }
                    break;
                default:
                    break;
            }
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(labelX, self.frame.size.height, widthOfTheColumnShouldBe, 20)];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
            //eColumnChartLabel.backgroundColor = ELightBlue;
            if (_columnLabelType !=1) {
                [self addSubview:eColumnChartLabel];
            }            
            [_eLabels setObject:eColumnChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
        }
    }
    
    if (_showHighAndLowColumnWithColor)
    {
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: maxIndex]];
        eColumn.barColor = _maxColumnColor;
        eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: minIndex]];
        eColumn.barColor = _minColumnColor;
    }
    
    
//    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
//    {
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, , BOTTOM_LINE_HEIGHT)];
//        bottomLine.backgroundColor = [UIColor blackColor];
//        bottomLine.layer.cornerRadius = 2.0;
//        [self addSubview:bottomLine];
//        [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BOTTOM_LINE_HEIGHT)];
//        
//    } completion:nil];
    
}



- (void)moveLeft
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    NSInteger index = _leftMostIndex + 1 * DIRECTION;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex = _leftMostIndex + 1 * DIRECTION;
    _rightMostIndex = _rightMostIndex + 1 * DIRECTION;
    
    NSInteger totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1)  * DIRECTION]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1) * DIRECTION]];
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
    }
    
    [self reloadData];
}
- (void)moveRight
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    NSInteger index = _rightMostIndex - 1 * DIRECTION;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex = _leftMostIndex - 1 * DIRECTION;
    _rightMostIndex = _rightMostIndex - 1 * DIRECTION;
    
    NSInteger totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i * DIRECTION]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + (i + 1) * DIRECTION]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i * DIRECTION]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + (i + 1) * DIRECTION]];
        
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
        /** Do not inlclude animations at the moment*/
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            eColumn.frame = nextEColumn.frame;
//        } completion:nil];
        
    }
    
    [self reloadData];
}


#pragma -mark- EColumnDelegate
- (void)eColumnTaped:(EColumn *)eColumn
{
    [_delegate eColumnChart:self didSelectColumn:eColumn];
    [_delegate fingerDidLeaveEColumnChart:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma -mark- detect Gesture

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    [_delegate fingerDidLeaveEColumnChart:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (EColumn *view in _eColumns.objectEnumerator)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            [_delegate eColumnChart:self fingerDidLeaveColumn:view];
            _fingerIsInThisEColumn = nil;
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    UITouch *touch = [[event allTouches] anyObject];
    /** We do not want the coordinate system of the columns here, 
     we need coordinate system of the Echart instead, so we use self*/
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (nil == _fingerIsInThisEColumn)
    {
        for (EColumn *view in _eColumns.objectEnumerator)
        {
            if(CGRectContainsPoint(view.frame, touchLocation) )
            {
                [_delegate eColumnChart:self fingerDidEnterColumn:view];
                _fingerIsInThisEColumn = view;
                return ;
            }
        }
    }
    if (_fingerIsInThisEColumn && !CGRectContainsPoint(_fingerIsInThisEColumn.frame, touchLocation))
    {
        [_delegate eColumnChart:self fingerDidLeaveColumn:_fingerIsInThisEColumn];
        _fingerIsInThisEColumn = nil;
    }
    
    return ;
}



@end
