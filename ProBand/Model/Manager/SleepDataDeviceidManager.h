//
//  SleepDataDeviceidManager.h
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepDataDeviceidManager : NSObject

//更新标志位
+(void)updateFlag:(NSString *)Flag;
//获取到flag为0的数据
+(NSArray *)getUnUploadSleep;
//批量更新数据库
+ (void)updateFlag:(NSString *)flag withArray:(NSArray *)array;
//获取指定日期的model
+(sleepDate_deviceid_Model *)getModelByUserId:(NSString *)UserId date:(NSString *)date;
//获取sleep数据条数
+ (int) count;
+(void)insertWithSleepDateArray:(NSArray *)sleepDateArray withFlag:(NSString *)flag;
+(void)updateWithSleepDetailArray:(NSArray *)sleepDetailArray;
+(void)insertSleepDetailInfo:(sleepDate_deviceid_Model *)sleepObj;
+(NSArray *)getAllSleepInfoByuserId:(NSString *)userID;
@end

