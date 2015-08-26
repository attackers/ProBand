//
//  PayRecordController.m
//  ProBand
//
//  Created by star.zxc on 15/6/9.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "PayRecordController.h"
#import "TradeDetailController.h"
#define CELL_HEIGHT 60
@interface PayRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *payArray;
}
@end

@implementation PayRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"支付记录" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"支付记录" leftImage:@"pay_top_up_return.png"];
    self.navigationController.navigationBar.barTintColor = COLOR(25, 25, 31);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic1 = @{@"money":@"¥500.00",@"payWay":@"银行卡充值",@"date":@"10:01 3/31"};
    NSDictionary *dic2 = @{@"money":@"¥12.36",@"payWay":@"手环支付",@"date":@"15:03 3/29"};
    payArray = [NSMutableArray arrayWithObjects:dic1,dic2, nil];
    
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)goBackAction
{
    self.navigationController.navigationBar.barTintColor = navigationColor;
    [self.navigationController popViewControllerAnimated:YES];
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
    return payArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSDictionary *dic = payArray[indexPath.row];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, CELL_HEIGHT)];
    label1.textColor = [UIColor blackColor];
    label1.text = dic[@"money"];
    label1.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label1];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 20, 18, 18)];
    if ([dic[@"payWay"] isEqualToString:@"银行卡充值"]) {
        imageview.image = [UIImage imageNamed:@"pay_record_bank_card"];
    }
    else if ([dic[@"payWay"] isEqualToString:@"手环支付"])
    {
        imageview.image = [UIImage imageNamed:@"pay_record_bracelet"];
    }
    [cell.contentView addSubview:imageview];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 0, SCREEN_WIDTH/3, CELL_HEIGHT)];
    label2.textColor = [UIColor blackColor];
    label2.text = dic[@"payWay"];
    [cell.contentView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, CELL_HEIGHT)];
    label3.textColor = [UIColor lightGrayColor];
    label3.text = dic[@"date"];
    [cell.contentView addSubview:label3];
    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 24, 12, 12)];
    imageview2.image = [UIImage imageNamed:@"setting_arrow"];
    [cell.contentView addSubview:imageview2];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%d行",indexPath.row);
    [self.navigationController pushViewController:[TradeDetailController new] animated:YES];
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
