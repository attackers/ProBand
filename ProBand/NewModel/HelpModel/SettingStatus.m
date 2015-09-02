//
//  SettingStatus.m
//  LenovoVB10
//
//  Created by yumiao on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SettingStatus.h"

@implementation SettingStatus

//数据映射
+ (SettingStatus *)instancesFromDictionary:(NSDictionary *)userinfoDic
{
    SettingStatus *instance = [[SettingStatus alloc] init];
  
    instance.clockDaile = userinfoDic[@"clockDaile"];
    instance.WeightUnits = userinfoDic[@"WeightUnits"];
    instance.LenthUnits = userinfoDic[@"LenthUnits"];
    instance.ColudBackUp = userinfoDic[@"ColudBackUp"];
    instance.Address = userinfoDic[@"Address"];
    instance.smsStatus = userinfoDic[@"smsStatus"];
    instance.userId = userinfoDic[@"userId"];
    instance.Id = userinfoDic[@"Id"];
    instance.callState = userinfoDic[@"callState"];
    instance.weatherState = userinfoDic[@"weatherState"];
    instance.wecatState = userinfoDic[@"wecatState"];
    instance.WhatsappState = userinfoDic[@"WhatsappState"];
    instance.FaceBookState = userinfoDic[@"FaceBookState"];
    instance.TwitterState = userinfoDic[@"TwitterState"];
    
    
    instance.calendarState = userinfoDic[@"calendarState"];
    instance.FindPhone = userinfoDic[@"FindPhone"];
    instance.UnlockPhone = userinfoDic[@"UnlockPhone"];
    instance.LinkLostPhone = userinfoDic[@"LinkLostPhone"];
    instance.BatteryPowerPush = userinfoDic[@"BatteryPowerPush"];
    
    return instance;
    
}



- (void)setAttributesFromDictionary:(NSDictionary *)userInfoDic
{
    if (![userInfoDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    [self setValuesForKeysWithDictionary:userInfoDic];
}
+(SettingStatus *)parserSetStatus:(id)reslut 
{
    SettingStatus *obj = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[reslut dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([dic[@"retcode"] intValue] == 10000)
    {
        NSString *retstring = dic[@"retstring"];
        if ([retstring dataUsingEncoding:NSUTF8StringEncoding])
        {
            obj = [[SettingStatus alloc]init];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[retstring dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil][0];
            NSString *deviceStr = tempDic[@"deviceSetting"];
            if ([deviceStr dataUsingEncoding:NSUTF8StringEncoding]) {
                
                NSDictionary *deviceDic = [NSJSONSerialization JSONObjectWithData:[deviceStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
               NSString *str = [XlabTools decimalTOBinary:[deviceDic[@"swithchs"] intValue] backLength:13];
                NSLog(@"~~~~deviceDic~~~~~~~%@",deviceDic);
                NSLog(@"---swithchs----%@",str);
                obj.clockDaile = deviceDic[@"clockDaile"];
                
                for(int i = 0;i<str.length;i++)
                {
                    if (i==0) {
                        
                        obj.smsStatus = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==1)
                    {
                        obj.callState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==2)
                    {
                       obj.wecatState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==3)
                    {
                        obj.BatteryPowerPush = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==4)
                    {
                        obj.weatherState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==5)
                    {
                        obj.WhatsappState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==6)
                    {
                         obj.FaceBookState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==7)//TwitterState推送
                    {
                         obj.TwitterState = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==8)//找手机
                    {
                         obj.FindPhone = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==9)//通讯录（iOS不用）
                    {
                         obj.Address = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==11)//手机开锁（iOS不用）
                    {
                        obj.UnlockPhone = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==12)//手机防丢
                    {
                        obj.LinkLostPhone = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                    else if (i==13)//云备份
                    {
                         obj.ColudBackUp = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
                    }
                }
                
            }
           
            
        }
    }
    
    NSLog(@"obj－－－－－－%@",obj.clockDaile);
    return obj;
}
@end
