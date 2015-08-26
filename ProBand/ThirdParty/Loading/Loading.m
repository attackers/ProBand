//
//  Loading.m
//  LenovoVB10
//
//  Created by jacy on 14/12/6.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "Loading.h"
#import "MBProgressHUD.h"
@implementation Loading

+ (instancetype)shareInstance{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark Loading
// webservice开始
- (void)startLoadingInView:(UIView *)view
{
    
    _loadingCount = 1;
    if (_loadingCount == 1) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
        }
        _loadingView = [[MBProgressHUD alloc] initWithView:view];
        _loadingView.labelText = @"正在加载数据，请稍后...";
        [_loadingView show:YES];
    }
    [view addSubview:_loadingView];
}
- (void)startLoadingInView:(UIView *)view withmessage:(NSString *)message
{
    _loadingCount = 1;
    
    if (_loadingCount == 1) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
        }
        _loadingView = [[MBProgressHUD alloc] initWithView:view];
        _loadingView.labelText = message;
        [_loadingView show:YES];
    }
    [view addSubview:_loadingView];
}
- (void)stopLoading
{
    _loadingCount--;
    
    // 当没有请求web的时候才移除loading
    if (_loadingCount == 0) {
        if (_loadingView) {
            [_loadingView hide:YES];
            [_loadingView removeFromSuperview];
            _loadingView = nil;
            
            // 网络加载标志停止转动
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
    }
}




@end
