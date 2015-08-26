//
//  DailyViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DailyViewController.h"
#import "EShadeCircleView.h"
#import "TrendDailyController.h"
#import "TestDataModel.h"
#import "SyncAlertView.h"
#import "SendCommandToPeripheral.h"
#import "HistoryDataInfomation.h"
#import "CAShawRoundView.h"
#import "ExerciseDayView.h"

#import "TargetInfoManager.h"
@interface DailyViewController ()<HistoryDataInfomationDelegate>
{
    NSArray *imageArray;
    NSArray *describeArray;
    NSArray *valueArray;
    /**
     *  显示当前余额
     */
    UILabel *moneyLabel;
    CAShawRoundView* round;
}
@property (nonatomic,strong)UILabel *stepLab;
@property (nonatomic,strong)UILabel *distantsLab;
@property (nonatomic,strong)UILabel *calorieLab;
@property (nonatomic,strong)UIScrollView *bigScrollView;

@end

@implementation DailyViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    HistoryDataInfomation *h = [HistoryDataInfomation shareHistoryDataInfomation];
    h.delegate = self;
}
- (void)historyDataSyncEnd:(BOOL)end
{
    NSLog(@"end sync history!");
    [self isHistorySyncEnd];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addSubView0820];

}
- (void)isHistorySyncEnd
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData]) {
        
        t_goal_step *step_goal = [[TargetInfoManager alloc]sportTargetFromDB];
        CGFloat fromDicStep = [step_goal.goal_step floatValue]==0 ? 1.0:[step_goal.goal_step floatValue];
        NSDictionary *stepDic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData];
        CGFloat totalStep = [[stepDic objectForKey:@"total_step"]floatValue];
        CGFloat v= totalStep/fromDicStep;
        round.value = v;
        [round setpercent:v*10 animated:YES];
        self.stepLab.text = [stepDic objectForKey:@"total_step"];
        NSInteger me = [[stepDic objectForKey:@"total_meter"]integerValue];
        self.distantsLab.text = [NSString stringWithFormat:@"%0.3f",me/1000.0];
        self.calorieLab.text = [stepDic objectForKey:@"total_kCalory"];
        [SyncAlertView shareSyncAlerview:YES];
    }
    
}
- (void)initData
{
    imageArray = @[@"daily_steps",@"daily_mileage",@"daily_calorie"];
    describeArray = @[ NSLocalizedString(@"steps_step", nil),NSLocalizedString(@"day_mileage_day", nil),NSLocalizedString(@"calorie_kcal", nil)];
    valueArray = @[@"6839",@"2.3",@"125"];
}
-(void)createView
{
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefreshingTemp) name:@"refreshFinish" object:nil];
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    [_bigScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10)];
    [self.view addSubview:_bigScrollView];
    
    __block DailyViewController *saftSelf = self;
    [_bigScrollView addHeaderWithCallback:^{
        
        [[[HistoryData alloc]init] getHostoryDataRequest];
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
        addY = 15;
    }
    else if (iPhone6)
    {
        bgOffSet = -120;
    }
    else if (iPhone6plus)
    {
        bgOffSet = -120;
    }
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, bgOffSet, SCREEN_WIDTH, SCREEN_HEIGHT+20+addY)];
    bgimage.contentMode = UIViewContentModeScaleAspectFill;
    bgimage.image = [UIImage imageNamed:@"exercise_bg.png"];
    [_bigScrollView addSubview:bgimage];
    
    UIImageView *iconMoneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 17, 17)];
    iconMoneyImage.image = [UIImage imageNamed:@"daily_balance"];
    [_bigScrollView addSubview:iconMoneyImage];
    
    NSMutableString *moneyText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"account_balance", nil)];
    [moneyText appendString:@"78.00￥"];
    UILabel *MoneyLab = [PublicFunction getlabel:CGRectMake(40, iconMoneyImage.frame.origin.y-6.5, 150, 30) text:moneyText color:[UIColor whiteColor] size:iPhone6plus||iPhone6?14:12];
    [_bigScrollView addSubview:MoneyLab];
    
    UIImageView *payMoneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -(iPhone6||iPhone6plus?180:160), iconMoneyImage.frame.origin.y, 17, 17)];
    payMoneyImage.image = [UIImage imageNamed:@"daily_consumption"];
    [_bigScrollView addSubview:payMoneyImage];
    
    NSMutableString *payMoneyText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"day_consumption", nil)];
    [payMoneyText appendString:@"1005.00￥"];
    UILabel *payMoneyLab = [PublicFunction getlabel:CGRectMake(payMoneyImage.frame.origin.x + 20, MoneyLab.frame.origin.y, 150, 30) text:payMoneyText fontSize:iPhone6plus||iPhone6?14:12 color:[UIColor whiteColor] align:@"left"];
    [_bigScrollView addSubview:payMoneyLab];
    
    
    [self createButtomView];
    
}

-(void)endRefreshingTemp
{
    [self.bigScrollView headerEndRefreshing];
    [self performSelector:@selector(refreshView) withObject:nil afterDelay:1];
    
}

-(void)refreshView
{
    int lineWidth = 90;
    if (iPhone4) {
        
        lineWidth = 80;
    }
    else if (iPhone6||iPhone6plus)
    {
        lineWidth = 115;
    }
    
    [self drawShadeChartView:[TestDataModel getModelDataForShadeChart] withLineWidth:lineWidth withShow:YES];
    
    EShadeCircleView *shadeView = (EShadeCircleView*)[self.view viewWithTag:9000];
    [shadeView removeFromSuperview];
    [SyncAlertView shareSyncAlerview:YES];
}
-(void)createButtomView
{
    //    for (int i = 0; i<3; i++) {
    //
    //        int x = 250;
    //        if (iPhone6||iPhone6plus) {
    //
    //            x = 280;
    //        }
    //        else if (iPhone4)
    //        {
    //            x = 220;
    //        }
    //        UIImageView *Image = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*SCREEN_WIDTH/3+ 40,SCREEN_HEIGHT - x,iPhone4?25:30,iPhone4?25:30)];
    //        [_bigScrollView addSubview:Image];
    //        UILabel *titleLab = [PublicFunction getlabel:CGRectMake(Image.frame.origin.x-40, Image.frame.origin.y + (iPhone4? 25:40), 100, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
    //        [_bigScrollView addSubview:titleLab];
    //
    //        if (i == 0) {
    //            _stepLab = [PublicFunction getlabel:CGRectMake(titleLab.frame.origin.x - 10, titleLab.frame.origin.y + 25, 100, 30) text:@"6839" fontSize:18 color:[UIColor whiteColor] align:@"center"];
    //            [_bigScrollView addSubview:_stepLab];
    //            _stepLab.font = [UIFont boldSystemFontOfSize:18];
    //            Image.image = [UIImage imageNamed:@"daily_steps"];
    //            titleLab.text = NSLocalizedString(@"steps_step", nil);
    //        }
    //        else if (i==1){
    //
    //            _distantsLab = [PublicFunction getlabel:CGRectMake(titleLab.frame.origin.x - 10, titleLab.frame.origin.y + 25, 100, 30) text:@"2.3" fontSize:18 color:[UIColor whiteColor] align:@"center"];
    //            [_bigScrollView addSubview:_distantsLab];
    //            _distantsLab.font = [UIFont boldSystemFontOfSize:18];
    //            Image.image = [UIImage imageNamed:@"daily_mileage"];
    //            titleLab.text = NSLocalizedString(@"day_mileage_day", nil);
    //        }
    //        else
    //        {
    //             _calorieLab= [PublicFunction getlabel:CGRectMake(titleLab.frame.origin.x - 10, titleLab.frame.origin.y + 25, 100, 30) text:@"125" fontSize:18 color:[UIColor whiteColor] align:@"center"];
    //            [_bigScrollView addSubview:_calorieLab];
    //            _calorieLab.font = [UIFont boldSystemFontOfSize:18];
    //            Image.image = [UIImage imageNamed:@"daily_calorie"];
    //            titleLab.text = NSLocalizedString(@"calorie_kcal", nil);
    //        }
    //    }
    //前后各隔10个像素点
    for (int i = 0; i < 3; i ++)
    {
        int x = 250;
        if (iPhone6||iPhone6plus)
        {
            x = 280;
        }
        else if (iPhone4)
        {
            x = 220;
        }
        CGFloat xCenter = (SCREEN_WIDTH-20)*(2*i+1)/6.0+10;
        UIImageView *Image = [[UIImageView alloc]initWithFrame:CGRectMake(xCenter-(iPhone4?25:30)/2,SCREEN_HEIGHT - x,iPhone4?25:30,iPhone4?25:30)];
        [_bigScrollView addSubview:Image];
        Image.image = [UIImage imageNamed:imageArray[i]];
        UILabel *describeLab = [[UILabel alloc]initWithFrame:CGRectMake(xCenter-50, CGRectGetMaxY(Image.frame), 100, 30)];
        describeLab.text = describeArray[i];
        describeLab.textColor = [UIColor whiteColor];
        describeLab.textAlignment = NSTextAlignmentCenter;
        describeLab.font = [UIFont systemFontOfSize:14];
        [_bigScrollView addSubview:describeLab];
        UILabel *valueLab = [[UILabel alloc]initWithFrame:CGRectMake(xCenter-50, CGRectGetMaxY(describeLab.frame), 100, 30)];
        valueLab.text = valueArray[i];
        valueLab.textColor = [UIColor whiteColor];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.font = [UIFont systemFontOfSize:18];
        [_bigScrollView addSubview:valueLab];
    }
}


- (void)drawShadeChartView:(EShadeChartDataModel *)data withLineWidth:(CGFloat)lineWidth withShow:(BOOL)blean{
    
    int y = 180;
    int k = 90;
    if (iPhone6||iPhone6plus) {
        
        y = 230;
        k = 110;
    }
    else if (iPhone4)
    {
        y = 180;
        k = 60;
    }
    
    EShadeCircleView *circlrView = [[EShadeCircleView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- y)/2,k,y,y) andDataModel:data withLineWid:lineWidth isShow:blean];
    circlrView.tag = 9000;
    [_bigScrollView addSubview:circlrView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetailView:)];
    [circlrView addGestureRecognizer:tap];
}


-(void)gotoDetailView:(UITapGestureRecognizer *)tap
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _bigScrollView.backgroundColor = [UIColor yellowColor];
        EShadeCircleView *circle = (EShadeCircleView *)[_bigScrollView viewWithTag:9000];
        [[XlabTools sharedInstance]startLoadingInView:circle withmessage:@"加载中..."];
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[[FMDBTool sharedInstance] addAllTestData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XlabTools sharedInstance]stopLoading];
            [self.navigationController pushViewController:[TrendDailyController new] animated:YES];
        });
    });
    //[self.navigationController pushViewController:[TrendDailyController new] animated:YES];
}
#pragma mark |********************** 新的UI *************************|
- (void)addSubView0820
{
    /**
     显示账户余额
     */
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.view.frame), 60)];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.attributedText = [self returnAttributedStringFromString:@"账户余额￥00.00"];
    
    /**
     添加分割线
     */
    UIImageView *segmentationImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame) + 10, CGRectGetWidth(self.view.frame), 10)];
    segmentationImageview.image = [UIImage imageNamed:@"daily_projection"];
    segmentationImageview.contentMode = UIViewContentModeScaleAspectFill;
    if (round) {
        [round removeFromSuperview];
    }
    round = [[CAShawRoundView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(moneyLabel.frame) - 12, CGRectGetWidth(self.view.frame), 265)];
    round.contentMode = UIViewContentModeRedraw;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData]) {
        
        t_goal_step *step_goal = [[TargetInfoManager alloc]sportTargetFromDB];
        CGFloat fromDicStep = [step_goal.goal_step floatValue]==0 ? 1.0:[step_goal.goal_step floatValue];
        NSDictionary *stepDic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData];

        CGFloat totalStep = [[stepDic objectForKey:@"total_step"]floatValue];
        CGFloat v= totalStep/fromDicStep;
        round.value = v;
        [round setpercent:v*10 animated:YES];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [round addGestureRecognizer:tap];
    [self.view addSubview:moneyLabel];
    [self.view addSubview:round];
    [self.view addSubview:segmentationImageview];
    
    
    UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    bottomImageView.center = self.view.center;
    bottomImageView.image = [UIImage imageNamed:@"daily_bg"];
    [self.view addSubview:bottomImageView];
    [self addBottomView];
    
}
- (void)addBottomView
{
    
    UIImageView *centerImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,31, 25)];
    centerImageview.center = CGPointMake(self.view.center.x,CGRectGetMaxY(round.frame) + 50);
    centerImageview.image = [UIImage imageNamed:@"daily_distance"];
    [self.view addSubview:centerImageview];
    
    UIImageView *leftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(47, centerImageview.frame.origin.y, 31, 25)];
    leftImageview.image = [UIImage imageNamed:@"daily_steps"];
    [self.view addSubview:leftImageview];
    
    UIImageView *rightImageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-70, centerImageview.frame.origin.y, 31, 25)];
    rightImageview.image = [UIImage imageNamed:@"daily_cal"];
    [self.view addSubview:rightImageview];
    CGFloat w = CGRectGetWidth(self.view.frame)/3;
    self.stepLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(centerImageview.frame), CGRectGetWidth(self.view.frame)/3, 30)];
    self.stepLab.text = @"0";
    self.stepLab.textColor = [UIColor whiteColor];
    self.stepLab.font = [UIFont fontWithName:HelveticaNeueLTPro_Th_C size:24];
    self.stepLab.textAlignment = NSTextAlignmentCenter;
    self.distantsLab = [[UILabel alloc]initWithFrame:CGRectMake(w, CGRectGetMaxY(centerImageview.frame), w, 30)];
    self.distantsLab.text = @"0";
    self.distantsLab.textColor = [UIColor whiteColor];
    self.distantsLab.font = [UIFont fontWithName:HelveticaNeueLTPro_Th_C size:24];
    self.distantsLab.textAlignment = NSTextAlignmentCenter;
    self.calorieLab = [[UILabel alloc]initWithFrame:CGRectMake(w*2, CGRectGetMaxY(centerImageview.frame), w, 30)];
    self.calorieLab.text = @"0";
    self.calorieLab.textColor = [UIColor whiteColor];
    self.calorieLab.font = [UIFont fontWithName:HelveticaNeueLTPro_Th_C size:24];
    self.calorieLab.textAlignment = NSTextAlignmentCenter;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData]) {
        
        t_goal_step *step_goal = [[TargetInfoManager alloc]sportTargetFromDB];
        CGFloat fromDicStep = [step_goal.goal_step floatValue]==0 ? 1.0:[step_goal.goal_step floatValue];
        NSDictionary *stepDic = [[NSUserDefaults standardUserDefaults]objectForKey:statisticsStepData];
        CGFloat totalStep = [[stepDic objectForKey:@"total_step"]floatValue];
        CGFloat v= totalStep/fromDicStep;
        round.value = v;
        [round setpercent:v*10 animated:YES];
        
        self.stepLab.text = [stepDic objectForKey:@"total_step"];
        NSInteger me = [[stepDic objectForKey:@"total_meter"]integerValue];
        self.distantsLab.text = [NSString stringWithFormat:@"%0.3f",me/1000.0];
        self.calorieLab.text = [stepDic objectForKey:@"total_kCalory"];
        
    }else{
        
        round.value = 0.00;
        [round setpercent:0.00 animated:YES];
    }
    UILabel *step = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calorieLab.frame), w, 20)];
    step.text = @"步";
    step.font = [UIFont fontWithName:MicrosoftYaHe size:13];
    step.textColor = ColorRGB(92, 96, 102);
    step.textAlignment = NSTextAlignmentCenter;
    UILabel *km = [[UILabel alloc]initWithFrame:CGRectMake(w, CGRectGetMaxY(self.calorieLab.frame), w, 20)];
    km.text = @"km";
    km.font = [UIFont fontWithName:MicrosoftYaHe size:13];
    km.textColor = ColorRGB(92, 96, 102);
    km.textAlignment = NSTextAlignmentCenter;
    UILabel *kca = [[UILabel alloc]initWithFrame:CGRectMake(w*2, CGRectGetMaxY(self.calorieLab.frame), w, 20)];
    kca.text = @"kcal";
    kca.font = [UIFont fontWithName:MicrosoftYaHe size:13];
    kca.textColor = ColorRGB(92, 96, 102);
    kca.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.stepLab];
    [self.view addSubview:self.distantsLab];
    [self.view addSubview:self.calorieLab];
    [self.view addSubview:step];
    [self.view addSubview:km];
    [self.view addSubview:kca];
    
}
- (NSAttributedString*)returnAttributedStringFromString:(NSString*)stg
{
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:stg];
    UIColor *firstColor = ColorRGB(92, 96, 102);
    UIColor *secondColor = ColorRGB(50, 125, 222);
    NSDictionary *firstDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:12],NSFontAttributeName,firstColor,NSForegroundColorAttributeName, nil];
    [mString setAttributes:firstDic range:NSMakeRange(0, 4)];
    
    NSDictionary *secondDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:18],NSFontAttributeName,secondColor,NSForegroundColorAttributeName, nil];
    
    [mString setAttributes:secondDic range:NSMakeRange(4, 1)];
    [mString setAttributes:secondDic range:NSMakeRange(stg.length - 2, 2)];
    
    NSDictionary *moneyDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:42],NSFontAttributeName,secondColor,NSForegroundColorAttributeName, nil];
    [mString setAttributes:moneyDic range:NSMakeRange(5, stg.length - 7)];
    return mString.mutableCopy;
}
- (void)tapAction:(id)sender
{
    TrendDailyController *ex = [TrendDailyController new];
    [self.navigationController pushViewController:ex animated:YES];
    NSLog(@"tapAction");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
