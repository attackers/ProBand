//
//  MyBandCardController.m
//  ProBand
//
//  Created by star.zxc on 15/6/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "MyBandCardController.h"
#import "AddBandCardController.h"
#import "SingleCardController.h"
@interface MyBandCardController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *cardArray;
    NSMutableArray *imageArray;
    NSMutableArray *selectImageArray;
    NSMutableArray *accountArray;//银行卡号的数组
    UITableView *cardTable;
    NSInteger defaultIndex;//默认的银行卡
}
@end

@implementation MyBandCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHomeBarTitle:@"我的银行卡" leftImage:@"return.png" leftAction:@selector(goBack:) rightImage:@"pay_password_invalid.png" rightAction:nil bgColor:navigationColor];
    cardArray = [NSMutableArray arrayWithObjects:@"中国工商银行",@"交通银行", nil];
    imageArray = [NSMutableArray arrayWithObjects:@"pay_bank_card_01.png",@"pay_bank_card_02.png", nil];
    selectImageArray = [NSMutableArray arrayWithObjects:@"pay_bank_card_01_press.png",@"pay_bank_card_02_press.png", nil];
    accountArray = [NSMutableArray arrayWithObjects:@"**************4415",@"**************7249", nil];
    
    cardTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    cardTable.delegate = self;
    cardTable.dataSource = self;
    UIImageView *bgdImageView = [PublicFunction getImageView:CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT) imageName:@"pay_my_bank_card_bg.png"];
    cardTable.backgroundView = bgdImageView;
    cardTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cardTable];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *addBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, 0, 100, 40) title:@"添加银行卡" align:nil color:[UIColor whiteColor] fontsize:14 tag:50 clickAction:@selector(addBandCard:) imageName:nil];
    [addBn setImage:[UIImage imageNamed:@"pay_add"] forState:UIControlStateNormal];
    [footView addSubview:addBn];
    cardTable.tableFooterView = footView;
    // Do any additional setup after loading the view.
}
- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//在下方添加单元格:先跳入到另外一个页面
- (void)addBandCard:(UIButton *)sender
{

    AddBandCardController *addController = [[AddBandCardController alloc]init];
    addController.postAccount = ^(NSString *account){
        [cardArray addObject:@"中国银行"];
        [imageArray addObject:@"pay_bank_card_02.png"];
        [selectImageArray addObject:@"pay_bank_card_02_press.png"];
        [accountArray addObject:account];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cardArray.count-1 inSection:0];
        [cardTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:addController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cardArray.count;
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
    NSInteger row = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *cardButton = [PublicFunction getButtonInControl:self frame:CGRectMake((SCREEN_WIDTH-301)/2, (120-99.5)/2, 301, 99.5) imageName:imageArray[row] title:nil tag:100+(int)row clickAction:@selector(selectBandCard:)];
    [cardButton setImage:[UIImage imageNamed:selectImageArray[row]] forState:UIControlStateHighlighted];
    [cell.contentView addSubview:cardButton];
    //添加银行卡号的label
    UILabel *accountLabel = [PublicFunction getlabel:CGRectMake(0, 99.5-25, 301, 25) text:accountArray[row] fontSize:20 color:[UIColor whiteColor] align:@"center"];
    [cardButton addSubview:accountLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)selectBandCard:(UIButton *)sender
{
    NSLog(@"您当前选中的按钮属性为:%ld",(long)sender.tag);
    SingleCardController *cardController = [[SingleCardController alloc]init];

    cardController.icon = sender.imageView.image;
    
    [self.navigationController pushViewController:cardController animated:YES];
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
