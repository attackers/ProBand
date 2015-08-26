//
//  CustomAlertview.m
//  CustomAlertview
//
//  Created by yumiao on 14/12/10.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "CustomAlertview.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CustomAlertview ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic,strong)  UIView *bgView;
@end

@implementation CustomAlertview

#pragma mark -

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Actions

- (void)show {
    self.alpha = 0.0;
    CGAffineTransform scale = CGAffineTransformMakeScale(5, 5);
    self.transform = scale;
    [[[UIApplication sharedApplication] windows][0] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss:(float)angle {
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 0;
        _bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];
}

- (void)alertButtonWasTapped:(UIButton *)button {
    [self dismiss:360];
    [self.delegate alertView:self clickedButtonAtIndex:button.tag];
}

#pragma mark - setup

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate withContextView:(UIView *)vi cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        _delegate = delegate;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
         UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [win addSubview:_bgView];
        
       
        
        
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        CGFloat currentWidth = 280;
        CGFloat extraHeight = 0;
        if ((cancelButtonTitle && [otherButtonTitles count] <= 1) || ([otherButtonTitles count] < 2 && !cancelButtonTitle)) {
            //Cancel button and 1 other button, or 1/2 other buttons and no cancel button
            extraHeight = 40;
        }
        else if (cancelButtonTitle && [otherButtonTitles count] > 1) {
            extraHeight = 40 + [otherButtonTitles count]*40;
        }
        else {
            NSLog(@"failed both");
        }
        CGSize maximumSize = CGSizeMake(currentWidth, CGFLOAT_MAX);
        CGRect boundingRect = [message boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : font} context:nil];
        
        CGFloat height = boundingRect.size.height +20+40+extraHeight;
        if (message) {
            height = height + 50;
        }
        
        
        self.frame = CGRectMake(20, 568/2-height/2, 280, height);
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        self.backgroundColor = [UIColor whiteColor];

        
        //Title View
        UIView *topPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        [self addSubview:topPart];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 280, 40)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [topPart addSubview:titleLabel];
        
        //横线
        CALayer *horizontalBorderOne = [CALayer layer];
        horizontalBorderOne.frame = CGRectMake(0.0f, titleLabel.center.y + 30, self.bounds.size.width, 1.000f);
        horizontalBorderOne.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
        [self.layer addSublayer:horizontalBorderOne];
        if (!vi) {
            
            //Message view
            _messageView = [[UITextView alloc] init];
            CGFloat newLineHeight = boundingRect.size.height + 10.0;
            _messageView.frame = CGRectMake(0, 70, 280, newLineHeight);
            _messageView.text = message;
            _messageView.textColor = [UIColor grayColor];
            _messageView.font = font;
            _messageView.editable = NO;
            _messageView.dataDetectorTypes = UIDataDetectorTypeAll;
            _messageView.userInteractionEnabled = NO;
            [self addSubview:_messageView];
            
        }
        else{
            
            //CGFloat newLineHeight = vi.bounds.size.height - 30.0;
            vi.frame = CGRectMake(0,vi.frame.origin.y, 280, vi.frame.size.height);
            
            [self addSubview:vi];
            self.frame = CGRectMake(0,568/2-height/2, 280, vi.frame.size.height +height);
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
            //height = newLineHeight + height;
        }
        
        //buttons
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 45, 280, 45)];
        //横线
        CALayer *horizontalBorder = [CALayer layer];
        horizontalBorder.frame = CGRectMake(0.0f, self.bounds.size.height - 50, buttonView.frame.size.width, 1.f);
        horizontalBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
        [self.layer addSublayer:horizontalBorder];
        if ((cancelButtonTitle && [otherButtonTitles count] == 1) || ([otherButtonTitles count] <= 2 && !cancelButtonTitle)) {
            //竖线
            CALayer *centerBorder = [CALayer layer];
            centerBorder.frame = CGRectMake(buttonView.frame.size.width/2+0.5, 2.f, 1.f, buttonView.frame.size.height - 7);
            centerBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
            [buttonView.layer addSublayer:centerBorder];
        }
        [self addSubview:buttonView];
        
        if (cancelButtonTitle) {
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
            if ([otherButtonTitles count] == 1) {
                cancelButton.frame = CGRectMake(0, 0, 141, 40);
            }
            else cancelButton.frame = CGRectMake(0, CGRectGetHeight(buttonView.frame)-40, 280, 40);
            
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            cancelButton.tag = 0;
            [buttonView addSubview:cancelButton];
        }
        
        for (int i=0; i<[otherButtonTitles count]; i++) {
            UIButton *otherTitleButton = [UIButton buttonWithType:UIButtonTypeSystem];
            
            if ([otherButtonTitles count] == 1 && !cancelButtonTitle) {
                //1 other button and no cancel button
                otherTitleButton.frame = CGRectMake(0, 0, 280, 40);
                otherTitleButton.tag = 0;
            }
            else if (([otherButtonTitles count] == 2 && !cancelButtonTitle) || ([otherButtonTitles count] == 1 && cancelButtonTitle)) {
                // 2 other buttons, no cancel or 1 other button and cancel
                otherTitleButton.tag = i+1;
                otherTitleButton.frame = CGRectMake(140, 0, 142, 40);
            }
            else if ([otherButtonTitles count] >= 2) {
                
                if (cancelButtonTitle) {
                    otherTitleButton.frame = CGRectMake(0, (i*40)+0.5, 280, 40);
                    otherTitleButton.tag = i+1;
                }
                else {
                    otherTitleButton.frame = CGRectMake(0, i*40, 280, 40);
                    otherTitleButton.tag = i;
                }
                CALayer *horizontalBorder = [CALayer layer];
                horizontalBorder.frame = CGRectMake(0.0f, otherTitleButton.frame.origin.y+39.5, buttonView.frame.size.width, 0.5f);
                horizontalBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
                [buttonView.layer addSublayer:horizontalBorder];
            }
            [otherTitleButton addTarget:self action:@selector(alertButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
            [otherTitleButton setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
            [otherTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[otherTitleButton setTitleColor:[UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:1.000] forState:UIControlStateHighlighted];
            otherTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [buttonView addSubview:otherTitleButton];
        }
        
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-20);
        horizontalMotionEffect.maximumRelativeValue = @(20);
        
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-20);
        verticalMotionEffect.maximumRelativeValue = @(20);
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        [self addMotionEffect:group];
        
    }
    return self;
}
-(void)dismiss{
    [self.delegate alertView:self clickedButtonAtIndex:0];
    [self dismiss:130];
}

@end
