//
//  CustomActionSheetView.m
//  ActionSheet
//
//  Created by attack on 15/7/9.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "CustomActionSheetView.h"

#define BUTTON_HEIGHT 70

@implementation CustomActionSheetView
+ (CustomActionSheetView*)sharaActionSheetWithStyle:(NSString *)styleName
{
    CustomActionSheetView *actionSheet = [[CustomActionSheetView alloc]initWithFrame:[UIScreen mainScreen].bounds style:styleName];
    return actionSheet;
}
- (instancetype)initWithFrame:(CGRect)frame style:(NSString *)styleName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - BUTTON_HEIGHT*2-1, CGRectGetWidth(self.frame), BUTTON_HEIGHT*2+1)];
        bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), BUTTON_HEIGHT);
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0,BUTTON_HEIGHT+1, CGRectGetWidth(self.frame), BUTTON_HEIGHT);
        
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 9900;
        button2.tag = 9901;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, BUTTON_HEIGHT, CGRectGetWidth(self.frame) - 40, 1)];
        imageview.backgroundColor = [UIColor blueColor];
        imageview.image = [UIImage imageNamed:@"moving_target_regulation02"];
        [bottomView addSubview:imageview];
        
        [bottomView addSubview:button];
        [bottomView addSubview:button2];
        
        [self addSubview:bottomView];
        
        
        if ([styleName isEqualToString:@"Gender"]) {
            [button setImage:[UIImage imageNamed:@"setting_man"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"setting_man_press"] forState:UIControlStateHighlighted];
            [button2 setImage:[UIImage imageNamed:@"setting_woman"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"setting_woman_press"] forState:UIControlStateHighlighted];
        }else if ([styleName isEqualToString:@"headImage"]){
            
            [button setTitle:@"拍照" forState:UIControlStateNormal];
            [button2 setTitle:@"从手机相册选择" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}


- (void)customActionSheetSelectedIndexButton:(SelectIndexButton)indexButton
{
    
    _selectIndexButton = ^(UIButton *sender){
        
        indexButton(sender);
    };
}
- (void)buttonClick:(UIButton*)sender
{
    
    if (_selectIndexButton) {
        
        _selectIndexButton(sender);
    }
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
