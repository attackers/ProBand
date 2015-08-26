//
//  EPie.h
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPieChartDataModel.h"
@interface EPie : UIView
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;

@property (strong, nonatomic) UIColor *budgetColor;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) UIColor *estimateColor;
@property (strong,nonatomic)UIImageView *bgImageViewOne;
@property (strong,nonatomic)UIImageView *bgImageViewTwo;
@property (strong,nonatomic)UIImageView *bgImageViewThree;
@property (nonatomic,strong)UIImageView *cirImageViewOne;
@property (nonatomic,strong)UIImageView *cirImageViewTwo;

@property (nonatomic) BOOL isSleep;

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

- (void) reloadContent;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;
@end
