//
//  AppDelegate.h
//  ProBand
//
//  Created by zhuzhuxian on 15/5/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property   (nonatomic,strong) UINavigationController *navi;
@property   (nonatomic,assign) BOOL isReachable;
+ (AppDelegate *)getAPPDelegate;
-(void)pushHomeViewController;
@end

