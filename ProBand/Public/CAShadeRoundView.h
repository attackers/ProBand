//
//  CAShadeRoundView.h
//  ProBand
//
//  Created by star.zxc on 15/8/31.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAShadeRoundView : UIView
//介于0和1之间，用于绘图
@property (nonatomic, assign)CGFloat value;

@property (nonatomic, strong)NSString *describe;

@property (nonatomic, strong)UIColor *startColor;

@property (nonatomic, strong)UIColor  *endColor;

@property (nonatomic, strong)NSString *endImageName;
//图的类型：计步为1，睡眠为2，锻炼为3:最后设置
@property (nonatomic, assign)int type;
@end
