//
//  UIView+category.h
//  Macmax
//
//  Created by fly on 14/12/22.
//  Copyright (c) 2014年 com.fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (category)

/**
 *  借助View生成一条直线
 *
 *  @param rect 生成View的大小
 *
 *  @return 返回生成的View
 */
+(UIView *)getLines:(CGRect)rect WithColor:(UIColor *)color;

//获取UIView所在UIViewController
- (UIViewController *)viewController;
@end
