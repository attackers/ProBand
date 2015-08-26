//
//  WaveScaleView.m
//  Rotation
//
//  Created by attack on 15/6/16.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "WaveScaleView.h"
#define layerwidth CGRectGetWidth(self.frame)-20
CGFloat width=0;
int repeat = 0;
CGFloat x = 40;
@implementation WaveScaleView
- (void)animation:(CALayer*)layer
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    basicAnimation.duration = 4;
    basicAnimation.repeatCount = 1110;
    basicAnimation.delegate = self;
    [layer addAnimation:basicAnimation forKey:@"transform.scale"];
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.toValue = [NSNumber numberWithFloat:0];
    opacity.duration = 4;
    opacity.repeatCount = 1110;
    opacity.delegate = self;
    [layer addAnimation:opacity forKey:@"opacity"];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:basicAnimation,opacity, nil]];
}
- (void)drawRect:(CGRect)rect {
    width = layerwidth;
    [self AddLayoutSubView];
}
- (void)AddLayoutSubView
{
    
    CALayer *waveLayer = [CALayer layer];
    waveLayer.frame = CGRectMake(x, x, width, width);

    waveLayer.borderColor = [UIColor colorWithRed:64/255.0f green:211/255.0f blue:209/255.0f alpha:.8f].CGColor;
    waveLayer.borderWidth = 1.5;
    waveLayer.cornerRadius = waveLayer.bounds.size.width/2;
    [self.layer addSublayer:waveLayer];
    [self animation:waveLayer];
    
    CGFloat timer = 1.0f;
    for (int i=0; i<3; i++) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CALayer *waveLayer1 = [CALayer layer];
            waveLayer1.frame = CGRectMake(x, x, width, width);
            waveLayer1.borderColor = [UIColor colorWithRed:64/255.0f green:211/255.0f blue:209/255.0f alpha:.8f].CGColor;
            waveLayer1.borderWidth = 1.5;
            waveLayer1.cornerRadius = waveLayer1.bounds.size.width/2;
            [self.layer addSublayer:waveLayer1];
            [self animation:waveLayer1];
            
        });
        timer = timer + 1;
    }
}


@end
