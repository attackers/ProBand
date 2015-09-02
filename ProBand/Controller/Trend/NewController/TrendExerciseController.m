//
//  TrendExerciseController.m
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TrendExerciseController.h"
#import "DetailChartView.h"
#import "ExerciseDataManager.h"
#import "ExerciseDayView.h"
typedef enum{
    DAY_CHART = 66,
    WEEK_CHART,
    MONTH_CHART,
}CHART_TYPE;
@interface TrendExerciseController ()
{
     UIView *containView;
    
//    DetailChartView *firstView;
//    DetailChartView *secondView;
//    DetailChartView *threeView;
    UIView *firstView;
    UIView *secondView;
    UIView *threeView;
    NSMutableArray *viewArray;
    
    CGFloat chartHeight;
    CGFloat chartY;
    CGFloat chartWidth;
    
    UISegmentedControl *_segment;
    UISegmentedControl *_distanceSegment;
    UILabel *dateLabel;
    
    UIImageView *footImage;
    CALayer *lineLayer;
    
    NSString *currentDate;//记载当前正在显示的日期
    CHART_TYPE currentType;
    
    ExerciseDayView *dayView;
}
@end

@implementation TrendExerciseController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    currentDate = [DateHandle dateToString:date withType:4];
    currentType = DAY_CHART;
    
    NSArray *sleepArray1 = @[@"运动时长",@"运动时长",@"运动时长"];
    NSArray *sleepArray2 = @[@"运动时间",@"运动时间",@"运动时长"];
    NSArray *sleepTimeArr1 = @[@"0小时0分钟",@"0小时0分钟",@"0小时0分钟"];
    NSArray *sleepTimeArr2 = @[@"20:51",@"06:35",@"1小时26分钟"];
    
    [self setControllerWithTitle:NSLocalizedString(@"exercising_volume", nil) UpDescribeArray:sleepArray1 downDescribeArray:sleepArray2 upValueArray:sleepTimeArr1 downValueArray:sleepTimeArr2 withIndex:2];
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
    //[self addDailySleepView];
    
    //先添加装柱状图的容器
    containView = [[UIView alloc]initWithFrame:CGRectMake(30, chartY, SCREEN_WIDTH-60, chartHeight+20)];
    containView.clipsToBounds = YES;
    [self.headView addSubview:containView];
    
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

//向右滑动：显示左侧的View
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
                
            }];
        }
    }
    
    [self performSelector:@selector(modifyLeftView) withObject:nil afterDelay:0.5];
}
//这里是动画结束后的方法，可以在此处更新下方的UI
- (void)modifyLeftView
{
    NSLog(@"当天日期为%@",currentDate);

    switch (currentType)
    {
        case DAY_CHART://日的时候先不要更新
        {
//            DailyDayModel *model = [[DailyDataManager sharedInstance] dailyDayModelForDate:currentDate];
//            if (model.valueArray.count > 0) {
//                [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
//            }
        }
            break;
        case WEEK_CHART:
        {
            ExerciseWeekModel *model = [[ExerciseDataManager sharedInstance] exerciseWeekModelForDate:currentDate];
            if (model.valueArray.count > 0) {
                [self updateControllerWithUpDescribeArray:model.upDescribeArray downDescribeArray:model.downDescribeArray upValueArray:model.upValueArray downValueArray:model.downValueArray];
            }
        }
            break;
        case MONTH_CHART:
        {
            ExerciseMonthModel *model = [[ExerciseDataManager sharedInstance] exerciseMonthModelForDate:currentDate];
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
            DetailChartView *chartView2 ;
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


- (void)chageDistance:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0://时间
        {
            NSLog(@"您选择了时间");
            _distanceSegment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_time_sel"]];
        }
            break;
        case 1://距离
        {
            NSLog(@"您选择了距离");
            _distanceSegment.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"volume_distance_sel"]];
        }
            break;
        default:
            break;
    }
}

//重新定义3个VIew的内容:为日的时候左侧加上一列图片
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
//    [dateLabel removeFromSuperview];
//    [firstView removeFromSuperview];
//    [secondView removeFromSuperview];
//    [threeView removeFromSuperview];
//    [dailySleepView removeFromSuperview];
//    [weekSleepView removeFromSuperview];
//    [monthSleepView removeFromSuperview];
    
    //图片移除失败
    [dateLabel removeFromSuperview];
    dateLabel = nil;
    [footImage removeFromSuperview];
    footImage = nil;
    [lineLayer removeFromSuperlayer];
    lineLayer = nil;
    
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
//添加每一天的睡眠情况：直接用新的tableView将原来的View覆盖掉
- (DetailChartView *)addDailySleepView:(NSString *)date
{
    [self hiddenDownView];
    if (dateLabel == nil) {
        dateLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(_segment.frame), SCREEN_WIDTH, 30) text:currentDate fontSize:16 color:[UIColor whiteColor] align:@"center"];
        [self.headView addSubview:dateLabel];
    }
    else
    {
        dateLabel.text = currentDate;
    }
    if (footImage==nil)
    {
        footImage = [[UIImageView alloc]initWithFrame:CGRectMake(30-6.5, CGRectGetMaxY(dateLabel.frame), 13,13)];
        footImage.image = [UIImage imageNamed:@"volume_step"];
        [self.headView addSubview:footImage];
    }
    if (lineLayer == nil)
    {
        lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(29.5, CGRectGetMaxY(footImage.frame), 0.5, self.headView.frame.size.height-CGRectGetMaxY(footImage.frame));
        lineLayer.backgroundColor = CGCOLOR(39, 72, 105);
        [self.headView.layer addSublayer:lineLayer];
    }

    //SectionModel *dayModel = [[ExerciseDataManager sharedInstance]exerciseSectionModelForDate:date];
    ExerciseSectionModel *dayModel = [[ExerciseDataManager sharedInstance]exerciseSectionModelFromDate:date];
    NSArray *startArr = dayModel.startArray;
    NSArray *endArr = dayModel.endArray;
    //NSArray *valueArr = dayModel.valueArray;
    NSArray *dateArray = @[@"00:00",@"12:00",@"24.00"];
    //int columnLabelType = 1;
    DetailChartView *chartView = [[DetailChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    
    NSMutableArray *pillarWidths = [NSMutableArray array];
    //柱子宽度有问题,不应该递增，相加不能超过250
    for (int i = 0; i < endArr.count; i ++)
    {
        [pillarWidths addObject:[NSNumber numberWithFloat:([endArr[i] intValue]-[startArr[i] intValue])*250/1440.0]];
    }
    NSMutableArray *spaceWidths = [NSMutableArray array];
    for (int j = 0; j < endArr.count; j ++)
    {
        if (j==0)
        {
            [spaceWidths addObject:[NSNumber numberWithFloat:[startArr[0] intValue]*250/1440.0]];
        }
        else
        {
            [spaceWidths addObject:[NSNumber numberWithFloat:([startArr[j] intValue]-[endArr[j-1] intValue])*250/1440.0]];
        }
    }
    
    //只有159个值，检查数据库
    [chartView drawUnQualblyChartWithDateArray:dateArray valueArray:dayModel.valueArray pillarWidths:pillarWidths spaceWidths:spaceWidths columnLabelType:1 chartColor:COLOR(27, 205, 115)];
    
    
    //添加下方的View:必须将原来的给清理掉
    if (dayView)
    {
        [dayView removeFromSuperview];
    }
    CGFloat dayViewY = 210;
    CGFloat dayHeight = 150;
    if (iPhone5) {
        dayViewY = 270;
        dayHeight = 170;
    }
    else if(iPhone6) {
        dayViewY = 270;
        dayHeight = 180;
    }
    else if (iPhone6plus)
    {
        
    }
    dayView = [[ExerciseDayView alloc]initWithFrame:CGRectMake(0, dayViewY, SCREEN_WIDTH, dayHeight) exerciseModel:dayModel];
    dayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dayView];
    return chartView;
}
- (DetailChartView *)addWeekSleepView:(NSString *)date
{
    [self showDownView];
    ExerciseWeekModel *weekModel = [[ExerciseDataManager sharedInstance]exerciseWeekModelForDate:date];
    NSArray *valueArray = [NSArray arrayWithArray:weekModel.valueArray];
    NSArray *dateArray = [NSArray arrayWithArray:weekModel.dateArray];
    
    DetailChartView *chartView = [[DetailChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    [chartView drawChartViewWithDateArray:dateArray valueArray:valueArray pillarWidth:(SCREEN_WIDTH-60)/7.0-5.0 spaceWidth:5.0 columnLabelType:0 chartColor:COLOR(27, 205, 115)];
    if ([date isEqualToString:currentDate] && weekModel.valueArray.count > 0)
    {
        [self updateControllerWithUpDescribeArray:weekModel.upDescribeArray downDescribeArray:weekModel.downDescribeArray upValueArray:weekModel.upValueArray downValueArray:weekModel.downValueArray];
    }
    [dayView removeFromSuperview];
    return chartView;
}
- (DetailChartView *)addMonthSleepView:(NSString *)date
{
    [self showDownView];
    ExerciseMonthModel *monthModel = [[ExerciseDataManager sharedInstance]exerciseMonthModelForDate:date];
    NSArray *dateArray = [NSArray arrayWithArray:monthModel.dateArray];
    NSArray *valueArray = [NSArray arrayWithArray:monthModel.valueArray];
    DetailChartView *chartView =[[DetailChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, chartHeight)];
    [chartView drawChartViewWithDateArray:dateArray valueArray:valueArray pillarWidth:(SCREEN_WIDTH-60)/4.0-5.0 spaceWidth:5.0 columnLabelType:0 chartColor:COLOR(27, 205, 115)];
    //[self.headView addSubview:monthSleepView];
    if ([date isEqualToString:currentDate] && monthModel.valueArray.count>0) {
        [self updateControllerWithUpDescribeArray:monthModel.upDescribeArray downDescribeArray:monthModel.downDescribeArray upValueArray:monthModel.upValueArray downValueArray:monthModel.downValueArray];
    }
    [dayView removeFromSuperview];
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
