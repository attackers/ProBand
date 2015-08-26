//
//  AllModel.h
//  LenovoVB10
//
//  Created by 于苗 on 15/4/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClockModel.h"
#import "SettingStatus.h"
#import "UserTargetModel.h"

@interface AllModel : NSObject

@property (nonatomic,strong)NSArray *clockModelArr;
@property (nonatomic,strong)SettingStatus *setStatusObj;
@property (nonatomic,strong)UserTargetModel *tagetModelObj;

@end
