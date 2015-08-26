//
//  EColumn.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnDataModel.h"
@class EColumn;

@protocol EColumnDelegate <NSObject>

- (void)eColumnTaped:(EColumn *)eColumn;


@end


@interface EColumn : UIView

@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) EColumnDataModel *eColumnDataModel;

-(void)rollBack;

@property (weak, nonatomic) id <EColumnDelegate> delegate;

//三种颜色的柱子
@property (nonatomic, assign)BOOL isColorFul;
/**
 *  设定柱子的各部分颜色和高度
 *
 *  @param colorArray  从下向上各部分的颜色
 *  @param colorValues 从下向上各部分的值：决定各部分颜色占的比重
 */
- (void)setPillarColor:(NSArray *)colorArray colorValue:(NSArray *)colorValues;
@property (nonatomic, strong)NSArray *colorArray;
@property (nonatomic, strong)NSArray *colorValues;
@end
