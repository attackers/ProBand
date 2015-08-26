//
//  SleepdownModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface SleepdownModel : BaseModel
//睡眠下半页对应的数据
@property (nonatomic, strong) NSString *Id;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *sleeps;//睡眠详情
@property(nonatomic,strong) NSString *lightTime;
@property(nonatomic,strong) NSString *DeepTime;
@property(nonatomic,strong) NSString *wakeTime;
@property(nonatomic,strong) NSString *quality;
@property(nonatomic,strong) NSString *totalSleep;

+(SleepdownModel *)convertDataToModel:(NSDictionary *)aDictionary;
@end
