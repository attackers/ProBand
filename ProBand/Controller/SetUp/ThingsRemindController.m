//
//  ThingsRemindController.m
//  ProBand
//
//  Created by Echo on 15/5/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ThingsRemindController.h"
#import "EditThingsController.h"

@interface ThingsRemindController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
}
@end

@implementation ThingsRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"事件提醒";
    _titleArray=[[NSArray alloc] initWithObjects:@"07：20  带电脑",@"09：20  喝水",@"12：20  吃药",@"16：20  接孩子",@"20：20  见客户",nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - TableVIewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 46;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *vi in cell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 66, 10, 280, 30)];
    [cell.contentView addSubview:switcher];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[EditThingsController new] animated:YES];
}

@end
