//
//  HomeViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/5.
//  Copyright (c) 2015年 fenda. All rights reserved.


#import "HomeViewController.h"
#import "SetUpViewController.h"

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
    CustomButton *syncButton;
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

    [self performSelector:@selector(BLEConnectStatu) withObject:self afterDelay:0.5f];
    [self addSubView0819];
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
    
    NSArray *vcArray = [NSArray arrayWithArray:self.navigationController.viewControllers];
    id vHome = vcArray[0];
    if ([vHome isKindOfClass:[HomeViewController class]]) {
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
    syncButton = [[CustomButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 136, CGRectGetMidY(electricImageView.frame) -18,100, 36)];
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
    

    
    SleepVC = [[SleepViewController alloc]init];
    SleepVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [backVC addChildViewController:SleepVC];
    
    TrainingVC = [TrainingViewController new];
    TrainingVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [backVC addChildViewController:TrainingVC];
    
    PayVC = [PayViewController new];
    PayVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(backVC.view.frame), CGRectGetHeight(backVC.view.frame));
    [backVC addChildViewController:PayVC];
    
    dailyVC = [DailyViewController new];
    dailyVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [backVC addChildViewController:dailyVC];
    [backVC.view addSubview:dailyVC.view];
    currentVC = dailyVC;
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[DateAndWeatherInformation alloc]init] timeSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[DateAndWeatherInformation alloc]init] weatherSync];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[HistoryData alloc]init] getHostoryDataRequest];
    });
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
    UIViewAnimationOptions options = UIViewAnimationOptionLayoutSubviews ;//UIViewAnimationOptionLayoutSubviews
    switch (index) {
        case 0:
        {
            if (currentIndex == 0) {
                return;
            }
            
            [backVC transitionFromViewController:currentVC toViewController:dailyVC duration:0.1 options:options animations:^{
                
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
            [backVC transitionFromViewController:currentVC toViewController:PayVC duration:0.1 options:options animations:^{
                
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
            [backVC transitionFromViewController:currentVC toViewController:SleepVC duration:0.1 options:options animations:^{
                
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
            [backVC transitionFromViewController:currentVC toViewController:TrainingVC duration:0.1 options:options animations:^{
                
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
