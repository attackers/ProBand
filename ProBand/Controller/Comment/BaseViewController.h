/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UINavigationControllerDelegate>

-(void)setBarTitle:(NSString *)title leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor;
-(void)setBarTitle:(NSString *)title;
-(void)setBarTitle:(NSString *)title  leftImage:(NSString *)leftImage;

-(void)setHomeBarTitle:(NSString *)title leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor;

-(void)setBarTitle:(NSString *)title  txtColor:(UIColor *)txtColor leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor;

//新添加的
-(void)setUserViewBarTitle:(NSString *)title;

-(void)setBarTitle:(NSString *)title leftAction:(SEL)leftAction;
-(void)setbartitle:(NSString *)title rightTitle:(NSString *)rightStr withRightAction:(SEL)rightAction;

-(void)setbartitle:(NSString *)title leftImage:(NSString *)leftImage rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction;

//添加by Star
- (void)setBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightImage:(NSString *)rightImageName rightAction:(SEL)rightAction;
- (void)setBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction;
@end
