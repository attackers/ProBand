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
@end
