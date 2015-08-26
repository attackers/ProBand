//
//  FitValue_Model.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitValue_Model : NSObject
@property (nonatomic, copy) NSString *value;//属性名，如UUID的值（D89E3BF2-4F9C-4F7C-BECA-ED3E2D68BDF4）,manufacturer（fenda）的值等
@property (nonatomic, assign) int format;//数据类型，FLOAT = 0，INT32 = 1，STRING = 2，DOUBLE = 3。此处为2，即string类型
@end
