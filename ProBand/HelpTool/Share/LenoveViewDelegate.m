//
//  LenoveViewDelegate.m
//  ShareSDKTest
//
//  Created by yumiao on 14/12/2.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "LenoveViewDelegate.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
#import <ShareSDK/ISSShareViewDelegate.h>

@interface LenoveViewDelegate()<ISSShareViewDelegate>
@end
@implementation LenoveViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
        
    }
    
    if ([UIDevice currentDevice].isPad)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:22];
        viewController.navigationItem.titleView = label;
        label.text = viewController.title;
        [label sizeToFit];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
    
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    if ([UIDevice currentDevice].isPad)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}
@end
