//
//  CAShawRoundView.m
//  da
//
//  Created by attack on 15/8/17.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "CAShawRoundView.h"


@implementation CAShawRoundView
{
    CAShapeLayer *progressLayer;
    UIImageView *circleView ;
    UILabel *label;
    UILabel *label2;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.value = 0.001;
        UIImageView *backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 266, 241)];
        backGroundImage.backgroundColor = [UIColor clearColor];
        backGroundImage.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 10);
        backGroundImage.image  = [UIImage imageNamed:@"daily_dashboard"];
        [self addSubview:backGroundImage];
        self.backgroundColor = [UIColor clearColor];
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/2-20 , CGRectGetWidth(self.frame), 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = label.frame;
        gradientLayer.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor,(id)[UIColor blackColor].CGColor];
        [self.layer addSublayer:gradientLayer];
        gradientLayer.locations = @[@0.5,@0.9,@1];
        gradientLayer.startPoint = CGPointMake(0.5, 1);
        gradientLayer.endPoint = CGPointMake(0.5, 0);
        gradientLayer.mask = label.layer;
        label.frame = gradientLayer.bounds;
        
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.center.y - 20, CGRectGetWidth(self.frame), 60)];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label2];
 
    }
    return self;
}

 - (void)setValue:(CGFloat)value
{

    _value = value==0?0.001:value;
    CGFloat rValue = ((self.value*360)*(M_PI*2))/360;
    NSLog(@"%f",rValue);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 3) radius:80 startAngle:M_PI_2*3 endAngle:M_PI_2*3+rValue clockwise:YES];
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame =self.bounds;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = [UIColor clearColor].CGColor;
    trackLayer.opacity = 0.25;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 1.f;
    trackLayer.path = path.CGPath;
//    if (progressLayer) {
//        [progressLayer removeFromSuperlayer];
//    }
    progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bounds;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor yellowColor].CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = 2.0f;
    progressLayer.path = path.CGPath;
    progressLayer.strokeEnd = 0.0;

    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame));
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:53/255.0f green:81/255.0f blue:210/255.0f alpha:1].CGColor,(id)[UIColor colorWithRed:89/255.0f green:130/255.0f blue:197/255.0f alpha:1].CGColor, nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.8,@1]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5,1)];
    [gradientLayer addSublayer:gradientLayer1];
    
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(CGRectGetWidth(self.frame)/2, 0, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame));
    [gradientLayer2 setLocations:@[@0.5,@0.8,@1]];
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:49/255.0f green:177/255.0f blue:240/255.0f alpha:1].CGColor,(id)[UIColor colorWithRed:89/255.0f green:130/255.0f blue:197/255.0f alpha:1].CGColor, nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    [gradientLayer setMask:progressLayer];
    [self.layer addSublayer:gradientLayer];
    
    if (circleView) {
        [circleView removeFromSuperview];
    }
    UIImage *image = [UIImage imageNamed:@"daily_dashboard_04"];
    circleView = [[UIImageView alloc] initWithImage:image];
    circleView.contentMode = UIViewContentModeScaleAspectFill;
    circleView.frame = CGRectMake(1, 1, 7, 7);
    circleView.center = CGPointMake(0, 0);
    [self addSubview:circleView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.calculationMode = kCAAnimationCubicPaced;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.0;
    pathAnimation.path = path.CGPath;
    [circleView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    [self addStringLay];
    [self addStringLay1];
    [self setpercent:_value*10 animated:YES];

}
// Only override drawRect: if you perform custom drawing.

- (void)setpercent:(CGFloat)percent animated:(BOOL)animated
{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];
    progressLayer.strokeEnd = percent*10;
    [CATransaction commit];

}

- (void)addStringLay
{
    NSString *string2 = @"目标完成度";
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:string2];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    shadow.shadowOffset = CGSizeMake(2, 1);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Roboto-Regular" size:15],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,shadow,NSShadowAttributeName, nil];
    [mString setAttributes:dic range:NSMakeRange(0, string2.length)];
    label.attributedText = mString;
    
}
- (void)addStringLay1
{
    CGFloat fValue = self.value*100;
    fValue = fValue>100?100:fValue;
    NSString *string = [NSString stringWithFormat:@"%.0f%%",fValue];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:string];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    shadow.shadowOffset = CGSizeMake(2, 1);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:HelveticaNeueLTPro_Th_C size:70],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,shadow,NSShadowAttributeName, nil];
    [mString setAttributes:dic range:NSMakeRange(0, string.length - 1)];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:HelveticaNeueLTPro_Lt_3 size:16],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,shadow,NSShadowAttributeName, nil];
    [mString setAttributes:dic2 range:NSMakeRange(string.length - 1, 1)];
    label2.attributedText = mString;
}
@end
