//
//  SingleCardController.m
//  ProBand
//
//  Created by star.zxc on 15/6/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SingleCardController.h"
#import "RechargeController.h"
@interface SingleCardController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *describeArr1;
}
@end

@implementation SingleCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"我的银行卡" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"我的银行卡" leftImage:@"pay_top_up_return.png"];
    self.navigationController.navigationBar.barTintColor = COLOR(25, 25, 31);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)goBackAction
{
    self.navigationController.navigationBar.barTintColor = navigationColor;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData
{
    describeArr1 = [NSArray arrayWithObjects:@"账户信息", @"充值",@"交易记录",@"银行卡信息",@"客服电话",nil];
}
- (void)createView
{
    UITableView *singleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    singleTable.delegate = self;
    singleTable.dataSource = self;
    //singleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:singleTable];
    
    //扫描出的图片？？？
    UIImageView *cardImage = [PublicFunction getImageView:CGRectMake((SCREEN_WIDTH-271)/2, 30, 271, 141) imageName:nil];
    cardImage.image = [UIImage imageNamed:@"pay_my_bank_card_01"];
    cardImage.contentMode = UIViewContentModeScaleToFill;
//    cardImage.backgroundColor = [UIColor redColor];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headView.backgroundColor = COLOR(36, 39, 47);
    [headView addSubview:cardImage];
    
    singleTable.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 60)];
    label.numberOfLines = 0;
    label.text = @"银行卡可以充值到手环，也可以直接支付，方便快捷";
    label.textColor = COLOR(50, 175, 239);
    [footView addSubview:label];
    singleTable.tableFooterView = footView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return describeArr1.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = describeArr1[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你选择了第%d行",indexPath.row);
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"账户信息");
        }
            break;
        case 1:
        {
            NSLog(@"充值");
            [self.navigationController pushViewController:[RechargeController new] animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"交易记录");
        }
            break;
        case 3:
        {
            NSLog(@"银行卡信息");
        }
            break;
        case 4:
        {
            NSLog(@"客服电话");
        }
            break;
        default:
            break;
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
