//
//  ScanBandCardController.m
//  ProBand
//
//  Created by star.zxc on 15/6/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ScanBandCardController.h"
#import "CardIO.h"
@interface ScanBandCardController ()<CardIOViewDelegate>

@end

@implementation ScanBandCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setBarTitle:@"扫描银行卡" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"扫描银行卡" leftImage:@"pay_top_up_return.png"];
    UIImage *backImage = [UIImage imageNamed:@"pay_my_bank_card_bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView
{
    CardIOView *cardIOView = [[CardIOView alloc]initWithFrame:CGRectMake(-90, 18, 500, 400)];
    cardIOView.backgroundColor = [UIColor clearColor];
    cardIOView.delegate = self;
    [self.view addSubview:cardIOView];
    
    //下面取消扫描
    UIButton *cancelBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, CGRectGetMaxY(cardIOView.frame)+20, SCREEN_WIDTH-40, 30) title:@"取消扫描" align:@"center" color:[UIColor whiteColor] fontsize:16 tag:11 clickAction:@selector(cancelScan:)];
    [self.view addSubview:cancelBn];
}

#pragma - mark:CardIOViewDelegate
- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)cardInfo
{
    if (cardInfo) {
        NSLog(@"识别的账户为:%@",cardInfo.redactedCardNumber);
        NSLog(@"结果为：%@",cardInfo.cardNumber);
        if (self.postCardNumber) {
            self.postCardNumber(cardInfo.cardNumber);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"用户取消了识别");
    }
    [cardIOView removeFromSuperview];
}

- (void)cancelScan:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
