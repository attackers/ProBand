//
//  FitDevice_Model.h
//  ProBand
//
//  Created by Echo on 15/7/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitDevice_Model : NSObject
@property (nonatomic, copy) NSString *deviceId;//设备ID
@property (nonatomic, copy) NSString *manufacturer;//生成厂商
@property (nonatomic, copy) NSString *model;//暂时不清楚。可随意字符串
@property (nonatomic, copy) NSString *version;//设备版本
@end
