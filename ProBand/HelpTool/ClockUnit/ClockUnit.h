//
//  ClockUnit.h
//  LenovoVB10
//
//  Created by jacy on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorking.h"
#import "t_alarmModel.h"
@interface ClockUnit : NetWorking

+(NSArray *)getClockModel;
+(void)saveEditClockInfo:(t_alarmModel *)obj;
+(void)saveSwichStatus:(NSString *)aStatus WithClockID:(NSString *)clockID;

+(NSArray *)parserColock:(id)reslut; 
@end
