//
//  TargetModelManager.h
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetModelManager : NSObject
//返回制定时间的用户记步目标
+(NSString *)getStepTargetByUserId:(NSString *)UserId date:(NSString *)date;
+(NSString *)getStepTargetByUserId:(NSString *)UserId;
//更新几步的目标值
+(void)saveStepTarget:(NSString *)stepTarget  startTime :(NSString *)startTime   userid:(NSString *)userid;

+(NSString *)getSleepTargetByUserId:(NSString *)UserId date:(NSString *)date;
@end
