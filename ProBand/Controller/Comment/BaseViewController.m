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

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()

@end
#define statusBarHeight 20
@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDlg = [AppDelegate getAPPDelegate];
    if (appDlg.isReachable) {
        NSLog(@"网络已连接");
    }else{
        NSLog(@"网络连接异常");
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    // 背景设置为黑色
    //self.navigationController.navigationBar.barTintColor =bgBlue;//[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    // 透明度设置为0.3
    //self.navigationController.navigationBar.alpha = 0;
    // 设置为半透明
    //self.navigationController.navigationBar.translucent= YES;
    
    //[self.navigationController setNavigationBarHidden:YES];
    
}
-(void)setBarTitle:(NSString *)title leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor
{
  
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, statusBarHeight+4, 32, 32) imageName:leftImage title:@"" clickAction:leftAction];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-40, statusBarHeight+0, 32, 32) imageName:rightImage title:@"" clickAction:rightAction];
    
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake((SCREEN_WIDTH-80)/2, statusBarHeight+4,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationController.navigationBar.barTintColor =bgColor;
   
    if(self.navigationController.navigationBarHidden==YES)
    {  UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        titleView.backgroundColor=bgColor;
        [titleView addSubview:btnLeft];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
       
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
         self.navigationItem.titleView=titleLabel;
        
    }
    
}

-(void)setBarTitle:(NSString *)title  txtColor:(UIColor *)txtColor leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor
{
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    titleView.backgroundColor=bgColor;
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, statusBarHeight+4, 32, 32) imageName:leftImage title:@"" clickAction:leftAction];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-40, statusBarHeight+0, 32, 32) imageName:rightImage title:@"" clickAction:rightAction];
    
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake((SCREEN_WIDTH-80)/2, statusBarHeight+4,80, 32) text:title  BGColor:[UIColor clearColor] textColor:txtColor size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationController.navigationBar.barTintColor =bgColor;
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        titleView.backgroundColor=bgColor;
        [titleView addSubview:btnLeft];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}

-(void)setBarTitle:(NSString *)title
{
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    titleView.backgroundColor=ColorRGB(243, 243, 243);
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, 24, 32, 32) imageName:@"ic_back02" title:@"" clickAction:@selector(goBackAction)];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(40,24,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor blackColor] size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationController.navigationBar.barTintColor = ColorRGB(243, 243, 243);
    [titleView addSubview:btnLeft];

    [titleView addSubview:titleLabel];
    [self.view addSubview:titleView];
}
-(void)setBarTitle:(NSString *)title  leftImage:(NSString *)leftImage
{
    //修改by Star:CGRectMake(20, 20, 32, 32)
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(20, 27, 24, 24) imageName:leftImage  title:@"" clickAction:@selector(goBackAction)];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(SCREEN_WIDTH/2 - 40, 24,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.navigationController.navigationBar.barTintColor = ColorRGB(243, 243, 243);
    
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        titleView.backgroundColor=ColorRGB(6, 24, 44);
        [titleView addSubview:btnLeft];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }


}
-(void)setHomeBarTitle:(NSString *)title leftImage:(NSString *)leftImage leftAction:(SEL)leftAction  rightImage:(NSString *)rightImage  rightAction:(SEL)rightAction bgColor:(UIColor *)bgColor
{
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, 40)];
    titleView.backgroundColor=[UIColor clearColor];
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, 4, 32, 32) imageName:leftImage title:@"" clickAction:leftAction];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-40, 4, 32, 32) imageName:rightImage title:@"" clickAction:rightAction];
    
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(50, 4,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationController.navigationBar.barTintColor =bgColor;
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        titleView.backgroundColor=bgColor;
        [titleView addSubview:btnLeft];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}
//登录的导航
-(void)setbartitle:(NSString *)title rightTitle:(NSString *)rightStr withRightAction:(SEL)rightAction
{
    UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, statusBarHeight+40)];
    titleView.backgroundColor=ColorRGB(243, 243, 243);
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-60,statusBarHeight, 60, 32) imageName:nil title:rightStr clickAction:rightAction];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:18];
    [btnRight setTitleColor:ColorRGB(49, 125, 211) forState:normal];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(10, statusBarHeight,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor blackColor] size:18];
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
       
        self.navigationItem.titleView=titleLabel;
    }

}
//登录的导航
-(void)setbartitle:(NSString *)title leftImage:(NSString *)leftImage rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction
{
   
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0,statusBarHeight, 32, 32) imageName:leftImage title:nil clickAction:@selector(goBackAction)];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-60, statusBarHeight, 60, 32) imageName:nil title:rightTitle clickAction:rightAction];
    [btnRight setTitleColor:ColorRGB(49, 125, 211) forState:normal];
     btnRight.titleLabel.font = [UIFont systemFontOfSize:18];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(50, statusBarHeight,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor blackColor] size:18];
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
       
        [titleView addSubview:btnLeft];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}
//添加by Star
- (void)setBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightImage:(NSString *)rightImageName rightAction:(SEL)rightAction
{
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0,statusBarHeight, 32, 32) imageName:nil title:leftTitle clickAction:@selector(goBackAction)];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-60, statusBarHeight, 60, 32) imageName:rightImageName title:nil clickAction:rightAction];
    [btnRight setTitleColor:ColorRGB(49, 125, 211) forState:normal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:18];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(50, statusBarHeight,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:18];
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        if (leftTitle && leftTitle.length > 0) {
             [titleView addSubview:btnLeft];
        }
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        if (leftTitle && leftTitle.length > 0) {
                    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        }
       self.navigationItem.titleView=titleLabel;
    }
}

- (void)setBarTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle rightAction:(SEL)rightAction
{
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0,statusBarHeight, 60, 32) imageName:nil title:leftTitle clickAction:@selector(goBackAction)];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-60, statusBarHeight, 60, 32) imageName:nil title:rightTitle clickAction:rightAction];
    [btnRight setTitleColor:[UIColor whiteColor] forState:normal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:18];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(50, statusBarHeight,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:18];
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        
        [titleView addSubview:btnLeft];
        [titleView addSubview:btnRight];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}
-(void)setUserViewBarTitle:(NSString *)title
{
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, statusBarHeight, 32, 32) imageName:@"ic_back01" title:@"" clickAction:@selector(goBackAction)];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(40,statusBarHeight,80, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:16];
    
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, statusBarHeight+40)];
        titleView.backgroundColor=ColorRGB(56, 56, 56);
        [titleView addSubview:btnLeft];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}


-(void)setBarTitle:(NSString *)title leftAction:(SEL)leftAction
{
  
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, 24, 32, 32) imageName:@"ic_back02" title:@"" clickAction:leftAction];
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake(40,24,120, 32) text:title  BGColor:[UIColor clearColor] textColor:[UIColor blackColor] size:16];
    self.navigationController.navigationBar.barTintColor = ColorRGB(243, 243, 243);
    if(self.navigationController.navigationBarHidden==YES)
    {
        UIView *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, statusBarHeight+40)];
        titleView.backgroundColor=ColorRGB(243, 243, 243);
        [titleView addSubview:btnLeft];
        [titleView addSubview:titleLabel];
        [self.view addSubview:titleView];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        self.navigationItem.titleView=titleLabel;
    }
}



- (void)goBackAction
{
    NSLog(@"goBackAction");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
