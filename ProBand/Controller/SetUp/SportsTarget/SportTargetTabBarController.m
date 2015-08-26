//
//  SportTargetTabBarController.m
//  ProBand
//
//  Created by Echo on 15/6/25.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SportTargetTabBarController.h"

#import "UserSportTargetController.h"
#import "UserSleepTargetController.h"
#import "UserTrainTargetController.h"
#define bottomViewColor [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0]
@interface SportTargetTabBarController ()
{
    UIImageView *picView;
    UIView *contentView;
    UIButton *fristButton;
    UIButton *secondButton;
    UIButton *thirdButton;
    UIViewController *currentViewController;
    UserSportTargetController *sportPage;
    UserSleepTargetController *sleepPage;
    UserTrainTargetController *trainPage;
    UILabel *titlelabel;
}
@end

@implementation SportTargetTabBarController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"sport_target", nil);
//    titlelabel.textColor = [UIColor whiteColor];
//    titlelabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = titlelabel;
    
    int systemVersion = [[[UIDevice currentDevice]systemVersion]intValue];
    if (systemVersion>=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    sportPage = [[UserSportTargetController alloc] init];
    sportPage.showSegment = YES;
    [self addChildViewController:sportPage];
    
    sleepPage = [[UserSleepTargetController alloc] init];
    sleepPage.showSegment = YES;
    [self addChildViewController:sleepPage];
    
    trainPage = [[UserTrainTargetController alloc] init];
    trainPage.showSeg = YES;
    [self addChildViewController:trainPage];
    
    [self creatView];
    [contentView addSubview:sportPage.view];
    currentViewController = sportPage;
}

- (void)creatView
{
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-1)];
    [self.view addSubview:contentView];
    
    CGFloat buttonW = SCREEN_WIDTH/3;
    CGFloat buttonH = 49;
    
    fristButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fristButton.frame = CGRectMake(0, SCREEN_HEIGHT- buttonH-60, buttonW, buttonH);
    fristButton.backgroundColor = bottomViewColor;
    fristButton.tag = 1;
    [fristButton setTitle:NSLocalizedString(@"sport", nil) forState:UIControlStateNormal];
    [fristButton setTitleColor:COLOR(90, 90, 90) forState:UIControlStateNormal];
    [fristButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fristButton];
    
    secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(buttonW, SCREEN_HEIGHT- buttonH-60, buttonW, buttonH);
    secondButton.backgroundColor = bottomViewColor;
    secondButton.tag = 2;
    [secondButton setTitle:NSLocalizedString(@"sleep", nil) forState:UIControlStateNormal];
    [secondButton setTitleColor:COLOR(90, 90, 90) forState:UIControlStateNormal];
    [secondButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondButton];
    
    thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.backgroundColor = bottomViewColor;
    thirdButton.tag = 3;
    thirdButton.frame = CGRectMake(buttonW*2, SCREEN_HEIGHT- buttonH-60, buttonW, buttonH);
    [thirdButton setTitle:NSLocalizedString(@"exercise", nil) forState:UIControlStateNormal];
    [thirdButton setTitleColor:COLOR(90, 90, 90) forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdButton];
    
    picView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volume_instructions"]];
    picView.frame = CGRectMake(((SCREEN_WIDTH/3)-42)/2, SCREEN_HEIGHT- buttonH-60-20, 42, 21);
    
    [self.view addSubview:picView];
}

- (void)btnClick:(UIButton *)btn
{
    NSLog(@"btn.tag = %ld", (long)btn.tag);
    CGFloat spaceBetween = SCREEN_WIDTH/6-21;
    CGFloat picY = SCREEN_HEIGHT- 49-60-20;
    if ((currentViewController == sportPage&&[btn tag]==1)||
        (currentViewController == sleepPage&&[btn tag]==2) ||
        (currentViewController == trainPage&&[btn tag]==3) ) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    switch ([btn tag]) {
        case 1:
        {
            self.titleLabel.text = NSLocalizedString(@"sport_target", nil);
            
            picView.frame = CGRectMake(spaceBetween, picY, 42, 21);
            [self transitionFromViewController:currentViewController toViewController:sportPage duration:1 options:UIViewAnimationOptionTransitionNone  animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=sportPage;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 2:
        {
            self.titleLabel.text = NSLocalizedString(@"sleep_target", nil);

            picView.frame = CGRectMake((SCREEN_WIDTH/3)+spaceBetween, picY, 42, 21);
            [self transitionFromViewController:currentViewController toViewController:sleepPage duration:1 options:UIViewAnimationOptionTransitionNone  animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=sleepPage;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 3:
        {
            self.titleLabel.text = NSLocalizedString(@"exercise_target", nil);

            picView.frame = CGRectMake(((SCREEN_WIDTH/3)*2)+spaceBetween, picY, 42, 21);
            [self transitionFromViewController:currentViewController toViewController:trainPage duration:1 options:UIViewAnimationOptionTransitionNone  animations:^{
                
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=trainPage;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        default:
            break;
    }
    
}


@end
