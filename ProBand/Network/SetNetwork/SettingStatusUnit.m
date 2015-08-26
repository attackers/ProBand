//
//  SettingStatusUnit.m
//  LenovoVB10
//
//  Created by yumiao on 15/1/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SettingStatusUnit.h"

@implementation SettingStatusUnit

+(void)saveStatus:(UIButton *)btn
{
    NSString *selectStr =[NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
    NSString *insertStr = [NSString stringWithFormat:@"insert into t_settingInfo (userId,smsStatus,callState,weatherState,wecatState,photoState,masterSwitch,findphoneState) values('%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected]];
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE t_settingInfo SET smsStatus ='%@',callState='%@',weatherState = '%@',wecatState = '%@',photoState = '%@',masterSwitch = '%@',findphoneState = '%@' where userId ='%@'",[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[NSString stringWithFormat:@"%d",btn.selected],[Singleton getUserID]];
    [DBOPERATOR insertDataToSQL:insertStr updatesql:updateStr withExsitSql:selectStr];
}
+(NSArray *)getSettinginfo{

    NSString *selectStr = [NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
      
    return [DBOPERATOR getDataForSQL:selectStr];
}

+(void)saveStatusInfo:(SettingStatus *)obj
{
    
    //NSLog(@"%@,%@,%@,%@,%@,%@",obj)
    NSString *selectStr =[NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
    NSString *insertStr = [NSString stringWithFormat:@"insert into t_settingInfo(userId,weatherState,callState,smsStatus,wecatState,WhatsappState,FacebookState,calendarState,TiwitterState,FindPhone,LinkLostPhone,BatteryPowerPush,Address) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],obj.weatherState,@"1",@"1",obj.wecatState,obj.WhatsappState,obj.FaceBookState,@"1",obj.TwitterState,@"1",obj.LinkLostPhone,@"1",@"0"];
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE t_settingInfo SET weatherState ='%@',wecatState ='%@',WhatsappState ='%@',FacebookState ='%@',calendarState ='%@',TiwitterState ='%@',FindPhone='%@',LinkLostPhone = '%@',BatteryPowerPush = '%@',callState = '%@',smsStatus = '%@' where userId ='%@'",obj.weatherState,obj.wecatState,obj.WhatsappState,obj.FaceBookState,obj.calendarState,obj.TwitterState,@"1",obj.LinkLostPhone,@"1" ,obj.callState,obj.smsStatus,[Singleton getUserID]];
    
    if (obj.ColudBackUp) {
        insertStr = [NSString stringWithFormat:@"insert into t_settingInfo(userId,weatherState,callState,smsStatus,wecatState,WhatsappState,FacebookState,calendarState,TiwitterState,FindPhone,LinkLostPhone,BatteryPowerPush,Address,ColudBackUp) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],obj.weatherState,@"1",@"1",obj.wecatState,obj.WhatsappState,obj.FaceBookState,@"1",obj.TwitterState,@"1",obj.LinkLostPhone,@"1",@"0",obj.ColudBackUp];
        updateStr = [NSString stringWithFormat:@"UPDATE t_settingInfo SET weatherState ='%@',wecatState ='%@',WhatsappState ='%@',FacebookState ='%@',calendarState ='%@',TiwitterState ='%@',FindPhone='%@',LinkLostPhone = '%@',BatteryPowerPush = '%@',ColudBackUp = '%@',callState = '%@',smsStatus = '%@' where userId ='%@'",obj.weatherState,obj.wecatState,obj.WhatsappState,obj.FaceBookState,obj.calendarState,obj.TwitterState,@"1",obj.LinkLostPhone,@"1" ,obj.ColudBackUp,obj.callState,obj.smsStatus,[Singleton getUserID]];
        
    }
    [DBOPERATOR insertDataToSQL:insertStr updatesql:updateStr withExsitSql:selectStr];
    
    [Singleton setSettingStatus]; //持久化开关信息
    
    
}

+ (SettingStatus *)getSettingStatusData
{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
    NSArray *settingArr = [DBOPERATOR getDataForSQL:sqlStr];
    if (settingArr.count > 0) {
        SettingStatus *model = [SettingStatus new];
        model.FaceBookState = settingArr[0][@"FacebookState"];
        model.TwitterState = settingArr[0][@"TiwitterState"];
        model.WhatsappState = settingArr[0][@"WhatsappState"];
        model.callState = settingArr[0][@"callState"];
        model.smsStatus = settingArr[0][@"smsStatus"];
        model.weatherState = settingArr[0][@"weatherState"];
        model.wecatState = settingArr[0][@"wecatState"];
        model.ColudBackUp = settingArr[0][@"ColudBackUp"];
        model.clockDaile = settingArr[0][@"clockDaile"];
        model.FindPhone = settingArr[0][@"FindPhone"];
        model.UnlockPhone = settingArr[0][@"UnlockPhone"];
        model.LinkLostPhone = settingArr[0][@"LinkLostPhone"];
        model.BatteryPowerPush = settingArr[0][@"BatteryPowerPush"];
        return model;
    }
    else
    {
        return nil;
    }
}
//保存电话及信息推送的按钮
+(void)saveStateCallInfo:(SettingStatus *)obj
{
   NSString *selectStr =[NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
    NSString *insertStr = [NSString stringWithFormat:@"insert into t_settingInfo(userId,callState,smsStatus,wecatState,WhatsappState,FacebookState,calendarState,TiwitterState,FindPhone,LinkLostPhone,BatteryPowerPush,Address) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],@"1",obj.callState,obj.smsStatus,obj.wecatState,@"1",@"1",@"1",@"1",obj.FindPhone,@"1",@"1",obj.Address];
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE t_settingInfo SET callState ='%@',smsStatus='%@',Address = '%@' where userId ='%@'",obj.callState,obj.smsStatus,obj.Address,[Singleton getUserID]];
    [DBOPERATOR insertDataToSQL:insertStr updatesql:updateStr withExsitSql:selectStr];
    
     [Singleton setSettingStatus]; //持久化开关信息
}
@end
