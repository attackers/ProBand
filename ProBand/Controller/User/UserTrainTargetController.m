//
//  UserTrainTargetController.m
//  ProBand
//
//  Created by star.zxc on 15/6/5.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserTrainTargetController.h"
#import "CustomDatePickerView.h"
#import "HomeViewController.h"

#import "TargetInfoManager.h"


@interface UserTrainTargetController ()
{
    UIScrollView *bgScrollView;
    UISegmentedControl *segmented;
    UILabel *valueLabel;
    
    NSUserDefaults *userDefaults;
    
    NSString *_trainTime;
    NSString *_trainDistance;
}
@property (nonatomic, strong)t_goal_exercise *exerciseTarget;
@end

@implementation UserTrainTargetController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_exerciseTarget == nil) {
        _exerciseTarget = [TargetInfoManager exerciseTargetFromDB];
        _trainTime = _exerciseTarget.goal_time;
        _trainDistance = _exerciseTarget.goal_distance;
    }
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.titleLabel.text = @"训练目标";
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.rightBtn.transform = CGAffineTransformMakeScale(1,1);
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createView];
}
- (void)rightBtnClick:(id)sender
{
    HomeViewController *home = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
}
- (void)createView
{
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60)];
    [self.view addSubview:bgScrollView];
    
    //添加中间的View
    UIImageView *bgdImageView = [PublicFunction getImageView:CGRectMake(SCREEN_WIDTH/2-105,50, 210, 210) imageName:@"training_goal_dashboard.png"];
    [bgScrollView addSubview:bgdImageView];
    UILabel *goalLabel = [PublicFunction getlabel:CGRectMake(30, 70, 150, 25) text:@"训练目标" fontSize:16 color:[UIColor lightGrayColor] align:@"center"];
    [bgdImageView addSubview:goalLabel];
    valueLabel = [PublicFunction getlabel:CGRectMake(30, CGRectGetMaxY(goalLabel.frame), 150, 40) text:nil fontSize:14 color:COLOR(26,194,195) align:@"center"];
    
    valueLabel.attributedText = [self getAttributedStr:@"8小时30分钟"];
    [bgdImageView addSubview:valueLabel];
    
    CGFloat bnWidth = 77.5;
    UIButton *timeBn = [PublicFunction getButtonInControl:self frame:CGRectMake(60, CGRectGetMaxY(bgdImageView.frame)+40, bnWidth, bnWidth) title:@"训练时间" align:@"center" color:COLOR(26,194,195) fontsize:14 tag:11 clickAction:@selector(setTrainTime:) imageName:nil];
    [timeBn setBackgroundImage:[UIImage imageNamed:@"training_goal_time"] forState:UIControlStateNormal];
    [timeBn setBackgroundImage:[UIImage imageNamed:@"training_goal_time_press"] forState:UIControlStateHighlighted];
    timeBn.titleEdgeInsets = UIEdgeInsetsMake(33, 0, 0, 0);
    timeBn.tag = 1000;
    [bgScrollView addSubview:timeBn];
    
    UIButton *distanceBn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-CGRectGetMaxX(timeBn.frame), CGRectGetMinY(timeBn.frame), bnWidth, bnWidth) title:@"训练距离" align:@"center" color:COLOR(26,194,195) fontsize:14 tag:12 clickAction:@selector(setTrainDistance:) imageName:nil];
    distanceBn.tag = 1001;
    [distanceBn setBackgroundImage:[UIImage imageNamed:@"training_goal_time"] forState:UIControlStateNormal];
    [distanceBn setBackgroundImage:[UIImage imageNamed:@"training_goal_time_press"] forState:UIControlStateHighlighted];
    distanceBn.titleEdgeInsets = UIEdgeInsetsMake(33, 0, 0, 0);
    [bgScrollView addSubview:distanceBn];
    
    segmented = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"确认",@"取消", nil]];
    segmented.frame = CGRectMake(20, CGRectGetMaxY(distanceBn.frame)+15, CGRectGetWidth(bgScrollView.frame) - 40,37);
    segmented.layer.cornerRadius = CGRectGetHeight(segmented.frame)/2;
    segmented.layer.borderColor = [UIColor grayColor].CGColor;
    segmented.tintColor = [UIColor grayColor];
    segmented.backgroundColor = [UIColor clearColor];
    segmented.layer.borderWidth = 1.5;
    segmented.layer.masksToBounds = YES;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    if (!_showSeg) {
        
        segmented.hidden = YES;
    }
    [segmented addTarget:self action:@selector(segmentedSel) forControlEvents:UIControlEventValueChanged];
    [bgScrollView addSubview:segmented];
    
    valueLabel.attributedText = [self getAttributedStr:_exerciseTarget.goal_time];
}

- (void)setTrainTime:(UIButton *)sender
{
    CustomDatePickerView *dateview = [[CustomDatePickerView alloc]init];
    dateview.modelType = showDate;
    dateview.view.frame = [UIScreen mainScreen].bounds;
    [dateview returnSelectTime:^(NSString *hourValues, NSString *minuteValues) {
        NSString *timeStr = [NSString stringWithFormat:@"%@小时%@分钟",hourValues,minuteValues];
        valueLabel.attributedText = [self getAttributedStr:timeStr];
        _trainTime = timeStr;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:dateview.view];

}
- (void)setTrainDistance:(UIButton *)sender
{
    CustomDatePickerView *dateview = [[CustomDatePickerView alloc]init];
    dateview.modelType = showKM;
    dateview.view.frame = [UIScreen mainScreen].bounds;
    [dateview returnSelectTime:^(NSString *hourValues, NSString *minuteValues) {
        NSString *distanceStr = [NSString stringWithFormat:@"%@.%@",hourValues,minuteValues];
        valueLabel.attributedText = [self returnKMString:distanceStr];
        _trainDistance =   [NSString stringWithFormat:@"%d",(int)[distanceStr floatValue]*1000];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:dateview.view];
    

}

- (void)segmentedSel
{
    if (segmented.selectedSegmentIndex == 0)
    {
        _exerciseTarget.goal_time = _trainTime;
        _exerciseTarget.goal_distance = _trainDistance;
        [TargetInfoManager updateExerciseTargetWithDictionary:_exerciseTarget];
    }
    segmented.selectedSegmentIndex = -1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableAttributedString *)getAttributedStr:(NSString *)str
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];

    NSRange hourRange;
    NSRange minuteRange;
    for (int i = 0; i < str.length; i++) {
        NSString *string = [str substringWithRange:NSMakeRange(i, 1)];
        if ([string isEqualToString:@"小"]) {
            
            hourRange = NSMakeRange(0, i);
        }
    }
    
    for (NSInteger i = str.length-1; i >=0 ; i--) {
        NSString *string = [str substringWithRange:NSMakeRange(i, 1)];
        if ([string isEqualToString:@"时"]) {
            
            minuteRange = NSMakeRange(i+1, str.length - 2 -i-1);
        }
    }
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:hourRange];
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} range:minuteRange];

    return dreepStr;
}
- (NSAttributedString*)returnKMString:(NSString*)stg
{
    stg = [stg stringByAppendingString:@"km"];
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
    NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    NSDictionary *mStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    [mString setAttributes:mStringDic range:NSMakeRange(stg.length - 2, 2)];
    return mString;
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
