//
//  CustomTextFiledImage.h
//  Demo
//
//  Created by yumiao on 14/12/1.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextFiledImage : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,copy) void (^myBlock)(NSString *text);


//  初始化
/**
 *  初始化一个带图片的文本框对象
 *
 *  @param frame        文本框的frame
 *  @param image        你想要在文本框左边放的图片
 *  @param imgBounds    图片的bounds
 *  @param isSecureText 文本框是否作为密码框
 *  @param textBounds   真正的textFiled的大小
 *  @param placeHolder  默认是会显示的字
 *
 *  @return 返回一个带图片的文本框对象
 */
-(id)initWithFrame:(CGRect)frame Image:(UIImage *)image withImageBounds:(CGRect)imgBounds
    withSecureText:(BOOL)isSecureText withTextBound:(CGRect)textBounds
  WithPleaceHolder:(NSString *)placeHolder;




@end
