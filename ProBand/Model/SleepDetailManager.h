//
//  SleepDetailManager.h
//  LenovoVB10
//
//  Created by 于苗 on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepDetailManager : NSObject

//得到每一天的数据
+(NSArray *)getDaySleepDetail:(NSArray *)allSleepDetailArr;

//得到每一周的

+(NSArray *)getWeekSleepDetail:(NSArray *)allSleepArr;

//得到每个月的
+(NSArray *)getMonthSleepDetail:(NSArray *)allSleepArr;
@end
