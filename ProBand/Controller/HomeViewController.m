//
//  HomeViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/5.
//  Copyright (c) 2015年 fenda. All rights reserved.


#import "HomeViewController.h"
#import "SetUpViewController.h"
#import "DataBase.h"

#import "ThirdPartyLoginManager.h"
#import "DailyViewController.h"
#import "PayViewController.h"
#import "SleepViewController.h"
#import "TrainingViewController.h"

#import "SCNavTabBarController.h"

#import "EShadeChartDataModel.h"
#import "TestDataModel.h"
#import "SetUpViewController.h"

#import "TopAler.h"
#import "SSOTest.h"
#import "UIView+Extension.h"
#import "LoginNewController.h"
#import "SendCommandToPeripheral.h"
#import "ScheduleViewController.h"
#import "CustomButton.h"
#import "CAShawRoundView.h"
#import "CustomSegmentedControl.h"
@interface HomeViewController ()<UIAlertViewDelegate,SCNavSrollDelegate,CustomSegmentedDelegate>
{
    SSOTest *sso;
     UIImageView *pageImage;
    CustomSegmentedControl *seg;
    UIScrollView *backGroundScr;
    UIView *topview;
    UIViewController *backVC;
    UIViewController *currentVC;
    DailyViewController *dailyVC;
    PayViewController *PayVC;
    TrainingViewController *TrainingVC;
    SleepViewController *SleepVC;
    NSInteger currentIndex;
}
@property (nonatomic, strong)NSTimer *ssoTimer;//单点登录定时器
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"home_menu_bg"],[UIImage imageNamed:@"daily_icon_sel"],[UIImage imageNamed:@"pay_icon_sel"],[UIImage imageNamed:@"sleep_icon_sel"],[UIImage imageNamed:@"training_icon_sel"], nil];
    seg = [[CustomSegmentedControl alloc]initWithItems:images frame:CGRectMake(CGRectGetWidth(self.view.frame)/2-(130/2), SCREEN_HEIGHT - 50, 130, 20)];
    seg.delegate = self;
    [seg selectTabItem:currentIndex];
    [[UIApplication sharedApplication].keyWindow addSubview:seg];
    topview.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [seg removeFromSuperview];
    topview.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.redRoundImageView.hidden = NO;
    self.segmentTationLineL.hidden = NO;
    self.segmentTationLineR.hidden = NO;
    currentIndex = 0;
    //add by wsf for ssoTest
//    sso = [SSOTest new];
//    [sso initNet];
//
//    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"] == nil) {
//        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        [sso initUploadEnvAndSubmitUUID];
//        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:@"UUID"];
//    }
//    
//    [self checkUUID];
//    _ssoTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkUUID) userInfo:nil repeats:YES];

    //add end
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"daily_more"] forState:UIControlStateNormal];
    [self.leftBtn setTitle:nil forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(gotoBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
 
    [self.rightBtn setImage:[UIImage imageNamed:@"daily_calendar_press"] forState:UIControlStateNormal];
    self.rightBtn.hidden = NO;
    
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 1)];
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(goRight) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"daily", nil)];
    self.view.backgroundColor = ColorRGB(48, 54, 60);
    
//    // Do any additional setup after loading the view.
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [DataBase updateTable];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//    {
//        self.navigationController.navigationBar.barTintColor = navigationColor;
//    }
//    else
//    {
//        self.navigationController.navigationBar.tintColor= navigationColor;
//    }
//    
//    DailyViewController *oneViewController = [[DailyViewController alloc] init];
//    oneViewController.title = NSLocalizedString(@"daily", nil);
//    oneViewController.view.backgroundColor = [UIColor whiteColor];
//    int lineWidth = 90;
//    if (iPhone4) {
//        
//        lineWidth = 80;
//    }
//    else if (iPhone6||iPhone6plus)
//    {
//        lineWidth = 115;
//    }
//    [oneViewController drawShadeChartView:[TestDataModel getModelDataForShadeChart] withLineWidth:lineWidth withShow:YES];
//    PayViewController *twoViewController = [[PayViewController alloc] init];
//    
//    twoViewController.title = NSLocalizedString(@"pay", nil);
//    twoViewController.view.backgroundColor = [UIColor whiteColor];
//    
//    SleepViewController *threeViewController = [[SleepViewController alloc] init];
//    threeViewController.title = NSLocalizedString(@"sleep", nil);
//    threeViewController.view.backgroundColor = [UIColor whiteColor];
//    [threeViewController drawViewwithData:[TestDataModel getModelDataForPieChart] showColor:YES];
//    
//    TrainingViewController *fourViewController = [[TrainingViewController alloc] init];
//    fourViewController.title = NSLocalizedString(@"exercise", nil);
//    fourViewController.view.backgroundColor = [UIColor whiteColor];
//    [fourViewController drawShadeChartView:[TestDataModel getExerciseModelDataForShadeChart] withLineWidth:32.0f withShow:YES];
//    
//    TrainingViewController *fourViewController
//    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
//    navTabBarController.subViewControllers = @[oneViewController, twoViewController, threeViewController, fourViewController];
//    navTabBarController.showArrowButton = NO;
//    navTabBarController.delegate = self;
//    [navTabBarController addParentController:self];
//    
////    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2- 50, SCREEN_HEIGHT - 110, 100, 30)];
////    _pageControl.numberOfPages = 4;
////    _pageControl.currentPage = 0;
////    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1];
////    navTabBarController.pageControl = _pageControl;
//    pageImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2- 33, SCREEN_HEIGHT - 80, 66, 4.5)];
//    pageImage.image = [UIImage imageNamed:@"home_page_1"];
//    [self.view addSubview:pageImage];
    
    [DataBase updateTable];
    [self performSelector:@selector(BLEConnectStatu) withObject:self afterDelay:2.0f];
    //    [HTTPManage connectServerWithblock:^(NSData *result,NSError *error)
    //    {
    //        NSLog(@"error=%@",error.description);
    //    }];
    [self scanBandAndConnectBand];
    [self addSubView0819];
}
- (void)scanBandAndConnectBand
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"defaultBand"]) {
        [[BLEManage shareCentralManager]startscanPeripheral];
    }
    
    
}

-(void)gotoBackBtnClick
{
   
    SetUpViewController *setUpVC = [[SetUpViewController alloc] init];
    [self.navigationController pushViewController:setUpVC animated:YES];
    
}
-(void)goRight
{
    ScheduleViewController *sche = [[ScheduleViewController alloc]init];
    [self.navigationController pushViewController:sche animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)BLEConnectStatu
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpen"]){
        TopAler *top = [TopAler shareTopAler];
        BLEManage *ble = [BLEManage shareCentralManager];
        [ble startscanPeripheral];
        [ble connectState:^(BOOL ok) {
            if (ok) {
                top.showText = @"连接成功";
            }else{
                top.showText = @"手环已断开，请检查设备";
            }
            [top startShow];
        }];
    }
}

- (void)checkUUID
{
    [sso getUUIDFromServerWithBlock:^(NSString *uuid) {
        NSString *currentUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
        NSLog(@"Echo------->>>>%@, %@",uuid, currentUUID);
        if ([uuid isEqualToString:currentUUID]) {
            
        }else
        {
            NSLog(@"uuid冲突");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil];
            alertView.centerX = SCREEN_WIDTH/2;
            alertView.centerY = SCREEN_HEIGHT/2;
            alertView.width = SCREEN_WIDTH - 150;
            alertView.height = 180;
            [alertView show];
            [_ssoTimer invalidate];
        }
    }];
}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //退出按钮
        NSLog(@"退出按钮点击");
        LoginNewController *lobginVC = [[LoginNewController alloc] init];
        [self.navigationController pushViewController:lobginVC animated:YES];
    }else
    {
        //重新登录
        NSLog(@"重新登录");
        [sso uploadCurrentDevicesUUID];
        _ssoTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkUUID) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_ssoTimer forMode:NSRunLoopCommonModes];
        
    }
}

- (void)navTabbarDidScrollToController:(NSInteger)index
{
    NSLog(@"当前滚动到第%ud个视图",index);
    switch (index) {
        case 0:
        {
            pageImage.image = [UIImage imageNamed:@"home_page_1"];
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"daily", nil)];
        }
            break;
        case 1:
        {
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"pay", nil)];
            pageImage.image = [UIImage imageNamed:@"home_page_2"];

        }
            break;
        case 2:
        {
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"sleep", nil)];
            pageImage.image = [UIImage imageNamed:@"home_page_3"];

        }
            break;
        case 3:
        {
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"exercise", nil)];
            pageImage.image = [UIImage imageNamed:@"home_page_4"];

        }
            break;
        default:
            break;
    }
}

#pragma mark |********************** 新的UI *************************|
- (void)addSubView0819
{
    topview = [[UIView alloc]initWithFrame:CGRectMake(0, 67, CGRectGetWidth(self.view.frame), 40)];
    UIImageView *electricImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 18, 16, 16)];
    topview.backgroundColor = ColorRGB(48, 54, 60);
    electricImageView.image = [UIImage imageNamed:@"daily_charging"];
    /**
     蓝牙连接状态
     */
    CustomButton *blueButton = [[CustomButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(electricImageView.frame) + 6, CGRectGetMidY(electricImageView.frame)- 18, 100, 36)];
    blueButton.rightLabel.text = @"Lenovo_1234";
    blueButton.leftImageView.image = [UIImage imageNamed:@"daily_band"];
    [blueButton addTarget:self action:@selector(clickBlueButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     同步按钮
     */
    CustomButton *syncButton = [[CustomButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 136, CGRectGetMidY(electricImageView.frame) -18,100, 36)];
    syncButton.leftImageView.image = [UIImage imageNamed:@"daily_synchronous"];

    syncButton.rightLabel.text = @"未同步";
    if ([[NSUserDefaults standardUserDefaults]objectForKey:touchBeginSyncDate]) {
        NSString *syncString = [[NSUserDefaults standardUserDefaults]objectForKey:touchBeginSyncDate];
        NSString *suSyncstring = [syncString substringFromIndex:syncString.length - 5];
        syncButton.rightLabel.text = [NSString stringWithFormat:@"最近同步%@",suSyncstring];

    }
    [syncButton addTarget:self action:@selector(clickSyncButton:) forControlEvents:UIControlEventTouchUpInside];
    /**
     *  分享按钮
     */
    CustomButton *shareButton = [[CustomButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(syncButton.frame)+8, CGRectGetMidY(electricImageView.frame)-18, 80, 36)];

    shareButton.leftImageView.image = [UIImage imageNamed:@"daily_upload"];
    [shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:electricImageView];
    [topview addSubview:blueButton];
    [topview addSubview:syncButton];
    [topview addSubview:shareButton];
    [[UIApplication sharedApplication].keyWindow addSubview:topview];
    
    backVC = [[UIViewController alloc]init];
    backVC.view.frame = CGRectMake(0, CGRectGetMaxY(shareButton.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(shareButton.frame));
    [self addChildViewController:backVC];
    [self.view addSubview:backVC.view];
    
    dailyVC = [DailyViewController new];
    dailyVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(backVC.view.frame), CGRectGetHeight(backVC.view.frame));
    [backVC addChildViewController:dailyVC];
    [backVC.view addSubview:dailyVC.view];
    currentVC = dailyVC;
    
    SleepVC = [SleepViewController new];
    SleepVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(backVC.view.frame), CGRectGetHeight(backVC.view.frame));
    [backVC addChildViewController:SleepVC];
    
    TrainingVC = [TrainingViewController new];
    TrainingVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(backVC.view.frame), CGRectGetHeight(backVC.view.frame));
    [backVC addChildViewController:TrainingVC];
    
    PayVC = [PayViewController new];
    PayVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(backVC.view.frame), CGRectGetHeight(backVC.view.frame));
    [backVC addChildViewController:PayVC];
    
}
/**
 *  蓝牙连接按钮
 *
 *  @param sender
 */
- (void)clickBlueButton:(UIButton*)sender
{
    NSLog(@"clickBlueButton");
}
/**
 *  同步事件
 *
 *  @param sender
 */
- (void)clickSyncButton:(CustomButton*)sender
{
    NSLog(@"clickSyncButton");
    [[[HistoryData alloc]init] getHostoryDataRequest];
    sender.rightLabel.text = [NSString stringWithFormat:@"最近同步%@",[self syncDate]];

}
/**
 *  分享事件
 *
 *  @param sender
 */
- (void)clickShareButton:(UIButton*)sender
{
    NSLog(@"clickShareButton");
    [[LenovoShareSdk sharedInstance]popShareView:sender];

}
/**
 *  选择按钮代理
 *
 *  @param index 返回所选择的item
 */
- (void)selectTabItemIndex:(int)index
{
    NSLog(@"%d",index);
    switch (index) {
        case 0:
        {
            if (currentIndex == 0) {
                return;
            }
            
            [backVC transitionFromViewController:currentVC toViewController:dailyVC duration:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
             self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"daily", nil)];
            currentVC = dailyVC;
            currentIndex = 0;
        }
            break;
        case 1:
        {
            if (currentIndex == 1) {
                return;
            }
            [backVC transitionFromViewController:currentVC toViewController:PayVC duration:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"pay", nil)];
            currentVC = PayVC;
            currentIndex = 1;
        }
            break;
        case 2:
        {
            if (currentIndex == 2) {
                return;
            }
            [backVC transitionFromViewController:currentVC toViewController:SleepVC duration:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"sleep", nil)];
            currentVC = SleepVC;
            currentIndex = 2;
        }
            break;
        case 3:
        {
            if (currentIndex == 3) {
                return;
            }
            [backVC transitionFromViewController:currentVC toViewController:TrainingVC duration:0.1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            self.titleLabel.text =  [NSString stringWithFormat:@"联想自由付·%@",NSLocalizedString(@"exercise", nil)];
            currentVC = TrainingVC;
            currentIndex = 3;
        }
            break;
        default:
            break;
    }
    
}
- (NSString*)syncDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fDate = [[NSDateFormatter alloc]init];
    [fDate setDateFormat:@"HH:mm"];
    NSString *string = [fDate stringFromDate:date];
    
    NSDateFormatter *fdefault = [[NSDateFormatter alloc]init];
    [fdefault setDateFormat:@"yy/MM/dd HH:mm"];
    NSString *fString = [fdefault stringFromDate:date];
    [[NSUserDefaults standardUserDefaults]setObject:fString forKey:touchBeginSyncDate];
    return string;

}
@end
