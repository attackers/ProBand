//
//  UserSleepTargetController.m
//  ProBand
//
//  Created by 于苗 on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserSleepTargetController.h"
#import "t_goal_sleep.h"
#import "TargetInfoManager.h"
#import "UserTrainTargetController.h"
#import "UIView+Extension.h"
#import "InitUserInfomationViewController.h"
#import "CustomDatePickerView.h"
#import "SendCommandToPeripheral.h"
#import "UIView+Toast.h"
#define ISSELECT @"isSelect"


@interface UserSleepTargetController ()
{
    NSString *_selcetTime;
    NSString *_sleepTime;//睡眠时长
    UIScrollView *bgScrollView;
    UISegmentedControl *segmented;
    /**
     *  开始时间，时钟
     */
    UInt8 startH;
    /**
     *  开始时间，分钟
     */
    UInt8 startM;
    /**
     *  结束时间，时钟
     */
    UInt8 endH;
    /**
     *  结束时间，分钟
     */
    UInt8 endM;
    /**
     *  自动睡眠开关
     */
    UInt8 autoS;
    UInt8 hourArrayUInt8;
    UInt8 minArrayUInt8;
    
    NSUserDefaults *userDefaults;
}
@property (nonatomic, strong)t_goal_sleep *userTargetObj;
@end

@implementation UserSleepTargetController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    _sleepTime = [NSString string];
    autoS = 0;
    self.titleLabel.text = @"睡眠目标";
    self.rightBtn.transform = CGAffineTransformMakeScale(1,1);
    self.rightBtn.hidden = NO;
    [self.rightBtn addTarget:self action:@selector(goToTrainTargetView) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_userTargetObj == nil)
    {
        _userTargetObj = [TargetInfoManager sleepTargetFromDB];
    }

    
    [self createView];
  
}

-(void)saveSleepInfo{

    NSString *str = [NSString string];
    for ( int i = 1000; i <= 1002; i++) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        if (![btn1 isSelected]) {
            continue;
        }
        str = [NSString stringWithFormat:@"%i",i];
    }
    
    //不再保存到plist文件，直接保存到数据库
    UIButton *startBn = (UIButton *)[self.view viewWithTag:1005];
    UIButton *finishBn = (UIButton *)[self.view viewWithTag:1006];
    NSString *beginTime = startBn.titleLabel.text;
    NSString *endTime = finishBn.titleLabel.text;
    _userTargetObj.goal_sleep_time = [DateHandle timeStringFromTime:beginTime];
    _userTargetObj.goal_getup_time = [DateHandle timeStringFromTime:endTime];
    
    [TargetInfoManager updateSleepTargetWithDictionary:_userTargetObj];
}
- (void)goToTrainTargetView
{
    [self saveSleepInfo];
    
    [[[PersonalGoalsRequest alloc]init]sendSleepGoals:startH StartM:startM EndH:endH EndM:endM automaticSleep:autoS];
    
    UserTrainTargetController  *trainController = [[UserTrainTargetController alloc]init];
    trainController.showSeg = NO;
    [self.navigationController pushViewController:trainController animated:YES];
}

-(void)createView
{
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [bgScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+80)];
    [self.view addSubview:bgScrollView];
    
    UILabel *topLab = [PublicFunction getlabel:CGRectMake(0, 10, SCREEN_WIDTH, 60) text:@"根据世界卫生组织的建议，结合你的个人信息,\n成年人睡眠质量为7-8小时(不宜少于6小时)." color:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1] size:13];
    topLab.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:topLab];
    
    CALayer *topLine = [CALayer new];
    topLine.frame = CGRectMake(0, CGRectGetMaxY(topLab.frame)+10, SCREEN_WIDTH, 1);
    topLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [bgScrollView.layer addSublayer:topLine];
    
    UILabel *sleepLab = [PublicFunction getlabel:CGRectMake(0, topLine.frame.origin.y + 20, SCREEN_WIDTH, 30) text:@"睡眠时长" color:[UIColor grayColor] size:20];
    [bgScrollView addSubview:sleepLab];
    sleepLab.textAlignment = NSTextAlignmentCenter;
    
    NSString *sleepStr = @"8小时30分钟";
    if (_userTargetObj.goal_sleep_time && _userTargetObj.goal_sleep_time.length > 0) {
        sleepStr = _userTargetObj.goal_sleep_time;
    }
    UILabel *timeLengthLabel = [PublicFunction getlabel:CGRectMake(0, sleepLab.frame.origin.y + 30, SCREEN_WIDTH, 30) text:@"" textSize:14 textColor:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] textBgColor:nil textAlign:@"center"];
    timeLengthLabel.tag = 2001;
    [bgScrollView addSubview:timeLengthLabel];
    timeLengthLabel.attributedText = [self getAttributedStr:sleepStr withDecollator:@"小"];
    
    
    UILabel *beginLab = [PublicFunction getlabel:CGRectMake(35, timeLengthLabel.frame.origin.y + 40, 120, 30) text:@"入睡时间" color:[UIColor blackColor] size:16];
    [bgScrollView addSubview:beginLab];
    
    UILabel *endLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH - 125, beginLab.frame.origin.y, 120, 30) text:@"醒来时间" color:[UIColor blackColor] size:18];
    [bgScrollView addSubview:endLab];
    
    CALayer *lineOne = [CALayer new];
    lineOne.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    lineOne.frame = CGRectMake(10, endLab.frame.origin.y + 35, 120, 2);
    [bgScrollView.layer addSublayer:lineOne];
    
    
    NSString *beginTime = [DateHandle timeFromTimeString:_userTargetObj.goal_sleep_time];
    UIButton *beginSleepBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, endLab.frame.origin.y + 35, 100, 50) title:beginTime align:@"center" color:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] fontsize:35 tag:1005 clickAction:@selector(setSleepTarget:)];
    [bgScrollView addSubview:beginSleepBtn];
    
    
    
    CALayer *lineTwo = [CALayer new];
    lineTwo.frame = CGRectMake(10, beginSleepBtn.frame.origin.y + 50, lineOne.bounds.size.width, 2);
    lineTwo.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [bgScrollView.layer addSublayer:lineTwo];
    
    
    CALayer *lineThree = [CALayer new];
    lineThree.frame =CGRectMake(endLab.frame.origin.x - 30, lineOne.frame.origin.y, lineOne.bounds.size.width, 2);
    lineThree.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [bgScrollView.layer addSublayer:lineThree];
    
    
    NSString *getupTime = [DateHandle timeFromTimeString:_userTargetObj.goal_getup_time];
    UIButton *endSleepBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH/2 + 30, beginSleepBtn.frame.origin.y , 100, 50) title:getupTime align:@"center" color:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] fontsize:35 tag:1006 clickAction:@selector(setSleepTarget:)];
    [bgScrollView addSubview:endSleepBtn];
    
    CALayer *lineFour = [CALayer new];
    lineFour.frame =CGRectMake(lineThree.frame.origin.x, lineTwo.frame.origin.y, lineThree.bounds.size.width, 2);
    lineFour.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [bgScrollView.layer addSublayer:lineFour];
    
    
    CGFloat btnY = CGRectGetMaxY(lineFour.frame);
    
    //    UIButton *midnightBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, workerBtn.frame.origin.y, 150, 150) title:@"熬夜党" align:@"center" color:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] fontsize:14 tag:1001 clickAction:@selector(selectTypeBtn:)];
    //    midnightBtn.center = CGPointMake(SCREEN_WIDTH/2, workerBtn.frame.origin.y);
    UIButton *midnightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    midnightBtn.size = CGSizeMake(80, 80);
    midnightBtn.center = CGPointMake(SCREEN_WIDTH/2, btnY+70);
    [midnightBtn setTitle:@"熬夜党" forState:UIControlStateNormal];
    [midnightBtn setTitleColor:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    midnightBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    midnightBtn.tag=1001;
    //    midnightBtn.backgroundColor = [UIColor grayColor];
    [midnightBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [midnightBtn setImage:[UIImage imageNamed:@"sleep_target_ayd_press"] forState:normal];
    midnightBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -80, 0, 0);
    [midnightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [midnightBtn setImage:[UIImage imageNamed:@"sleep_target_ayd_sel"] forState:UIControlStateSelected];
    [bgScrollView addSubview:midnightBtn];
    
    //    UIButton *workerBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(iPhone6plus||iPhone6?20:0, CGRectGetMaxY(lineFour.frame),100, 100) title:@"上班族" align:@"center" color:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] fontsize:14 tag:1000 clickAction:@selector(selectTypeBtn:)];
    UIButton *workerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    workerBtn.size = CGSizeMake(80, 80);
    workerBtn.center = CGPointMake(SCREEN_WIDTH/2-100, btnY+70);
    [workerBtn setTitle:@"上班族" forState:UIControlStateNormal];
    [workerBtn setTitleColor:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    workerBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    workerBtn.tag=1000;
    //    workerBtn.backgroundColor = [UIColor grayColor];
    [workerBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [workerBtn setImage:[UIImage imageNamed:@"sleep_target_work_press"] forState:normal];
    [workerBtn setImage:[UIImage imageNamed:@"sleep_target_work_sel"] forState:UIControlStateSelected];
    workerBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -80, 0, 0);
    [workerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    workerBtn.selected = YES;
    //    workerBtn.backgroundColor = [UIColor redColor];
    [bgScrollView addSubview:workerBtn];
    
    
    
    
    
    //    UIButton *studentBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(midnightBtn.frame.origin.x + 110, midnightBtn.frame.origin.y, 150, 150) title:@"学生派" align:@"center" color:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] fontsize:14 tag:1002 clickAction:@selector(selectTypeBtn:)];
    UIButton *studentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    studentBtn.size = CGSizeMake(80, 80);
    studentBtn.center = CGPointMake(SCREEN_WIDTH/2+100, btnY+70);
    [studentBtn setTitle:@"学生派" forState:UIControlStateNormal];
    [studentBtn setTitleColor:[UIColor colorWithRed:0 green:204/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    studentBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:14];
    studentBtn.tag=1002;
    //    studentBtn.backgroundColor = [UIColor grayColor];
    [studentBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [studentBtn setImage:[UIImage imageNamed:@"sleep_target_student_press"] forState:normal];
    studentBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -80, 0, 0);
    [studentBtn setImage:[UIImage imageNamed:@"sleep_target_student_sel"] forState:UIControlStateSelected];
    [studentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [bgScrollView addSubview:studentBtn];
    
    NSDictionary *dic1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"worker"];
    NSDictionary *dic2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"midnight"];
    NSDictionary *dic3 = [[NSUserDefaults standardUserDefaults]objectForKey:@"student"];
    NSString *state = dic1[@"state"];
    NSString *state2 = dic2[@"state"];
    NSString *state3 = dic3[@"state"];
    if ([state isEqualToString:@"1"]) {
        workerBtn.selected = YES;
        midnightBtn.selected = NO;
        studentBtn.selected = NO;
        [beginSleepBtn setTitle:dic1[@"begin"] forState:normal];
        [endSleepBtn setTitle:dic1[@"end"] forState:normal];
    }
    else if ([state2 isEqualToString:@"1"]) {
        midnightBtn.selected = YES;
        studentBtn.selected = NO;
        workerBtn.selected = NO;
        [beginSleepBtn setTitle:dic2[@"begin"] forState:normal];
        [endSleepBtn setTitle:dic2[@"end"] forState:normal];
    }
    else if ([state3 isEqualToString:@"1"]) {
        studentBtn.selected = YES;
        workerBtn.selected = NO;
        midnightBtn.selected = NO;
        
        [beginSleepBtn setTitle:dic3[@"begin"] forState:normal];
        [endSleepBtn setTitle:dic3[@"end"] forState:normal];
    }
    
    
    /**
     最下方的选择控件
     */
    segmented = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"确认",@"取消", nil]];
    segmented.frame = CGRectMake(20, CGRectGetMaxY(studentBtn.frame)+15, CGRectGetWidth(bgScrollView.frame) - 40,37);
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
    
    
    for ( int i = 1000; i <= 1002; i++) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        [btn1 setSelected:NO];
    
    }
    
    
    //最后将显示时间的label调整:by STar
    NSString *hourstr = _userTargetObj.goal_sleep_time;//[DateHandle timeStringFromTime:_userTargetObj.goal_sleep_time];
    NSString *minstr = _userTargetObj.goal_getup_time;//[DateHandle timeStringFromTime:_userTargetObj.goal_getup_time];
    NSString *result = [DateHandle sleepDurationFromSleepTime:hourstr getupTime:minstr];
    timeLengthLabel.attributedText = [self getAttributedStr:result withDecollator:@"小"];
}


- (void)goBackAction
{
    NSLog(@"goBackAction");
    [self.navigationController popViewControllerAnimated:YES];
    [self sureBtnClick];
}

-(void)sureBtnClick
{
    UIDatePicker *picker1 = (UIDatePicker *)[self.view viewWithTag:5000];
    UIView *view = (UIView *)[self.view viewWithTag:2000];
    if (picker1) {
        
        [picker1 removeFromSuperview];
        [view removeFromSuperview];
    }
    UIButton *beginBtn = (UIButton *)[self.view viewWithTag:1005];
    UIButton *endBtn = (UIButton *)[self.view viewWithTag:1006];
    NSString *beginStr = beginBtn.titleLabel.text;
    NSString *endStr = endBtn.titleLabel.text;
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1001];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:1002];
    
    [TargetInfoManager updateSleepTargetWithDictionary:_userTargetObj];
    
    NSDictionary *dic1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"midnight"];
    if (dic1) {
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":dic1[@"begin"],@"end":dic1[@"end"],@"state":@"0"} forKey:@"midnight"];
    }
    NSDictionary *dic2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"student"];
    if (dic2) {
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":dic2[@"begin"],@"end":dic2[@"end"],@"state":@"0"} forKey:@"student"];
        
    }
    NSDictionary *dic3 = [[NSUserDefaults standardUserDefaults]objectForKey:@"worker"];
    if (dic3) {
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":dic3[@"begin"],@"end":dic3[@"end"],@"state":@"0"} forKey:@"worker"];
    }
    
    if (btn1.selected) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":beginStr,@"end":endStr,@"state":@"1"} forKey:@"worker"];
        [[NSUserDefaults standardUserDefaults]synchronize];        
    }
    else if (btn2.selected)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":beginStr,@"end":endStr,@"state":@"1"} forKey:@"midnight"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else if(btn3.selected)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@{@"begin":beginStr,@"end":endStr,@"state":@"1"} forKey:@"student"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    //    NSArray *arr = self.navigationController.viewControllers;
    //    UIViewController *VC = arr[1];
    //    [self.navigationController popToViewController:VC animated:YES];
    
}
-(void)selectTypeBtn:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1001];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:1002];
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    btn.selected = !btn.selected;
    UIButton *beginBtn = (UIButton *)[self.view viewWithTag:1005];
    UIButton *endBtn = (UIButton *)[self.view viewWithTag:1006];
    UILabel *label = (UILabel *)[self.view viewWithTag:2001];
    if (btn.tag == 1000) {
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"worker"];
        if (dic) {
            [beginBtn setTitle:dic[@"begin"] forState:normal];
            [endBtn setTitle:dic[@"end"] forState:normal];
        }
        else
        {
            [beginBtn setTitle:@"22:30" forState:normal];
            [endBtn setTitle:@"7:30" forState:normal];
            
            startH = 22;
            startM = 30;
            
            endH = 7;
            endM = 30;
            
             label.attributedText = [self getAttributedStr:@"9小时" withDecollator:@"小"];
        }
    }
    else if (btn.tag == 1001)
    {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"midnight"];
        if (dic) {
            [beginBtn setTitle:dic[@"begin"] forState:normal];
            [endBtn setTitle:dic[@"end"] forState:normal];
        }
        else
        {
            [beginBtn setTitle:@"23:30" forState:normal];
            [endBtn setTitle:@"8:30" forState:normal];
            
            startH = 23;
            startM = 30;
            endH = 8;
            endM = 30;
            
            label.attributedText = [self getAttributedStr:@"9小时" withDecollator:@"小"];
        }
    }
    else
    {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"student"];
        if (dic) {
            [beginBtn setTitle:dic[@"begin"] forState:normal];
            [endBtn setTitle:dic[@"end"] forState:normal];
        }
        else
        {
            [beginBtn setTitle:@"22:00" forState:normal];
            [endBtn setTitle:@"7:30" forState:normal];
            
            startH = 22;
            startM = 00;
            endH = 7;
            endM = 30;
        }
        label.attributedText = [self getAttributedStr:@"9小时30分钟" withDecollator:@"小"];
    }
    
}
#pragma mark - 设置睡眠时间

-(void)setSleepTarget:(UIButton *)btn
{
    NSLog(@"设置睡眠时间");

    CustomDatePickerView *date = [[CustomDatePickerView alloc]init];
    [date returnSelectTime:^(NSString *hourValues, NSString *minuteValues) {
        
        if (btn.tag == 1005)
        {//开始时间
            
            UIButton *btnTemp = (UIButton *)[self.view viewWithTag:1005];
            [btnTemp setTitle:[NSString stringWithFormat:@"%02d:%02d",[hourValues intValue],[minuteValues intValue]] forState:UIControlStateNormal];
            startH = [hourValues integerValue];
            startM = [minuteValues integerValue];
        }
        else if(btn.tag == 1006)//结束时间
        {
            UIButton *btnTemp = (UIButton *)[self.view viewWithTag:1006];
            [btnTemp setTitle:[NSString stringWithFormat:@"%02d:%02d",[hourValues intValue],[minuteValues intValue]] forState:UIControlStateNormal];
            endH = [hourValues integerValue];
            endM = [minuteValues integerValue];
        }
        //计算相差时间并显示
        int hour=0;
        int minute = 0;
        if (endH>startH)
        {
            if (endM>=startM)
            {
                hour = endH-startH;
                minute = endM-startM;
            }
            else
            {
                hour = endH-startH-1;
                minute = endM-startM+60;
            }
        }
        else if(endH==startH)
        {
            if (endM>=startM)
            {
                hour = endH-startH;
                minute = endM-startM;
            }
            else
            {
                hour = endH-startH+23;
                minute = endM-startM+60;
            }
        }
        else
        {
            if (endM>=startM)
            {
                hour = endH-startH+24;
                minute = endM-startM;
            }
            else
            {
                hour = endH-startH+23;
                minute = endM-startM+60;
            }
        }
        NSString *labelText = [NSString stringWithFormat:@"%d小时%d分钟",hour,minute];
        UILabel *promptLabel = (UILabel *)[self.view viewWithTag:2001];
        promptLabel.text = labelText;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:date.view];
//    btn.selected = YES;

    
}

-(NSMutableAttributedString *)getAttributedStr:(NSString *)str withDecollator:(NSString *)flag
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];
    //[str containsString:flag]
    if ([str rangeOfString:flag].location != NSNotFound) {
        NSString *subStr1 = [str componentsSeparatedByString:@"小"][1];
        [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} range:NSMakeRange(0, dreepStr.length - (subStr1.length + 1))];
        //需要判断是否为整小时：修改by Star
        if (str.length <=4) {
            
        }
        else
        {
            [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25]} range:NSMakeRange(str.length - subStr1.length + 1, 2)];
        }
    }
    
    return dreepStr;
}

-(void)changeTime:(UIButton *)btn
{
    UIDatePicker *picker1 = (UIDatePicker *)[self.view viewWithTag:5000];
    UIView *view = (UIView *)[self.view viewWithTag:2000];
    if (picker1) {
        
        [picker1 removeFromSuperview];
        [view removeFromSuperview];
    }
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1005];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:1006];
    if (btn1.selected) {
        if (_selcetTime) {
            [btn1 setTitle:_selcetTime forState:normal];
            _userTargetObj.goal_sleep_time = _selcetTime;
        }
        
    }
    else if (btn2.selected)
    {
        if (_selcetTime) {
            [btn2 setTitle:_selcetTime forState:normal];
            _userTargetObj.goal_getup_time = _selcetTime;
        }
        
    }
    
    //计算相差时间并显示在label上
    NSString *startTime = btn1.titleLabel.text;
    NSString *endTime = btn2.titleLabel.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *startDate = [formatter dateFromString:startTime];
    NSDate *endDate = [formatter dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSLog(@"----%@---->%@---%f--",startDate,endDate,time);
    NSTimeInterval realTime = time;
    if (time < 0) {
        realTime = 86400+time;
    }
    int hour = (int)realTime/3600;
    int minute = ((int)realTime-3600*hour)/60;
    NSString *labelText = [NSString stringWithFormat:@"%d小时%d分钟",hour,minute];
    if(minute <= 0)
    {
        labelText = [NSString stringWithFormat:@"%d小时",hour];
    }
    UILabel *promptLabel = (UILabel *)[self.view viewWithTag:2001];
    promptLabel.text = labelText;
    _sleepTime = [NSString stringWithFormat:@"%d小时%d分钟",hour,minute];
    _userTargetObj.goal_getup_time = _sleepTime;
}
-(void)selectDatePicker:(UIDatePicker *)picker
{
    _selcetTime = [DateHandle dateToString:picker.date withType:1];
    NSLog(@"---%@---",_selcetTime);
}

- (void)segmentedSel
{

    if (segmented.selectedSegmentIndex == 0) {
        
        [self saveSleepInfo];
    }else{
        
    }
    segmented.selectedSegmentIndex = -1;
    
    [self.view makeToast:@"save ok" duration:1 position:@"center"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
