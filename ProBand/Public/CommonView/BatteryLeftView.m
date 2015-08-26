//
//  BatteryLeftView.m
//  ProBand
//
//  Created by Echo on 15/6/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BatteryLeftView.h"
@interface BatteryLeftView()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *batteryPercentLabel;
@property (nonatomic, weak) UILabel *dayLabel;

@end

@implementation BatteryLeftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        [self bgView];
        [self batteryPercentLabel];
        [self dayLabel];
    }
    return self;
}

- (UIView *)bgView
{
    if (_bgView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:view];
        _bgView = view;
    }
    return _bgView;
}

- (UILabel *)batteryPercentLabel
{
    if (_batteryPercentLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame)*0.8)];
        label.font = [UIFont fontWithName:@"Arial" size:35];
        label.textColor = [UIColor colorWithRed:24.0/255 green:182.0/255 blue:181.0/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _batteryPercentLabel = label;
    }
    return _batteryPercentLabel;
}

- (UILabel *)dayLabel
{
    if (_dayLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_bgView.frame)/2+25, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame)*0.5)];
        label.font = [UIFont fontWithName:@"Arial" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _dayLabel = label;
    }
    return _dayLabel;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.batteryPercentLabel.text = [NSString stringWithFormat:@"%.0f",progress * 100];
    
    //    [self drawRect:self.bounds];
    // 重新绘制
    // 在view上做一个重绘的标记，当下次屏幕刷新的时候，就会调用drawRect.
    //    [self setNeedsDisplay];
}

- (void)setUsedDays:(NSString *)usedDays
{
    _usedDays = usedDays;
    self.dayLabel.text = [NSString stringWithFormat:@"已使用%@天",usedDays];
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.bounds.size.width/2 - 3;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.5);
    
    UIColor *color = [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1];
    [color set];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:M_PI * 2 clockwise:YES];
    
    CGContextAddPath(ctx, bgPath.CGPath);
    CGContextStrokePath(ctx);
    
    
    UIColor *bluecolor = [UIColor colorWithRed:24.0/255 green:182.0/255 blue:181.0/255 alpha:1];
    [bluecolor set];
    
    CGFloat startP = -M_PI_2;
    CGFloat endP = -M_PI_2 + _progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startP endAngle:endP clockwise:YES];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
    
}

@end
