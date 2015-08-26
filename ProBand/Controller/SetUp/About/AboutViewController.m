//
//  AboutViewController.m
//  ProBand
//
//  Created by star.zxc on 15/5/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AboutViewController.h"
#import "UpdateAppViewController.h"
@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *updateView;
}
@end

@implementation AboutViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = COLOR(0, 31, 57);
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastController)];
//    self.navigationItem.leftBarButtonItem = backItem;
    NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjects:@[[UIColor whiteColor]] forKeys:@[NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.titleTextAttributes = titleAttribute;
    
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createView
{
    UITableView *aboutTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStyleGrouped];
    aboutTable.delegate = self;
    aboutTable.dataSource = self;
    [self.view addSubview:aboutTable];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 60, 200, 44)];
    UIImage *image = [UIImage imageNamed:@"about_logo"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [titleView setImage:image];
    [headView addSubview:titleView];
    
    NSString *version  =  [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *describe = version;
    UILabel *label = [PublicFunction getlabel:CGRectMake(0, 120, SCREEN_WIDTH, 30) text:describe textSize:14 textColor:COLOR(171, 178, 180) textBgColor:nil textAlign:@"center"];
    [headView addSubview:label];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    UILabel *versionLabel = [PublicFunction getlabel:CGRectMake(0, 100, SCREEN_WIDTH, 25) text:@"联想公司 版权所有" fontSize:12 color:COLOR(171, 178, 180) align:@"center"];
    [footView addSubview:versionLabel];
    UILabel *copyRightLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(versionLabel.frame), SCREEN_WIDTH, 50) text:@"Copyright © 2014 Lenovo All Rights Reserved" fontSize:12 color:COLOR(171, 178, 180) align:@"center"];
    [footView addSubview:copyRightLabel];
    
    aboutTable.tableHeaderView = headView;
    aboutTable.tableFooterView = footView;
}
//显示中间空白的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
//    switch (indexPath.row) {
//        case 0:
//        {
//            cell.textLabel.text = @"检测app更新";
//        }
//            break;
//        case 0:
//        {
            cell.textLabel.text = @"软件许可与隐私条款";
//        }
//            break;
//        default:
//            break;
//    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选中了第%d行",indexPath.row);
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    switch (indexPath.row) {
//        case 0:
//            [self showUpdate];
//            break;
//            
//        default:
//            break;
//    }
}
//显示更新
- (void)showUpdate
{
    if (updateView) {
        [self removeUpdateView];
    }
    updateView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
    updateView.backgroundColor = COLOR(57, 60, 60);
    [self.view addSubview:updateView];
    UILabel *versionLabel = [PublicFunction getlabel:CGRectMake(0, 40, SCREEN_WIDTH, 25) text:@"检测到新版本1.0.1.0" fontSize:16 color:[UIColor orangeColor] align:@"center"];
    [updateView addSubview:versionLabel];
    UILabel *updateLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(versionLabel.frame), SCREEN_WIDTH, 25) text:@"是否要现在更新" fontSize:16 color:[UIColor orangeColor] align:@"center"];
    [updateView addSubview:updateLabel];
    
    [UIView beginAnimations:nil context:nil];
    CGPoint center = updateView.center;
    updateView.center = CGPointMake(center.x, center.y-220);
    [UIView commitAnimations];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateNormal];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"更新",@"取消"]];
    seg.frame = CGRectMake(20, 160, SCREEN_WIDTH-40, 40);
    [seg addTarget:self action:@selector(respondToSeg:) forControlEvents:UIControlEventValueChanged];
    seg.tintColor = [UIColor orangeColor];
    //seg.backgroundColor = [UIColor redColor];
    seg.layer.masksToBounds = YES;
    seg.layer.cornerRadius = 10;
    seg.layer.borderWidth = 1.0;
    seg.tag = 100;
    [updateView addSubview:seg];
}
- (void)respondToSeg:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0://更新
        {
            [self removeUpdateView];
            [self.navigationController pushViewController:[UpdateAppViewController new] animated:YES];
        }
            break;
        case 1://取消：动画消失
        {
            CGPoint center = updateView.center;
            [UIView beginAnimations:nil context:nil];
            updateView.center = CGPointMake(center.x, center.y+220);\
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDidStopSelector:@selector(removeUpdateView)];
            [UIView commitAnimations];
        }
            break;
        default:
            break;
    }
}
- (void)removeUpdateView
{
    for (UIView *view in updateView.subviews) {
        [view removeFromSuperview];
    }
    [updateView removeFromSuperview];
    updateView = nil;
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
