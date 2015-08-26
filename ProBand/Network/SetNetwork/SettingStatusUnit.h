//
//  SettingStatusUnit.h
//  LenovoVB10
//
//  Created by yumiao on 15/1/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorkBase.h"
#import "SettingStatus.h"

@interface SettingStatusUnit : NetWorkBase

+(void)saveStatus:(UIButton *)btn;
+(NSArray *)getSettinginfo;
+(void)saveStatusInfo:(SettingStatus *)obj;

//保存电话及信息推送的按钮
+(void)saveStateCallInfo:(SettingStatus *)obj;

+(SettingStatus *)getSettingStatusData;
@end
