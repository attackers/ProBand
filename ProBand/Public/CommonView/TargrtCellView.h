//
//  TargrtCellView.h
//  ProBand
//
//  Created by star.zxc on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargrtCellView : UIView
@property (nonatomic, strong)NSString *valueText;
/**
 *  本类为运动目标页面的元素
 *
 *  @param describtion 圆框内的内容
 *  @param value       圆框下面的内容
 *  @param radius      圆框半径
 */
- (void)setDescribtion:(NSString *)describtion value:(NSString *)value rotationAngle:(CGFloat)angleValue radius:(CGFloat)radius;
@end
