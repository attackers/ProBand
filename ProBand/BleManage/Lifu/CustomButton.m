//
//  CustomButton.m
//  ProBand
//
//  Created by attack on 15/8/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/4, CGRectGetHeight(self.frame)/2, CGRectGetHeight(self.frame)/2)];
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame), CGRectGetHeight(self.frame)/4, CGRectGetWidth(self.frame) - CGRectGetWidth(_leftImageView.frame), CGRectGetHeight(self.frame)/2)];
        _rightLabel.font = [UIFont fontWithName:MicrosoftYaHe size:12];
        _rightLabel.textColor = ColorRGB(92, 96, 102);
        [self addSubview:_leftImageView];
        [self addSubview:_rightLabel];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
