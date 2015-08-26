//
//  AppDelegate.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LenovoShareSdk.h"
#import "BlueToothTestViewController.h"
#import "HTTPManage.h"
#import "GuidePageViewController.h"
#import "GetWeather.h"
#import "BLEManage.h"
#import "GetDataForPeriphera.h"
#import "Reachability.h"

#import "BandRemindManager.h"
#import "TargetInfoManager.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    Reachability *hostReach;
}
@end

@implementation AppDelegate

+ (AppDelegate *)getAPPDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self reachabilityNotification];
    [[LenovoShareSdk sharedInstance] initData];
    /********** 蓝牙相关初始 ***************/
    [self getLocation];
    [BLEManage shareCentralManager];
    [GetDataForPeriphera shareDataForPeriphera];
    /*************************************/
    [DBOPERATOR checkUserDatabase];
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpen"]) 
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpen"]) {
        NSLog(@"--------->>>%@",NSHomeDirectory());
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"defaultBand"]) {
            
            BlueToothTestViewController *b = [[BlueToothTestViewController alloc]init];
            _navi = [[UINavigationController alloc]initWithRootViewController:b];
            [_navi setNavigationBarHidden:YES];
            [self.window setRootViewController:_navi];
            [self.window makeKeyAndVisible];
            
        }else{
            [self pushHomeViewController];
        }
        //    [[FMDBTool sharedInstance]createDefaultTable];
        //    if ([AssisitTool isFirstEnterApp]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //[[FMDBTool sharedInstance]addTestData];
        });
        
        //    NSString *isStarted=[DefaultValueManage getValueForKey:@"isStarted"];
        
    }else{
        
        GuidePageViewController *g = [GuidePageViewController shareGuidePageViewController:[NSArray arrayWithObjects:@"welcome_page_2",@"welcome_page_3",@"welcome_page_1",nil]];
        _navi = [[UINavigationController alloc]initWithRootViewController:g];
        [_navi setNavigationBarHidden:YES];
        [self.window setRootViewController:_navi];
        [self.window makeKeyAndVisible];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstOpen"];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        _navi.navigationBar.barTintColor = navigationColor;
    }
    else
    {
        _navi.navigationBar.tintColor= navigationColor;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];    
    
    //3s后插入默认数据:或许应该在绑定的时候插入
    [self performSelector:@selector(insertDefaultInfo) withObject:nil afterDelay:3.0];
    
    // Override point for customization after application launch.
    return YES;
}
- (void)insertDefaultInfo
{
    [[BandRemindManager sharedInstance]insertDefaultSwitch];
    [[TargetInfoManager sharedInstance]insertDefaultTarget];
}
-(void)pushHomeViewController
{
    _navi = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
    [self.window setRootViewController:_navi];
    [self.window makeKeyAndVisible];    
}

- (void)getLocation
{
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    // fix ios8 location issue
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
#ifdef __IPHONE_8_0
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
        }
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }
#endif
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied :
        {
            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请在设置-隐私-定位服务中开启定位功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [tempA show];
        }
            break;
        case kCLAuthorizationStatusNotDetermined :
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestAlwaysAuthorization];
                [manager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
            }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            // 提示用户出错原因，可按住Option键点击 kCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                           message:@"定位服务无法使用！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [tempA show];
        }
            break;
            
        default:
            [locationManager startUpdatingLocation];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currLocation = [locations lastObject];
    [[GetWeather shareGetWeather]getweather:currLocation];
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.latitude]);
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.longitude]);
}

//分享的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

#pragma mark *********************** 网络监控 *******************
- (void)reachabilityNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
}
- (void)reachabilityChanged:(NSNotification*)sender
{
    Reachability *currReach = [sender object];
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    self.isReachable = YES;
    if (status == NotReachable) {
        NSLog(@"网络连接异常");
        self.isReachable = NO;
    }
    
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        NSLog(@"网络连接正常")
        self.isReachable = YES;
    }
    

}
@end
