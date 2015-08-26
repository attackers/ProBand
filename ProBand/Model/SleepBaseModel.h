//
//  SleepBaseModel.h
//  LenovoVB10
//
//  Created by 于苗 on 15/4/22.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sleepDate_deviceid_Model.h"


@interface SleepBaseModel : NSObject

@property (nonatomic,strong)NSString *totalSleep;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *dreep;
@property (nonatomic,strong)NSString *light;
@property (nonatomic,strong)NSString *weak;
@property (nonatomic,strong)NSArray *sleeps;
@property (nonatomic,strong)NSArray *sleepArr;

-(SleepBaseModel *)initWithSleepDate_deviceid_Model:(sleepDate_deviceid_Model*)obj;

@end
