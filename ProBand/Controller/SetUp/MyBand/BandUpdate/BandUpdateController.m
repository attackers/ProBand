//
//  BandUpdateController.m
//  ProBand
//
//  Created by Echo on 15/6/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BandUpdateController.h"
#import "WaveScaleView.h"
#import "UpdatingViewController.h"
#define  screenBound [[UIScreen mainScreen] bounds]
#define diaValue CGRectGetWidth(screenBound) - 105
#define waveValue CGRectGetWidth(screenBound) - 95

@interface BandUpdateController ()
{
    WaveScaleView *waveScaleView;
    UIImageView *rotationImageView;
    UIImageView *lenovoImageView;
    UIView *topView;
    UILabel *topLabel;
    UILabel *tipLabel;
    UIButton *updateButton;
    UIView *updatingView;
    UILabel *updatingLabel;
    UILabel *updatedLabel;
}

@end

@implementation BandUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"band_update", nil);
    [self selfViewAddSubView];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [topView removeFromSuperview];
        [topLabel removeFromSuperview];
        [self addTipLabel];
        [self addUpdateBtn];
       
//        UpdatingViewController *updatingVC = [[UpdatingViewController alloc]init];
//        [self.navigationController pushViewController:updatingVC animated:YES];
    });

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.layer removeAllAnimations];
}

-(void)selfViewAddSubView
{
    /**
     用来添加波纹动画，旋转动画，和联想图标
     */
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(screenBound), CGRectGetWidth(screenBound))];
    topView.center = CGPointMake(self.view.center.x, self.view.center.y - (CGRectGetWidth(screenBound)/4));
    [self.view addSubview:topView];
    
    topLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(topView.frame) + 30, SCREEN_WIDTH, 60) text:NSLocalizedString(@"checking_for_updates", nil) fontSize:18 color: ColorRGB(17, 113, 131)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topLabel];
    
    [self topViewAddSubView];
}

/**
 *  添加蓝牙开启时的动画及动画图片
 */
- (void)topViewAddSubView
{
    /**
     波纹动画
     */
    waveScaleView = [[WaveScaleView alloc]initWithFrame:CGRectMake(0, 0, waveValue, waveValue)];
    waveScaleView.center = CGPointMake(CGRectGetWidth(topView.frame)/2 -30, CGRectGetWidth(topView.frame)/2 - 40);
    waveScaleView.backgroundColor = [UIColor clearColor];
    [topView addSubview:waveScaleView];
    /**
     *  旋转动画
     *
     */
    rotationImageView = [PublicFunction getImageView:CGRectMake(0,0, diaValue,diaValue) imageName:@"search_bracelet_light"];
    rotationImageView.center = CGPointMake(CGRectGetWidth(topView.frame)/2, CGRectGetWidth(topView.frame)/2 -10);
    [topView addSubview:rotationImageView];
    [self rotationBegin];
    /**
     联想图标
     */
    lenovoImageView = [PublicFunction getImageView:CGRectMake(0,0, 40, 105) imageName:@"band_icon"];
    lenovoImageView.center = rotationImageView.center;
    [topView addSubview:lenovoImageView];
}

- (void)addTipLabel
{
    tipLabel = [PublicFunction getlabel:CGRectMake(0, 0, SCREEN_WIDTH, 60) text:NSLocalizedString(@"new_version_software_can_be_updated", nil) textSize:18 textColor:ColorRGB(60, 60, 60) textBgColor:nil textAlign:@"center"];
    tipLabel.center = topView.center;
    [self.view addSubview:tipLabel];
}

- (void)addUpdateBtn
{
    updateButton = [PublicFunction getButtonInControl:self frame:CGRectMake(20, SCREEN_HEIGHT-80, SCREEN_WIDTH-40, 40) title:NSLocalizedString(@"update", nil) align:@"center" color:[UIColor blackColor] fontsize:14 tag:1 clickAction:@selector(updateBtnClick)];
    updateButton.center = topLabel.center;
    updateButton.layer.cornerRadius = 20;
    updateButton.layer.masksToBounds = YES;
    updateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    updateButton.layer.borderWidth = 1.0;
    [self.view addSubview:updateButton];
}

#pragma mark *************** 自定义事件 ************************
/**
 *  旋转动画
 */
- (void)rotationBegin
{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotation.duration = 1;
    rotation.repeatCount = 999;
    rotation.autoreverses = NO;
    rotation.delegate = self;
    [rotationImageView.layer addAnimation:rotation forKey:@"animagelayer"];
    
}

- (void)updateBtnClick
{
    NSLog(@"updateBtnClick");
    [tipLabel removeFromSuperview];
    [self addUpdateView];
    [updateButton removeFromSuperview];
    
}

/**
 *  添加重新搜索动画
 */
- (void)addUpdateView
{
    updatingView = [[UIView alloc]initWithFrame:self.view.bounds];
//    reSearchView.backgroundColor =[UIColor colorWithRed:3/255.0f green:25/255.0f blue:38/255.0f alpha:.5f];
    [self.view addSubview:updatingView];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 132, 132)];
    imageview.image = [UIImage imageNamed:@"Search_bracelet_progress"];
    imageview.center = updatingView.center;
    [updatingView addSubview:imageview];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotation.duration = 1;
    rotation.repeatCount = 999;
    [imageview.layer addAnimation:rotation forKey:@"transform.rotation.z"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 24)];
    label.center = imageview.center;
    label.textColor = COLOR(25, 198, 195);
    label.text = @"Loading...";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [updatingView addSubview:label];
    
    updatingLabel = [PublicFunction getlabel:CGRectMake(0, SCREEN_HEIGHT-110, SCREEN_WIDTH, 60) text:NSLocalizedString(@"updating", nil) fontSize:18 color: ColorRGB(17, 113, 131)];
    updatingLabel.center = topLabel.center;
    updatingLabel.textAlignment = NSTextAlignmentCenter;
    updatingLabel.backgroundColor = [UIColor clearColor];
    [updatingView addSubview:updatingLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [updatingView removeFromSuperview];
//        [updatingLabel removeFromSuperview];
        [self showUpdatedView];
    });
}

- (void)showUpdatedView
{
    updatedLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    updatedLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    updatedLabel.font = [UIFont fontWithName:@"Arial" size:18];
//    updatedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    updatedLabel.numberOfLines = 0;
    updatedLabel.textAlignment=NSTextAlignmentCenter;
    updatedLabel.backgroundColor=[UIColor clearColor];
    updatedLabel.text=NSLocalizedString(@"updated_message", nil);
    [self.view addSubview:updatedLabel];
}


@end
