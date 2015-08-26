//
//  SubBaseViewcontroller.h
//  ProBand
//
//  Created by attack on 15/6/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseViewController.h"

@interface SubBaseViewcontroller : BaseViewController
/**
 *  导航标题
 */
@property (nonatomic,strong)UILabel *titleLabel;
/**
 *  导航左边控制按钮
 */
@property (nonatomic,strong)UIButton *leftBtn;
/**
 *  导航右边控制按钮
 */
@property (nonatomic,strong)UIButton *rightBtn;
/**
 *  提示用的红圆圈
 */
@property (nonatomic,strong)UIImageView *redRoundImageView;
/**
 *  左边分割线
 */
@property (nonatomic,strong)UIView *segmentTationLineL;
/**
 *  右边分割线
 */
@property (nonatomic,strong)UIView *segmentTationLineR;

@end
