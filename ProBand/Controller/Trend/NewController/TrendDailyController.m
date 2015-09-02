//
//  TrendDailyController.m
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TrendDailyController.h"
#import "DetailChartView.h"
#import "DailyDataManager.h"
typedef enum{
    DAY_CHART = 55,
    WEEK_CHART,
    MONTH_CHART,
}CHART_TYPE;
@interface TrendDailyController ()
{
    UIView *containView;
    
//    DetailChartView *firstView;
//    DetailChartView *secondView;
//    DetailChartView *threeView;
    //在View上添加图表
    UIView *firstView;
    UIView *secondView;
    UIView *threeView;
    NSMutableArray *viewArray;
    
    CGFloat chartHeight;
    CGFloat chartY;
    CGFloat chartWidth;
    
    UISegmentedControl *_segment;
    UILabel *dateLabel;
    
    NSString *currentDate;//记载当前正在显示的日期
    CHART_TYPE currentType;
    
    //下方的几个数组
    NSArray *upDescribeArray;
    NSArray *upValueArray;
    NSArray *downDescribeArray;
    NSArray *downValueArray;
}
@end

@implementation TrendDailyController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    currentDate = [DateHandle dateToString:date withType:4];
    currentType = DAY_CHART;
    //开始时需要获取某些model
    upDescribeArray = @[NSLocalizedString(@"day_mileage_day", nil),NSLocalizedString(@"day_steps_day", nil),NSLocalizedString(@"day_consumption_kcal", nil)];
   downDescribeArray = @[NSLocalizedString(@"sport_time", nil),NSLocalizedString(@"static_time", nil)];
    upValueArray = @[@"0",@"0",@"0"];
    downValueArray = @[@"0小时0分钟",@"24小时0分钟"];
    
    [self setControllerWithTitle:NSLocalizedString(@"sport_volume", nil) UpDescribeArray:upDescribeArray downDescribeArray:downDescribeArray upValueArray:upValueArray downValueArray:downValueArray withIndex:0];
            self.navigationController.navigationBar.barTintColor = navigationColor;
    
    chartHeight = 185.0;
    chartY = 130;
    chartWidth = SCREEN_WIDTH-60;
    if (iPhone4) {
        chartHeight = 139;
    }
    else if (iPhone5)
    {
        
    }
    else if (iPhone6)
    {
        
    }
    else if (iPhone6plus)
    {
        
    }
    _segment = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"day", nil),NSLocalizedString(@"week", nil),NSLocalizedString(@"month", nil)]];
    _segment.tintColor = [UIColor clearColor];
    //_segment.backgroundColor = COLOR(12, 90, 123);
    _segment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_day_sel"]];
    _segment.selectedSegmentIndex = 0;
    _segment.frame = CGRectMake(SCREEN_WIDTH/2-133.5/2, 85, 133.5, 19);
    _segment.layer.masksToBounds = YES;
    _segment.layer.cornerRadius = 9.5;
    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
    [_segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                               NSForegroundColorAttributeName: [UIColor lightTextColor]};
    [_segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [_segment addTarget:self action:@selector(chageChart:) forControlEvents:UIControlEventValueChanged];
    [self.headView addSubview:_segment];
    
    //添加左右按钮
    UIButton *leftBn = [[UIButton alloc]initWithFrame:CGRectMake(0, chartY+chartHeight/2-40, 30, 50)];
    leftBn.imageEdgeInsets = UIEdgeInsetsMake(8.5, 9.25, 8.5, 9.25);
    [leftBn setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
    [leftBn setImage:[UIImage imageNamed:@"left_arrow_press.png"] forState:UIControlStateHighlighted];
    [leftBn addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:leftBn];
    
    UIButton *rightBn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-CGRectGetMaxX(leftBn.frame), CGRectGetMinY(leftBn.frame), leftBn.frame.size.width, leftBn.frame.size.height)];
    rightBn.imageEdgeInsets = UIEdgeInsetsMake(8.5, 9.25, 8.5, 9.25);
    [rightBn setImage:[UIImage imageNamed:@"right_arrow_invalid"] forState:UIControlStateNormal];
    [rightBn setImage:[UIImage imageNamed:@"right_arrow_press"] forState:UIControlStateHighlighted];
    [rightBn addTarget:self action:@selector(showRightView) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:rightBn];
    
    //先添加装柱状图的容器
    containView = [[UIView alloc]initWithFrame:CGRectMake(30, chartY, SCREEN_WIDTH-60, chartHeight+20)];
    containView.clipsToBounds = YES;
    [self.headView addSubview:containView];
    //[self addDailySleepView];
    
    //添加3个VIew:View上添加绘图
    firstView = [[UIView alloc]init];
    firstView.bounds = CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight);
    firstView.center = CGPointMake(-chartWidth/2, chartHeight/2);
    [containView addSubview:firstView];
    secondView = [[UIView alloc]init];
    secondView.bounds = CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight);
    secondView.center = CGPointMake(chartWidth/2, chartHeight/2);
    [containView addSubview:secondView];
    threeView = [[UIView alloc]init];
    threeView.bounds = CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight);
    threeView.center = CGPointMake(chartWidth*3/2, chartHeight/2);
    [containView addSubview:threeView];
    
    DetailChartView *chartView1 = [self addDailySleepView:[DateHandle getLastDay:currentDate]];
    [firstView addSubview:chartView1];
    DetailChartView *chartView2 = [self addDailySleepView:currentDate];
    [secondView addSubview:chartView2];
    DetailChartView *chartView3 = [self addDailySleepView:[DateHandle getNextDay:currentDate]];
    [threeView addSubview:chartView3];
    
    //在ViewArray中，view添加的顺序并不重要，根据他们的横坐标来判断
    viewArray = [NSMutableArray array];
    [viewArray addObject:firstView];
    [viewArray addObject:secondView];
    [viewArray addObject:threeView];
    
    //添加左右手势
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showRightView)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.headView addGestureRecognizer:leftGesture];
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftView)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.headView addGestureRecognizer:rightGesture];
    // Do any additional setup after loading the view.
}

//向右滑动：显示左侧的View，重新构建View的内容,一直向前推
- (void)showLeftView
{
    switch (currentType) {
        case DAY_CHART:
        {
            currentDate = [DateHandle getLastDay:currentDate];
        }
            break;
        case WEEK_CHART:
        {
            currentDate = [DateHandle getLastWeek:currentDate];
        }
            break;
        case MONTH_CHART:
        {
            currentDate = [DateHandle getLastMonth:currentDate];
        }
            break;
        default:
            break;
    }
    for (  UIView *view in viewArray)
    {
        if (view.center.x > chartWidth)
        {
            view.center = CGPointMake(-chartWidth/2, chartHeight/2);//不要动画
            //view.label.text = [NSString stringWithFormat:@"第%d页",currentIndex-1];
        }
        else
        {
            CGPoint center = view.center;
            //向右滑动
            [UIView animateWithDuration:0.5 animations:^{
                view.center = CGPointMake(center.x + chartWidth, center.y);
            } completion:^(BOOL finished) {

            }];
        }
    }
    [self performSelector:@selector(modifyLeftView) withObject:nil afterDelay:0.5];
}
//在此处更新下方的UI，再取一次model？
- (void)modifyLeftView
{
    NSLog(@"当天日期为%@",currentDate);
    //有数据则刷新，没有数据则应该用0填充各项
    switch (currentType)
    {
        case DAY_CHART:
        {
            DailyDayModel *model = [[DailyDataManager sharedInstance] dailyDayModelForDate:currentDate];
            if (model.valueArray.count > 0) {
                [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
            }
        }
            break;
        case WEEK_CHART:
        {
            DailyWeekModel *model = [[DailyDataManager sharedInstance] dailyWeekModelForDate:currentDate];
            if (model.valueArray.count > 0) {
                [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
            }
        }
            break;
        case MONTH_CHART:
        {
            DailyMonthModel *model = [[DailyDataManager sharedInstance] dailyMonthModelForDate:currentDate];
            if (model.valueArray.count > 0) {
                [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
            }
        }
            break;
        default:
            break;
    }
    
    for (UIView *view in viewArray)
    {
        if (view.center.x < 0)
        {
            for (UIView *view1 in view.subviews)
            {
                [view1 removeFromSuperview];
            }
            DetailChartView *chartView1;
            switch (currentType) {
                case DAY_CHART:
                {
                    chartView1 = [self addDailySleepView:[DateHandle getLastDay:currentDate]];
                }
                    break;
                case WEEK_CHART:
                {
                    chartView1 = [self addWeekSleepView:[DateHandle getLastWeek:currentDate]];
                }
                    break;
                case MONTH_CHART:
                {
                    chartView1 = [self addMonthSleepView:[DateHandle getLastMonth:currentDate]];
                }
                    break;
                default:
                    break;
            }
            [view addSubview:chartView1];
        }
        else if(view.center.x > chartWidth)
        {
            for (UIView *view2 in view.subviews)
            {
                [view2 removeFromSuperview];
            }
            DetailChartView *chartView2 ;//= [self addDailySleepView:[DateHandle getNextDay:currentDate]]
            switch (currentType) {
                case DAY_CHART:
                {
                    chartView2 = [self addDailySleepView:[DateHandle getNextDay:currentDate]];
                }
                    break;
                case WEEK_CHART:
                {
                    chartView2 = [self addWeekSleepView:[DateHandle getNextWeek:currentDate]];
                }
                    break;
                case MONTH_CHART:
                {
                    chartView2 = [self addMonthSleepView:[DateHandle getNextMonth:currentDate]];
                }
                    break;
                default:
                    break;
            }
            [view addSubview:chartView2];
        }
    }
}

//向左滑动：显示右侧的View，一直向后推，到当前日期停止
- (void)showRightView
{
    if ([currentDate isEqualToString:[DateHandle currentDate]])
    {
        NSLog(@"已到当前日期");
        return;
    }
    switch (currentType) {
        case DAY_CHART:
        {
            currentDate = [DateHandle getNextDay:currentDate];
        }
            break;
        case WEEK_CHART:
        {
            currentDate = [DateHandle getNextWeek:currentDate];
        }
            break;
        case MONTH_CHART:
        {
            currentDate = [DateHandle getNextMonth:currentDate];
        }
            break;
        default:
            break;
    }
    for (DetailChartView *view in viewArray)
    {
        if (view.center.x < 0)
        {
            view.center = CGPointMake(chartWidth*3/2, chartHeight/2);//不要动画
        }
        else
        {
            CGPoint center = view.center;
            //向右滑动
            [UIView animateWithDuration:0.5 animations:^{
                view.center = CGPointMake(center.x - chartWidth, center.y);
            } completion:^(BOOL finished) {
               //动画结束后更新：调用两次怎么办
            }];
        }
    }
    [self performSelector:@selector(modifyLeftView) withObject:nil afterDelay:0.5];
}
//重新定义3个VIew的内容
- (void)chageChart:(UISegmentedControl *)segment
{
    NSDate *date = [NSDate date];
    currentDate = [DateHandle dateToString:date withType:4];
    [self removeAllView];
    switch (segment.selectedSegmentIndex) {
        case 0://日
        {
            currentType = DAY_CHART;
            
            //[self addDailySleepView];
            _segment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_day_sel"]];
            //重新添加View
            DetailChartView *chartView1 = [self addDailySleepView:[DateHandle getLastDay:currentDate]];
            DetailChartView *chartView2 = [self addDailySleepView:currentDate];
            DetailChartView *chartView3 = [self addDailySleepView:[DateHandle getNextDay:currentDate]];
            for (UIView *view in viewArray) {
                if (view.center.x < 0) {
                    [view addSubview:chartView1];
                }
                else if (view.center.x > chartWidth)
                {
                    [view addSubview:chartView3];
                }
                else
                {
                    [view addSubview:chartView2];
                }
            }
        }
            break;
        case 1://周
        {
            currentType = WEEK_CHART;
            
            //[self addWeekSleepView];
            _segment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_weeks_sel"]];
            //重新添加View
            DetailChartView *chartView1 = [self addWeekSleepView:[DateHandle getLastWeek:currentDate]];
            DetailChartView *chartView2 = [self addWeekSleepView:currentDate];
            DetailChartView *chartView3 = [self addWeekSleepView:[DateHandle getNextDay:currentDate]];
            for (UIView *view in viewArray) {
                if (view.center.x < 0) {
                    [view addSubview:chartView1];
                }
                else if (view.center.x > chartWidth)
                {
                    [view addSubview:chartView3];
                }
                else
                {
                    [view addSubview:chartView2];
                }
            }
        }
            break;
        case 2://月
        {
            currentType = MONTH_CHART;
            
            //[self addMonthSleepView];
            _segment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_month_sel"]];
            //重新添加View
            DetailChartView *chartView1 = [self addMonthSleepView:[DateHandle getLastMonth:currentDate]];
            DetailChartView *chartView2 = [self addMonthSleepView:currentDate];
            DetailChartView *chartView3 = [self addMonthSleepView:[DateHandle getNextMonth:currentDate]];
            for (UIView *view in viewArray) {
                if (view.center.x < 0) {
                    [view addSubview:chartView1];
                }
                else if (view.center.x > chartWidth)
                {
                    [view addSubview:chartView3];
                }
                else
                {
                    [view addSubview:chartView2];
                }
            }
        }
            break;
        default:
            break;
    }
    firstView.center = CGPointMake(-chartWidth/2, chartHeight/2);
    [containView addSubview:firstView];
    secondView.center = CGPointMake(chartWidth/2, chartHeight/2);
    [containView addSubview:secondView];
    threeView.center = CGPointMake(chartWidth*3/2, chartHeight/2);
    [containView addSubview:threeView];
    [viewArray removeAllObjects];
    [viewArray addObject:firstView];
    [viewArray addObject:secondView];
    [viewArray addObject:threeView];
}
- (void)removeAllView
{
     [dateLabel removeFromSuperview];
    dateLabel = nil;
    
    for (UIView *view in firstView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in secondView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in threeView.subviews) {
        [view removeFromSuperview];
    }
}
//date格式为yyyy-MM-dd
- (DetailChartView *)addDailySleepView:(NSString *)date
{
    if (dateLabel == nil) {
        dateLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(_segment.frame), SCREEN_WIDTH, 30) text:currentDate fontSize:16 color:[UIColor whiteColor] align:@"center"];
        [self.headView addSubview:dateLabel];
    }
    else
    {
        dateLabel.text = currentDate;
    }
    
    NSArray *dateArray = @[@"00:00",@"12:00",@"24.00"];
    DetailChartView *chartView = [[DetailChartView alloc]init];  // WithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    chartView.frame = CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight);
    NSMutableArray *pillarWidths = [NSMutableArray array];
    
    SectionModel *dailyModel = [[DailyDataManager sharedInstance] dailySectionModelForDate:date];
    NSArray *startArr = dailyModel.startArray;
    NSArray *endArr = dailyModel.endArray;
     NSMutableArray *spaceWidths = [NSMutableArray array];
    [pillarWidths addObject:@0.0];
    //进行单分钟数据加粗的处理
    for (int i = 0; i < endArr.count; i ++)
    {
        float pillerX = ([endArr[i] intValue]-[startArr[i] intValue])*250/1440.0;
        float spaceX = [startArr[0] intValue]*250/1440.0;
        if(i>0)
        {
            spaceX = ([startArr[i] intValue]-[endArr[i-1] intValue])*250/1440.0;
        }
        if (pillerX<1.0) {
            spaceX-=1-pillerX;
            pillerX=1.0;
        }
        [pillarWidths addObject:[NSNumber numberWithFloat:pillerX]];
        [spaceWidths addObject:[NSNumber numberWithFloat:spaceX]];
    }
    float lastSpace = (1440-[[endArr lastObject] intValue])*250/1440.0;
    [spaceWidths addObject:[NSNumber numberWithFloat:lastSpace]];
    NSMutableArray *valueArray = [NSMutableArray array];
    [valueArray addObject:@0];
    [valueArray addObjectsFromArray:dailyModel.valueArray];
    //只有159个值，检查数据库:valueArray不能超过480个值,后来会变成640个？前160个值为0，与时间有关？
    [chartView drawUnQualblyChartWithDateArray:dateArray valueArray:valueArray pillarWidths:pillarWidths spaceWidths:spaceWidths columnLabelType:1 chartColor:COLOR(84, 171, 225)];
    if ([date isEqualToString:currentDate] && dailyModel.valueArray.count>0) {
        DailyDayModel *model = [[DailyDataManager sharedInstance] dailyDayModelForDate:currentDate];
        if (model.valueArray.count > 0) {
            [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
        }
    }
    return chartView;
}
- (DetailChartView *)addWeekSleepView:(NSString *)date
{
    DailyWeekModel *weekModel = [[DailyDataManager sharedInstance] dailyWeekModelForDate:date];
    NSArray *valueArray = [NSArray arrayWithArray:weekModel.valueArray];
    NSArray *dateArray = [NSArray arrayWithArray:weekModel.dateArray];
    DetailChartView *chartView = [[DetailChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    [chartView drawChartViewWithDateArray:dateArray valueArray:valueArray pillarWidth:(SCREEN_WIDTH-60)/7.0-5.0 spaceWidth:5.0 columnLabelType:0 chartColor:COLOR(84, 171, 225)];//COLOR(27, 205, 115)
    if ([date isEqualToString:currentDate] && weekModel.valueArray.count>0) {
        [self updateControllerWithUpDescribeArray:weekModel.upDescribeArray downDescribeArray:weekModel.downDescribeArray upValueArray:weekModel.upValueArray downValueArray:weekModel.downValueArray];
    }
    return chartView;
}
- (DetailChartView *)addMonthSleepView:(NSString *)date
{
    DailyMonthModel *monthModel = [[DailyDataManager sharedInstance]dailyMonthModelForDate:date];
    NSArray *dateArray = [NSArray arrayWithArray:monthModel.dateArray];
    NSArray *valueArray = [NSArray arrayWithArray:monthModel.valueArray];
    
    DetailChartView *chartView =[[DetailChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    [chartView drawChartViewWithDateArray:dateArray valueArray:valueArray pillarWidth:(SCREEN_WIDTH-60)/4.0-5.0 spaceWidth:5.0 columnLabelType:0 chartColor:COLOR(84, 171, 225)];
    if ([date isEqualToString:currentDate] && monthModel.valueArray.count>0) {
        [self updateControllerWithUpDescribeArray:monthModel.upDescribeArray downDescribeArray:monthModel.downDescribeArray upValueArray:monthModel.upValueArray downValueArray:monthModel.downValueArray];
    }
    return chartView;
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
