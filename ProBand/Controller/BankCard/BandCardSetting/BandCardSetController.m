//
//  BandCardSetController.m
//  ProBand
//
//  Created by star.zxc on 15/6/9.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BandCardSetController.h"

@interface BandCardSetController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *textArray;
}
@end

@implementation BandCardSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"通用设置" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"通用设置" leftImage:@"pay_top_up_return.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    textArray = [NSArray arrayWithObjects:@"支付开关",@"客服电话",@"服务协议", nil];
}
- (void)createView
{
    UITableView *setTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:setTableView];
}

#pragma - mark:TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return textArray.count;
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
        for (UIView *vew in cell.contentView.subviews) {
            [vew removeFromSuperview];
        }
    }
    UILabel *textLabel = [PublicFunction getlabel:CGRectMake(20, 10, 100, 40) text:textArray[indexPath.row] fontSize:16 color:[UIColor blackColor] align:@"center"];
    [cell.contentView addSubview:textLabel];
    
    if (indexPath.row==0) {
        UISwitch *switch0 = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 15, 60, 30)];
        [switch0 addTarget:self action:@selector(changePayState:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switch0];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
/**
 *  改变支付状态的方法
 *
 *  @param aswitch 支付开关
 */
- (void)changePayState:(UISwitch *)aswitch
{
    NSLog(@"改变支付状态");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1://客服电话
        {
            NSLog(@"客服电话");
        }
            break;
        case 2://服务协议
        {
            NSLog(@"服务协议");
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
