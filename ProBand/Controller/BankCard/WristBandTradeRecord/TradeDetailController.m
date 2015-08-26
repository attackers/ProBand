//
//  TradeDetailController.m
//  ProBand
//
//  Created by star.zxc on 15/7/9.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TradeDetailController.h"
#define CELL_HEIGHT 60
@interface TradeDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *describeArray;
    NSArray *valueArray;
}
@end

@implementation TradeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"交易详情" leftImage:@"pay_top_up_return.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    describeArray = [NSArray arrayWithObjects:@"支付银行卡",@"支付金额",@"商户名",@"商户号",@"终端号",@"凭证号",@"交易日期",@"交易日期", nil];
    valueArray = [NSArray arrayWithObjects:@"****4415",@"12.36",@"有限公司",@"126345646.3213447",@"2454738957985",@"2632849897",@"2015/7/9",@"17:42:30", nil];
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    tableView.delegate =self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return describeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *labelColor = [UIColor blackColor];
    if (indexPath.row > 1) {
        labelColor = [UIColor lightGrayColor];
    }
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/3, CELL_HEIGHT)];
    label1.textColor = labelColor;
    label1.text = describeArray[indexPath.row];
    label1.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH*2/3-15, CELL_HEIGHT)];
    label2.textColor = labelColor;
    label2.textAlignment = NSTextAlignmentRight;
    label2.text = valueArray[indexPath.row];
    [cell.contentView addSubview:label2];
    
    return cell;
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
