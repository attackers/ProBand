//
//  EPieChart.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EPieChart.h"
#import "EColor.h"


@implementation EPieChart
@synthesize frontPie = _frontPie;
@synthesize backPie = _backPie;
@synthesize isUpsideDown = _isUpsideDown;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize ePieChartDataModel = _ePieChartDataModel;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ePieChartDataModel:nil withIsSleep:_isSleep];
}

- (id)initWithFrame:(CGRect)frame
 ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel withIsSleep:(BOOL)b
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isUpsideDown = NO;
        
        if (nil == ePieChartDataModel)
        {
            //默认
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                             radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
            _isSleep = b;
            _frontPie.isSleep = b;
        }
        else
        {
            _ePieChartDataModel = ePieChartDataModel;
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                              radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5
                                  ePieChartDataModel: _ePieChartDataModel];
            _frontPie.isSleep = b;
            _isSleep = b;
        }
        
        
        _frontPie.layer.shadowOffset = CGSizeMake(0, 3);
        _frontPie.layer.shadowRadius = 5;
        _frontPie.layer.shadowColor = EGrey.CGColor;
        _frontPie.layer.shadowOpacity = 0.8;
        [self addSubview:_frontPie];
        
        
        
        _backPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                         radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
        _backPie.layer.shadowOffset = CGSizeMake(0, 3);
        _backPie.layer.shadowRadius = 5;
        _backPie.layer.shadowColor = EGrey.CGColor;
        _backPie.layer.shadowOpacity = 0.8;
        _backPie.isSleep = b;
        
    }
    return self;
}


//反转前后界面
- (void)turnPie
{
    [UIView transitionWithView:self
                      duration:0.3
                       options:_isUpsideDown?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^
     {
         if (_isUpsideDown)
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToFrontViewWithFrontView:)])
             {
                 [_delegate ePieChart:self didTurnToFrontViewWithFrontView:_frontPie];
             }
             
             [_backPie removeFromSuperview];
             [self addSubview:_frontPie];
         }
         else
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToBackViewWithBackView:)])
             {
                 [_delegate ePieChart:self didTurnToBackViewWithBackView:_backPie];
             }
             
             [_frontPie removeFromSuperview];
             [self addSubview:_backPie];
             
         }
         
     } completion:nil];
    
    _isUpsideDown = _isUpsideDown ? NO: YES;
}


//delegate and dataSource methods
- (void)setDelegate:(id<EPieChartDelegate>)delegate
{
    if (delegate && delegate != _delegate)
    {
        _delegate = delegate;
    }
}

- (void)setDataSource:(id<EPieChartDataSource>)dataSource
{
    if (dataSource && dataSource != _dataSource)
    {
        _dataSource = dataSource;
        
        if ([_dataSource respondsToSelector:@selector(backViewForEPieChart:)])
        {
            _backPie.contentView = [_dataSource backViewForEPieChart:self];
        }
        
        if ([_dataSource respondsToSelector:@selector(frontViewForEPieChart:)])
        {
            _frontPie.contentView = [_dataSource frontViewForEPieChart:self];
        }
        
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end





