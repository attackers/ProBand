//
//  ClockModel.h
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/16.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ClockModel : BaseModel
@property (nonatomic, strong) NSString *Id;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *repeat;
@property (nonatomic,strong) NSString *interval;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *AlarmId;
@property (nonatomic,strong) NSString *status;


+(NSMutableArray *)getResultArr:(NSArray *)arr;
+(ClockModel *)convertDataToModel:(NSDictionary *)aDictionary;

//把星期排成高到底
+(NSArray *)sortWeek:(NSString *)str;




@end
