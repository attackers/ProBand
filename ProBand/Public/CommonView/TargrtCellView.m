//
//  TargrtCellView.m
//  ProBand
//
//  Created by star.zxc on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TargrtCellView.h"

@implementation TargrtCellView
{
    UIImageView *bdgImageView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _valueText = [NSString string];
        bdgImageView = [PublicFunction getImageView:CGRectMake(0, 0, frame.size.width, frame.size.height) imageName:@"Moving_target_round.png"];
        [self addSubview:bdgImageView];
    }
    return self;
}
/**
 *  本类为运动目标页面的元素
 *
 *  @param describtion 圆框内的内容
 *  @param value       圆框下面的内容
 *  @param radius      圆框半径
 */
- (void)setDescribtion:(NSString *)describtion value:(NSString *)value rotationAngle:(CGFloat)angleValue radius:(CGFloat)radius
{
    //首先移除之前VIew上所有控件
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UIImageView class]]) {
             [view removeFromSuperview];
        }
    }
//    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*radius, 2*radius)];
//    circleView.backgroundColor = [UIColor lightGrayColor];
//    circleView.layer.masksToBounds = YES;
//    circleView.layer.cornerRadius = radius;
//    [self addSubview:circleView];
    [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGFloat currentValue = angleValue;
    //顺时针旋转90
    bdgImageView.transform = CGAffineTransformMakeRotation(2*M_PI*currentValue/20000.0);
    [UIView commitAnimations];
    
    UILabel *valueLabel = [PublicFunction getlabel:CGRectMake(20, 30, self.frame.size.width-40, 25) text:value textSize:18 textColor:COLOR(37, 201, 200) textBgColor:nil textAlign:@"center"];
    //valueLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:valueLabel];
    
    UILabel *describeLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(valueLabel.frame), 2*radius,20) text:describtion textSize:14 textColor:COLOR(37, 201, 200) textBgColor:nil textAlign:@"center"];
    //describeLabel.center = self.center;
    [self addSubview:describeLabel];
    
    _valueText = value;
}
@end
