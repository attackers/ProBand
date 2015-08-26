//
//  LenovoShareSdk.h
//  ShareSDKTest
//
//  Created by yumiao on 14/12/2.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <SinaWeiboConnection/ISSSinaWeiboApp.h>
#import <FacebookConnection/FacebookConnection.h>
#import "LenoveViewDelegate.h"
@interface LenovoShareSdk : NSObject<WXApiDelegate>{
    
    SSInterfaceOrientationMask _interfaceOrientationMask;
}
@property (nonatomic,readonly,copy) LenoveViewDelegate *viewDelegate;

+ (id)sharedInstance;
/**
 *  初始化各种要分享的平台的信息
 */
- (void)initData;
/**
 *  点击按钮时所触发的分享方法
 *
 *  @param sender 按钮对象
 */
- (void)popShareView:(id)sender;
@end
