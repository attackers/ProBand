//
//  DetailTabbarController.m
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DetailTabbarController.h"
#import "TrendSleepController.h"
#import "TrendDailyController.h"
@interface DetailTabbarController ()

@end

@implementation DetailTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    TrendDailyController *dailyController = [[TrendDailyController alloc]init];
    dailyController.tabBarItem.title = @"日常";
    TrendSleepController *sleepController = [[TrendSleepController alloc]init];
    sleepController.tabBarItem.title = @"睡眠";
    
    self.viewControllers = @[dailyController,sleepController];
    // Do any additional setup after loading the view.
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
