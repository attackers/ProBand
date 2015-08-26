//
//  CustomTextFiledImage.m
//  Demo
//
//  Created by yumiao on 14/12/1.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "CustomTextFiledImage.h"
@interface CustomTextFiledImage()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation CustomTextFiledImage

-(id)initWithFrame:(CGRect)frame Image:(UIImage *)image withImageBounds:(CGRect)imgBounds
    withSecureText:(BOOL)isSecureText withTextBound:(CGRect)textBounds
  WithPleaceHolder:(NSString *)placeHolder{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.frame = frame;
        self.backgroundColor =[UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, imgBounds.size.width, imgBounds.size.height)];
        _iconImageView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.5];
        _iconImageView.image = image;
        [self addSubview:_iconImageView];
        
        
       
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 2, textBounds.size.width, textBounds.size.height - 2)];
        _textField.delegate = self;
        _textField.textColor = [UIColor lightGrayColor];

        if (isSecureText)
        {
            [self secureTextEntry];
        }
        [self setPleaceHolder:placeHolder];
        [self addSubview:_textField];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [_textField resignFirstResponder];
    return YES;
}
//设置为密码
- (void)secureTextEntry
{
    _textField.secureTextEntry = YES;
}
//设置默认字
- (void)setPleaceHolder:(NSString *)placeHolder
{
    _textField.placeholder = placeHolder;
}
//获取输入字
- (NSString *)getText
{
    return _textField.text;
}
//重写画图方法
-(void)drawRect:(CGRect)rect
{
    //改变placeholderLabel的颜色
    
    //UIColor *color = [UIColor whiteColor];
    //_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName: color}];
    
    //改变placeholderLabel的颜色
//    [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_textField setValue:[UIFont systemFontOfSize:19] forKeyPath:@"_placeholderLabel.font"];
    //画矩形框
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(1.0f, 1.0f,self.bounds.size.width - 2, 40.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathAddRect(path, nil, rectangle);
    CGContextAddPath(context, path);
    [[UIColor clearColor]setFill];
    [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] setStroke];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.myBlock) {
        self.myBlock(textField.text);
    }
   // NSLog(@"textFieldDidEndEditing");
}


@end
