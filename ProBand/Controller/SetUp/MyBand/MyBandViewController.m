//
//  MyBandViewController.m
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "MyBandViewController.h"
#import "BatteryLeftView.h"
#import "BandUpdateController.h"
#import "SubSegmentedControl.h"
#import "BlueToothTestViewController.h"
#import "BLEManage.h"
#import "SendCommandToPeripheral.h"
#import "GetDataForPeriphera.h"
@interface MyBandViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UILabel *_battertDetailLabel;
    UIView *customAlertView;
    NSString *isconnect;
}

@end

@implementation MyBandViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"my_band", nil);
    _titleArray=[[NSArray alloc] initWithObjects:NSLocalizedString(@"band_id", nil),NSLocalizedString(@"unbund_band", nil),NSLocalizedString(@"band_status", nil),NSLocalizedString(@"check_band_firmware", nil),NSLocalizedString(@"last_sync_time", nil),NSLocalizedString(@"band_mac", nil),NSLocalizedString(@"band_BLE", nil),nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [self createHeader];
    _tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    isconnect = NSLocalizedString(@"band_disconnect", nil);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BlueToothConnectState:) name:@"connect" object:nil];
}
- (void)BlueToothConnectState:(NSNotification*)sender
{
    id ok = sender.object;
    if (ok) {
        isconnect = NSLocalizedString(@"band_connected", nil);

    }else{
        
        isconnect = NSLocalizedString(@"band_disconnect", nil);

    }
    [_tableView reloadData];
}

- (UIView *)createHeader
{
    CGFloat viewH = 110;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, viewH)];
    
    UILabel *label = [PublicFunction getlabel:CGRectMake(14, 0, 150, viewH-20) text:NSLocalizedString(@"current_power", nil) textSize:17 textColor:COLOR(72, 72, 72) textBgColor:nil textAlign:nil];
    [view addSubview:label];
    
    BatteryLeftView *batteryLeftView = [[BatteryLeftView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10, viewH-40, viewH-40)];
    
    if ([BLEManage shareCentralManager].isOpenOrOFF) {
        [[[ElectricInformation alloc]init] getElectricRequest];
    }
    [[[GetDataForPeriphera alloc]init] returnElectricValue:^(CGFloat fValue) {
       
        batteryLeftView.progress = fValue/100;
        batteryLeftView.usedDays = [NSString stringWithFormat:@"%.0f",fValue/12];

    }];
    
    [[BLEManage shareCentralManager] connectState:^(BOOL ok) {
       
        
        NSLog(@"connect ok or no");
    }];
    
    [view addSubview:batteryLeftView];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREEN_WIDTH, 20)];
    separatorView.backgroundColor =COLOR(218, 223, 234);
    [view addSubview:separatorView];
    return view;
}

#pragma mark - TableVIewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
    for (UIView *vi in cell.contentView.subviews) {
        
        [vi removeFromSuperview];
    }
    }
    cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:223/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    if (indexPath.row == 1 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    UILabel *ladel = [PublicFunction getlabel:CGRectMake(14, 10, 150, 30) text:_titleArray[indexPath.row] fontSize:17 color:COLOR(72, 72, 72) align:nil];
    [cell.contentView addSubview:ladel];

    UILabel *accessoryLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH - 220, 3, 200, 46) text:nil align:@"right"];
    [accessoryLabel setTextColor:COLOR(0, 194, 194)];
    [cell.contentView addSubview:accessoryLabel];
    
    if (indexPath.row == 0) {
        accessoryLabel.text = @"payBand";
    }else if(indexPath.row == 2)
    {
        accessoryLabel.text = isconnect;
        BOOL isConnect = [[NSUserDefaults standardUserDefaults]boolForKey:@"connect"];
        if (isConnect) {
            accessoryLabel.text = NSLocalizedString(@"band_connected", nil);

        }else{
            accessoryLabel.text = NSLocalizedString(@"band_disconnect", nil);
        }

        
    }
    else if(indexPath.row == 3)
    {
        UILabel *label = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH - 230, 0, 200, 46) text:@"236-02048-002556" textSize:15 textColor:COLOR(23, 182, 180) textBgColor:nil textAlign:@"right"];
        [cell.contentView addSubview:label];
        
    }else if(indexPath.row == 4)
    {
        NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:touchBeginSyncDate];
        accessoryLabel.text = string;
    }
    else if(indexPath.row == 5)
    {
        accessoryLabel.text = @"DD:E2:45:AE:45:A8";
    }
    else if(indexPath.row == 6)
    {
//        accessoryLabel.font = [UIFont systemFontOfSize:15];
        accessoryLabel.text = @"236-02048-002556-150100";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self addAlertView];
    }
    if (indexPath.row == 3) {
        BandUpdateController *bandUpdateVC = [[BandUpdateController alloc] init];
        [self.navigationController pushViewController:bandUpdateVC animated:YES];
    }
}

- (void)switchBtnClick:(UIButton *)btn
{
    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
    NSLog(@"path.row: %d",path.row);
    NSLog(@"switchBtnClick");
    btn.selected = !btn.selected;
}

-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addAlertView
{
    customAlertView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    customAlertView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(customAlertView.frame) - 215, CGRectGetWidth(customAlertView.frame), 215)];
    NSString *string = NSLocalizedString(@"result_after_unbinding", nil);
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(customAlertView.frame), 24)];
    lable.text = string;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bracelet_line@2x"]];
    imageview.frame = CGRectMake(20, CGRectGetMaxY(lable.frame)+ 10, CGRectGetWidth(view.frame) - 40, 1);
    
    string = NSLocalizedString(@"what_you_can_do_after_unbinding", nil);
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 20, CGRectGetWidth(customAlertView.frame), 40)];
    lable2.text = string;
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
    SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"unbund", nil),NSLocalizedString(@"cancel", nil), nil]];
    seg.frame = CGRectMake(20, CGRectGetHeight(view.frame) - 57, CGRectGetWidth(view.frame) - 40, 37);
    seg.layer.cornerRadius = CGRectGetHeight(seg.frame)/2;
    [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
        NSLog(@"%d",segmc.selectedSegmentIndex);
        
        if (segmc.selectedSegmentIndex == 1) {
            
            [customAlertView removeFromSuperview];
        }else{
            [customAlertView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Singleton getUserID]];
            BlueToothTestViewController *blue = [[BlueToothTestViewController alloc]init];
            [self.navigationController pushViewController:blue animated:YES];
            
        }
        segmc.selectedSegmentIndex = -1;
    }];
    
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:lable];
    [view addSubview:imageview];
    [view addSubview:lable2];
    [view addSubview:seg];
    [customAlertView addSubview:view];
    [[UIApplication sharedApplication].keyWindow addSubview:customAlertView];
}
@end
