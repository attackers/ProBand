//
//  BindSuccessController.m
//  ProBand
//
//  Created by star.zxc on 15/6/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BindSuccessController.h"
#import "MyBandCardController.h"
@interface BindSuccessController ()

@end

@implementation BindSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"添加银行卡" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"添加银行卡" leftImage:@"pay_top_up_return.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView
{
    UILabel *successLab = [PublicFunction getlabel:CGRectMake(0, 100, SCREEN_WIDTH, 50) text:@"绑定已成功！" fontSize:30 color:[UIColor blackColor] align:@"center"];
    [self.view addSubview:successLab];
    
    UIButton *finishBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, SCREEN_HEIGHT-150, SCREEN_WIDTH-40, 30) title:@"完成" align:@"center" color:[UIColor blackColor] fontsize:16 tag:10 clickAction:@selector(finished:)];
    [self.view addSubview:finishBn];
}

- (void)finished:(UIButton *)sender
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[MyBandCardController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
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
