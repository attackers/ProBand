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
#import "HistoryDataInfomation.h"

#import "CAShadeRoundView.h"
@interface SleepViewController ()<HistoryDataInfomationDelegate>

@property (nonatomic,strong)UILabel *dreepSleepLab;
@property (nonatomic,strong)UILabel *lightSleepLab;
@property (nonatomic,strong)UILabel *weakSleepLab;
@property (nonatomic,strong)UIScrollView *bigScrollView;

@property (nonatomic, strong)CAShadeRoundView *shadeRoundView;
@property (nonatomic, strong)t_total_sleepData *currentModel;
@end

@implementation SleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加同步成功的方法
    HistoryDataInfomation *history = [HistoryDataInfomation shareHistoryDataInfomation];
    history.delegate = self;
    
    _currentModel = [TotalInfoManager totalSleepModelFromUserDefaults];
    CGFloat value = 0.0;
    if (_currentModel)
    {
      value = ([_currentModel.total_light_sleep intValue]+[_currentModel.total_awake_sleep intValue]+[_currentModel.total_deep_sleep intValue])/1440.0;
    }
    
    
    [self createView];

    //添加by Star
    [self drawRoundViewWithValue:value];
    //[[SleepDataManager sharedInstance]getSleepData];
}
- (void)viewWillAppear:(BOOL)animated
{
    _bigScrollView.backgroundColor = COLOR(48, 54, 60);
}
//如果蓝牙没有连接也需要调用该方法
- (void)historyDataSyncEnd:(BOOL)end
{
    if (end) {
        [self endRefreshingTemp];
    }
}
-(void)createView
{
   _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_bigScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT +10)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bigScrollView];
    __block SleepViewController *saftSelf = self;
    [_bigScrollView addHeaderWithCallback:^{
        
        [[[HistoryData alloc]init] getHostoryDataRequest];
        
        [saftSelf drawRoundViewWithValue:0.0];
        
        //下拉刷新调用的方法
        [[XlabTools sharedInstance]startLoadingInView:saftSelf.view withmessage:@"下拉数据中..."];
        //暂时先写在一个延迟方法中:需要修改
        //[saftSelf performSelector:@selector(endRefreshingTemp) withObject:saftSelf afterDelay:1];
        
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
    UIImageView *segmentationImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, CGRectGetWidth(self.view.frame), 10)];
    segmentationImageview.image = [UIImage imageNamed:@"daily_projection.png"];
    segmentationImageview.contentMode = UIViewContentModeScaleAspectFill;
    [_bigScrollView addSubview:segmentationImageview];
    
    _bigScrollView.backgroundColor = COLOR(48, 54, 60);
    
    UILabel *timeTitleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 100,25, 60, 20) text:NSLocalizedString(@"sleep_time", nil) fontSize:14 color: ColorRGB(92, 96, 102) align:@"right"];
    timeTitleLab.font = [UIFont fontWithName:MicrosoftYaHe size:12];
    [_bigScrollView addSubview:timeTitleLab];
    
    UILabel *timeLab = [PublicFunction getlabel:CGRectMake(CGRectGetMaxX(timeTitleLab.frame)+5, CGRectGetMinY(timeTitleLab.frame)-14, 180, 40) text:@"22:00-08:00" fontSize:18 color:ColorRGB(50, 125, 222) align:nil];
    timeLab.font = [UIFont fontWithName:MicrosoftYaHe size:26];
    [_bigScrollView addSubview:timeLab];
    
    for (int i = 0; i<3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*SCREEN_WIDTH/3 + 40,  SCREEN_HEIGHT -(iPhone6||iPhone6plus?280:250), 30, 30)];
        
        if (iPhone4) {
            
            imageView.frame = CGRectMake((i%3)*SCREEN_WIDTH/3 + 40, 260, 25, 25);
        }
        UILabel *lab = [PublicFunction getlabel:CGRectMake(imageView.frame.origin.x-5, imageView.frame.origin.y + 60, 40, 30) text:nil fontSize:17 color:[UIColor whiteColor] align:@"center"];// CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + 30, 40, 30)
        if (iPhone4) {
            
            lab.frame = CGRectMake(imageView.frame.origin.x-55, imageView.frame.origin.y + 60, 120, 30);
        }
        [_bigScrollView addSubview:lab];
        if (i==0) {
            imageView.image = [UIImage imageNamed:@"sleep_deep_sleep"];
            lab.text = NSLocalizedString(@"deep_sleep", nil);
            _dreepSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45, imageView.frame.origin.y + 30, 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];//CGRectMake(lab.frame.origin.x - 45, lab.frame.origin.y + 30, 120, 30)
            [_bigScrollView addSubview:_dreepSleepLab];
            _dreepSleepLab.attributedText = [self getAttributedStr:@"3小时48分钟"];
        }
        else if (i==1)
        {
            imageView.image = [UIImage imageNamed:@"sleep_light_sleep"];
            lab.text = NSLocalizedString(@"light_sleep", nil);
            _lightSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45, CGRectGetMinY(_dreepSleepLab.frame), 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_lightSleepLab];
            _lightSleepLab.attributedText = [self getAttributedStr:@"4小时13分钟"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"sleep_sober"];
            lab.text = NSLocalizedString(@"awake", nil);
            _weakSleepLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 45,CGRectGetMinY(_dreepSleepLab.frame), 120, 30) text:@"" fontSize:12 color:[UIColor whiteColor] align:@"center"];
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
    [[XlabTools sharedInstance]stopLoading];
}

- (void)showFromDB
{
    if (_currentModel.userid == nil) {
        _currentModel =  [TotalInfoManager totalSleepModelFromUserDefaults];
    }
    if (_currentModel.userid && _currentModel.mac)
    {
        NSString *totalAwake = _currentModel.total_awake_sleep;
        NSString *totalLight = _currentModel.total_light_sleep;
        NSString *totalDeep = _currentModel.total_deep_sleep;
        CGFloat value = ([totalAwake intValue]+[totalLight intValue]+[totalDeep intValue])/1440.0;
        [self drawRoundViewWithValue:value];
        
        NSLog(@"----%d---%d---%d",[totalDeep intValue],[totalLight intValue],[totalAwake intValue]);
        //更新下方的UI
        _dreepSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalDeep intValue]/60,[totalDeep intValue]%60]];
        _lightSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalLight intValue]/60,[totalLight intValue]%60]];
        _weakSleepLab.attributedText = [self getAttributedStr:[NSString stringWithFormat:@"%d小时%d分钟",[totalAwake intValue]/60,[totalAwake intValue]%60]];
    }
    else
    {
        [self drawRoundViewWithValue:0.0];
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



- (void) taped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //_bigScrollView.backgroundColor = [UIColor yellowColor];
        _bigScrollView.backgroundColor = COLOR(6, 24, 44);
        [[XlabTools sharedInstance]startLoadingInView:_shadeRoundView withmessage:@"加载中..."];
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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

- (void)drawRoundViewWithValue:(CGFloat)value
{
    if (_shadeRoundView)
    {
        [_shadeRoundView removeFromSuperview];
    }
    _shadeRoundView = [[CAShadeRoundView alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 265)];
    _shadeRoundView.startColor = COLOR(48, 181, 245);
    _shadeRoundView.endColor = COLOR(255,182,0);
    _shadeRoundView.value = value;
    _shadeRoundView.describe = @"睡眠时长";
    _shadeRoundView.type = 2;
    _shadeRoundView.endImageName = @"exercise_dashboard_02.png";
    [_bigScrollView addSubview:_shadeRoundView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [_shadeRoundView addGestureRecognizer:tapGestureRecognizer];
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
