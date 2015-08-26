//
//  Loading.h
//  LenovoVB10
//
//  Created by jacy on 14/12/6.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;
@interface Loading : NSObject
{
    MBProgressHUD *_loadingView;
    NSUInteger _loadingCount;
}

+ (instancetype)shareInstance;
/**
 *  lodingView
 *
 *  @param view UIView *loadingView = ((AppDelegate *)[UIApplication getAPPDelegate].delegate).window;
 */
- (void)startLoadingInView:(UIView *)view;
- (void)startLoadingInView:(UIView *)view withmessage:(NSString *)message;
- (void)stopLoading;
@end
