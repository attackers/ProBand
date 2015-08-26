//
//  GuidePageViewController.m
//  GuidePageView
//
//  Created by attack on 15/7/2.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "GuidePageViewController.h"
#import "BlueToothTestViewController.h"
#import "LoginNewController.h"
@interface GuidePageViewController ()<UIScrollViewDelegate>
{
    UIScrollView *backgrounpScrollView;
    UIPageControl *pageC;
    int currentPage;
    CGFloat x;
    NSArray *pointImage;
    UIImageView *imagePointView;
}
@end
@implementation GuidePageViewController

+ (instancetype)shareGuidePageViewController:(NSArray*)ImageArray
{
    GuidePageViewController *vc = [[GuidePageViewController alloc]init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    vc.imageArray = [NSArray arrayWithArray:ImageArray];
    return vc;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)setImageArray:(NSArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = imageArray;
    }
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        imageView.image = [UIImage imageNamed:_imageArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgrounpScrollView addSubview:imageView];
    }
    backgrounpScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)*_imageArray.count, CGRectGetHeight([UIScreen mainScreen].bounds));
    
    pageC.numberOfPages = _imageArray.count;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isKindOfClass:[UINavigationController class]]) {
        self.navigationController.navigationBarHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    self.view.backgroundColor = [UIColor redColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    int ver = [[[UIDevice currentDevice]systemVersion]intValue];
    if (ver >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    backgrounpScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    backgrounpScrollView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    backgrounpScrollView.pagingEnabled = YES;
    backgrounpScrollView.scrollEnabled = YES;
    backgrounpScrollView.delaysContentTouches = NO;
    backgrounpScrollView.canCancelContentTouches  = NO;
    backgrounpScrollView.bounces = NO;
    backgrounpScrollView.delegate = self;
    backgrounpScrollView.showsHorizontalScrollIndicator = NO;
    backgrounpScrollView.showsVerticalScrollIndicator = NO;
    backgrounpScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backgrounpScrollView];
    
    imagePointView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-93)/2, SCREEN_HEIGHT-30, 93, 10)];
    imagePointView.contentMode = UIViewContentModeScaleAspectFill;
    pointImage = [NSArray arrayWithObjects:@"welcome_page_point_01",@"welcome_page_point_02",@"welcome_page_point_03", nil];
    [self.view addSubview:imagePointView];
    imagePointView.image = [UIImage imageNamed:pointImage[0]];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentPage = scrollView.contentOffset.x/320;
    if (x == 320*currentPage&&currentPage!=0) {
        
        
        NSLog(@"添加测试数据:时间过久");
        //[[FMDBTool sharedInstance]addTestData];
        [self.navigationController pushViewController:[LoginNewController new] animated:YES];
        
    }else{
        x = 320*currentPage;
    }
    
    imagePointView.image = [UIImage imageNamed:pointImage[currentPage]];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
