//
//  FitDataSource_Model.h
//  ProBand
//
//  Created by Echo on 15/7/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitApplication_Model.h"
#import "FitDevice_Model.h"

@interface FitDataSource_Model : NSObject
@property (nonatomic, copy) NSString *fitDataSourceId;
@property (nonatomic, strong) FitApplication_Model *appModel;
@property (nonatomic, strong) FitDevice_Model *deviceModel;
@end
