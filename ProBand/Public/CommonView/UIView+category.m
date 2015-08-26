//
//  UIView+category.m
//  Macmax
//
//  Created by fly on 14/12/22.
//  Copyright (c) 2014年 com.fenda. All rights reserved.
//

#import "UIView+category.h"

@implementation UIView (category)

/**
 *  借助View生成一条直线
 *
 *  @param rect 生成View的大小
 *
 *  @return 返回生成的View
 */
+(UIView *)getLines:(CGRect)rect WithColor:(UIColor *)color
{
    UIView *view=[[UIView alloc] initWithFrame:rect];
    view.backgroundColor=color;
    return view;
}

- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
