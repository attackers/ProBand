//
//  UserSleepTargetController.h
//  ProBand
//
//  Created by 于苗 on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//


#import "SubBaseViewcontroller.h"
@interface UserSleepTargetController : SubBaseViewcontroller

//接收上一个页面传递的运动信息
@property (nonatomic, assign)NSInteger stepTarget;
@property (nonatomic,assign) BOOL showSegment;
@end
