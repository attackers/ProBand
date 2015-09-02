//
//  DetailBaseViewController.m
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DetailBaseViewController.h"
#import "TrendDailyController.h"
#import "TrendSleepController.h"
#import "TrendExerciseController.h"
#import "HomeViewController.h"
#import "TriangleView.h"
@interface DetailBaseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //UILabel *dateLabel;
    
    NSArray *sleepArray1;
    NSArray *sleepTimeArr1;
    NSArray *sleepArray2;
    NSArray *sleepTimeArr2;
    
    NSMutableArray *buttonArray;//最下面3个按钮的数组
    NSInteger currectIndex;
    CGFloat currentHeight;
    
    UITableView *tableView;
    
    NSInteger rowCount;
}
//@property (nonatomic, strong)UISegmentedControl *segment;
@end

@implementation DetailBaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    buttonArray = [NSMutableArray array];
    currectIndex = 0;
    currentHeight = 44;
    rowCount = 2;
    // Do any additional setup after loading the view.
}
- (void)setControllerWithTitle:(NSString *)title UpDescribeArray:(NSArray *)array1 downDescribeArray:(NSArray *)array2 upValueArray:(NSArray *)valueArray1 downValueArray:(NSArray *)valueArray2 withIndex:(NSInteger)index
{
    
    [self setHomeBarTitle:title leftImage:@"return.png" leftAction:@selector(goBack:) rightImage:@"share.png" rightAction:@selector(share:) bgColor:COLOR(48, 54, 60)];
    sleepArray1 = [NSArray arrayWithArray:array1];
    sleepArray2 = [NSArray arrayWithArray:array2];
    sleepTimeArr1 = [NSArray arrayWithArray:valueArray1];
    sleepTimeArr2 = [NSArray arrayWithArray:valueArray2];
        currectIndex = index;
    [self createView];
    
}
- (void)updateControllerWithUpDescribeArray:(NSArray *)array1 downDescribeArray:(NSArray *)array2 upValueArray:(NSArray *)valueArray1 downValueArray:(NSArray *)valueArray2
{
    sleepArray1 = [NSArray arrayWithArray:array1];
    sleepArray2 = [NSArray arrayWithArray:array2];
    sleepTimeArr1 = [NSArray arrayWithArray:valueArray1];
    sleepTimeArr2 = [NSArray arrayWithArray:valueArray2];
    [tableView reloadData];
}

- (void)goBack:(UIButton *)sender
{
    NSLog(@"当前视图控制器有：%@",self.navigationController.viewControllers);
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (void)share:(UIButton *)sender
{
    [[LenovoShareSdk sharedInstance]popShareView:sender];
}

- (void)createView
{
    //适配屏幕
    CGFloat headHeight = 400;//headView的高度
    CGFloat footHeight = 64;//footVIew的高度
    if (iPhone4) {
        headHeight = 270;
        footHeight = 55;
    }
    else if(iPhone5)//模拟器会将6识别为5
    {
        headHeight = 316;
    }
    else if (iPhone6)
    {
        headHeight = 316;
    }
    else if (iPhone6plus)
    {
        headHeight = 430;
    }
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, SCREEN_HEIGHT+16-footHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = COLOR(48, 54, 60);
    tableView.allowsSelection = NO;
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    

    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, headHeight)];
    _headView.backgroundColor = [UIColor clearColor];
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    lineLayer.frame = CGRectMake(0, headHeight-1, SCREEN_WIDTH, 0.5);
    [_headView.layer addSublayer:lineLayer];
    
//    _segment = [[UISegmentedControl alloc]initWithItems:@[@"日",@"周",@"月"]];
//    //_segment.tintColor = [UIColor blueColor];
//    _segment.backgroundColor = COLOR(12, 70, 123);
//    _segment.selectedSegmentIndex = 0;
//    _segment.frame = CGRectMake(SCREEN_WIDTH/2-75, 100, 150, 25);
//    _segment.layer.masksToBounds = YES;
//    _segment.layer.cornerRadius = 12.5;
//    [headView addSubview:_segment];
//    
//    dateLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(_segment.frame), SCREEN_WIDTH, 30) text:@"2015-5-20" fontSize:16 color:[UIColor whiteColor] align:@"center"];
//    [headView addSubview:dateLabel];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-footHeight-64, SCREEN_WIDTH, footHeight)];
    footView.backgroundColor = COLOR(28, 31, 35);
    NSArray *titleArray = @[NSLocalizedString(@"daily", nil),NSLocalizedString(@"sleep", nil),NSLocalizedString(@"exercise", nil)];
    NSArray *normalBnArray = @[@"home_daily.png",@"home_sleep.png",@"home_exercise.png"];
    NSArray *selectBnArray = @[@"home_daily_sel.png",@"home_sleep_sel.png",@"home_exercise_sel.png"];
    //添加3个按钮:按钮选中后保持选中状态
    for (int i = 0; i < 3; i ++)
    {
        NSInteger tag = 1000+i;
        CGRect rect = CGRectMake(SCREEN_WIDTH*i/3, 0, SCREEN_WIDTH/3, 60);
        UIButton *tabBn = [[UIButton alloc]initWithFrame:rect];
        //tabBn.backgroundColor = [UIColor redColor];
        [tabBn setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabBn setImage:[UIImage imageNamed:normalBnArray[i]] forState:UIControlStateNormal];
        [tabBn setImage:[UIImage imageNamed:selectBnArray[i]] forState:UIControlStateHighlighted];
        if (i == currectIndex) {
            [tabBn setTitleColor:COLOR(84, 162, 226) forState:UIControlStateNormal];
            [tabBn setImage:[UIImage imageNamed:selectBnArray[i]] forState:UIControlStateNormal];
        }
        else
        {
        [tabBn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [tabBn setTitleColor:COLOR(84, 162, 226) forState:UIControlStateHighlighted];
        [tabBn addTarget:self action:@selector(pushToDetaiController:) forControlEvents:UIControlEventTouchUpInside];
        tabBn.tag = tag;
        [footView addSubview:tabBn];
        [buttonArray addObject:tabBn];
    }
    
    tableView.tableHeaderView = _headView;
    //后期修改：footView不能加载tableView上
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:footView];
}

- (void)hiddenDownView
{
    rowCount = 0;
    [tableView reloadData];
}

- (void)showDownView
{
    rowCount = 2;
    [tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentHeight = 110;
    if (iPhone4) {
        currentHeight = 85;
    }
    if (iPhone5) {
        currentHeight= 102;
    }
    if (iPhone6plus) {
        currentHeight = 120;
    }
    return currentHeight;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    //CGFloat lineHeight = 60;
    
    switch (indexPath.row) {
        case 0:
        {
            for (int i = 1; i < sleepTimeArr1.count; i ++)
            {
                CALayer *lineLayer = [[CALayer alloc]init];
                lineLayer.frame = CGRectMake(SCREEN_WIDTH*i/sleepTimeArr1.count, 20, 0.5, currentHeight-40);
                lineLayer.backgroundColor = [UIColor blackColor].CGColor;
                [cell.contentView.layer addSublayer:lineLayer];
                
            }
            for (int i = 0; i < sleepTimeArr1.count; i ++) {
                UILabel *describeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepTimeArr1.count+5, 20, SCREEN_WIDTH/sleepTimeArr1.count-10, 20) text:sleepArray1[i] fontSize:10 color:COLOR(80, 96, 114) align:@"center"];
                [cell.contentView addSubview:describeLabel];
                
                UILabel *timeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/3+5, CGRectGetMaxY(describeLabel.frame), SCREEN_WIDTH/3-10, 30) text:nil fontSize:14 color:COLOR(225, 228, 229) align:@"center"];
                timeLabel.attributedText = [self getAttributedStr:sleepTimeArr1[i]];
                [cell. contentView addSubview:timeLabel];
            }
        }
            break;
        case 1:
        {
            for (int i = 1; i < sleepTimeArr2.count; i ++)
            {
                CALayer *lineLayer = [[CALayer alloc]init];
                lineLayer.frame = CGRectMake(SCREEN_WIDTH*i/sleepTimeArr2.count, 20, 0.5, currentHeight-40);
                lineLayer.backgroundColor = [UIColor blackColor].CGColor;
                [cell.contentView.layer addSublayer:lineLayer];
                
            }
            //绘制顶部的线条
            CALayer *lineLayer = [[CALayer alloc]init];
            lineLayer.frame = CGRectMake(60, 0, SCREEN_WIDTH-120, 0.5);
            lineLayer.backgroundColor = [UIColor blackColor].CGColor;
            [cell.contentView.layer addSublayer:lineLayer];
            
            for (int i = 0; i < sleepArray2.count; i ++) {
                UILabel *describeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepArray2.count+5, 20, SCREEN_WIDTH/sleepArray2.count-10, 20) text:sleepArray2[i] fontSize:10 color:COLOR(80, 96, 114) align:@"center"];
                [cell.contentView addSubview:describeLabel];
                
                UILabel *timeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepArray2.count+5, CGRectGetMaxY(describeLabel.frame), SCREEN_WIDTH/sleepArray2.count-10, 30) text:nil textSize:14 textColor:COLOR(225, 228, 229) textBgColor:[UIColor clearColor] textAlign:@"center"];
                timeLabel.attributedText = [self getAttributedStr:sleepTimeArr2[i]];
                [cell. contentView addSubview:timeLabel];
            }
            
            //添加底部的三角形
            CGFloat length = 10;
            CGRect rect = CGRectMake(SCREEN_WIDTH*currectIndex/3+SCREEN_WIDTH/6-length, currentHeight-length, 2*length, length);
            TriangleView *triangle = [[TriangleView alloc]initWithFrame:rect];
            [cell.contentView addSubview:triangle];

        }
            break;
        default:
            break;
    }
    return cell;
}
//每次都会重新加载本类的View
- (void)pushToDetaiController:(UIButton *)sender
{
    NSArray *arrayControllers = self.navigationController.viewControllers;
    switch (sender.tag) {
        case 1000://日常详情
        {
            BOOL hasPushed = NO;
            for (UIViewController *viewController in arrayControllers) {
                if ([viewController isKindOfClass:[TrendDailyController class]]) {
                    hasPushed = YES;
                    [self.navigationController popToViewController:viewController animated:NO];
                }
            }
            if (!hasPushed) {
                [self.navigationController pushViewController:[TrendDailyController new] animated:NO];
            }
        }
            break;
        case 1001://睡眠
        {
            BOOL hasPushed = NO;
            for (UIViewController *viewController in arrayControllers) {
                if ([viewController isKindOfClass:[TrendSleepController class]]) {
                    hasPushed = YES;
                    [self.navigationController popToViewController:viewController animated:NO];
                }
            }
            if (!hasPushed) {
                [self.navigationController pushViewController:[TrendSleepController new] animated:NO];
            }
        }
            break;
        case 1002://锻炼
        {
            BOOL hasPushed = NO;
            for (UIViewController *viewController in arrayControllers) {
                if ([viewController isKindOfClass:[TrendExerciseController class]]) {
                    hasPushed = YES;
                    [self.navigationController popToViewController:viewController animated:NO];
                }
            }
            if (!hasPushed) {
                [self.navigationController pushViewController:[TrendExerciseController new] animated:NO];
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//只要包含有数字就要变大:英文可能要重写,小时分钟可能为各位数
-(NSMutableAttributedString *)getAttributedStr:(NSString *)str
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];
    if ([str rangeOfString:@"小"].location != NSNotFound)
    {
        NSString *subStr1 = [str componentsSeparatedByString:@"小时"][1];
        NSString *subStr0 = [str componentsSeparatedByString:@"小时"][0];
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0,subStr0.length)];
        //后半部分需要和分钟区别开来
//        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(str.length - subStr1.length + 1, 2)];
//        NSString *minuteSTr = [subStr1 componentsSeparatedByString:@"分"][0];
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(subStr0.length+2, subStr1.length-2)];
    }
    else
    {
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, dreepStr.length)];
    }
    return dreepStr;
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
