//
//  AddBandCardController.m
//  ProBand
//
//  Created by star.zxc on 15/6/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AddBandCardController.h"
#import "ScanBandCardController.h"
#import "BindSuccessController.h"
#import "AssisitTool.h"
@interface AddBandCardController ()<UITextFieldDelegate>
{
    UILabel *accountErrorLab;
    UIScrollView *scrollView;
}
@property (nonatomic, strong)UITextField *accountField;
@property (nonatomic, strong)UITextField *phoneNumberField;
@property (nonatomic, strong)UITextField *authCodeField;
@end

@implementation AddBandCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"添加银行卡" leftTitle:@"取消" rightImage:nil rightAction:nil];
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

}
- (void)createView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scrollView];
    if (iPhone4) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
    }
    
    UILabel *pleaseLabel = [PublicFunction getlabel:CGRectMake(20, 20, SCREEN_WIDTH-80, 30) text:@"请绑定持卡人本人的银行卡" fontSize:16 color:[UIColor blackColor] align:nil];
    [scrollView addSubview:pleaseLabel];
    //绘制一条线
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(0, CGRectGetMaxY(pleaseLabel.frame)+20, SCREEN_WIDTH, 0.5);
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [scrollView.layer addSublayer:line1];
    
    _accountField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(20, CGRectGetMaxY(pleaseLabel.frame)+40, SCREEN_WIDTH-40, 40) tag:10 returnType:nil text:nil placeholder:@"卡号"];
    [scrollView addSubview:_accountField];
    UIButton *cameraBn = [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-80, 0, 39, 39) imageName:@"pay_record.png" title:nil clickAction:@selector(cameraForAccount:)];
    [_accountField addSubview:cameraBn];
    
    //提示账户错误的label
    accountErrorLab = [PublicFunction getlabel:CGRectMake(CGRectGetMinX(_accountField.frame), CGRectGetMaxY(_accountField.frame), SCREEN_WIDTH-80, 20) text:@"卡号格式不对" color:[UIColor redColor] size:14];
    accountErrorLab.hidden = YES;
    [scrollView addSubview:accountErrorLab];
    
    _phoneNumberField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(CGRectGetMinX(_accountField.frame), CGRectGetMaxY(_accountField.frame)+20, SCREEN_WIDTH-40, _accountField.frame.size.height) tag:11 returnType:nil text:nil placeholder:@"银行预留电话"];
    [scrollView addSubview:_phoneNumberField];
    
    _authCodeField = [PublicFunction getTextFieldInControl:self frame:CGRectMake(CGRectGetMinX(_accountField.frame), CGRectGetMaxY(_phoneNumberField.frame)+20, SCREEN_WIDTH-140, _accountField.frame.size.height) tag:12 returnType:nil text:nil placeholder:@"输入验证码"];
    [scrollView addSubview:_authCodeField];
    
    UIButton *getCodeBn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_authCodeField.frame)+5, CGRectGetMinY(_authCodeField.frame)+2, 100, _authCodeField.frame.size.height-4)];
    getCodeBn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCodeBn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBn setBackgroundColor:COLOR(82, 182, 240)];
    getCodeBn.layer.masksToBounds = YES;
    getCodeBn.layer.cornerRadius = 5.0;
    [getCodeBn addTarget:self action:@selector(getNewAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:getCodeBn];
    
//    UIButton *getCodeBn = [PublicFunction getButtonInControl:self frame:CGRectMake(CGRectGetMaxX(_authCodeField.frame)+5, CGRectGetMinY(_authCodeField.frame)+10, 75, 20) title:@"获取验证码" align:@"center" color:[UIColor blackColor] fontsize:14 tag:13 clickAction:@selector(getNewAuthCode:)];
//    getCodeBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    getCodeBn.layer.borderWidth = 0.5;
//    [scrollView addSubview:getCodeBn];
    
//    UISwitch *switch1 = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(_accountField.frame)+10, CGRectGetMaxY(_authCodeField.frame)+20, 50, 30)];
//    [scrollView addSubview:switch1];
    UIButton *checkBn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_accountField.frame)+5, CGRectGetMaxY(_authCodeField.frame)+20, 20, 20)];
    [checkBn setImage:[UIImage imageNamed:@"pay_add_bank_card_options"] forState:UIControlStateNormal];
    [checkBn setImage:[UIImage imageNamed:@"pay_add_bank_card_options_sel"] forState:UIControlStateSelected];
    [checkBn addTarget:self action:@selector(checkAgreeDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:checkBn];
    
    UILabel *agreeLabel = [PublicFunction getlabel:CGRectMake(CGRectGetMaxX(checkBn.frame), CGRectGetMinY(checkBn.frame), 30, 20) text:@"同意" size:14];
    [scrollView addSubview:agreeLabel];
    UIButton *delegateBn = [PublicFunction getButtonInControl:self frame:CGRectMake(CGRectGetMaxX(agreeLabel.frame), CGRectGetMinY(agreeLabel.frame), 100, 20) title:@"《用户协议》" align:nil color:COLOR(82, 182, 240) fontsize:14 tag:15 clickAction:@selector(goToUserDelegate:)];
    [scrollView addSubview:delegateBn];
    
    //最下方的提示
    UITextView *textView = [PublicFunction getTextView:CGRectMake(CGRectGetMinX(_accountField.frame), CGRectGetMaxY(checkBn.frame)+20, SCREEN_WIDTH-40, 90) text:@"温馨提示\n为了您的账户资金安全，只能绑定持卡人本人的银行卡." size:16];
    //textView.backgroundColor = [UIColor redColor];
    textView.scrollEnabled = NO;
    textView.textColor = COLOR(82, 182, 240);
    [scrollView addSubview:textView];
    
    UIButton *nextBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, CGRectGetMaxY(textView.frame)+50, SCREEN_WIDTH-60, 40) title:@"下一步" align:@"center" color:[UIColor blackColor] fontsize:16 tag:16 clickAction:@selector(nextStep:)];
    nextBn.layer.masksToBounds = YES;
    nextBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    nextBn.layer.borderWidth = 1.0;
    nextBn.layer.cornerRadius = 20;
    [scrollView addSubview:nextBn];
}
- (void)cameraForAccount:(UIButton *)sender
{
    ScanBandCardController *scanController = [[ScanBandCardController alloc]init];
    scanController.postCardNumber = ^(NSString *cardNumber){
        _accountField.text = cardNumber;
    };
    [self.navigationController pushViewController:scanController animated:YES];
}
//获取验证码
- (void)getNewAuthCode:(UIButton *)sender
{
    
}
//进入用户协议的页面
- (void)goToUserDelegate:(UIButton *)sender
{
    
}
- (void)checkAgreeDelegate:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
//下一步
- (void)nextStep:(UIButton *)sender
{
    if (self.postAccount && _accountField.text.length > 0) {
        self.postAccount(_accountField.text);
    }
    BindSuccessController *bind = [[BindSuccessController alloc]init];
    [self.navigationController pushViewController:bind animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 10://账户的field
        {
            if (![AssisitTool checkCardNo:textField.text]) {
                accountErrorLab.hidden = NO;
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    accountErrorLab.hidden = YES;
                });
            }
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
