//
//  FitField_Model.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitField_Model : NSObject
@property (nonatomic, copy) NSString *name;//属性名，如UUID,manufacturer等
@property (nonatomic, assign) int format;//数据类型，FLOAT = 0，INT32 = 1，STRING = 2，DOUBLE = 3。此处为2，即string类型
@end
