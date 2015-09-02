//
//  FitDataPoint_Model.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitValue_Model.h"

@interface FitDataPoint_Model : NSObject

@property (nonatomic, assign) long startTime;//开始时间
@property (nonatomic, assign) long entTime;//结束时间
@property (nonatomic, assign) int fitDataSourceId;//已存储在本地
@property (nonatomic, copy) NSString *fitDataTypeName;//自定义数据名字，此处为com.lenovo.settings.heartbeat
@property (nonatomic, strong) NSMutableArray *values;//包含一个或者多个FitValue_Model

@end
