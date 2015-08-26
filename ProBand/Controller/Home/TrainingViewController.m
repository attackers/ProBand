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
@interface TrainingViewController ()

@property (nonatomic,strong)UILabel *runTimeLab;
@property (nonatomic,strong)UILabel *walkTimeLab;
@property (nonatomic,strong)UILabel *staictTimeLab;
@property (nonatomic,strong)UILabel *speedTimeLab;
@property (nonatomic,strong)UIScrollView *bigScrollView;

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
 [self drawShadeChartView:[TestDataModel getModelDataForShadeChart] withLineWidth:lineWidth withShow:YES];
}

-(void)createView
{
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefreshingTemp) name:@"refreshFinish" object:nil];
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_bigScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 10)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.backgroundColor = COLOR(5, 27, 52);
    [self.view addSubview:_bigScrollView];
    
    __block TrainingViewController *safeSlef = self;
    [self.bigScrollView addHeaderWithCallback:^{
        
        NSLog(@"加载开始");
        [[[HistoryData alloc]init] getHostoryDataRequest];
        //暂时先写在一个延迟方法中
       [safeSlef performSelector:@selector(endRefreshingTemp) withObject:safeSlef afterDelay:0.05];
        
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
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, bgOffSet, SCREEN_WIDTH, SCREEN_HEIGHT+30+addY)];
    bgimage.image = [UIImage imageNamed:@"exercise_bg.png"];
    [_bigScrollView addSubview:bgimage];
    
    UILabel *timeTitleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50, 10, 100, 20) text:NSLocalizedString(@"exercise_time", nil) fontSize:14 color:[UIColor whiteColor] align:@"center"];
    [_bigScrollView addSubview:timeTitleLab];
    
    UILabel *timeLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 50, CGRectGetMaxY(timeTitleLab.frame), 110, 25) text:nil fontSize:16 color:[UIColor whiteColor] align:@"center"];
    [_bigScrollView addSubview:timeLab];
    timeLab.attributedText = [self getAttributedStr:@"0小时0分钟"];
    
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

-(void)endRefreshingTemp
{
   [self.bigScrollView headerEndRefreshing];
   [self performSelector:@selector(refreshView) withObject:nil afterDelay:1];
   
    //更新上方的UI:by Star,没有数据暂时不更新

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
    //[TestDataModel getExerciseModelDataForShadeChart]
    [self drawShadeChartView:[TestDataModel getModelDataForShadeChart] withLineWidth:lineWidth withShow:YES];
    
    EShadeCircleView *tempView = (EShadeCircleView*)[self.bigScrollView viewWithTag:9001];
    if (tempView) {
        
        [tempView removeFromSuperview];
    }
    
    [SyncAlertView shareSyncAlerview:YES];
}
-(NSMutableAttributedString *)getAttributedStr:(NSString *)str
{
    NSMutableAttributedString *dreepStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSString *subStr1 = [str componentsSeparatedByString:@"时"][1];
    
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(0, dreepStr.length - subStr1.length-1)];
    [dreepStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(str.length - subStr1.length, 2)];
    return dreepStr;
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
    
    //EShadeCircleView *circlrView = [[EShadeCircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- y)/2,k,y,y) andDataModel:data withLineWid:lineWidth isShow:blean withBgImageView:@"exercise_dashboard_pointer"];
    EShadeCircleView *circlrView = [[EShadeCircleView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- y)/2,k,y,y) andDataModel:data withLineWid:lineWidth isShow:blean];
    circlrView.tag = 9001;
    [_bigScrollView addSubview:circlrView];
    
   UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleDisplay:)];
    tapgesture.delegate = self;
    //触摸点个数
    [tapgesture setNumberOfTouchesRequired:1];
    tapgesture.numberOfTapsRequired = 1;
    [circlrView addGestureRecognizer:tapgesture];
    
}

#pragma mark - UIGestureRecognizerDelegate Methos
- (void)handleSingleDisplay:(UITapGestureRecognizer*)sender{
          dispatch_async(dispatch_get_main_queue(), ^{
              _bigScrollView.backgroundColor = COLOR(6, 24, 44);
              EShadeCircleView *circle = (EShadeCircleView *)[_bigScrollView viewWithTag:9001];
            [[XlabTools sharedInstance]startLoadingInView:circle withmessage:@"加载中..."];
              
          });
          dispatch_async(dispatch_get_global_queue(0, 0), ^{
              //[[FMDBTool sharedInstance] addAllTestData];
              dispatch_async(dispatch_get_main_queue(), ^{
                   [[XlabTools sharedInstance]stopLoading];
                  [self.navigationController pushViewController:[TrendExerciseController new] animated:YES];
              });
          });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
