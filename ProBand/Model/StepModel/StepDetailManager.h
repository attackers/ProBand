//
//  StepDetailManager.h
//  LenovoVB10
//
//  Created by fly on 15/4/27.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepTodayModel.h"
#import "StepDataModel.h"
#import "stepDetailModel.h"
#import "stepDate_deviceid_Model.h"
@interface StepDetailManager : NSObject
+(StepTodayModel *)getTodayData;

/**
 *  把原始的model转化成记步详情中需要的model
 *
 *  @param originalModel 原始model
 *
 *  @return 记步详情所需的Model
 */
+(stepDetailModel *)conventModelFrom:(stepDate_deviceid_Model *)originalModel;


/**
 *  从原始库中取出的数据进行补全操作
 *
 *  @param originalSteps 原始数组
 *  @param stepDataModel 记步详情model
 *
 *  @return 返回处理好的记步详情model
 */
+(StepDataModel *)getEveryDayFullWithoriginalArray:(NSArray *)originalSteps withStepDataModel:(StepDataModel *)stepDataModel;
/**
 *  获取到每天的数据分6组
 *
 *  @param stepDataModel 含补全数据的model
 *
 *  @return 处理后的model,包含每八天为一组的数组
 */
+(StepDataModel *)getEveryDayDataWithStepDataModel:(StepDataModel *)stepDataModel;
/**
 *  获取到每周的日期数据
 *
 *  @param stepDataModel 即将要处理的周model
 *
 *  @return 处理好的周model
 */
+(StepDataModel *)getEveryWeekDataWithStepDataModel:(StepDataModel *)stepDataModel;
/**
 *  获取到每月的日期数据
 *
 *  @param stepDataModel 即将要处理的周model
 *
 *  @return 处理好的月model
 */
+(StepDataModel *)getEveryMonthDataWithStepDataModel:(StepDataModel *)stepDataModel;

/**
 *  得到默认的stepDetailModel
 *
 *  @param dateStr 传入时间
 *
 *  @return 返回需要的model
 */
+(stepDetailModel *)getDefaultStepModelWithDate:(NSString *)dateStr;
/**
 *  转换成月详情需要显示的格式
 *
 *  @param originalArray 原始数组装yyyy-MM-dd
 *
 *  @return 返回的数组装MM月格式
 */
+ (NSArray *)changeArrayValue:(NSArray *)originalArray;

@end
