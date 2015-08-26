//
//  CommonNavViewController.m
//  LenovoVB10
//
//  Created by fenda on 14/11/28.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "CommonNavViewController.h"
@interface CommonNavViewController ()

@end

@implementation CommonNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Contants setStatusBarType:UIStatusBarStyleDefault];
    
}
- (void)setNavWithTitle:(NSString *)title
         backButtonImage:(NSString *)backButtonImage
         backButtonTitle:(NSString *)backButtonTitle
         nextButtonImage:(NSString *)nextButtonImage
        withNextBtnFrame:(CGRect)frame
            nextSelector:(SEL)nextSelector
  backSelector:(SEL)backSelector
{
    
    [self setNavWithTitle:title backButtonImage:backButtonImage backButtonTitle:backButtonTitle nextButtonImage:nextButtonImage withNextBtnFrame:frame nextSelector:nextSelector];
    [_backButton addTarget:self action:backSelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavWithTitle:(NSString *)title
        backButtonImage:(NSString *)backButtonImage
        backButtonTitle:(NSString *)backButtonTitle
        nextButtonImage:(NSString *)nextButtonImage
       withNextBtnFrame:(CGRect)frame
           nextSelector:(SEL)nextSelector
{
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0f, SCREEN_WIDTH, 64.0)];
    [_titleView setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 10, SCREEN_WIDTH-90, 54.0)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = title;
    [_titleView addSubview:_titleLabel];
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundColor:[UIColor clearColor]];
    if (backButtonImage){
        [_backButton setImage:[UIImage imageNamed:backButtonImage] forState:UIControlStateNormal];
    }else{
//        [_backButton setImage:[UIImage imageNamed:@"back_btn01"] forState:UIControlStateNormal];
//        [_backButton setImage:[UIImage imageNamed:@"ic_back01"] forState:UIControlStateHighlighted];
    }
    _backButton.frame = CGRectMake(0.0f, 0.0, 64.0f, 64.0);
    //_backButton.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    if (backButtonTitle) {
        [_backButton setTitle:backButtonTitle forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    [_backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_backButton];
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = frame;
    [_nextButton setBackgroundColor:[UIColor clearColor]];
    if (nextButtonImage)
    {
        [_nextButton setImage:[UIImage imageNamed:nextButtonImage] forState:UIControlStateNormal];
    }
    [_nextButton addTarget:self action:nextSelector forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _nextButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_titleView addSubview:_nextButton];
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSLog(@"viewControllers .count=%lu",(unsigned long)viewControllers.count);
    long count=[[[[UIApplication sharedApplication] delegate] window] rootViewController].navigationController.viewControllers.count;
    NSLog(@"viewControllers .count2=%lu",(unsigned long)count);
}
#pragma mark Keyboard Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    //Code in view controller B
    [super viewDidAppear:animated];
    NSLog(@"isMovingToParentViewController: %d",self.isMovingToParentViewController);
     NSLog(@"self.isBeingPresented: %d",self.isBeingPresented);
    int num=self.isMovingToParentViewController;
    // this will log 1 if pushing from A but 0 if C is popped
    if (num==1) {
        NSLog(@"pushing");
    }
else if (num==0)
{
 NSLog(@" popped");
}
}
- (void)goBackAction
{
   NSLog(@"isMovingToParentViewController: %d",self.isMovingToParentViewController);
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    long count=[[[[UIApplication sharedApplication] delegate] window] rootViewController].navigationController.viewControllers.count;
    NSLog(@"viewControllers .count2=%lu",(unsigned long)count);
    if(count==1)
    {
        NSLog(@"View controller was rootview ");
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSLog(@"viewControllers .count=%lu",(unsigned long)viewControllers.count);
   
      if (viewControllers.count == 1)
      {
        //[[AppDelegate getAPPDelegate] setRootMainViewController:[LoginViewController new]];
          [[AppDelegate getAPPDelegate] pushHomeViewController];
      }
      else if (viewControllers.count > 1)
      {
          [self.navigationController popViewControllerAnimated:YES];
      }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
