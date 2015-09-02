//
//  ClockUnit.m
//  LenovoVB10
//
//  Created by jacy on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ClockUnit.h"

@implementation ClockUnit

- (void)requestComplete:(id)result{
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary *)result;
        NSArray *allKeys = [dic allKeys];
        //根据接口返回字段相印的修改retCode
        if ([allKeys containsObject:@"retCode"]) {
            NSString *code = [dic objectForKey:@"retCode"];
            if ([code intValue] == 0  && code) {
                flag = YES;
            }
        }
    }
    
    if (self.completion) {
        self.completion(result,flag);
    }
}
//
//+(NSArray *)getClockModel{
//    
//    NSString *sqlSelect = [NSString stringWithFormat:@"select * from t_alarm where userId = '%@'",[Singleton getUserID]];
//    NSArray *arr = [DBOPERATOR getDataForSQL:sqlSelect];
//    if (arr.count>0)
//    {
//        
//    }
//    return [ClockModel getResultArr:arr];
//}
////把闹钟数据存到数据库中
//+(void)saveEditClockInfo:(ClockModel *)obj
//{
//    NSString *sqlStr = [NSString stringWithFormat:@"insert into t_alarm(startTime,name,repeat,interval,userId,AlarmId,status) values('%@','%@','%@','%@','%@','%@','%@')",obj.startTime,obj.name,obj.repeat,obj.interval,obj.userId,obj.AlarmId,obj.status];
//    NSString *sqlUpdate = [NSString stringWithFormat:@"update t_alarm set startTime = '%@',name = '%@', repeat = '%@',interval = '%@' where userid = '%@' and AlarmId = '%@'",obj.startTime,obj.name,obj.repeat,obj.interval,obj.userId,obj.AlarmId];
//    NSString *sqlSelect = [NSString stringWithFormat:@"select count(*) from t_alarm where AlarmId = '%@'",obj.AlarmId];
//    [DBOPERATOR insertDataToSQL:sqlStr updatesql:sqlUpdate withExsitSql:sqlSelect];
//
//}

+(void)saveSwichStatus:(NSString *)aStatus WithClockID:(NSString *)clockID
{
    NSLog(@"%@",aStatus);
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from t_alarm where AlarmId = '%@' and userId = '%@'",clockID,[Singleton getUserID]];
    NSString *updateSql = [NSString stringWithFormat:@"update t_alarm set status = '%@' where AlarmId = '%@' and userId = '%@'",aStatus,clockID,[Singleton getUserID]];
    [DBOPERATOR updateTheDataToDbWithExsitSql:selectSql withSql:updateSql];
}

+(NSArray *)parserColock:(id)reslut
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:[reslut dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([dic[@"retcode"] intValue]==10000) {
        NSString *retstring = dic[@"retstring"];
        if (![retstring dataUsingEncoding:NSUTF8StringEncoding]) {
            return arr;
        }
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[retstring dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil][0];
        
        NSString *deviceSetting = tempDic[@"deviceSetting"];
        NSLog(@"deviceSetting%@",deviceSetting);
        if (![deviceSetting dataUsingEncoding:NSUTF8StringEncoding]) {
            return arr;
        }
        NSDictionary *deviceDic = [NSJSONSerialization JSONObjectWithData:[deviceSetting dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"~~~deviceDic~~~~~~%@",deviceDic);
        if (deviceDic==nil) {
            return arr;
        }
        NSArray *arrTemp = deviceDic[@"alarms"];
        for (int i = 0;i<arrTemp.count;i++)
        {
            NSDictionary *tempDic = arrTemp[i];
            t_alarmModel *obj = [t_alarmModel convertDataToModel:tempDic];
//            obj.AlarmId = [NSString stringWithFormat:@"%d",i+1];
//            obj.name = tempDic[@"alarmName"];
//            obj.status = tempDic[@"status"];
//            obj.startTime = tempDic[@"alarmTime"];
//            obj.interval = tempDic[@"interval"];
//            obj.repeat = [XlabTools decimalTOBinary:[tempDic[@"repeat"] intValue] backLength:7];
            [arr addObject:obj];
        }
//        UserTargetModel *targetObj = [[UserTargetModel alloc]init];
//        targetObj.botherStatus = deviceDic[@"fazeSwitch"];
//        targetObj.botherStart = deviceDic[@"fazeStartTime"];
//        targetObj.botherEnd = deviceDic[@"fazeEndTime"];
//        targetObj.clockDaile = deviceDic[@"clockDaile"];
//        SettingStatus *setObj = [self getSettingInfo:[deviceDic[@"swithchs"] intValue]];
//        [arr addObject:targetObj];
//        [arr addObject:setObj];
//        NSLog(@"===arrTemp=======%@",arr);
    }
    return arr;
}
+(SettingStatus *)getSettingInfo:(int)count
{
    SettingStatus *obj = [[SettingStatus alloc]init];
    NSString *str = [XlabTools decimalTOBinary:count backLength:13];
    
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
    
    return obj;
    
}

@end
