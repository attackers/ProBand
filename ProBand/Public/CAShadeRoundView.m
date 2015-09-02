//
//  CAShadeRoundView.m
//  ProBand
//
//  Created by star.zxc on 15/8/31.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "CAShadeRoundView.h"

@implementation CAShadeRoundView
{
    CAShapeLayer *progressLayer;
    UIImageView *circleView ;
    UILabel *label;
}
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
        
        _value = 0.0;
    }
    return self;
}
//绘图
- (void)setValue:(CGFloat)value
{
    _value = value==0?0.001:value;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 3) radius:80 startAngle:1.5*M_PI endAngle:1.5*M_PI+_value*2*M_PI clockwise:YES];
    CAShapeLayer *trackLayer2 = [CAShapeLayer layer];
    trackLayer2.frame =self.bounds;
    trackLayer2.fillColor = [UIColor clearColor].CGColor;
    trackLayer2.strokeColor = [UIColor blueColor].CGColor;
    trackLayer2.opacity = 1;
    trackLayer2.lineCap = kCALineCapRound;
    trackLayer2.lineWidth = 5.f;
    trackLayer2.path = path2.CGPath;
    [self.layer addSublayer:trackLayer2];
    //CALayer *gradientLayer10 = [CALayer layer];
    CAGradientLayer *gradientLayer11 = [CAGradientLayer layer];
    gradientLayer11.type = kCAGradientLayerAxial;
    gradientLayer11.frame = CGRectMake(0, 0, 300, 300);
    [gradientLayer11 setColors:[NSArray arrayWithObjects:(id)self.startColor.CGColor,(id)self.endColor.CGColor, nil]];
    [gradientLayer11 setLocations:@[@0.3,@0.6,@1]];
    [gradientLayer11 setStartPoint:CGPointMake(0.3, 0)];
    [gradientLayer11 setEndPoint:CGPointMake(0.3,0.6)];
    [gradientLayer11 setMask:trackLayer2];
    [self.layer addSublayer:gradientLayer11];
}
- (void)setDescribe:(NSString *)describe
{
    label.text = describe;
    _describe = describe;
}
- (void)setEndImageName:(NSString *)endImageName
{
    //添加结束的图片名:待完成
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.center = self.center;
    imageView.bounds = CGRectMake(0, 0, 180, 180);
    imageView.image = [UIImage imageNamed:endImageName];
    imageView.layer.transform = CATransform3DMakeRotation(_value*2*M_PI, 0, 0, 1);
    [self addSubview:imageView];
}
- (void)setType:(int)type
{
    CGPoint center = self.center;
    switch (type) {
        case 1:
            break;
        case 3://锻炼
        {
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(center.x-60, center.y-40, 120, 100)];
            NSString *exerciseStr = [NSString stringWithFormat:@"%d%%",(int)self.value*100];
            label2.attributedText = [self attributedStr:exerciseStr];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [UIColor whiteColor];
            [self addSubview:label2];
        }
            break;
        case 2://睡眠
        {
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(center.x-60, center.y-45, 120, 100)];
            int intvalue = (int)(self.value*1440);
            NSString *sleepStr = [NSString stringWithFormat:@"%.2d:%.2d分钟",intvalue/60,intvalue%60];
            label3.attributedText = [self attributedStr:sleepStr];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.textColor = [UIColor whiteColor];
            [self addSubview:label3];
        }
            break;
        default:
            break;
    }
}
//设定特定字符串的大小
- (NSMutableAttributedString *)attributedStr:(NSString *)str
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:str];
    if ([str rangeOfString:@":"].location != NSNotFound)
    {
        //如果包含：表示为睡眠页面
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:MicrosoftYaHe size:35],NSFontAttributeName,nil];
        [attribute addAttributes:dic range:NSMakeRange(0, 5)];
        [attribute addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:NSMakeRange(5, 2)];
    }
    else if ([str rangeOfString:@"%"].location != NSNotFound)
    {
        //包含％表示为锻炼页面
        [attribute addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:60]} range:NSMakeRange(0, str.length-1)];
        [attribute addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} range:NSMakeRange(str.length-1, 1)];
    }
    return attribute;
}
@end
