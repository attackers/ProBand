//
//  EditClockController.h
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class alarm_Model;
#import "SubBaseViewcontroller.h"
@interface EditClockController : SubBaseViewcontroller
@property (nonatomic, assign) BOOL isEditType;
@property (nonatomic, strong) alarm_Model *currentModel;
@property (nonatomic, strong) NSMutableArray *alarmArray;
@end
