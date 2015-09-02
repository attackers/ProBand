//
//  TrainingViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TrainingViewController.h"
#import "EShadeCircleView.h"
#import "TrendExerciseController.h"
#import "TestDataModel.h"
#import "SyncAlertView.h"
#import "SendCommandToPeripheral.h"

#import "CAShadeRoundView.h"
@interface TrainingViewController ()

@property (nonatomic,strong)UILabel *runTimeLab;
@property (nonatomic,strong)UILabel *walkTimeLab;
@property (nonatomic,strong)UILabel *staictTimeLab;
@property (nonatomic,strong)UILabel *speedTimeLab;
@property (nonatomic,strong)UIScrollView *bigScrollView;

@property (nonatomic, strong)CAShadeRoundView *shadeRoundView;
@end

@implementation TrainingViewController

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFinish" object:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createView];
    
    int lineWidth = 90;
    if (iPhone4) {
        
        lineWidth = 80;
    }
    else if (iPhone6||iPhone6plus)
    {
        lineWidth = 115;
    }
 [self drawRoundViewWithValue:0.0];
}
- (void)viewWillAppear:(BOOL)animated
{
    _bigScrollView.backgroundColor = COLOR(48, 54, 60);
}
-(void)createView
{
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefreshingTemp) name:@"refreshFinish" object:nil];
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_bigScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 10)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bigScrollView];
    
    __block TrainingViewController *safeSlef = self;
    [self.bigScrollView addHeaderWithCallback:^{
        
        NSLog(@"加载开始");
        [[[HistoryData alloc]init] getHostoryDataRequest];
        //暂时先写在一个延迟方法中
       //[safeSlef performSelector:@selector(endRefreshingTemp) withObject:safeSlef afterDelay:0.05];
        [[XlabTools sharedInstance]startLoadingInView:safeSlef.view withmessage:@"下拉数据中..."];
    }];
    
    CGFloat bgOffSet = -120;
    CGFloat addY = 5;
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
    
//    UILabel *timeTitleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 20) text:NSLocalizedString(@"exercise_time", nil) fontSize:14 color:[UIColor whiteColor] align:@"center"];
//    [_bigScrollView addSubview:timeTitleLab];
//    
//    UILabel *timeLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50, CGRectGetMaxY(timeTitleLab.frame), 110, 25) text:nil fontSize:16 color:[UIColor whiteColor] align:@"center"];
//    [_bigScrollView addSubview:timeLab];
//    timeLab.attributedText = [self getAttributedStr:@"0小时0分钟"];
    
    UILabel *timeTitleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 100,25, 60, 20) text:NSLocalizedString(@"exercise_time", nil) fontSize:14 color: ColorRGB(92, 96, 102) align:@"right"];
    timeTitleLab.font = [UIFont fontWithName:MicrosoftYaHe size:12];
    [_bigScrollView addSubview:timeTitleLab];
    
    UILabel *timeLab = [PublicFunction getlabel:CGRectMake(CGRectGetMaxX(timeTitleLab.frame), CGRectGetMinY(timeTitleLab.frame)-16, 180, 40) text:nil fontSize:18 color:ColorRGB(50, 125, 222) align:nil];
    timeLab.attributedText = [self getAttributedStr:@"1小时20分钟"];
//    timeLab.font = [UIFont fontWithName:MicrosoftYaHe size:26];
    [_bigScrollView addSubview:timeLab];
    
    for (int i = 0; i<4; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%4)*SCREEN_WIDTH/4 + 20,  SCREEN_HEIGHT -(iPhone6||iPhone6plus?280:250), 30, 30)];
        [_bigScrollView addSubview:imageView];
        
        if (iPhone4) {
            
            imageView.frame =CGRectMake((i%4)*SCREEN_WIDTH/4 + 20, SCREEN_HEIGHT - 230, 30, 30);
        }
        UILabel *lab = [PublicFunction getlabel:CGRectMake(imageView.frame.origin.x - 5, imageView.frame.origin.y + 30, 40, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
        [_bigScrollView addSubview:lab];
        
        if(i==0 )
        {
            imageView.image = [UIImage imageNamed:@"exercise_run"];
            lab.text = NSLocalizedString(@"run", nil);
            _runTimeLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 40, lab.frame.origin.y + 30, 120, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_runTimeLab];
            _runTimeLab.attributedText =[self getAttributedStr:@"0时0分"];
        }
        else if (i==1){
            
            imageView.image = [UIImage imageNamed:@"exercise_walk"];
            lab.text = NSLocalizedString(@"walk", nil);
            _walkTimeLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 40, lab.frame.origin.y + 30, 120, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_walkTimeLab];
            _walkTimeLab.attributedText = [self getAttributedStr:@"0时0分"];
        }
        else if (i==2)
        {
            imageView.image = [UIImage imageNamed:@"exercise_static"];
            lab.text = NSLocalizedString(@"static", nil);
            _staictTimeLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x - 40, lab.frame.origin.y + 30, 120, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_staictTimeLab];
            _staictTimeLab.attributedText = [self getAttributedStr:@"0时0分"];
        }
        else if (i==3)
        {
            imageView.image = [UIImage imageNamed:@"exercise_average_speed"];
            lab.bounds = CGRectMake(0, 0, 100, 30);
            lab.text = NSLocalizedString(@"average_speed_hour", nil);
            _speedTimeLab = [PublicFunction getlabel:CGRectMake(lab.frame.origin.x, lab.frame.origin.y + 30, 120, 30) text:nil fontSize:14 color:[UIColor whiteColor] align:@"center"];
            [_bigScrollView addSubview:_speedTimeLab];
            
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"0千米"];
            [str addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, str.length - 2)];
            _speedTimeLab.attributedText = str;
        }
    }
    
    
}
//没连上会不会一直下拉
-(void)endRefreshingTemp
{
   [self.bigScrollView headerEndRefreshing];
   //[self performSelector:@selector(refreshView) withObject:nil afterDelay:1];
   
    //更新上方的UI:by Star,没有数据暂时不更新
    [self drawRoundViewWithValue:0.0];
}
//-(void)refreshView
//{
//    int lineWidth = 90;
//    if (iPhone4) {
//        
//        lineWidth = 80;
//    }
//    else if (iPhone6||iPhone6plus)
//    {
//        lineWidth = 115;
//    }
//    [self drawShadeChartView:[TestDataModel getModelDataForShadeChart] withLineWidth:lineWidth withShow:YES];
//    
//    EShadeCircleView *tempView = (EShadeCircleView*)[self.bigScrollView viewWithTag:9001];
//    if (tempView) {
//        
//        [tempView removeFromSuperview];
//    }
//    
//    [SyncAlertView shareSyncAlerview:YES];
//    [[XlabTools sharedInstance]stopLoading];
//}
-(NSMutableAttributedString *)getAttributedStr:(NSString *)str
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];
    if ([str rangeOfString:@"小时"].location != NSNotFound)
    {
        //xx小时xx分钟
        NSString *str1 = [str componentsSeparatedByString:@"小时"][0];
        NSString *str2 = [str componentsSeparatedByString:@"小时"][1];
        NSString *str3 = [str2 componentsSeparatedByString:@"分"][0];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:26],NSFontAttributeName,nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:26],NSFontAttributeName,nil];
        
        [dreepStr addAttributes:dic range:NSMakeRange(0, str1.length)];
        [dreepStr addAttributes:dic2 range:NSMakeRange(str1.length, 2)];
        [dreepStr addAttributes:dic range:NSMakeRange(str1.length+2, str3.length)];
        [dreepStr addAttributes:dic2 range:NSMakeRange(str.length-2,2)];
    }
    else if ([str rangeOfString:@"时"].location != NSNotFound)
    {
    NSString *subStr1 = [str componentsSeparatedByString:@"时"][1];
    
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, dreepStr.length - subStr1.length-1)];
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(str.length - subStr1.length, 2)];
    }
    return dreepStr;
}


#pragma mark - UIGestureRecognizerDelegate Methos
- (void)handleSingleDisplay:(UITapGestureRecognizer*)sender{
          dispatch_async(dispatch_get_main_queue(), ^{
              _bigScrollView.backgroundColor = COLOR(6, 24, 44);
            [[XlabTools sharedInstance]startLoadingInView:_shadeRoundView withmessage:@"加载中..."];
              
          });
          dispatch_async(dispatch_get_global_queue(0, 0), ^{
              dispatch_async(dispatch_get_main_queue(), ^{
                   [[XlabTools sharedInstance]stopLoading];
                  [self.navigationController pushViewController:[TrendExerciseController new] animated:YES];
              });
          });
}

- (void)drawRoundViewWithValue:(CGFloat)value
{
    if (_shadeRoundView) {
        [_shadeRoundView removeFromSuperview];
    }
    _shadeRoundView = [[CAShadeRoundView alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 265)];
    _shadeRoundView.startColor = COLOR(48, 181, 245);
    _shadeRoundView.endColor = COLOR(54, 82, 214);
    _shadeRoundView.value = value;
    _shadeRoundView.describe = @"锻炼完成度";
    _shadeRoundView.type = 3;
    _shadeRoundView.endImageName = @"exercise_dashboard_02.png";
    [_bigScrollView addSubview:_shadeRoundView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleDisplay:)];
    [_shadeRoundView addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
