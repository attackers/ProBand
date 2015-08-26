//
//  TriangleView.m
//  UITest
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, width/2, 0);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, width/2, 0);
    CGContextClosePath(context);
    [[UIColor clearColor]setStroke];
    [COLOR(7, 26, 48) setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
