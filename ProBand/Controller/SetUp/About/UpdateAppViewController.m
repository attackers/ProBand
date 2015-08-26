//
//  UpdateAppViewController.m
//  ProBand
//
//  Created by star.zxc on 15/5/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UpdateAppViewController.h"
#import "UpdateView.h"
@interface UpdateAppViewController ()
{
    
}
@property (nonatomic, strong)UIButton *sureBn;
@property (nonatomic, strong)UpdateView *updateView;
@property (nonatomic, strong)UILabel *failLabel;
@property (nonatomic, strong)UILabel *checkLabel;
//@property (nonatomic, strong)UIButton *tryBn;
//@property (nonatomic, strong)UIButton *cancelBn;
@property (nonatomic, strong)UISegmentedControl *seg;
@end

@implementation UpdateAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更新";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = COLOR(0, 31, 57);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastController)];
    self.navigationItem.leftBarButtonItem = backItem;
    NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjects:@[[UIColor whiteColor]] forKeys:@[NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.titleTextAttributes = titleAttribute;

    
    [self addUpdateView];
    
    _sureBn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-60, 100, 30) title:@"确认" align:@"center" color:[UIColor whiteColor] fontsize:16 tag:11 clickAction:@selector(confirmUpdate:)];
    _sureBn.enabled = NO;//默认不可点击
    _sureBn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_sureBn];
    
    _failLabel = [PublicFunction getlabel:CGRectMake(0, SCREEN_HEIGHT/2-30, SCREEN_WIDTH, 30) text:@"更新失败" fontSize:18 color:[UIColor orangeColor] align:@"center"];
    _failLabel.hidden = YES;
    [self.view addSubview:_failLabel];
    
    _checkLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(_failLabel.frame)+5, SCREEN_WIDTH, 50) text:@"请检查手环电量是否充足，\n确保手机蓝牙打开饼与互联网连接" fontSize:15 color:[UIColor orangeColor] align:@"center"];
    _checkLabel.numberOfLines = 2;
    _checkLabel.hidden = YES;
    [self.view addSubview:_checkLabel];
    
//    _tryBn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH/2-110, SCREEN_HEIGHT-60, 100, 30) title:@"再次尝试" align:@"center" color:[UIColor blackColor] fontsize:14 tag:12 clickAction:@selector(tryAgainUpdate:)];
//    _tryBn.hidden = YES;
//    [self.view addSubview:_tryBn];
//    
//    _cancelBn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH/2+10, CGRectGetMinY(_tryBn.frame), 100, 30) title:@"取消更新" align:@"center" color:[UIColor blackColor] fontsize:14 tag:13 clickAction:@selector(cancelUpdate:)];
//    _cancelBn.hidden = YES;
//    [self.view addSubview:_cancelBn];
    
    _seg = [[UISegmentedControl alloc]initWithItems:@[@"再次尝试",@"取消"]];
    _seg.frame = CGRectMake(20, SCREEN_HEIGHT-60, SCREEN_WIDTH-40, 40);
    [_seg addTarget:self action:@selector(respondToSeg:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor orangeColor];
    //seg.backgroundColor = [UIColor redColor];
    _seg.layer.masksToBounds = YES;
    _seg.layer.cornerRadius = 20;
    _seg.layer.borderWidth = 1.0;
    _seg.tag = 100;
    _seg.hidden = YES;
    [self.view addSubview:_seg];
    // Do any additional setup after loading the view.
}
- (void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addUpdateView
{
    _updateView = [[UpdateView alloc]init];
    _updateView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _updateView.bounds = CGRectMake(0, 0, 208, 208);
    __block UpdateAppViewController *blockSelf = self;
    _updateView.updateFinished = ^{
        blockSelf.sureBn.enabled = YES;
    };
    _updateView.updateFailed = ^{
        [blockSelf.updateView removeFromSuperview];
        //blockSelf.updateView.hidden = YES;
        blockSelf.sureBn.hidden = YES;
        blockSelf.failLabel.hidden = NO;
        blockSelf.checkLabel.hidden = NO;
        blockSelf.seg.hidden = NO;
    };
    [self.view addSubview:_updateView];
}
- (void)respondToSeg:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0://再次尝试
        {
            [self tryAgainUpdate];
        }
            break;
        case 1://取消：动画消失
        {
            [self cancelUpdate];
        }
            break;
        default:
            break;
    }
}
- (void)confirmUpdate:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tryAgainUpdate
{
    [self addUpdateView];
}
- (void)cancelUpdate
{
    [self.navigationController popViewControllerAnimated:YES];
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
