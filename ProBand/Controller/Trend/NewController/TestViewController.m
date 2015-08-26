//
//  TestViewController.m
//  ProBand
//
//  Created by star.zxc on 15/6/23.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TestViewController.h"
#import "EFloatBox.h"
#import "EColumnChartLabel.h"
#import "EColumnDataModel.h"
#import "EColumnChart.h"
#import "DetailChartView.h"
#import "SleepDataManager.h"
#import "DailyDataManager.h"
#import "ExerciseDataManager.h"
@interface TestViewController ()<EColumnChartDelegate,EColumnChartDataSource,FMDBDataDelegate>
{
    NSMutableArray *_data;
    UIScrollView *scrollView;
}
@property (strong, nonatomic)EColumnChart *eColumnChart;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize  = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT *3);
    [self.view addSubview:scrollView];

    
//    DetailChartView *chart1 = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 40, 250, 200)];
//    [chart1 drawChartViewWithDateArray:@[@"3月",@"4月",@"5月",@"6月"] valueArray:@[@20.0,@50.0,@30.0,@100.0] pillarWidth:50.0 spaceWidth:5.0 columnLabelType:1 chartColor:[UIColor greenColor]];
//    [scrollView addSubview:chart1];
//    
//    DetailChartView *detailChart = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 240, 250, 200)];
//    [detailChart drawUnpureChartViewWithDateArray:@[@"6-25",@"6-26",@"6-27",@"6-28"] valueArray:@[@[@0.1,@3.4,@0.5],@[@0.4,@2.4,@0.2],@[@0.3,@0.4,@0.7],@[@1,@0.6,@0.3]] colorArray:@[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]] pillarWidths:@[@30.0,@20.0,@50.0,@80.0] spaceWidths:@[@5.0,@10.0,@20.0,@5.0] columnLabelType:2];
//    [scrollView addSubview:detailChart];
//    
//    DetailChartView *chart3 = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 500, 250, 200)];
//    [chart3 drawColorfulChartWithDateArray:@[@"周一",@"周二",@"周三",@"周四"] valueArray:@[@[@20.0,@30.0,@10.0],@[@10.0,@10.0,@10.0],@[@40.0,@30.0,@10.0],@[@20.0,@60.0,@10.0]] colorArray:@[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]] pillarWidth:50.0 spaceWidth:5.0 columnLabelType:0];
//    [scrollView addSubview:chart3];
//    
//    DetailChartView *chart4 = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 750, 250, 200)];
//    [chart4 drawUnQualblyChartWithDateArray:@[@"周一",@"周二",@"周三",@"周四"] valueArray:@[@20.0,@50.0,@30.0,@100.0] pillarWidths:@[@30.0,@20.0,@50.0,@80.0] spaceWidths:@[@5.0,@10.0,@20.0,@5.0] columnLabelType:0 chartColor:[UIColor greenColor]];
//    [scrollView addSubview:chart4];
//    
//    DetailChartView *chart5 = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 1000, 250, 200)];
//    [chart5 drawDifferentColorColumnChartWithDateArray:@[@"周一",@"周二",@"周三",@"周四"] valueArray:@[@20.0,@50.0,@30.0,@100.0] columnColorArray:@[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor lightGrayColor]] pillarWidths:@[@30.0,@20.0,@50.0,@80.0] spaceWidths:@[@5.0,@10.0,@20.0,@5.0] columnLabelType:0];
//    [scrollView addSubview:chart5];
    

    
    //[[FMDBTool sharedInstance] addTestData];
    
//    NSDictionary *dailyDic1 = @{@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:12345],@"steps":[NSNumber numberWithInt:180],@"meters":[NSNumber numberWithInt:(int)180*0.7],@"kCalories":[NSNumber numberWithFloat:120*1.23],@"isRead":[NSNumber numberWithInt:0]};//,@"keys":@"mac,time,steps,meters,kCalories,isUpload"
//    [[FMDBManage shareFMDBManage] insertDataFromTable:StepDataTable insertValueDic:dailyDic1];
    
    NSString *date = @"2015-06-30";
    NSString *date2 = [DateHandle getTomorrowAndYesterDayByCurrentDate:date byIndex:2 withType:@"yyyy-MM-dd"];
    NSLog(@"新的日期结果为：%@",date2);
    NSDate *date8 = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSDate *date10 = [NSDate dateWithTimeInterval:10000 sinceDate:date8];
    //当前时间与本地时间一致,该时间点也是正确的
    //NSDate *date9 = [NSDate date];
    NSInteger a = [DateHandle getTimeFromDate:date10 withType:0];
    NSInteger b = [DateHandle getTimeFromDate:date10 withType:1];
    NSInteger c = [DateHandle getTimeFromDate:date10 withType:2];
    NSInteger d = [DateHandle getTimeFromDate:date10 withType:3];
    NSInteger e = [DateHandle getTimeFromDate:date10 withType:4];
    NSInteger f = [DateHandle getTimeFromDate:date10 withType:5];
    //是他的实际时间.但是NSDate显示的是UTC时间,如果是UTC时间要将小时加8
    NSLog(@"获取到时间为%d-%d-%d-%d-%d-%d",a,b,c,d,e,f);
    
    
    UIButton *stepBn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, 120, 30)];
    [stepBn1 setTitle:@"插入计步数据" forState:UIControlStateNormal];
    [stepBn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [stepBn1 addTarget:self action:@selector(insertStepTestData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stepBn1];
    //添加一个按钮增加到汇总表的方法
    UIButton *stepBn = [[UIButton alloc]initWithFrame:CGRectMake(200, 70, 120, 30)];
    [stepBn setTitle:@"计步数据汇总" forState:UIControlStateNormal];
    [stepBn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [stepBn addTarget:self action:@selector(collectStepData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stepBn];
    
    UIButton *exerciseBn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, 120, 30)];
    [exerciseBn1 setTitle:@"插入锻炼数据" forState:UIControlStateNormal];
    [exerciseBn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exerciseBn1 addTarget:self action:@selector(insertExerciseTestData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exerciseBn1];
    UIButton *exerciseBn = [[UIButton alloc]initWithFrame:CGRectMake(200, 120, 120, 30)];
    [exerciseBn setTitle:@"锻炼数据汇总" forState:UIControlStateNormal];
    [exerciseBn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exerciseBn addTarget:self action:@selector(collectExerciseData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exerciseBn];
    
    UIButton *sleepBn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 170, 120, 30)];
    [sleepBn1 setTitle:@"插入睡眠数据" forState:UIControlStateNormal];
    [sleepBn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sleepBn1 addTarget:self action:@selector(insertSleepTestData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sleepBn1];
    UIButton *sleepBn = [[UIButton alloc]initWithFrame:CGRectMake(200, 170, 120, 30)];
    [sleepBn setTitle:@"睡眠数据汇总" forState:UIControlStateNormal];
    [sleepBn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sleepBn addTarget:self action:@selector(collectSleepData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sleepBn];
    
    NSArray *fonts = [UIFont familyNames];
    NSLog(@"字体总数为%d",fonts.count);
    for (NSString *font in fonts) {
        NSLog(@"字体名为：%@",font);
    }
    UIFont *font1 = [UIFont fontWithName:APP_FONT_BASE size:40];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, 300, 40)];
    label.textColor = [UIColor redColor];
    label.text  =@"adhnfd";
    label.font = font1;
    [self.view addSubview:label];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(160, 270, 300, 40)];
    label1.textColor = [UIColor redColor];
    label1.text  =@"adhnfda";
    label1.font = [UIFont fontWithName:APP_FONT_THIN size:40];
    [self.view addSubview:label1];
    //先转为时间戳再转回去，看能否生效
    NSDate *date6 = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date6 timeIntervalSince1970];
    NSLog(@"转为时间戳后为%f---%f",second,second/3600);//second=536870912???
    int abc = second/(3600*24);
    int adf = abc*(3600*24);
    
    NSDate *date7 = [DateHandle stringToDate:@"2015-04-05" withtype:2];
    NSInteger aDays = [DateHandle calcDaysFromBegin:date6 end:date7];
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t_total_sleepData where date = '%@'",@"2015-04-01"];
    NSArray *data = [DBOPERATOR getDataForSQL:selectSql];
    NSDictionary *dic = data[0];
    NSString *sleepStr = dic[@"sleeps"];
    NSArray *array = [sleepStr componentsSeparatedByString:@","];
    [self handleForArray:array];
       // Do any additional setup after loading the view.
}
- (void)requestDelegateData:(NSMutableArray *)fSetArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *valueArray = [NSMutableArray array];
        NSArray *dateArray = @[@"00:00",@"06:00",@"12:00",@"18:00",@"24.00"];
        CGFloat pillarWidth = 250.0/480.0;
        CGFloat spaceWidth = 0;
        int columnLabelType = 1;
        for (int i = 0; i < fSetArray.count; i ++)
        {
            NSDictionary *sleepDic = fSetArray[i];
            NSNumber *timeNumber = [sleepDic objectForKey:@"time"];
            NSDate *date = [DateHandle getDateFromTimeStamp:[timeNumber intValue]];
            
            if ([DateHandle getTimeFromDate:date withType:2] == 10)
            {
                NSNumber *sleeps = [sleepDic objectForKey:@"sleeps"];
                NSNumber *newNumber = [NSNumber numberWithInt:[sleeps intValue]+1];
                [valueArray addObject:newNumber];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            DetailChartView *chart6 = [[DetailChartView alloc]initWithFrame:CGRectMake(30, 1300, 250, 200)];
            [chart6 drawChartViewWithDateArray:dateArray valueArray:valueArray pillarWidth:pillarWidth spaceWidth:spaceWidth columnLabelType:columnLabelType chartColor:[UIColor greenColor]];
            [scrollView addSubview:chart6];
        });
    });

}

- (void)collectStepData:(UIButton *)sender
{
    NSDate *tmpStart = [NSDate date];
    [DailyDataManager collectAllDailyData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"计步数据汇总时间为%fms",deltaTime*1000);
}
- (void)insertStepTestData:(UIButton *)sender
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970];
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 15000; i ++)
    {
        NSDictionary *stepDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+180*i],@"steps":[NSNumber numberWithInt:arc4random()%180],@"meters":[NSNumber numberWithInt:(int)180*0.7],@"kCalories":[NSNumber numberWithFloat:arc4random()%150],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:stepDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:StepDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
}
//exercise属性表示快跑，慢跑，静止等,汇总数据时需要注意
- (void)insertExerciseTestData:(UIButton *)sender
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970]
    ;
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 15000; i ++)
    {
        NSDictionary *exerciseDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+180*i],@"steps":[NSNumber numberWithInt:arc4random()%180],@"exercise":[NSNumber numberWithInt:arc4random()%3+1],@"meters":[NSNumber numberWithInt:(int)180*0.7],@"kCalories":[NSNumber numberWithFloat:arc4random()%150],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:exerciseDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:ExerciseDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
    
    
}

- (void)collectExerciseData:(UIButton *)sender
{
    NSDate *tmpStart = [NSDate date];
    [ExerciseDataManager collectAllExerciseData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"计步数据汇总时间为%fms",deltaTime*1000);
}

//插入睡眠数据
- (void)insertSleepTestData:(UIButton *)sender
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970];
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 15000; i ++)
    {
        //睡眠数据为0，1，2，3，0表示没有数据
        NSDictionary *exerciseDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+180*i],@"sleeps":[NSNumber numberWithInt:arc4random()%4],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:exerciseDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:SleepDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
}

- (void)collectSleepData:(UIButton *)sender
{
    NSDate *tmpStart = [NSDate date];
    [SleepDataManager collectAllSleepData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"睡眠数据汇总时间为%fms",deltaTime*1000);
}
//数组元素为单个数字的字符串，返回什么值?返回值要能够直接绘图,只取有效的时间,首先把两个时间点的数组取出
//开始数组表示时间段开始的点，结束数组表示时间段结束的点
- (void)handleForArray:(NSArray *)numberArray
{
    int startPoint = 0;
    int endPoint = 0;
    BOOL isSleep = NO;
    NSMutableArray *startArray = [NSMutableArray array];//记录各个时间段开始点的数组
    NSMutableArray *endArray = [NSMutableArray array];//记录各个时间段结束点的数组
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 0; i < numberArray.count-1; i ++)
    {
        NSString *number = numberArray[i];
        if ([number intValue]>0)
        {
            if (!isSleep)
            {
                startPoint = i;
                [startArray addObject:[NSNumber numberWithInt:i]];//添加第一个开始点
                isSleep = YES;
            }
        }
        else//否则为睡眠时间:0,连续的情况需要避免,结束时间点需要加上最后一个点
        {
            NSString *str;
            if (i>1) {
                str  = numberArray[i-1];
            }
            else
            {
                str = @"0";
            }
            //连续两个为0
            if (i > startPoint && [str intValue]>0 && [numberArray[i+1] intValue]<=0)
            {
                endPoint = i-1;
                [endArray addObject:[NSNumber numberWithInt:endPoint]];
                isSleep = NO;
            }
        }
    }
    int count = numberArray.count;
    if ([[numberArray lastObject] intValue]>0 || [numberArray[count-1] intValue]>0)
    {
        endPoint = count;
        [endArray addObject:[NSNumber numberWithInt:endPoint]];
        isSleep = NO;
    }
    NSLog(@"开始数组为%d---%@",startArray.count,startArray);
    NSLog(@"结束数组为%d---%@",endArray.count,endArray);
    for (int j = 0; j < endArray.count; j ++)
    {
        int sum = 0;
        for (int k = [startArray[j] intValue]; k < [endArray[j] intValue]; k ++)
        {
            sum+= [numberArray[k] intValue];
        }
        [valueArray addObject:[NSNumber numberWithInt:sum]];
    }
    NSLog(@"数值数组为:%@",valueArray);
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
