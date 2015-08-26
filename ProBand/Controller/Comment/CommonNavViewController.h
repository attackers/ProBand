//
//  CommonNavViewController.h
//  LenovoVB10
//
//  Created by fenda on 14/11/28.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonNavViewController : UIViewController<UITextFieldDelegate>{
    
    UIView *_titleView;
    UIButton *_backButton;
    UIButton *_nextButton;
    UIImageView *_bgImageView;
    UILabel *_titleLabel;
}

@property(nonatomic,strong) NSString *strTitle;
@property(nonatomic,strong) NSString *showType;

- (void)setNavWithTitle:(NSString *)title
        backButtonImage:(NSString *)backButtonImage
        backButtonTitle:(NSString *)backButtonTitle
        nextButtonImage:(NSString *)nextButtonImage
       withNextBtnFrame:(CGRect)frame
           nextSelector:(SEL)nextSelector
           backSelector:(SEL)backSelector;

- (void)setNavWithTitle:(NSString *)title
        backButtonImage:(NSString *)backButtonImage
        backButtonTitle:(NSString *)backButtonTitle
        nextButtonImage:(NSString *)nextButtonImage
       withNextBtnFrame:(CGRect)frame
           nextSelector:(SEL)nextSelector;
@end
