//
//  RechargeController.m
//  ProBand
//
//  Created by star.zxc on 15/7/8.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "RechargeController.h"
#import "RechargeView.h"
@interface RechargeController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIView *coverView;//蒙板View
    NSInteger currentTextField;//标记当前编辑的TextField
    UIView *popView;//弹出的View
}
@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self setBarTitle:@"充值" leftTitle:@"返回" rightImage:nil rightAction:nil];
    [self setBarTitle:@"充值" leftImage:@"pay_top_up_return.png"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    currentTextField = 0;
    [self createView];
    // Do any additional setup after loading the view.
}

- (void)createView
{
    CGFloat offsetHeight = 0;
//    if (systemIsIOS7) {
//        offsetHeight = 0;
//    }
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, offsetHeight, SCREEN_WIDTH, SCREEN_HEIGHT-offsetHeight)];
    //scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:scrollView];
    
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    UILabel *describe1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 30)];
    describe1.text = @"电子现金账号:";
    describe1.font = labelFont;
    describe1.textAlignment = NSTextAlignmentRight;
    describe1.textColor = [UIColor blackColor];
    [scrollView addSubview:describe1];
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(describe1.frame), CGRectGetMinY(describe1.frame), SCREEN_WIDTH-30-describe1.frame.size.width, describe1.frame.size.height)];
    account.text = @"2255 5545 1111 5664 515";
    account.textAlignment = NSTextAlignmentLeft;
    account.font = labelFont;
    account.textColor = [UIColor blackColor];
    [scrollView addSubview:account];
    
    RechargeView *chargeView = [[RechargeView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, CGRectGetMaxY(describe1.frame)+30, 120, 120)];
    [chargeView drawShadeChartViewWithScale:75];
    [scrollView addSubview:chargeView];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(chargeView.frame)+30, SCREEN_WIDTH/2-15, 30)];
    balanceLabel.text = @"余额：750.00元";
    balanceLabel.font = labelFont;
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = [UIColor blackColor];
    [scrollView addSubview:balanceLabel];
    UILabel *chargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(balanceLabel.frame), SCREEN_WIDTH/2-15, 30)];
    chargeLabel.text = @"可充值：150.00元";
    chargeLabel.font = labelFont;
    chargeLabel.textAlignment = NSTextAlignmentCenter;
    chargeLabel.textColor = [UIColor blackColor];
    [scrollView addSubview:chargeLabel];
    //绘制线条
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(CGRectGetMinX(balanceLabel.frame), CGRectGetMinY(balanceLabel.frame)-0.5, SCREEN_WIDTH-30, 0.5);
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [scrollView.layer addSublayer:line1];
    CALayer *line2 = [CALayer layer];
    line2.frame = CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(balanceLabel.frame)+2, 0.5, 26);
    line2.backgroundColor = [UIColor lightGrayColor].CGColor;
    [scrollView.layer addSublayer:line2];
    CALayer *line3 = [CALayer layer];
    line3.frame = CGRectMake(CGRectGetMinX(balanceLabel.frame), CGRectGetMaxY(balanceLabel.frame), SCREEN_WIDTH-30, 0.5);
    line3.backgroundColor = [UIColor lightGrayColor].CGColor;
    [scrollView.layer addSublayer:line3];
    
    UITextField *chargeField = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(balanceLabel.frame)+30, SCREEN_WIDTH-60, 40)];
    chargeField.clearButtonMode = UITextFieldViewModeAlways;
    chargeField.placeholder = @"请输入充值金额";
    chargeField.delegate = self;
    chargeField.tag = 8888;
    [scrollView addSubview:chargeField];
    CALayer *line4 = [CALayer layer];
    line4.frame = CGRectMake(20, CGRectGetMaxY(chargeField.frame), SCREEN_WIDTH-40, 0.5);
    line4.backgroundColor = [UIColor lightGrayColor].CGColor;
    [scrollView.layer addSublayer:line4];
    
    UIButton *chargeBn = [[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60-64, SCREEN_WIDTH-40, 40)];
    [chargeBn setTitle:@"充值" forState:UIControlStateNormal];
    [chargeBn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    chargeBn.layer.borderWidth = 1.0;
    chargeBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    chargeBn.layer.masksToBounds = YES;
    chargeBn.layer.cornerRadius = 25;
    [chargeBn addTarget:self action:@selector(respondToCharge:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:chargeBn];
}
#pragma - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘弹出时View上移:先调用该方法再调用键盘弹出的方法
    NSLog(@"开始编辑信息");
    switch (textField.tag) {
        case 8888://充值金额
        {
            currentTextField = 8888;
        }
            break;
        case 9999://充值金额
        {
            currentTextField = 9999;
        }
            break;
        default:
            break;
    }
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSLog(@"键盘即将弹出");
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //获取键盘高度
    if (currentTextField == 8888)
    {
        [UIView beginAnimations:nil context:nil];
        scrollView.contentOffset = CGPointMake(0, height);
        [UIView setAnimationDuration:0.35];
        [UIView commitAnimations];
    }
    else if (currentTextField == 9999)
    {
        CGPoint center = popView.center;
        [UIView beginAnimations:nil context:nil];
        popView.center = CGPointMake(center.x, center.y-height-popView.frame.size.height*3/2+5);
        [UIView setAnimationDuration:0.35];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"键盘即将消失");
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (currentTextField == 8888)
    {
        [UIView beginAnimations:nil context:nil];
        scrollView.contentOffset = CGPointZero;
        [UIView setAnimationDuration:0.35];
        [UIView commitAnimations];
    }
    else if (currentTextField == 9999)
    {
        [UIView beginAnimations:nil context:nil];
        popView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+popView.frame.size.height/2);
        [UIView setAnimationDuration:0.35];
        [UIView commitAnimations];
        [coverView removeFromSuperview];
    }
    currentTextField = 0;
}
- (void)respondToCharge:(UIButton *)sender
{
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    coverView.backgroundColor = [UIColor lightGrayColor];
    coverView.alpha = 0.8;
    [self.view addSubview:coverView];
    popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 140)];
    popView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:popView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    label1.text = @"充值金额";
    label1.textColor = [UIColor lightGrayColor];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), SCREEN_WIDTH, 35)];
    label2.text = @"150.00";
    label2.textColor = COLOR(55, 188, 242);
    label2.font = [UIFont systemFontOfSize:30];
    label2.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:label2];
    UITextField *psdField = [[UITextField alloc]initWithFrame:CGRectMake(15, popView.frame.size.height-35, SCREEN_WIDTH-15-70, 30)];
    psdField.delegate = self;
    psdField.placeholder = @"输入银行卡密码";
    psdField.clearButtonMode = UITextFieldViewModeAlways;
    psdField.tag = 9999;
    [psdField becomeFirstResponder];
    [popView addSubview:psdField];
    //绘线
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(10, CGRectGetMaxY(psdField.frame), psdField.frame.size.width+5, 0.5);
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [popView.layer addSublayer:line1];
    
    UIButton *confirmBn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(psdField.frame)+5, CGRectGetMinY(psdField.frame), 60, psdField.frame.size.height)];
    [confirmBn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    confirmBn.layer.masksToBounds = YES;
    confirmBn.layer.cornerRadius = 5.0;
    confirmBn.layer.borderWidth = 1.0;
    confirmBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [popView addSubview:confirmBn];
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
