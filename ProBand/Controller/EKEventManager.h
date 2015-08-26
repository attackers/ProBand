//
//  EKEventManager.h
//  EventStore
//
//  Created by attack on 15/8/3.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EKEventManager : NSObject
+(EKEventManager*)shareEKEventManager;
/*
 *新建日程
 */
- (BOOL)createEventWithTitle:(NSString *)paramTitle//日程标题
                   startDate:(NSDate *)paramStartDate//开始时间
                     endDate:(NSDate *)paramEndDate//结束时间
                       notes:(NSString *)paramNotes;//日程信息
/*
 *删除日程，参数信息同上
 */
- (BOOL)removeEventWithTitle:(NSString *)paramTitle
                   startDate:(NSDate *)paramStartDate
                     endDate:(NSDate *)paramEndDate
                       notes:(NSString *)paramNotes;
/*
 *获取日程列表
 */
- (NSArray*)readEvents;
@end
