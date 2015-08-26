//
//  SleepDetailModel.h
//  LenovoVB10
//
//  Created by 于苗 on 15/4/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepDetailModel : NSObject

@property (nonatomic,strong)NSArray *dayArray;
@property (nonatomic,strong)NSArray *weekArray;
@property (nonatomic,strong)NSArray *monthArray;


-(void)getAllSleepDetailInfo;
@end
