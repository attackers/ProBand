//
//  SyncAlertView.m
//  ProBand
//
//  Created by attack on 15/7/14.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SyncAlertView.h"

@implementation SyncAlertView
{
    UILabel *alertTitleLabel;
}
+(SyncAlertView*)shareSyncAlerview:(BOOL)SyncOk
{
    SyncAlertView *sy = [[SyncAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    sy.isok = SyncOk;
    [[UIApplication sharedApplication].keyWindow addSubview:sy];
    return sy;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 190, CGRectGetWidth([UIScreen mainScreen].bounds) - 190)];
        imageview.backgroundColor = [UIColor clearColor];
        imageview.center = CGPointMake(self.center.x, self.center.y - 60);
        imageview.layer.borderColor = [ColorRGB(16, 120, 127) CGColor];
        imageview.layer.borderWidth = 2;
        [imageview.layer setCornerRadius:CGRectGetHeight(imageview.frame)/2];
        imageview.clipsToBounds = YES;
        
        alertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), 24)];
        alertTitleLabel.backgroundColor = [UIColor clearColor];
        alertTitleLabel.center = imageview.center;
        alertTitleLabel.textColor = [UIColor whiteColor];
        alertTitleLabel.font = [UIFont boldSystemFontOfSize:19];
        alertTitleLabel.textAlignment  = NSTextAlignmentCenter;
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self addSubview:imageview];
        [self addSubview:alertTitleLabel];
        [self performSelector:@selector(removeSelf) withObject:self afterDelay:2.0f];
    }
    return self;
}
- (void)setIsok:(BOOL)isok
{
    if (isok) {
        alertTitleLabel.text = @"同步成功!";
    }else{
        alertTitleLabel.text = @"同步失败!";
    }

}
- (void)removeSelf
{
    [self removeFromSuperview];

}

@end
