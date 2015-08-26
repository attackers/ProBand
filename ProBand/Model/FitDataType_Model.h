//
//  FitDataType_Model.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitField_Model.h"
@interface FitDataType_Model : NSObject

@property (nonatomic, copy) NSString *name;//自定义数据name，此处为com.lenovo.settings.heartbeat
@property (nonatomic, strong) NSMutableArray *fitfields;//FitField_Model数组，包含一个或者多个FitField_Model

@end
