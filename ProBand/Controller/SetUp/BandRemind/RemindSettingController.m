//
//  RemindSettingController.m
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "RemindSettingController.h"
#import "ClockViewController.h"
#import "BLEManage.h"
#import "BandRemindManager.h"
#import "UIView+Toast.h"
@interface RemindSettingController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    
    NSArray *switchArray;
}
@end

@implementation RemindSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    switchArray = [BandRemindManager switchArrayForBandRemind];
    
    self.titleLabel.text = NSLocalizedString(@"band_reminds", nil);
    _titleArray=[[NSArray alloc] initWithObjects:NSLocalizedString(@"alarm_reminder", nil),NSLocalizedString(@"calls_reminder", nil),NSLocalizedString(@"sms_reminder", nil),NSLocalizedString(@"calendar_reminder", nil),NSLocalizedString(@"E-mail_reminder", nil),NSLocalizedString(@"QQ_reminder", nil),NSLocalizedString(@"WeChat_reminder", nil),NSLocalizedString(@"Facebook_reminder", nil),NSLocalizedString(@"Twitter_reminder", nil),NSLocalizedString(@"Whatsapp_reminder", nil),nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self createHeader];
    _tableView.backgroundColor = COLOR(223, 234, 235);
    [self addTableFootView];
    
    BLEManage *bM = [BLEManage shareCentralManager];


}
- (void)addTableFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 107)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0 , CGRectGetWidth(footView.frame) - 12, 0.7)];
    imageView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 37)];
    footLabel.text = NSLocalizedString(@"connect_band_then_modify_remind_setting", nil);
    footLabel.font = [UIFont systemFontOfSize:19];
    footLabel.textColor = COLOR(220, 93, 26);
    footLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:imageView];
    [footView addSubview:footLabel];
    [_tableView setTableFooterView:footView];
    
    
    [[BLEManage shareCentralManager]connectState:^(BOOL ok) {
        if (ok) {
            _tableView.tableFooterView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            [self.view makeToastActivity];
        }else{
            _tableView.tableFooterView.hidden = NO;
            self.view.userInteractionEnabled = NO;
            [self.view makeToast:@"请连接蓝牙" duration:9999 position:@"center"];
        }
    }];


    
}
- (UIView *)createHeader
{
    CGFloat viewH = 100;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, viewH)];
    view.backgroundColor = [UIColor whiteColor];//COLOR(223, 234, 235);
    
    UILabel *label = [PublicFunction getlabel:CGRectMake(0, 0, SCREEN_WIDTH, 80) text:NSLocalizedString(@"close_remind_message", nil) fontSize:16 color:COLOR(219, 97, 37) align:@"center"];
    [view addSubview:label];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREEN_WIDTH, 20)];
    separatorView.backgroundColor = COLOR(219, 223, 225);//COLOR(219, 97, 37);
    [view addSubview:separatorView];
    
    return view;
}

#pragma mark - TableVIewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        UIButton *switchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 66, 7, 71, 37) normalImageName:@"setting_button_sel.png" selectedImageName:@"setting_button.png" title:nil tag:1 clickAction:@selector(switchBtnClick:)];
        [cell.contentView addSubview:switchBtn];
        if (![switchArray[indexPath.row-1] boolValue])
        {
            switchBtn.selected = !switchBtn.selected;
        }
    }
    
    UILabel *titleLabel = [PublicFunction getlabel:CGRectMake(14, 10, 150, 30) text:_titleArray[indexPath.row] fontSize:17 color:COLOR(72, 72, 72) align:nil];
    [cell.contentView addSubview:titleLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[ClockViewController new] animated:YES];
    }
}


- (void)switchBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
    NSArray *array = [cell subviews];
    UIView *view = array[0];
    NSArray *subArray = [view subviews];
    for (id sub in subArray) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)sub;
            if (!btn.selected) {
                label.textColor = [UIColor blackColor];
            }else{
                label.textColor = [UIColor grayColor];
            }
        }
    }
    //更新数据库
    [[BandRemindManager sharedInstance] updateStateWithIndex:path.row];
    NSLog(@"path.row: %d",path.row);
}

-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
