//
//  RechargeView.m
//  ProBand
//
//  Created by star.zxc on 15/7/8.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "RechargeView.h"
#import "EShadeCircleView.h"
@implementation RechargeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //外围绘制一圈线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2-1, 0, 2*M_PI, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (EShadeChartDataModel *)testModel
{
    EShadeChartDataModel *data = [EShadeChartDataModel new];
    data.backGroundImage = [UIImage imageNamed:@"pay_top_up_dashboard_01"];
    data.showImage = [UIImage imageNamed:@"pay_top_up_dashboard_02"];
    data.currentValue = self.currentScale;
    data.targetValue = 100;
    return data;
}

- (void)drawShadeChartViewWithScale:(NSInteger)scale
{
    self.currentScale = scale;
    EShadeCircleView *circleView = [[EShadeCircleView alloc]initWithFrame:CGRectMake(10, 10, 100, 100) andDataModel:[self testModel] withLineWid:50];
    [self addSubview:circleView];
    
    //添加两个ImageView
    UIImageView *fixedImage = [[UIImageView alloc]initWithFrame:circleView.frame];
    fixedImage.image = [UIImage imageNamed:@"pay_top_up_dashboard_03"];
    [self addSubview:fixedImage];
    
    UIImageView *movedImage = [[UIImageView alloc]initWithFrame:circleView.frame];
    movedImage.image = [UIImage imageNamed:@"pay_top_up_dashboard_04"];
    movedImage.transform = CGAffineTransformMakeRotation(2*M_PI*scale/100);
    [self addSubview:movedImage];
}

@end
