//
//  EColumn.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumn.h"
#import "EColor.h"
#import <QuartzCore/QuartzCore.h>
@implementation EColumn
{
    int _animation;
}
@synthesize barColor = _barColor;
@synthesize eColumnDataModel = _eColumnDataModel;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;//kCALineCapButt
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
		[self.layer addSublayer:_chartLine]; 
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGesture];
        _isColorFul = NO;
        _animation = 0;
    }
    return self;
}



-(void)setGrade:(float)grade
{
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
//	if (_barColor) {
//		_chartLine.strokeColor = [_barColor CGColor];
//	}else{
//		_chartLine.strokeColor = [EGreen CGColor];
//	}
#warning -mark:修改by Star
    if (_barColor) {
        _chartLine.strokeColor = [_barColor CGColor];
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = _chartLine.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[_barColor CGColor],(id)[UIColor clearColor].CGColor, nil];
//        gradient.locations = @[[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.8]];
//        [_chartLine insertSublayer:gradient atIndex:0];
    }else{
        _chartLine.strokeColor = [EGreen CGColor];
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.delegate = self;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
}

- (void)setBarColor:(UIColor *)barColor
{
    _chartLine.strokeColor = [barColor CGColor];
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:_chartLine.strokeColor];
}

-(void)rollBack{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
    
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
	//Draw BG
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextAddRect(context, CGRectMake(0, 30, self.frame.size.width/2, 100));
//	CGContextFillRect(context, rect);
    
}
//两个数组必须包含3个元素
- (void)setPillarColor:(NSArray *)colorArray colorValue:(NSArray *)colorValues
{
    _isColorFul = YES;
    //最高为grade所对应的高度
    if (_chartLine) {
        [_chartLine removeFromSuperlayer];
    }
    _colorArray = [NSArray arrayWithArray:colorArray];
    _colorValues = [NSArray arrayWithArray:colorValues];
    
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    UIColor *firstColor = colorArray[0];
//    UIColor *secondColor = colorArray[1];
//    UIColor *thirdColor = colorArray[2];
//    NSNumber *firstNumber = colorValues[0];
//    NSNumber *secondNumber = colorValues[1];
//    NSNumber *thirdNumber = colorValues[2];
//    float first = [firstNumber floatValue];
//    float second = [secondNumber floatValue];
//    float third = [thirdNumber floatValue];
//    float sum = first + second + third;

}

//当一个动画停止时继续下一个动画:View不在了但是动画仍然存在
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _animation++;
    if (!_isColorFul)
    {
        return;
    }
    if (_animation > 3) {
        return;
    }
    UIColor *firstColor = _colorArray[0];
    UIColor *secondColor = _colorArray[1];
    UIColor *thirdColor = _colorArray[2];
    NSNumber *firstNumber = _colorValues[0];
    NSNumber *secondNumber = _colorValues[1];
    NSNumber *thirdNumber = _colorValues[2];
    float first = [firstNumber floatValue];
    float second = [secondNumber floatValue];
    float third = [thirdNumber floatValue];
    float sum = first + second + third;
    if (sum < 0.0001) {
        sum = 1.0;
    }
    
    CGFloat startY = 0;;
    CGFloat endY = 0;
    //为什么grade会这么大
    CGFloat totalHeight =  _grade* self.frame.size.height;//(1 - _grade)
    CGFloat height = self.frame.size.height;
    CGFloat width  = self.frame.size.width;
    UIColor *layerColor = [UIColor whiteColor];
    switch (_animation) {
        case 1:
        {
            layerColor = firstColor;
            startY = height;
            endY = height-totalHeight*first/sum;
        }
            break;
        case 2:
        {
            layerColor = secondColor;
            startY = height-totalHeight*first/sum;
            endY = height-totalHeight*(first/sum+second/sum);
        }
            break;
        case 3:
        {
            layerColor = thirdColor;
            startY = height-totalHeight*(first/sum+second/sum);
            endY = height-totalHeight;
        }
            break;
        default:
            break;
    }
    UIBezierPath *progressLine = [UIBezierPath bezierPath];
    [progressLine moveToPoint:CGPointMake(width/2, startY)];
    [progressLine addLineToPoint:CGPointMake(width/2, endY)];
    [progressLine setLineWidth:1.0];
    [progressLine setLineCapStyle:kCGLineCapButt];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.3;//总时间为1
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.delegate = self;

    CAShapeLayer *layer =[CAShapeLayer layer];
    layer.lineCap = kCALineCapButt;
    layer.fillColor = [[UIColor whiteColor]CGColor];
    layer.lineWidth = width;
    layer.strokeEnd = 0.0;
    layer.path = progressLine.CGPath;
    layer.strokeColor = layerColor.CGColor;
    [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    layer.strokeEnd = 1.0;
    [self.layer addSublayer:layer];
}

#pragma -mark- detect Geusture

- (void) taped:(UITapGestureRecognizer *)tapGesture
{
    [_delegate eColumnTaped:self];
}



@end
