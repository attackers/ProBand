//
//  EKEventManager.m
//  EventStore
//
//  Created by attack on 15/8/3.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "EKEventManager.h"
@interface EKEventManager()
{
    EKEventStore *store;
    EKCalendar *_calendar;
}
@end
@implementation EKEventManager
+(EKEventManager*)shareEKEventManager
{
    static EKEventManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m=[[EKEventManager alloc]init];
    });
    return m;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        store = [[EKEventStore alloc]init];
        EKSource *icloudSource = [self sourceInEventStore:store sourceType:EKSourceTypeCalDAV sourceTitle:@"ProBand"];
        _calendar = [self calendardefault];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            if (error) {
                
                NSLog(@"%@",error.domain);
                
            }
            if (granted) {
                
                
                NSLog(@"YES");
                
            }else{
                EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
                switch (status) {
                    case EKAuthorizationStatusNotDetermined:
                    {
                        NSLog(@"用户还没有关于这个应用程序是否做出了选择.");
                    }
                        break;
                    case EKAuthorizationStatusRestricted:
                    {
                        NSLog(@"这个应用程序未被授权访问该服务。");
                        
                    }
                        break;
                    case EKAuthorizationStatusDenied:
                    {
                        NSLog(@"拒绝用户访问这个服务");
                        
                    }
                        break;
                    case EKAuthorizationStatusAuthorized:
                    {
                        NSLog(@"此应用程序授权访问该服务");
                        
                    }
                        break;
                    default:
                        break;
                }
            }
            
        }];
        
    }
    return self;
}
- (EKSource *) sourceInEventStore:(EKEventStore *)paramEventStore
                       sourceType:(EKSourceType)paramType
                      sourceTitle:(NSString *)paramSourceTitle
{
    for (EKSource *source in paramEventStore.sources){
        if (source.sourceType == paramType && [source.title caseInsensitiveCompare:paramSourceTitle] == NSOrderedSame){
            return source;
        }
    }
    return nil;
}
/*创建用户日历库*/
- (EKCalendar*)calendardefault
{
    if (!_calendar) {
        NSArray *calendarArray = [store calendarsForEntityType:EKEntityTypeEvent];
        NSString *calendarTitle = @"ProBand";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@",calendarTitle];
        NSArray *filered = [calendarArray filteredArrayUsingPredicate:predicate];
        
        if ([filered count]) {
            _calendar = [filered firstObject];
        }else{
            
            
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:store];
            _calendar.title = @"ProBand";
            _calendar.source = store.defaultCalendarForNewEvents.source;
            
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [store saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                NSLog(@"calendar save Error");
            }
        }
        
    }
    return _calendar;
    
}
- (BOOL)createEventWithTitle:(NSString *)paramTitle
                   startDate:(NSDate *)paramStartDate
                     endDate:(NSDate *)paramEndDate
                       notes:(NSString *)paramNotes
{
    
    BOOL result = NO;
    if (_calendar.allowsContentModifications == NO) {
        NSLog(@"The slected calendar does not allow modifications");
        return NO;
    }
    
    EKEvent *event = [EKEvent eventWithEventStore:store];
    event.calendar = _calendar;
    event.title = paramTitle;
    event.notes = paramNotes;
    event.startDate = paramStartDate;
    event.endDate = paramEndDate;
    
    NSError *saveError = nil;
    
    result = [store saveEvent:event span:EKSpanThisEvent error:&saveError];
    if (result == NO) {
        NSLog(@"An error occurred = %@",saveError);
    }
    
    return result;
}
- (NSArray*)readEvents
{
    
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSinceNow:-3600*24*90];//事件段，开始时间
    NSDate* ssend = [NSDate dateWithTimeIntervalSinceNow:3600*24*90];//结束时间，取中间
    EKSource *icloudSource = [self sourceInEventStore:store
                                           sourceType:EKSourceTypeCalDAV
                                          sourceTitle:@"ProBand"];
    if (icloudSource == nil){
        NSLog(@"You have not configured iCloud for your device.");
    }
    NSSet *calendars = [icloudSource calendarsForEntityType:EKEntityTypeEvent];
    NSTimeInterval NSOneYear = 1 * 365 * 24.0f * 60.0f * 60.0f;
    NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:-NSOneYear];
    NSDate *endDate = [NSDate date];
    NSPredicate *predicate =
    [store predicateForEventsWithStartDate:startDate
                                   endDate:endDate
                                 calendars:calendars.allObjects];
    
    //    NSPredicate *searchPredicate = [store predicateForCompletedRemindersWithCompletionDateStarting:ssdate ending:ssend calendars:@[_calendar]];
    NSArray *events = [store eventsMatchingPredicate:predicate];
    if (events != nil) {
        for (EKEvent *event in events) {
            NSLog(@"%@",event.title);
        }
    }
    return events;
}
- (BOOL)removeEventWithTitle:(NSString *)paramTitle
                   startDate:(NSDate *)paramStartDate
                     endDate:(NSDate *)paramEndDate
                       notes:(NSString *)paramNotes
{
    BOOL result = NO;
    if (_calendar.allowsContentModifications == NO) {
        NSLog(@"The selected calendar does not allow modifications.");
        return NO;
    }
    NSPredicate *predicate = [store predicateForEventsWithStartDate:paramStartDate endDate:paramEndDate calendars:@[_calendar]];
    NSArray *events = [store eventsMatchingPredicate:predicate];
    if ([events count]>0) {
        for (EKEvent *event in events) {
            NSError *removeError = nil;
            
            if (![store removeEvent:event span:EKSpanThisEvent commit:NO error:&removeError]) {
                NSLog(@"Failed to remove event %@ with error = %@",event, removeError);
            }
        }
        
        NSError *commitError = nil;
        if ([store commit:&commitError]) {
            result = YES;
        }else{
            
            NSLog(@"Failed to commit the event store.");
        }
    }else{
        NSLog(@"No events matched your input.");
    }
    return result;
}
@end
