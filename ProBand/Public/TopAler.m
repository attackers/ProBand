//
//  TopAler.m
//  TopAler
//
//  Created by attack on 15/7/8.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "TopAler.h"

@implementation TopAler
{
    UILabel *label;
}
+ (TopAler*)shareTopAler
{
    TopAler *top =[[TopAler alloc]initWithFrame:CGRectMake(0, -60, CGRectGetWidth([UIScreen mainScreen].bounds), 60)];
    top.backgroundColor = [UIColor grayColor];
    [[UIApplication sharedApplication].keyWindow addSubview:top];
    return top;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17];
        [self addSubview:label];
    }
    return self;
}
- (void)setShowText:(NSString *)showText
{
    _showText = showText;
    label.text = _showText;
}
- (void)startShow
{
    CABasicAnimation *ca = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    ca.toValue = [NSNumber numberWithInt:60];
    ca.duration = 1.5;
    ca.repeatCount = 1;
    ca.removedOnCompletion = NO;
    [self.layer addAnimation:ca forKey:@"transform.translation.y"];
    
    
}
@end
