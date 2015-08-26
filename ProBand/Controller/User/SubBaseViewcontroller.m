//
//  SubBaseViewcontroller.m
//  ProBand
//
//  Created by attack on 15/6/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SubBaseViewcontroller.h"

@implementation SubBaseViewcontroller
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:48/255.0 green:54/255.0 blue:60/255.0 alpha:1];
    _leftBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, 60, 60) imageName:@"" title:@"" clickAction:@selector(gotoBackBtnClick)];
    [_leftBtn setImage:[UIImage imageNamed:@"return"] forState:normal];
    _leftBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    
    _redRoundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 5, 5)];
    _redRoundImageView.backgroundColor = [UIColor redColor];
    [_redRoundImageView.layer setCornerRadius:CGRectGetWidth(_redRoundImageView.frame)/2];
    _redRoundImageView.clipsToBounds = YES;
    _redRoundImageView.hidden = YES;
    [_leftBtn addSubview:_redRoundImageView];
    
    _segmentTationLineL = [[UIView alloc] initWithFrame:CGRectMake(32, 15, 2, 30)];
    _segmentTationLineL.backgroundColor = ColorRGB(42, 46, 52);
    _segmentTationLineL.hidden = YES;
    [_leftBtn addSubview:_segmentTationLineL];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 60, 60);
    _rightBtn.transform = CGAffineTransformMakeScale(1.5, 1.4);
    [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.hidden = YES;
    _segmentTationLineR = [[UIView alloc] initWithFrame:CGRectMake(30, 18, 1.7, 26)];
    _segmentTationLineR.backgroundColor = ColorRGB(42, 46, 52);
    _segmentTationLineR.hidden = YES;
    [_rightBtn addSubview:_segmentTationLineR];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:MicrosoftYaHe size:15];
    self.navigationItem.titleView = _titleLabel;
    self.navigationController.navigationBar.barTintColor = COLOR(36, 41, 46);
    
}

- (void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
