//
//  DataSyncController.m
//  ProBand
//
//  Created by Echo on 15/7/23.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DataSyncController.h"

@interface DataSyncController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
}

@end

@implementation DataSyncController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"数据同步";
    _titleArray=[[NSArray alloc] initWithObjects:@"仅WLAN下同步数据到云端",@"自动同步数据到云端",@"与手环自动同步数据",nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = COLOR(223, 234, 235);
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - TableVIewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        
        for (UIView *vi in cell.contentView.subviews) {
            
            [vi removeFromSuperview];
        }
    }
//    cell.backgroundColor = COLOR(223, 234, 235);
    
    UIButton *switchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 66, 7, 71, 37) normalImageName:@"setting_button_sel.png" selectedImageName:@"setting_button.png" title:nil tag:1 clickAction:@selector(switchBtnClick:)];
    [cell.contentView addSubview:switchBtn];
    
    
    UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(14, 10, 220, 30) text:_titleArray[indexPath.row] fontSize:17 color:COLOR(72, 72, 72) align:nil];
    [cell.contentView addSubview:titleLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)switchBtnClick:(UIButton *)btn
{
    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
    NSLog(@"path.row: %d",path.row);
    NSLog(@"switchBtnClick");
    btn.selected = !btn.selected;
}

@end
