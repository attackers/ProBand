////
//  PayViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/28.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "PayViewController.h"
#import "MyBandCardController.h"
#import "PayRecordController.h"
#import "BandCardSetController.h"
#import "SyncAlertView.h"
@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}


-(void)createView
{
    CGFloat moneyY = 30;
    if (iPhone4)
    {
        moneyY = 20;
    }
    else if (iPhone6 || iPhone6plus)
    {
        moneyY = 40;
    }
   
    self.view.backgroundColor = COLOR(48, 54, 60);
    
//    UIImageView *iconMoneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60,moneyY, 30, 30)];
//    iconMoneyImage.image = [UIImage imageNamed:@"daily_balance"];
//    [self.view addSubview:iconMoneyImage];
    UILabel *titleLab = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2-140, moneyY+15, 100, 30) text:NSLocalizedString(@"electronic_cash_amount", nil) color:[UIColor whiteColor] size:16];
    [self.view addSubview:titleLab];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame), CGRectGetMinY(titleLab.frame)-22, 190, 60)];
    moneyLab.text = @"$182.70";
    moneyLab.textColor = COLOR(51, 126, 225);
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = [UIFont fontWithName:APP_FONT_BASE size:50];
//    moneyLab.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:moneyLab];
    
    CGFloat imageX = 255;
    CGFloat imageY = 173.5;
    UIImageView *bgImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-imageX*0.9/2, moneyLab.frame.origin.y+80, imageX*0.9, imageY*0.9)];
    bgImage1.image = [UIImage imageNamed:@"pay_jh_card.png"];
    bgImage1.alpha = 0.6;
    [self.view addSubview:bgImage1];
    
    UIImageView *bgImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-imageX*0.95/2, CGRectGetMinY(bgImage1.frame)+10, imageX*0.95, imageY*0.95)];
    bgImage2.image = [UIImage imageNamed:@"pay_jh_card.png"];
    bgImage2.alpha = 0.3;
    [self.view addSubview:bgImage2];
    
    UIImageView *blankBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-imageX/2, CGRectGetMinY(bgImage1.frame)+20, imageX, imageY)];
    blankBgImage.image = [UIImage imageNamed:@"pay_jh_card.png"];
    blankBgImage.alpha = 1;
    [self.view addSubview:blankBgImage];
    
    if (iPhone4) {
        
        moneyLab.font = [UIFont systemFontOfSize:50];
    }
    
    
    
    UILabel *numberLab = [PublicFunction getlabel:CGRectMake(10, blankBgImage.bounds.size.height - 40, blankBgImage.bounds.size.width - 20, 30) text:@"**************4444" fontSize:20 color:COLOR(42, 46, 52) align:@"center"];
    [blankBgImage addSubview:numberLab];
    
    
    for (int i = 0; i<3; i++) {
        CGFloat xCenter = (SCREEN_WIDTH-20)*(2*i+1)/6.0+10;
        UIButton *btn = [PublicFunction getButtonInControl:self frame:CGRectMake(xCenter-50,  SCREEN_HEIGHT - (iPhone6||iPhone6plus?300:270), 100, 100) imageName:@"" title:@"" tag:i clickAction:@selector(buttomBtnClick:)];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [btn setTitleColor:[UIColor whiteColor] forState:normal];
        UILabel *lab = [PublicFunction getlabel:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + 80, 100, 30) text:nil fontSize:13 color:[UIColor whiteColor] align:@"center"];
        [self.view addSubview:lab];
        if (i==0) {
            
            [btn setImage:[UIImage imageNamed:@"pay_bank_card"] forState:normal];
            [btn setImage:[UIImage imageNamed:@"pay_bank_card_press"] forState:UIControlStateSelected];
            lab.text = NSLocalizedString(@"my_bank_card", nil);
        }
        else if (i==1)
        {
            [btn setImage:[UIImage imageNamed:@"pay_record"] forState:normal];
            [btn setImage:[UIImage imageNamed:@"pay_record_press"] forState:UIControlStateSelected];
             lab.text = NSLocalizedString(@"band_transactions", nil);
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"pay_setting"] forState:normal];
            [btn setImage:[UIImage imageNamed:@"pay_setting_press"] forState:UIControlStateSelected];
            lab.text = NSLocalizedString(@"bank_card_set", nil);
        }
        [self.view addSubview:btn];
    }

}

-(void)buttomBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0://我的银行卡
        {
            [self.navigationController pushViewController:[MyBandCardController new] animated:YES];
        }
            break;
        case 1://手环交易记录
        {
            [self.navigationController pushViewController:[PayRecordController new] animated:YES];
        }
            break;
        case 2://银行卡设置
        {
            [self.navigationController pushViewController:[BandCardSetController new] animated:YES];
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
