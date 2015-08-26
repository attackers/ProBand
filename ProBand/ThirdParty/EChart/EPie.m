//
//  EPie.m
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import "EPie.h"
#import "EColor.h"
#import "UICountingLabel.h"

@interface EPie ()
@property (nonatomic, strong) CAShapeLayer *circleBudget;
@property (nonatomic, strong) CAShapeLayer *circleCurrent;
@property (nonatomic, strong) CAShapeLayer *circleEstimate;
@property (nonatomic, strong) CAShapeLayer *circleBase;

@property (nonatomic) CGPoint center;

@end

@implementation EPie
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize circleBudget = _circleBudget;
@synthesize circleCurrent = _circleCurrent;
@synthesize circleEstimate = _circleEstimate;
@synthesize center = _center;
@synthesize radius = _radius;
@synthesize budgetColor = _budgetColor;
@synthesize currentColor = _currentColor;
@synthesize estimateColor = _estimateColor;
@synthesize lineWidth = _lineWidth;
@synthesize contentView = _contentView;

//默认
- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        _center = center;
        _radius = radius;
        
        self.backgroundColor = EGreen;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        
    }
    return self;
}

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        /** Default settings*/
        _budgetColor = weakSleepColor;
        _currentColor = deepSleepColor;
//        _estimateColor = [EYellow colorWithAlphaComponent:0.3];
        _estimateColor = lightSleepColor;
        _lineWidth = radius/3;
        
        
        _center = center;
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        _bgImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _bgImageViewOne.image = [UIImage imageNamed:ePieChartDataModel.bgImageNameOne];
        [self addSubview:_bgImageViewOne];
        
        _cirImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.bounds.size.width , self.bounds.size.height)];
        _cirImageViewOne.image = [UIImage imageNamed:ePieChartDataModel.bgImageNameOne];
        [self addSubview:_cirImageViewOne];
        
        _cirImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
         _cirImageViewTwo.image = [UIImage imageNamed:ePieChartDataModel.bgImageNameOne];
        [self addSubview:_cirImageViewTwo];
        
        _bgImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.width-10)];
        _bgImageViewTwo.image = [UIImage imageNamed:ePieChartDataModel.bgImageNameTwo];
        //[self addSubview:_bgImageViewTwo];
        _bgImageViewThree = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, self.bounds.size.width-6, self.bounds.size.width-6)];
        _bgImageViewThree.image = [UIImage imageNamed:ePieChartDataModel.bgImageNameThree];
        [self addSubview:_bgImageViewThree];
        
        //[self sendSubviewToBack:_bgImageViewTwo];
        /** Default Content View*/
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.clipsToBounds = YES;
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:self.frame];
        title.text = @"睡眠时长";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont fontWithName:@"Menlo-Bold" size:15];
        title.textColor = [UIColor whiteColor];
        title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.6);
        [_contentView addSubview:title];
        
        
        UICountingLabel *budgetLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        budgetLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.95);
        budgetLabel.textAlignment = NSTextAlignmentCenter;
        budgetLabel.method = UILabelCountingMethodEaseInOut;
        budgetLabel.font = [UIFont fontWithName:@"Menlo" size:20];
        budgetLabel.textColor = [UIColor whiteColor];
        //budgetLabel.format = @"%.0f小时";
        //修改by Star
        budgetLabel.text = [NSString stringWithFormat:@"%.1f小时",(_ePieChartDataModel.budget+_ePieChartDataModel.current+_ePieChartDataModel.estimate)/60.0];
        [_contentView addSubview:budgetLabel];
       // [budgetLabel countFrom:0 to:_ePieChartDataModel.budget+_ePieChartDataModel.current+_ePieChartDataModel.estimate withDuration:2.0f];
        
        //白线
        UIView *line = [[UIView alloc] initWithFrame:self.bounds];
        line.backgroundColor = [UIColor whiteColor];
        line.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.6, 1);
        line.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.1);
        [_contentView addSubview:line];
        
        
        
        UICountingLabel *currentLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        currentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.2);
        currentLabel.textAlignment = NSTextAlignmentCenter;
        currentLabel.method = UILabelCountingMethodEaseInOut;
        currentLabel.font = [UIFont fontWithName:@"Menlo" size:12];
        currentLabel.textColor = [UIColor whiteColor];
        //currentLabel.format = @"D:%.0f";
       // [_contentView addSubview:currentLabel];
        [currentLabel countFrom:0 to:_ePieChartDataModel.current withDuration:2.0f];
        
        UICountingLabel *estimateLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        estimateLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.4);
        estimateLabel.textAlignment = NSTextAlignmentCenter;
        estimateLabel.method = UILabelCountingMethodEaseInOut;
        estimateLabel.font = [UIFont fontWithName:@"Menlo" size:18];
        estimateLabel.textColor = [UIColor colorWithRed:0 green:204/25.0 blue:204/255.0 alpha:1];
        estimateLabel.text = @"优";
        //estimateLabel.format = @"L:%.0f";
        [_contentView addSubview:estimateLabel];
        //[estimateLabel countFrom:0 to:_ePieChartDataModel.estimate withDuration:2.0f];
        
        [self reloadContent];
        
    }
    return self;
}

#pragma -mark- Setter and Getter
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self reloadContent];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self reloadContent];
}

- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self reloadContent];
}

-(void)setBudgetColor:(UIColor *)budgetColor
{
    _budgetColor = budgetColor;
    [self reloadContent];
}

- (void)setEstimateColor:(UIColor *)estimateColor
{
    _estimateColor = estimateColor;
    [self reloadContent];
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView)
    {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:_contentView];
        
        NSLog(@"_contentView %@", NSStringFromCGRect(_contentView.frame));
        NSLog(@"self %@", NSStringFromCGRect(self.frame));
    }
}



#warning clockwise 顺时针逆时针
- (void) reloadContent
{
    
    CGFloat allValue = _ePieChartDataModel.current + _ePieChartDataModel.budget + _ePieChartDataModel.estimate;
    CGFloat time1Perc = _ePieChartDataModel.budget/allValue;
    CGFloat time2Perc = _ePieChartDataModel.current/allValue;
    CGFloat  time3Perc = _ePieChartDataModel.estimate/allValue;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1;
    pathAnimation.delegate = self;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    
    if (_isSleep)
    {
        
//        UIBezierPath* circleBasePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
//                                                                      radius: _radius * 0.68
//                                                                  startAngle: 0
//                                                                    endAngle: 2 * M_PI
//                                                                   clockwise:YES];
//        if (!_circleBase)
//            _circleBase = [CAShapeLayer layer];
//        _circleBase.path = circleBasePath.CGPath;
//        _circleBase.fillColor = [UIColor clearColor].CGColor;
//        _circleBase.strokeColor = [UIColor grayColor].CGColor;
//        _circleBase.lineCap = kCALineCapRound;
//        _circleBase.lineWidth = _lineWidth;
//        _circleBase.zPosition = -1;
        
        
        UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                        radius: _radius * 0.68
                                                                    startAngle: M_PI_2 * 3+0.0045*M_PI
                                                                      endAngle: M_PI_2 * 3 + 2 * M_PI*time1Perc -0.0045*M_PI
                                                                     clockwise:YES];
        
        if (!_circleBudget)
            _circleBudget = [CAShapeLayer layer];
        _circleBudget.path = circleBudgetPath.CGPath;
        _circleBudget.fillColor = [UIColor clearColor].CGColor;
        _circleBudget.strokeColor = _budgetColor.CGColor;
        _circleBudget.lineCap = kCALineCapButt;
        _circleBudget.lineWidth = _lineWidth;
        _circleBudget.zPosition = 1;
        
        float angle1 = M_PI_2 * 3 + 2 * M_PI*time1Perc;
        
        UIBezierPath* circleCurrentPath = [UIBezierPath bezierPathWithArcCenter: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                         radius: _radius * 0.68
                                                                     startAngle: angle1 + 0.0045*M_PI
                                                                       endAngle: angle1 +(time2Perc * (M_PI * 2)) -0.0045*M_PI
                                                                      clockwise: YES];
        if (!_circleCurrent)
            _circleCurrent = [CAShapeLayer layer];
        _circleCurrent.path = circleCurrentPath.CGPath;
        _circleCurrent.fillColor = [UIColor clearColor].CGColor;
        _circleCurrent.strokeColor = _currentColor.CGColor;
        _circleCurrent.lineCap = kCALineCapButt;
        _circleCurrent.lineWidth = _lineWidth;
        _circleCurrent.zPosition = 1;
        angle1 = angle1 +(M_PI * 2)*time2Perc;
        
        UIBezierPath* circleEstimatePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                          radius: _radius * 0.68
                                                                      startAngle:angle1 + 0.0045*M_PI
                                                                        endAngle: angle1 + time3Perc*(M_PI*2)- 0.0045*M_PI
                                                                       clockwise:YES];
        if (!_circleEstimate)
            _circleEstimate = [CAShapeLayer layer];
        _circleEstimate.path = circleEstimatePath.CGPath;
        _circleEstimate.fillColor = [UIColor clearColor].CGColor;
        _circleEstimate.strokeColor = _estimateColor.CGColor;
        _circleEstimate.lineCap = kCALineCapButt;
        _circleEstimate.lineWidth = _lineWidth;
        _circleEstimate.zPosition = 1;
        
        if (time1Perc == 0)
        {
            time2Perc = 0;
        }
        
        
        if (time2Perc == 0)
        {
            time3Perc = 0.5;
        }
        
        if ((time1Perc == 0) && (time2Perc == 0))
        {
            time3Perc = 0;
        }
        
        if ((time1Perc == 0) && (time3Perc == 0))
        {
            time2Perc = 0;
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC*time1Perc), dispatch_get_main_queue(), ^{
            [_circleBudget addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self.layer addSublayer:_circleBudget];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC*time2Perc), dispatch_get_main_queue(), ^{
            
            CGAffineTransform transform= CGAffineTransformMakeRotation(2 * M_PI*time1Perc);
            _cirImageViewOne.transform = transform;
            
            [self sendSubviewToBack:_cirImageViewOne];
            [_circleCurrent addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self.layer addSublayer:_circleCurrent];
            
            
            
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC*time3Perc), dispatch_get_main_queue(), ^{
            
            CGAffineTransform transform= CGAffineTransformMakeRotation(2 * M_PI*time1Perc+time2Perc*(M_PI*2));
            _cirImageViewTwo.transform = transform;
            
            [self sendSubviewToBack:_cirImageViewTwo];
            
            [_circleEstimate addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self.layer addSublayer:_circleEstimate];
        });
        
        
        [self.layer addSublayer:_circleBase];

        if (_contentView)
        {
            [self addSubview:_contentView];
        }
    
    
    }
    
    
}

- (void) reloadContentWithEPieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    _ePieChartDataModel = ePieChartDataModel;
    [self reloadContent];
}

@end

