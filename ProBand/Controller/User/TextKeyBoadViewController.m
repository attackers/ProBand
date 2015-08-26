//
//  TextKeyBoadViewController.m
//  keyboard
//
//  Created by attack on 15/7/6.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "TextKeyBoadViewController.h"

@interface TextKeyBoadViewController ()<UITextFieldDelegate>
{
    UIView *backview;
    NSString *textfieldString;
}
@end

@implementation TextKeyBoadViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    int i = [[[UIDevice currentDevice]systemVersion]intValue];
    if (i>=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 568, CGRectGetWidth(self.view.frame),292)];
    backview.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame) - 90, 40)];
    self.textView.placeholder = @"输入昵称";
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
    self.textView.clearButtonMode = UITextFieldViewModeAlways;

    [self.textView becomeFirstResponder];
    [backview addSubview: self.textView];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 36, CGRectGetWidth(self.view.frame) - 90, 1)];
    imageview.image = [UIImage imageNamed:@"moving_target_regulation02"];
    [backview addSubview:imageview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 70, 3, 60, 34);
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 8;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:button];
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [self.view addSubview:backview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)keyboardWasShown:(NSNotification*)id
{
    NSLog(@"%@",id);
    [UIView animateWithDuration:0.0 animations:^{
       
        CGRect rect = backview.frame;
        rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - 292 - 67;
        backview.frame = rect;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField

{
    textfieldString = textField.text;
    _rStg(textfieldString);
    NSLog(@"textfield text %@",textField.text);
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (BOOL)canResignFirstResponder
{
    return YES;
}
- (void)textFieldString:(ReturnStringValue)tStg
{
    _rStg = ^(NSString *string){
    
        tStg(string);
    };

}
- (void)buttonClick
{
    [self.textView canBecomeFirstResponder];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
