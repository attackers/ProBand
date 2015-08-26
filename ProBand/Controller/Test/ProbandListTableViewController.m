//
//  ProbandListTableViewController.m
//  ProBand
//
//  Created by attack on 15/6/17.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ProbandListTableViewController.h"
#import "ProbandListTableViewCell.h"
#import "BLEManage.h"
#import "PeripheralModel.h"
static NSString* mycell = @"mycell";
@interface ProbandListTableViewController ()
{
    BLEManage *manager;
    PeripheralModel *peripheralModel;
}
@end

@implementation ProbandListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ProbandListTableViewCell class] forCellReuseIdentifier:mycell];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    manager = [BLEManage shareCentralManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    [self setfootTableView];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _probandlistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProbandListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mycell];
    if (cell == nil) {
        cell = [[ProbandListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mycell];

    }
    peripheralModel = _probandlistArray[indexPath.row];
    NSLog(@"indexPath row : %d %@",indexPath.row,peripheralModel.peripheral.identifier.UUIDString);
    cell.namelabel.text = [NSString stringWithFormat:@"ProBand%d:%@",indexPath.row,peripheralModel.macAddr];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    peripheralModel = _probandlistArray[indexPath.row];
//    [manager connectPeripheral:peripheralModel.peripheral];
//    if (_begin) {
//        
//        _begin(YES);
//    }
    if (_listIndex) {
        
        _listIndex(indexPath.row);
    }
}
- (void)setfootTableView
{
  
    if (_probandlistArray == nil|| _probandlistArray.count == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tableView.frame))];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 -23, 20, 46, 46)];
        imageview.image = [UIImage imageNamed:@"connection_fails"];
        [view addSubview:imageview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(self.view.frame), 24) ];
        label.text = @"未搜索到手环";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), CGRectGetWidth(self.view.frame), 24)];
        label2.text = @"将手环开机并靠近手机同时确保手环电量充足";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor whiteColor];
        label2.font = [UIFont systemFontOfSize:12];
        [view addSubview:label2];
        view.backgroundColor = [UIColor clearColor];
        [self.tableView setTableFooterView:view];
        self.tableView.scrollEnabled = NO;
       
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *topImageview = [PublicFunction getImageView:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 2) imageName:@"search_bracelet_bg_line"];
    topImageview.contentMode = UIViewContentModeScaleAspectFill;
    return topImageview;
}
- (void)selectProBandAndBeginConnect:(SelectProband)beginconnect
{
    _begin = ^(BOOL beginCon){
    
        beginconnect(beginCon);
        
    };
    
}
- (void)probandlistIndex:(ProbandlistIndex)index
{
    _listIndex=^(NSInteger indexpath){
    
        index(indexpath);
    };

}
@end
