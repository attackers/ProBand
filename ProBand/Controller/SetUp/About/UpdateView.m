//
//  UpdateView.m
//  ProBand
//
//  Created by star.zxc on 15/5/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UpdateView.h"
#define distanceRadius 30
@implementation UpdateView
{
    NSTimer *updateTimer;
    CGFloat updateSchedule;//更新进度，从0到100.

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //首先添加一幅背景图片
        UIImageView *imageView1 = [[UIImageView alloc]init];
        imageView1.frame = CGRectMake(0, 0, 208, 208);
        //imageView1.center = self.center;
        [imageView1 setImage:[UIImage imageNamed:@"exercise_dashboard_bg"]];
        [self addSubview:imageView1];
        //添加一个label
        UILabel *updateLabel = [PublicFunction getlabel:CGRectMake(40, 92, 134, 30) text:@"正在更新中..." fontSize:14 color:[UIColor blackColor] align:@"center"];
        [self addSubview:updateLabel];
        
        updateSchedule = 0.0;
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = width/2;
    float angle = -M_PI/2+updateSchedule/100*2*M_PI;
    CGPoint center = CGPointMake(width/2, height/2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, width/2, 0);
    CGContextAddLineToPoint(context, width/2, distanceRadius);
    //CGContextAddArc(context, center.x, center.y, width/2-distanceRadius, 0, updateSchedule/100*2*M_PI, 1);
    //计算需要连接的外圆上的点
    CGPoint point1 = CGPointMake(center.x+radius*cosf(angle), center.y+radius*sinf(angle));
    //计算需要连接的内圆上的点
    CGPoint point0 = CGPointMake(center.x+(radius-distanceRadius)*cosf(angle), center.y+(radius-distanceRadius)*sinf(angle));
    CGContextAddArc(context, center.x, center.y, radius-distanceRadius, -M_PI/2, angle, 0);
    CGContextAddLineToPoint(context, point1.x, point1.y);
    CGContextAddArc(context, center.x, center.y, radius, angle, -M_PI/2,1);
    CGContextSetRGBFillColor(context, 219/255.0, 75/255.0, 0, 1);
    //初始时填充整个外围
    CGContextFillPath(context);
    //CGContextRelease(context);
}
- (void)updateView
{
    updateSchedule+=0.2;
    if (updateSchedule<50) {
          [self setNeedsDisplay];
    }
    else if (updateSchedule >= 50)
    {
        [updateTimer invalidate];
        updateTimer = nil;
        updateSchedule = 0.0;
        if (self.updateFailed) {
            self.updateFailed();
        }
    }
    else
    {
        [updateTimer invalidate];
        updateTimer = nil;
        updateSchedule = 0.0;
        if (self.updateFinished) {
            self.updateFinished();
        }
    }
    NSLog(@"当前进度为:%f",updateSchedule);
}
@end
