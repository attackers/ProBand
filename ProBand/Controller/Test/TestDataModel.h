//
//  TestDataModel.h
//  DrawChartView
//
//  Created by jacy on 14/12/27.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EShadeChartDataModel.h"
#import "EPieChartDataModel.h"
@interface TestDataModel : NSObject
/**
 *  创造数据
 *
 *  @param index 画图类型
 *  @param num   多少个点
 *
 *  @return NSArray
 */
+(NSArray *)getArrayFromDataModelwithChartIndex:(NSInteger)index withNum:(int)num;

//线型图
+(NSArray *)getArrayFromDataModelwithLineChartwithNum:(int)num;
//遮罩图
+(EShadeChartDataModel *)getModelDataForShadeChart;

//遮罩图
+(EShadeChartDataModel *)getExerciseModelDataForShadeChart;


//饼状图
+(EPieChartDataModel *)getModelDataForPieChart;

+(EShadeChartDataModel *)getExerciseDataForShadeChart;
@end
