//
//  LocalNotifyManager.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleSinglten.h"
#import "BleMecro.h"
@interface LocalNotifyManager : NSObject<UIAlertViewDelegate>{
  BOOL _localNotifyFlag;
}
SINGLETON

/**
 *  发送本地通知
 *
 *  @param alertBody
 *  @param alertAction
 *  @param hasAction
 *  @param messageDic
 */
-(void)pushLocalNotifyAlertBody:(NSString *)alertBody
                    alertAction:(NSString *)alertAction
                      hasAction:(BOOL)hasAction
                     messageDic:(NSDictionary *)messageDic;
/**
 *  取消所有本地通知
 *
 *  @param title
 *  @param message
 *  @param delega
 */
-(void)removeAllLocalNotifyTitle:(NSString *)title
                         message:(NSString *)message
                        delegate:(id)delega ;
/**
 *取消某个特定的本地通知
 *
 *  @param specialKey
 *  @param localNotification
 *  @param delegate
 */
-(void)removeSpecialLocalNotifyKey:(NSString *)specialKey
                specialLocalNotify:(UILocalNotification*)localNotification
                          delegate:(id)delegate;
@end
