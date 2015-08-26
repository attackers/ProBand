//
//  BandRemindManager.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BandRemindManager : NSObject

SINGLETON
//插入默认的开关
- (void)insertDefaultSwitch;

//默认全开:先插入默认数据,参数为开关的序号
- (void)updateStateWithIndex:(int)switchIndex;

//获取数据库中switch状态
+ (NSArray *)switchArrayForBandRemind;

//获取数据库中单个开关状态:1-9分别代表来电，短信，日程，邮件，QQ，微信，Facebook，推特，Whatsapp
+ (BOOL)switchStateForRemindIndex:(int)index;
@end
