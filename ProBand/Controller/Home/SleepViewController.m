//
//  SleepViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SleepViewController.h"
#import "TrendSleepController.h"
#import "TestDataModel.h"

#import "SleepDataManager.h"
#import "SyncAlertView.h"
#import "SendCommandToPeripheral.h"

#import "TotalInfoManager.h"
@interface SleepViewController ()

@property (nonatomic,strong)UILabel *dreepSleepLab;
@property (nonatomic,strong)UILabel *lightSleepLab;
@property (nonatomic,strong)UILabel *weakSleepLab;
@property (nonatomic,strong)UIScrollView *bigScrollView;

@property (nonatomic, strong)t_total_sleepData *currentModel;
@end

@implementation SleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentModel = [TotalInfoManager totalSleepModelFromUserDefaults];
    EPieChartDataModel *pieModel;
    if (_currentModel) {
        pieModel = [[EPieChartDataModel alloc] initWithBudget:[_currentModel.total_deep_sleep intValue] current:[_currentModel.total_light_sleep intValue] estimate:[_currentModel.total_awake_sleep intValue] bgimageOne:@"sleep_dashboard_pointer" bgimageTwo:@"sleep_dashboard_sober" bgimageThree:@"sleep_dashboard_round"];
    }
    else
    {
        pieModel = [TestDataModel getModelDataForPieChart];
    }
    
    [self createView];

    //添加by Star
    [self drawViewwithData:pieModel showColor:YES];
    //[[SleepDataManager sharedInstance]getSleepData];
}

-(void)createView
{
    
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_bigScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT +10)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bigScrollView];
    _bigScrollView.backgroundColor = COLOR(5, 27, 52);
    __block SleepViewController *saftSelf = self;
    [_bigScrollView addHeaderWithCallback:^{
        
        [[[HistoryData alloc]init] getHostoryDataRequest];
        if (saftSelf.ePieChart) {
            [saftSelf.ePieChart removeFromSuperview];

        }
        
        [saftSelf drawViewwithData:[TestDataModel getModelDataForPieChart] showColor:YES];
        
        //暂时先写在一个延迟方法中
        [saftSelf performSelector:@selector(endRefreshingTemp) withObject:saftSelf afterDelay:1];
        
    }];
    
    CGFloat bgOffSet = -120;
    CGFloat addY = 0;
    if (iPhone4) {
        bgOffSet = -130;
    }
    else if (iPhone5)
    {
        NSLog(@"iphone5");
        bgOffSet = -140;
        addY = 5;
    }
    else if (iPhone6)
    {
        bgOffSet = -120;
    }
    else if (iPhone6plus)
    {
        bgOffSet = -120;
    }
     UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, bgOffSet, SCREEN_WIDTH, SCREEN_HEIGHT+30+addY)];
    bgimage.image = [UIImage imageNamed:@"exercise_bg.png"];
    [_bigScrollView addSubview:bgimage];
    
    UILabel *timeTitleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50,5, 100, 20) text:NSLocalizedString(@"sleep_time", nil) fontSize:14 color:[UIColor whiteColor] align:@"center"];
    timeTitleLab.font = [UIFont fontWithName:APP_FONT_THIN size:14];
    [_bigScrollView addSubview:timeTitleLab];
    
    UILabel *timeLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50, CGRectGetMaxY(timeTitleLab.frame), 110, 30) text:@"22:00-08:00" fontSize:16 color:[UIColor whiteColor] align:@"center"];
    timeLab.font = [UIFont fontWithName:APP_FONT_THIN size:16];
    [_bigScrollView addSubview:timeLab];
    
    for (int i = 0; i<3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*SCREEN_WIDTH/3 + 40,  SCREEN_HEIGHT -(iPhone6||iPhone6plus?280:250), 30, 30)];
        
        if (iPhone4) {
            
            imageView.frame = CGRectMake((i%3)*SCREEN_WIDTH/3 + 40, 260, 25, 25);
        }
        UILabel *lab = [PublicFunction getlabel:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + 30, 40, 30) text:nil fontSize:17 color:[UIColor whiteColor] align:@"center"];
        if (iPhone4) {
            
            lab.frame = CGRectMake(imageView.frame.origin.x - 10, imageView.frame.origin.y + 30, 40, 30);
        }
        [_bigScrollView addSubview:lab];
        if (i==0) {
            imageView.image = [UIImage imageNamed:@"sleep_deep_sleep"];
            lab.text = NSLocalizedString(@"deep_sleep", nil);
            _dreepSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45, lab.frame.origin.y + 30, 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_dreepSleepLab];
            _dreepSleepLab.attributedText = [self getAttributedStr:@"3小时48分钟"];
        }
        else if (i==1)
        {
            imageView.image = [UIImage imageNamed:@"sleep_light_sleep"];
            lab.text = NSLocalizedString(@"light_sleep", nil);
            _lightSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45, lab.frame.origin.y + 30, 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_lightSleepLab];
            _lightSleepLab.attributedText = [self getAttributedStr:@"4小时13分钟"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"sleep_sober"];
            lab.text = NSLocalizedString(@"awake", nil);
            _weakSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45, lab.frame.origin.y + 30, 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_weakSleepLab];
            _weakSleepLab.attributedText = [self getAttributedStr:@"12小时10分钟"];
        }
        [_bigScrollView addSubview:imageView];
    }
    
    [self showFromDB];
}

-(void)endRefreshingTemp
{
    //刷新中间的UI:从数据库中获取,by Star
    [self showFromDB];
     [self.bigScrollView headerEndRefreshing];
    [SyncAlertView shareSyncAlerview:YES];
}

- (void)showFromDB
{
    if (_currentModel)
    {
        NSString *totalAwake = _currentModel.total_awake_sleep;
        NSString *totalLight = _currentModel.total_light_sleep;
        NSString *totalDeep = _currentModel.total_deep_sleep;
        EPieChartDataModel *model = [[EPieChartDataModel alloc]initWithBudget:[totalAwake intValue] current:[totalLight intValue] estimate:[totalDeep intValue] bgimageOne:@"sleep_dashboard_pointer.png" bgimageTwo:@"sleep_dashboard_sober.png" bgimageThree:@"sleep_dashboard_round.png"];
        [self drawViewwithData:model showColor:YES];
        //更新下方的UI
        _dreepSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalDeep intValue]/60,[totalDeep intValue]%60]];
        _lightSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalLight intValue]/60,[totalLight intValue]%60]];
        _weakSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalAwake intValue]/60,[totalAwake intValue]%60]];
    }
    else
    {
        EPieChartDataModel *model = [[EPieChartDataModel alloc]initWithBudget:0 current:0 estimate:0 bgimageOne:@"sleep_dashboard_pointer.png" bgimageTwo:@"sleep_dashboard_sober.png" bgimageThree:@"sleep_dashboard_round.png"];
        [self drawViewwithData:model showColor:YES];
        _dreepSleepLab.attributedText = [self getAttributedStr:@"0小时0分钟"];
        _lightSleepLab.attributedText = [self getAttributedStr:@"0小时0分钟"];
        _weakSleepLab.attributedText = [self getAttributedStr:@"0小时0分钟"];
    }
}
-(NSMutableAttributedString *)getAttributedStr:(NSString *)str
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];
    //分钟可能是两个或者一个
    if ([str rangeOfString:@"小"].location != NSNotFound) {
        NSString *subStr1 = [str componentsSeparatedByString:@"小"][1];
        
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, dreepStr.length - (subStr1.length + 1))];
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(str.length - subStr1.length + 1, subStr1.length-3)];
    }

    return dreepStr;
}


//-(void)buttomBtnClick:(UIButton *)btn
//{
//    
//}


- (void)drawViewwithData:(EPieChartDataModel *)dataModel showColor:(BOOL)blean{
    
    int y = 220;
    int k = 70;
    if (iPhone6||iPhone6plus) {
        
        y = 250;
        k = 110;
    }
    else if (iPhone4)
    {
        y = 200;
        k = 55;
    }
    if (_ePieChart) {
        [_ePieChart removeFromSuperview];
    }
    
    _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2- y/2,k,y,y) ePieChartDataModel:dataModel withIsSleep:YES];
    if (blean) {
        [_ePieChart.frontPie setLineWidth:15];
        [_ePieChart.frontPie setRadius:y/2];
        _ePieChart.frontPie.currentColor = [UIColor colorWithRed:88/255.0 green:172/255.0 blue:223/255.0 alpha:1];//浅睡
        _ePieChart.frontPie.budgetColor = [UIColor colorWithRed:16/255.0 green:96/255.0 blue:151/255.0 alpha:1];//深睡
        _ePieChart.frontPie.estimateColor = [UIColor colorWithRed:138/255.0 green:200/255.0 blue:238/255.0 alpha:1];//清醒
        
    }
    
    
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
    
    [_bigScrollView addSubview:_ePieChart];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [_ePieChart addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) taped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //_bigScrollView.backgroundColor = [UIColor yellowColor];
        _bigScrollView.backgroundColor = COLOR(6, 24, 44);
        [[XlabTools sharedInstance]startLoadingInView:_ePieChart withmessage:@"加载中..."];
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[[FMDBTool sharedInstance] addAllTestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XlabTools sharedInstance]stopLoading];
            [self.navigationController pushViewController:[TrendSleepController new] animated:YES];
        });
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///创建新版的UI
- (void)createUI2
{
    
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
