//
//  RegisterNetUnit.h
//  LenovoVB10
//
//  Created by yumiao on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorking.h"
#import "LoginModel.h"
#import <UIKit/UIKit.h>


@interface RegisterNetUnit : NetWorking
@property (nonatomic,assign) NSInteger *indexType;
SINGLETON

- (BOOL) registerUser:(LoginModel*)reginfo outErrorCode:(NSString**)errorCode;
@end
