//
//  EditClockController.h
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class t_alarmModel;
#import "SubBaseViewcontroller.h"
@interface EditClockController : SubBaseViewcontroller
@property (nonatomic, assign) BOOL isEditType;
@property (nonatomic, strong) t_alarmModel *currentModel;
@property (nonatomic, strong) NSMutableArray *alarmArray;
@end
