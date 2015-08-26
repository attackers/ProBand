//
//  EShadeCircleView.h
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "EShadeChartDataModel.h"

@interface EShadeCircleView : UIView
//遮罩线的宽度
@property (nonatomic, assign) CGFloat lineWidth;
//遮罩颜色
@property (nonatomic, strong) UIColor *progressTintColor;
//被遮罩的覆盖颜色
@property (nonatomic, strong) UIColor *backgroundTintColor;
//显示百分比
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) BOOL isShowAnimotion;


@property (nonatomic,strong)UIImageView *bgImageView;
//
-(id)initWithFrame:(CGRect)frame
      andDataModel:(EShadeChartDataModel*)data
       withLineWid:(CGFloat)lineWidth
            isShow:(BOOL)show;


-(id)initWithFrame:(CGRect)frame andDataModel:(EShadeChartDataModel *)data withLineWid:(CGFloat)lineWidth isShow:(BOOL)show withBgImageView:(NSString *)bgImageName;

//添加by STar
- (id)initWithFrame:(CGRect)frame andDataModel:(EShadeChartDataModel *)data withLineWid:(CGFloat)lineWidth;
@end
