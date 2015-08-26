//
//  UserSportTargetController.m
//  ProBand
//
//  Created by star.zxc on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserSportTargetController.h"
#import "TargrtCellView.h"
#import "UserSleepTargetController.h"
#import "UserTargetModel.h"
#import "SendCommandToPeripheral.h"
#import "UIView+Toast.h"
#import "TargetInfoManager.h"
@interface UserSportTargetController ()
{
    UIScrollView *bgScrollView;
    TargrtCellView *bushuView;
    TargrtCellView *caloryView;
    TargrtCellView *sportTimeView;
    TargrtCellView *kmView;
    UILabel *humbugLabel;
    NSInteger _stepTarget;
    UISegmentedControl *segmented;
    
    UInt16 stepUInt;
    UInt16 calorieUInt;
    UInt32 movementUInt;
    double distancesUInt;
    float sliderValue;
    
    NSUserDefaults *userDefault;
    NSDictionary * sportInfo;
    UISlider *slider ;

}
@property (nonatomic, strong)t_goal_step *sportTarget;
@end

@implementation UserSportTargetController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.leftBtn.hidden = YES;
    self.titleLabel.text = @"运动目标";
    self.rightBtn.transform = CGAffineTransformMakeScale(1,1);
    [self.rightBtn addTarget:self action:@selector(goToSleepTargetView) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

//-(void)saveSporInfo{
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
////    [dict setValue:[NSString stringWithFormat:@"%i",stepUInt] forKey:STEPUINT];
////    [dict setValue:[NSString stringWithFormat:@"%i",calorieUInt] forKey:CALORIEUINT];
////    [dict setValue:[NSString stringWithFormat:@"%f",( float)movementUInt] forKey:MOVEMENTUINT];
////    [dict setValue:[NSString stringWithFormat:@"%f",distancesUInt] forKey:DISTANCESUINT];
////    [dict setValue:[NSString stringWithFormat:@"%f",sliderValue] forKey:SLIDERVALUE];
////    [userDefault setObject:dict forKey:SPORTDICT];
//    [userDefault synchronize];
//}
- (void)goToSleepTargetView
{
    /**
     传输运动目标2015-08-11
     */

//    [self saveSporInfo];
    [[[PersonalGoalsRequest alloc]init] sendMovementGoals:stepUInt Calorie:calorieUInt MovementTime:movementUInt Distances:distancesUInt];
    
    //确认目标，保存到数据库
    [[TargetInfoManager sharedInstance]updateSportTargetWithDictionary:_sportTarget];
    
    UserSleepTargetController *sleepController = [UserSleepTargetController new];
    sleepController.stepTarget = _stepTarget;
    [self.navigationController pushViewController:sleepController animated:YES];
}
- (void)initData
{
    _stepTarget = 0;
    if (_sportTarget == nil) {
        _sportTarget = [[TargetInfoManager sharedInstance] sportTargetFromDB];
    }
}
- (void)createView
{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+30)];
    [self.view addSubview:bgScrollView];
    
    UILabel *suggestLabel = [PublicFunction getlabel:CGRectMake(0, 0, SCREEN_WIDTH, 60) text:@"根据世界卫生组织的建议,结合你的个人信息,\n我们为你推荐中等强度运动40分钟,相当于快走8000步." textSize:13 textColor:[UIColor lightGrayColor] textBgColor:nil textAlign:@"center"];
    suggestLabel.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:suggestLabel];
    
    //绘线
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.frame = CGRectMake(0, CGRectGetMaxY(suggestLabel.frame)+10, SCREEN_WIDTH, 1);
    lineLayer.backgroundColor = CGCOLOR(232, 232, 232);
    [bgScrollView.layer addSublayer:lineLayer];
    
    
    CGFloat cellWidth = 113;
    bushuView = [[TargrtCellView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lineLayer.frame)+20, cellWidth, cellWidth)];
    if (_sportTarget) {
        [bushuView setDescribtion:@"步数/步" value:_sportTarget.goal_step rotationAngle:0 radius:cellWidth/2];
    }
    else
    {
        [bushuView setDescribtion:@"步数/步" value:@"8000" rotationAngle:0 radius:cellWidth/2];
    }
    [bgScrollView addSubview:bushuView];
    
    caloryView = [[TargrtCellView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-CGRectGetMaxX(bushuView.frame), CGRectGetMinY(bushuView.frame), cellWidth, cellWidth)];
    NSString *caloryValueText = [NSString stringWithFormat:@"%@",_sportTarget.goal_kcal];
    [caloryView setDescribtion:@"卡路里/千卡" value:caloryValueText rotationAngle:0 radius:cellWidth/2];
    [bgScrollView addSubview:caloryView];
    //下面加一个Label
    humbugLabel = [PublicFunction getlabel:CGRectMake(CGRectGetMinX(caloryView.frame), CGRectGetMinY(caloryView.frame)+80, cellWidth, 20) text:@"≈一个汉堡" textSize:14 textColor:[UIColor lightGrayColor] textBgColor:nil textAlign:@"center"];
    [bgScrollView addSubview:humbugLabel];
    
    sportTimeView = [[TargrtCellView alloc]initWithFrame:CGRectMake(CGRectGetMinX(bushuView.frame), CGRectGetMaxY(bushuView.frame)+20, cellWidth, cellWidth)];
    NSString *sportTimeValue = [NSString stringWithFormat:@"%@",_sportTarget.goal_time];
    [sportTimeView setDescribtion:@"时间/分钟" value:sportTimeValue rotationAngle:0 radius:cellWidth/2];
    [bgScrollView addSubview:sportTimeView];
    
    kmView = [[TargrtCellView alloc]initWithFrame:CGRectMake(CGRectGetMinX(caloryView.frame), CGRectGetMinY(sportTimeView.frame), cellWidth, cellWidth)];
    CGFloat km = [_sportTarget.goal_distance floatValue]/1000.0;
    NSString *kmValue = [NSString stringWithFormat:@"%.1f",km];
    [kmView setDescribtion:@"距离/公里" value:kmValue rotationAngle:0 radius:cellWidth/2];
    [bgScrollView addSubview:kmView];
    
    //加一个滑块:背部加背景？
    slider = [[UISlider alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-266.5)/2, CGRectGetMaxY(kmView.frame)+20, 266.5, 10)];
    
    //先添加图片
    UIImageView *imageVew = [PublicFunction getImageView:CGRectMake((SCREEN_WIDTH-266.5)/2, CGRectGetMaxY(kmView.frame)+20, 250, 10) imageName:@"moving_target_regulation02"];
    [bgScrollView addSubview:imageVew];
    //slider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moving_target_regulation02"]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 20000.0;
    slider.value = [_sportTarget.goal_step intValue];//(float)_stepTarget
    slider.continuous = YES;
    [slider setMinimumTrackImage:[UIImage imageNamed:@"moving_target_regulation02"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"moving_target_regulation01"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"moving_target_regulation04"] forState:UIControlStateHighlighted];
    [slider setThumbImage:[UIImage imageNamed:@"moving_target_regulation04"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [bgScrollView addSubview:slider];
    
    /**
     最下方的选择控件
     */
    segmented = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"确认",@"取消", nil]];
    segmented.frame = CGRectMake(20, CGRectGetMaxY(slider.frame)+15, CGRectGetWidth(bgScrollView.frame) - 40,37);
    segmented.layer.cornerRadius = CGRectGetHeight(segmented.frame)/2;
    segmented.layer.borderColor = [UIColor grayColor].CGColor;
    segmented.tintColor = [UIColor grayColor];
    segmented.backgroundColor = [UIColor clearColor];
    segmented.layer.borderWidth = 1.5;
    segmented.layer.masksToBounds = YES;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [segmented addTarget:self action:@selector(segmentedSel) forControlEvents:UIControlEventValueChanged];
    if (!_showSegment) {
        segmented.hidden = YES;
        self.rightBtn.hidden = NO;
    }
    [bgScrollView addSubview:segmented];
    
}
- (void)valueDidChanged:(UISlider *)sender
{
    CGFloat radius = kmView.frame.size.width/2;
    //变化时上面数据跟着变化
    int stepAccount = (int)sender.value/100*100;
    _stepTarget = stepAccount;
    stepUInt = stepAccount;
    [bushuView setDescribtion:@"步数/步" value:[NSString stringWithFormat:@"%d",stepAccount]        rotationAngle:stepAccount radius:radius];
    int calory = stepAccount/100*4;
    calorieUInt = calory;
    [caloryView setDescribtion:@"卡路里/千卡" value:[NSString stringWithFormat:@"%d",calory] rotationAngle:stepAccount radius:radius];
    int minutes = stepAccount/200;
    movementUInt = minutes;
    [sportTimeView setDescribtion:@"时间/分钟" value:[NSString stringWithFormat:@"%d",minutes] rotationAngle:stepAccount radius:radius];
    
    CGFloat km = stepAccount/2162.162;
    distancesUInt = km;
    [kmView setDescribtion:@"距离/公里" value:[NSString stringWithFormat:@"%.1f",km] rotationAngle:stepAccount radius:radius];
    
    sliderValue = sender.value;
    
    _sportTarget.goal_step = [NSString stringWithFormat:@"%d",stepAccount];
    _sportTarget.goal_kcal = [NSString stringWithFormat:@"%d",calory];
    _sportTarget.goal_time = [NSString stringWithFormat:@"%d",minutes];
    _sportTarget.goal_distance = [NSString stringWithFormat:@"%f",km*1000.0];
}

//-(void)gotoSleepTargetView:(UIButton *)btn
//{
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]init];
//    barButtonItem.title = @"上一步";
//    barButtonItem.tintColor = [UIColor blackColor];
//    self.navigationItem.backBarButtonItem = barButtonItem;
//    UserSleepTargetController *sleepController = [UserSleepTargetController new];
//    sleepController.stepTarget = _stepTarget;
//    [self.navigationController pushViewController:sleepController animated:YES];
//}

- (void)segmentedSel
{
    if (segmented.selectedSegmentIndex == 0) {
        /**
         传输运动目标2015-08-11
         */
        [[[PersonalGoalsRequest alloc]init] sendMovementGoals:stepUInt Calorie:calorieUInt MovementTime:movementUInt Distances:distancesUInt];
//        [self saveSporInfo];
        [self.view makeToast:@"save ok" duration:1 position:@"center"];
        
        //确认目标，保存到数据库
        [[TargetInfoManager sharedInstance]updateSportTargetWithDictionary:_sportTarget];
    }
    segmented.selectedSegmentIndex = -1;
    NSLog(@"click segmengted");
    
}

@end
