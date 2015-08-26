//
//  SetUpViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/5.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SetUpViewController.h"
#import "UserInfoViewController.h"

#import "UserSportTargetController.h"

#import "MyBandViewController.h"

#import "RemindSettingController.h"
#import "AboutViewController.h"
#import "SportTargetTabBarController.h"
@interface SetUpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *titleArray;
}
@end

@implementation SetUpViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = @"设置";
    titleArray=[[NSArray alloc] initWithObjects:@"我的手环",@"个人信息",@"手环提醒",@"运动目标",@"",@"关于",nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
}
-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0://我的手环
        {
            [self.navigationController pushViewController:[MyBandViewController new] animated:YES];
            break;
        }
        case 1://个人信息
        {
            [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
            break;
        }
        case 2://手环提醒
        {
            [self.navigationController pushViewController:[RemindSettingController new] animated:YES];
         break;
        }
        case 3://运动目标
        {
//            [self.navigationController pushViewController:[UserSportTargetController new] animated:YES];
            [self.navigationController pushViewController:[SportTargetTabBarController new] animated:YES];
            break;
        }
        case 5://关于页面
        {
            [self.navigationController pushViewController:[AboutViewController new] animated:YES];
        }
        default:
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long row=indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if(indexPath.row == 4)
    {
        //参与改善计划 cell.height = 80;
        UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(20, 10, 150, 30) text:@"参与改善计划"];
        [cell.contentView addSubview:titleLabel];
        
        //如果为空或者yes
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:HasParticipateInImproving];
        UIButton *switchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 66, 7, 71, 37) normalImageName:@"setting_button.png" selectedImageName:@"setting_button_sel.png" title:nil tag:1 clickAction:@selector(switchBtnClick:)];
        if ([str isEqualToString:@"no"]) {
            switchBtn.selected = NO;
        }
        else
        {
            switchBtn.selected = YES;
        }
        [cell.contentView addSubview:switchBtn];
        
        UILabel *descLabel = [PublicFunction getlabel:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 14) text:@"只会将您的数据用于分析，用来帮助做用户体验的提升。"];
        [descLabel setTextColor:COLOR(128, 133, 133)];
        descLabel.textAlignment=NSTextAlignmentLeft;
        descLabel.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:descLabel];
    }
    if (!(indexPath.row == 4)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.contentView addSubview:[PublicFunction getlabel:CGRectMake(20, 5, 120, 40) text:[titleArray objectAtIndex:row]]];
//    cell.backgroundColor = [UIColor colorWithRed:223/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) return 70;
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (void)switchBtnClick:(UIButton *)btn
{
    NSLog(@"switchBtnClick");
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:HasParticipateInImproving];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:HasParticipateInImproving];
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
