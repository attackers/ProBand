//
//  SelectProBandViewController.m
//  ProBand
//
//  Created by attack on 15/6/17.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SelectProBandViewController.h"
#import "ProbandListTableViewController.h"
#import "HomeViewController.h"
#import "BLEManage.h"
#import "PeripheralModel.h"
#import "InitUserInfomationViewController.h"
#import "SendCommandToPeripheral.h"
#import "UIView+Toast.h"
#define  screenBound [[UIScreen mainScreen] bounds]
#define bottomViewY CGRectGetHeight(self.view.frame)<568.0f?(CGRectGetHeight(backgrougScrollview.frame) - 180):(CGRectGetHeight(backgrougScrollview.frame) - 120)
static BOOL onlyPush;
@interface SelectProBandViewController ()
{
    
    UILabel *titleLabel;
    UILabel *contentLabel;
    UILabel *bottomLabel;
    /**
     *  选择重新搜索或者绑定
     */
    UISegmentedControl *segmented;
    /**
     *  主背景窗口，主要是为了针对3.5的布局
     */
    UIScrollView *backgrougScrollview;
    /**
     *  显示搜索到的设备表格
     */
    ProbandListTableViewController *prolistTableview;
    /**
     *  重新搜索时的动画页面
     */
    UIView *reSearchView;
    UIButton *jump2HomeBtn;
    PeripheralModel *modelPerip;
    UIImageView*  lenovoImageview;
    UIView *banddingFailview;

}
@end

@implementation SelectProBandViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    onlyPush = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat contentSize = CGRectGetHeight(self.view.frame);
    backgrougScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), contentSize)];
    backgrougScrollview.scrollEnabled = YES;
    backgrougScrollview.pagingEnabled = YES;
    if (CGRectGetHeight(self.view.frame)<568.0f) {
        
        contentSize = 628;
    }
    backgrougScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), contentSize);
    backgrougScrollview.showsHorizontalScrollIndicator = NO;
    backgrougScrollview.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:[PublicFunction getImageView:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) imageName:@"search_bracelet_bg_"]];
    [self.view addSubview:backgrougScrollview];
    
    [self addsubview];
    
//    __weak SelectProBandViewController *weakSelf = self;
    [[BLEManage shareCentralManager]connectState:^(BOOL ok) {
        
        if (ok) {
            lenovoImageview.hidden = NO;
            bottomLabel.hidden = NO;
            banddingFailview.hidden = YES;
            if (onlyPush) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    reSearchView.hidden = YES;
                    InitUserInfomationViewController *iVC = [[InitUserInfomationViewController alloc]init];
                    self.navigationController.navigationBarHidden = NO;
                    [self.navigationController pushViewController:iVC animated:YES];
                    
                });
            }
            onlyPush=NO;
        }else{
            lenovoImageview.hidden = YES;
            reSearchView.hidden = YES;
//            dispatch_cancel(<#object#>)
            [self bangdingFail];
            NSLog(@"no");
        }
    }];
}
- (void)addsubview
{
    /**
     最上方的提示
     */
    titleLabel = [PublicFunction getlabel:CGRectMake(0, 37, CGRectGetWidth(self.view.frame), 47) text:NSLocalizedString(@"select_band", nil) fontSize:25 color: ColorRGB(36, 213, 211)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [backgrougScrollview addSubview:titleLabel];
    /**
     上方第二个提示
     */
    CGFloat contentLabelY = CGRectGetMaxY(titleLabel.frame) -20;
    contentLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, contentLabelY, CGRectGetWidth(self.view.frame), 60)];
    contentLabel.text = NSLocalizedString(@"show_band_id_then_select", nil);
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = ColorRGB(17, 113, 131);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.backgroundColor = [UIColor clearColor];
    [backgrougScrollview addSubview:contentLabel];
    
    /**
     最下方的选择控件
     */
    segmented = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"search_again", nil),NSLocalizedString(@"bind_now", nil), nil]];
    segmented.frame = CGRectMake(20, backgrougScrollview.contentSize.height - 65, CGRectGetWidth(backgrougScrollview.frame) - 40,37);
    segmented.layer.cornerRadius = CGRectGetHeight(segmented.frame)/2;
    segmented.layer.borderColor = [UIColor whiteColor].CGColor;
    segmented.tintColor = [UIColor whiteColor];
    segmented.backgroundColor = [UIColor clearColor];
    segmented.layer.borderWidth = 1.5;
    segmented.layer.masksToBounds = YES;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [segmented addTarget:self action:@selector(segmentedSel) forControlEvents:UIControlEventValueChanged];
    [backgrougScrollview addSubview:segmented];
    /**
     *  联想标识图片
     *
     */
    
    lenovoImageview = [PublicFunction getImageView:CGRectMake(0, 0,50, 140) imageName:@"band_icon"];
    lenovoImageview.center = CGPointMake(CGRectGetWidth(screenBound)/2, CGRectGetMidY(segmented.frame) - 155);
    lenovoImageview.backgroundColor = [UIColor clearColor];
    [backgrougScrollview addSubview:lenovoImageview];
    /**
     *  下方提示确认手环ID的label
     *
     */
    
    //    bottomLabel = [PublicFunction getlabel: text: font:[UIFont systemFontOfSize:12]];
    bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lenovoImageview.frame)+15, CGRectGetWidth(self.view.frame),24)];
    bottomLabel.text = NSLocalizedString(@"ensure_band_id_on_band", nil);
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = ColorRGB(36, 213, 211);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont boldSystemFontOfSize:12];
    [backgrougScrollview addSubview:bottomLabel];
    
    /**
     手环列表表格
     */
    prolistTableview = [[ProbandListTableViewController alloc]init];
    prolistTableview.view.frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame) - 3, CGRectGetWidth(self.view.frame), 150);
    prolistTableview.probandlistArray = _probandListArray;
    [backgrougScrollview addSubview:prolistTableview.view];
    [prolistTableview probandlistIndex:^(NSInteger index) {
        
        modelPerip = _probandListArray[index];
    }];
    
    UIImageView *imageview = [PublicFunction getImageView:CGRectMake(0, CGRectGetMaxY(prolistTableview.view.frame), CGRectGetWidth(self.view.frame), 2) imageName:@"search_bracelet_bg_line"];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [backgrougScrollview addSubview:imageview];
    
}
/**
 *  选择事件处理
 */
- (void)segmentedSel
{
    switch (segmented.selectedSegmentIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            if (modelPerip.peripheral == nil) {
                [self.view makeToast:@"please select Proband" duration:2 position:@"center"];
            }else{
                
                if (_probandListArray.count>0) {
                    
                    [[BLEManage shareCentralManager]connectPeripheral:modelPerip.peripheral];
                    [self addResearchView];
                }
            }
            
        }
            break;
        default:
            break;
    }
    NSLog(@"click segmengted");
    segmented.selectedSegmentIndex = -1;
    
}
/**
 *  添加重新搜索动画
 */
- (void)addResearchView
{
    reSearchView = [[UIView alloc]initWithFrame:self.view.frame];
    reSearchView.backgroundColor =[UIColor colorWithRed:3/255.0f green:25/255.0f blue:38/255.0f alpha:.5f];
    [self.view addSubview:reSearchView];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 132, 132)];
    imageview.image = [UIImage imageNamed:@"Search_bracelet_progress"];
    imageview.center = reSearchView.center;
    [reSearchView addSubview:imageview];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotation.duration = 1;
    rotation.repeatCount = 999;
    [imageview.layer addAnimation:rotation forKey:@"transform.rotation.z"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 24)];
    label.center = imageview.center;
    label.textColor = [UIColor whiteColor];
    label.text = @"Loading....";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [reSearchView addSubview:label];
}
/**
 *  绑定失败显示的图片
 */
- (void)bangdingFail
{
    lenovoImageview.hidden = YES;
    bottomLabel.hidden = YES;
    banddingFailview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(prolistTableview.view.frame)+ 15, CGRectGetWidth(prolistTableview.view.frame), CGRectGetHeight(backgrougScrollview.frame) - CGRectGetMaxY(prolistTableview.view.frame) - 38 -15)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 -23, 20, 46, 46)];
    imageview.image = [UIImage imageNamed:@"connection_fails"];
    [banddingFailview addSubview:imageview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(self.view.frame), 24) ];
    label.text = NSLocalizedString(@"connection_failed", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [banddingFailview addSubview:label];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), CGRectGetWidth(self.view.frame), 24)];
    label2.text = NSLocalizedString(@"turn_on_near_phone_full_power", nil);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:12];
    [banddingFailview addSubview:label2];
    banddingFailview.backgroundColor = [UIColor clearColor];
    [backgrougScrollview addSubview:banddingFailview];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
