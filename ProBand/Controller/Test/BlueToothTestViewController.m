//
//  BlueToothTestViewController.m
//  ProBand
//
//  Created by attack on 15/6/12.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BlueToothTestViewController.h"
#import "WaveScaleView.h"
#import "SelectProBandViewController.h"
#import "BLEManage.h"
#import "HomeViewController.h"
#import "SubSegmentedControl.h"
#define  screenBound [[UIScreen mainScreen] bounds]
#define diaValue CGRectGetWidth(screenBound) - 105
#define waveValue CGRectGetWidth(screenBound) - 95
@interface BlueToothTestViewController ()
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIImageView *rotationImageView;
    UIImageView *lenovoImageView;
    UIImageView *backgroungImageView;
    WaveScaleView *waveScaleView;
    BLEManage *bluetoothManager;
    
    UIView *bottomView;
    UIView *staticWaveView;
    UIView *bluetoothOffAlert;
    NSTimer *stopTime;
    
}
@property (nonatomic,strong)__block NSMutableArray *blockArray;
@end

@implementation BlueToothTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    bluetoothManager = [BLEManage shareCentralManager];
    [self selfViewAddSubView];
    [self bottomViewAddSubView];
    [self ifBluetoothIsTurnedOffAddSubView];
    
    __weak BlueToothTestViewController *weakself = self;
    __weak BLEManage *blue = bluetoothManager;
    __block UIView *bot = bottomView;
    __block UIView *wave = staticWaveView;
    __block UIView *aler = bluetoothOffAlert;
    if (bluetoothManager.isOpenOrOFF) {
        bottomView.hidden = NO;
        staticWaveView.hidden = YES;
        
    }else{
        bottomView.hidden = YES;
        staticWaveView.hidden = NO;
    }
    bluetoothManager.centerState = ^(BOOL open){
        
        if (open) {
            if ([weakself.view viewWithTag:98701]) {
                [aler removeFromSuperview];
            }
            bot.hidden = NO;
            wave.hidden = YES;
            [blue startscanPeripheral];
            [weakself performSelector:@selector(scanstop) withObject:weakself afterDelay:5];
            
        }else{
            
            bot.hidden = YES;
            wave.hidden = NO;
            [weakself addBluetoothisOffAlerviewShow];
            
        }
        
    };
    [bluetoothManager returnProbandArray:^(NSMutableArray *probandlistArray) {
        
        weakself.blockArray = probandlistArray.mutableCopy;
        [weakself pushToNextView];
        
    }];
    
}
- (void)pushToNextView
{
    [stopTime invalidate];
    if (bluetoothManager.isOpenOrOFF) {
        SelectProBandViewController *view = [[SelectProBandViewController alloc]init];
        view.probandListArray = self.blockArray.mutableCopy;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}
- (void)scanstop
{
    [bluetoothManager stopScanPeripheral];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (bluetoothManager.isOpenOrOFF) {
        stopTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanstop) userInfo:nil repeats:NO];
        [bluetoothManager startscanPeripheral];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.view.layer removeAllAnimations];
//    [rotationImageView.layer removeAllAnimations];
    
}
-(void)selfViewAddSubView
{
    backgroungImageView = [PublicFunction getImageView:screenBound imageName:@"search_bracelet_bg_"];
    [self.view addSubview:backgroungImageView];
    /**
     用来添加波纹动画，旋转动画，和联想图标
     */
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(screenBound) - CGRectGetWidth(screenBound), CGRectGetWidth(screenBound), CGRectGetWidth(screenBound))];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    /**
     用来添加波纹静态图片
     */
    staticWaveView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(screenBound) - CGRectGetWidth(screenBound), CGRectGetWidth(screenBound), CGRectGetWidth(screenBound))];
    staticWaveView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:staticWaveView];
    
    /**
     最上方的提示
     */
    titleLabel = [PublicFunction getlabel:CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 47) text:NSLocalizedString(@"searching_band", nil) fontSize:25 color: ColorRGB(36, 213, 211)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    /**
     上方第二个提示
     */
    contentLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)-20, CGRectGetWidth(self.view.frame), 60) text:NSLocalizedString(@"turn_on_near_phone_full_power", nil) fontSize:12 color: ColorRGB(17, 113, 131)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentLabel];
    
}
/**
 *  添加蓝牙开启时的动画及动画图片
 */
- (void)bottomViewAddSubView
{
    /**
     波纹动画
     */
    waveScaleView = [[WaveScaleView alloc]initWithFrame:CGRectMake(0, 0, waveValue, waveValue)];
    waveScaleView.center = CGPointMake(CGRectGetWidth(bottomView.frame)/2 -30, CGRectGetWidth(bottomView.frame)/2 - 40);
    waveScaleView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:waveScaleView];
    /**
     *  旋转动画
     *
     */
    rotationImageView = [PublicFunction getImageView:CGRectMake(0,0, diaValue,diaValue) imageName:@"search_bracelet_light"];
    rotationImageView.center = CGPointMake(CGRectGetWidth(bottomView.frame)/2, CGRectGetWidth(bottomView.frame)/2 -10);
    [bottomView addSubview:rotationImageView];
    [self rotationBegin];
    /**
     联想图标
     */
    lenovoImageView = [PublicFunction getImageView:CGRectMake(0,0, 40, 105) imageName:@"band_icon"];
    lenovoImageView.center = rotationImageView.center;
    [bottomView addSubview:lenovoImageView];
}
/**
 *  添加蓝牙没有开启时的图片
 */
- (void)ifBluetoothIsTurnedOffAddSubView
{
    [self addBackgroungLayer];
    
    UIImageView *failsImageView = [PublicFunction getImageView:CGRectMake(0, 0, 55, 55) imageName:@"connection_fails"];
    failsImageView.center = CGPointMake(CGRectGetWidth(bottomView.frame)/2, CGRectGetWidth(bottomView.frame)/2 - 30);
    
    UILabel *failsLabel = [PublicFunction getlabel:CGRectMake(CGRectGetMidX(failsImageView.frame) -45, CGRectGetMaxY(failsImageView.frame), 90, 37) text:NSLocalizedString(@"connection_failed", nil)];
    failsLabel.font = [UIFont boldSystemFontOfSize:17];
    failsLabel.textColor = [UIColor whiteColor];
    failsLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *bluetoothOffLabel = [PublicFunction getlabel:CGRectMake(CGRectGetMinX(failsLabel.frame), CGRectGetMaxY(failsLabel.frame) - 10, 90, 37) text:NSLocalizedString(@"BT_is_not_open", nil)];
    bluetoothOffLabel.textColor = [UIColor whiteColor];
    bluetoothOffLabel.font = [UIFont systemFontOfSize:13];
    bluetoothOffLabel.textAlignment = NSTextAlignmentCenter;
    [staticWaveView addSubview:failsImageView];
    [staticWaveView addSubview:failsLabel];
    [staticWaveView addSubview:bluetoothOffLabel];
    
}
/**
 *  自定义未开启蓝牙时的波纹及界面显示
 */
- (void)addBackgroungLayer
{
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(CGRectGetWidth(bottomView.frame)/6, CGRectGetHeight(bottomView.frame)/6, diaValue, diaValue);
    layer1.borderColor = [UIColor colorWithRed:18/255.0f green:118/255.0f blue:145/255.0f alpha:.5f].CGColor;
    layer1.borderWidth = 2.0f;
    layer1.cornerRadius = layer1.frame.size.width/2;
    layer1.transform = CATransform3DMakeScale(0.7f, 0.7f, 1.0f);
    [staticWaveView.layer addSublayer:layer1];
    //
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(CGRectGetWidth(bottomView.frame)/6, CGRectGetHeight(bottomView.frame)/6, diaValue, diaValue);
    layer2.borderColor = [UIColor colorWithRed:18/255.0f green:118/255.0f blue:145/255.0f alpha:1.0f].CGColor;
    layer2.borderWidth = 2.0f;
    layer2.cornerRadius = layer2.frame.size.width/2;
    layer2.backgroundColor = [UIColor colorWithRed:18/255.0f green:118/255.0f blue:145/255.0f alpha:.3f].CGColor;
    [staticWaveView.layer addSublayer:layer2];
    
    CGFloat scaleValue = 0.7f;
    CGFloat alphaValue = 0.3f;
    for (int i = 0; i<6; i++) {
        CALayer *layer3 = [CALayer layer];
        layer3.frame = CGRectMake(CGRectGetWidth(bottomView.frame)/6, CGRectGetHeight(bottomView.frame)/6, diaValue, diaValue);
        layer3.borderColor = [UIColor colorWithRed:18/255.0f green:118/255.0f blue:145/255.0f alpha:alphaValue].CGColor;
        layer3.borderWidth = 1.0f;
        layer3.cornerRadius = layer3.frame.size.width/2;
        layer3.transform = CATransform3DMakeScale(scaleValue, scaleValue, 1.0f);
        [staticWaveView.layer addSublayer:layer3];
        if (i>0) {
            scaleValue = scaleValue+0.2;
            
        }else{
            scaleValue = scaleValue+0.5;
        }
        alphaValue= alphaValue-.08;
    }
}
- (void)addBluetoothisOffAlerviewShow
{
    bluetoothOffAlert = [[UIView alloc]initWithFrame:self.view.frame];
    bluetoothOffAlert.tag = 98701;
    NSString *string = NSLocalizedString(@"turn_on_BT_connect_to_phone", nil);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bluetoothOffAlert.frame), 100)];
    label.numberOfLines =2;
    label.center = CGPointMake(bluetoothOffAlert.center.x, bluetoothOffAlert.center.y - 58);
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = string;
    
    SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"setting", nil),NSLocalizedString(@"i_know", nil), nil]];
    seg.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 10, CGRectGetWidth(bluetoothOffAlert.frame) - 40, 37);
    seg.layer.cornerRadius = CGRectGetHeight(seg.frame)/2;
    [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
        
        if (segmc.selectedSegmentIndex == 1) {
            
            [bluetoothOffAlert removeFromSuperview];
            
        }else{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        
    }];
    seg.type = 1;
    bluetoothOffAlert.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [bluetoothOffAlert addSubview:seg];
    [bluetoothOffAlert addSubview:label];
    [self.view addSubview:bluetoothOffAlert];
    
    
}
#pragma mark *************** 自定义事件 ************************
/**
 *  旋转动画
 */
- (void)rotationBegin
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotation.duration = 1.5;
    rotation.repeatCount = MAXFLOAT;
    rotation.autoreverses = NO;
    rotation.delegate = self;
    [rotationImageView.layer addAnimation:rotation forKey:@"animagelayer"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
