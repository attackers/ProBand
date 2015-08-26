//
//  originalDataManager.h
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface originalDataManager : NSObject

+(int)updateAllFlag;
//根据日期获取睡眠总时间
+(NSString *)getTotalSleepTimeByDay:(NSString *)day;
//根据日期获取深睡浅睡和清醒时间
+(NSString *)getSleepCategoryTimeByDay:(NSString *)day;
+(void)insertWithArray:(NSArray *)valueArray;
+ (int) countByDate:(NSString *)date;
+ (int) count;
+(NSArray *)getUnSaveDateArray:(NSString *)userid;
+(NSArray *)getPageList:(int)pageId type:(NSString *)type;
+(NSArray *)getPageListByDate:(NSString *)Date;
+(NSString *)getTodayStep;
+(NSString *)getDistanceCalorieMinutesByDay:(NSString *)day;
@end
