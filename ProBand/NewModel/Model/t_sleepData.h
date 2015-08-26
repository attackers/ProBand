//
//  t_sleepData.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_sleepData : BaseModel

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *mac;


@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy)NSString *sleeps;

@property (nonatomic, copy)NSString *isRead;

+ (t_sleepData *)convertDataToModel:(NSDictionary *)aDcitionary;

+ (NSDictionary *)dictionaryFromModel:(t_sleepData *)model;
@end
