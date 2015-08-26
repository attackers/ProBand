//
//  LoginNetUnit.h
//  LenovoVB10
//
//  Created by yumiao on 15/1/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorking.h"
#import <UIKit/UIKit.h>
#import "NSString+MD5Addition.h"

typedef enum : NSUInteger {
    LeUserEMAIL,
    LeUserMSISDN
} LeUserType;


@interface LoginNetUnit : NetWorking

SINGLETON

- (void)getDataWithName:(NSString *)nameStr withvalue:(NSString *)value withBlock:(void (^)(BOOL,NSString *,NSString *))block;
@end
