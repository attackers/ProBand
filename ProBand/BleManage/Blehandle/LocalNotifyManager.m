//
//  LocalNotifyManager.m
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "LocalNotifyManager.h"
#import "PlayAudioManager.h"
@implementation LocalNotifyManager
SINGLETON_SYNTHE

-(id)init
{
    if (self = [super init])
    {
        _localNotifyFlag = YES;
    }
    
    return self;
}

-(void)pushLocalNotifyAlertBody:(NSString *)alertBody alertAction:(NSString *)alertAction hasAction:(BOOL)hasAction messageDic:(NSDictionary *)messageDic
{
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0]; //触发通知的时间
        notification.repeatInterval = NSCalendarUnitYear  ; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody = alertBody;
        
        notification.alertAction = alertAction;  //提示框按钮
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        
        //下面设置本地通知发送的消息，这个消息可以接受
        notification.userInfo = messageDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

-(void)removeAllLocalNotifyTitle:(NSString *)title message:(NSString *)message delegate:(id)delega
{
    if (_localNotifyFlag)
    {
        _localNotifyFlag = NO;
        return;
    }
    
    NSInteger count =[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    if(count>0)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

-(void)removeSpecialLocalNotifyKey:(NSString *)specialKey specialLocalNotify:(UILocalNotification*)localNotification delegate:(id)delegate
{
    // 取消某个特定的本地通知
    
    _localNotifyFlag = YES;
    
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        
        NSString *notiID = [noti.userInfo objectForKey:specialKey];
        
        NSString *receiveNotiID = [localNotification.userInfo objectForKey:specialKey];
        
        if ([notiID isEqualToString:receiveNotiID])
        {
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            
        }
    }
    if ([BleSinglten getBoolState:ALERTINFO_POPBOX])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:localNotification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [BleSinglten setBoolState:NO defaultKey:ALERTINFO_POPBOX];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [[PlayAudioManager sharedInstance] stopFindPhone];
    [BleSinglten setBoolState:YES defaultKey:ALERTINFO_POPBOX];
}
@end
