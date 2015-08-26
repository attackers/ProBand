//
//  CustomAlertview.h
//  CustomAlertview
//
//  Created by yumiao on 14/12/10.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertview;


@protocol CustomAlertviewDelegate <NSObject>

@required

- (void)alertView:(CustomAlertview *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface CustomAlertview : UIView

@property (nonatomic, assign) id<CustomAlertviewDelegate> delegate;
@property (nonatomic,strong) UITextView *messageView ;

/**
 *  初始化警告框
 *
 *  @param title             设置标题
 *  @param message           设置内容
 *  @param delegate          设置代理（此代理方法必须实现）
 *  @param vi                想要添加的view(这只view会把message覆盖)
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题(数组)
 *
 *  @return 警告框对象
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate withContextView:(UIView *)vi cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
- (void)show;
- (void)dismiss:(float)angle;

@end
