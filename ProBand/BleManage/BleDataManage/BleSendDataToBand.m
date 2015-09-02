//
//  BleSendDataToBand.m
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BleSendDataToBand.h"
#import "BluetoothManage.h"

#import "GetCityDataModel.h"
#import "DateHandle.h"
#import "ClockUnit.h"
#import "AlarmManager.h"
#import "t_userInfo.h"
#import "UserInfoManager.h"
@interface BleSendDataToBand()
{
    
}

@property (nonatomic, strong) BluetoothManage *bleConnectManager;

@end
@implementation BleSendDataToBand
SINGLETON_SYNTHE

/**
 *  发送数据的直接接口，可以直接调用也可以调用状态机
 *
 *  @return 返回发送数据的单例
 */
-(id)init
{
    if (self = [super init])
    {
       
        
        self.bleConnectManager = [BluetoothManage sharedInstance];
        /**
         *  判断当蓝牙连接时此时状态值为初始值
         *
         *  @param state      发送数据的状态
         *  @param peripheral 当前连接的BLE设备
         *
         *  @return 返回初始化好的单例
         */
       
    }
    return self;
}

/**
 *  简单命令头发送通用函数
 *
 *  @param type  简单指令类型
 *  @param param 携带的具体参数
 *
 *
 包括： GET_NRF_BDADDR                        = 0x61,//获取手环地址(IOS)
 GET_VERSION_ID                        = 0x62,//获取手环版本
 GET_BATTERY_LEVER                     = 0x63,//获取手环电池电量
 GET_TOTAL_STEPS                       = 0x6a,//获取手环步数
 GET_TOTAL_CALORIE                     = 0x6b,//获取手环卡路里
 SYNC_DATA_REQUEST    			     = 0xa2,//获取数据
 DATE_TIME_SET                         = 0x31,//全部使用UTC时间，添加时区。
 RESPOND_USER_INFO                     = 0x88,//同步用户信息
 PERSONAL_GOAL                         = 0x45,//个人目标
 RESPOND_AUTO_SLEEP_TIME               = 0x86,//同步睡眠设置
 RESPOND_ALARM                         = 0x87,//同步闹钟设置
 拍照 on/off
 同步防丢开关
 同步天气/同步短信/同步微信/twitter/facebook
 
 //只需接受信息的指令
 1.拍照信号
 2.来电静音/拒接 信号
 3.找手机
 4.同步数据
 */

- (void)sendSyncCMD:(WEARABLE_PACKAGEHEADER)type param:(id)param
{
    self.state = BLE_INIT;
    [self sendSampleCMD:type param:param];
}

- (void)sendSampleCMD:(WEARABLE_PACKAGEHEADER)type param:(id)param
{
    
    NSMutableData *data = [[NSMutableData alloc] initWithData:[BleSinglten intTochar:type withReserved:YES]];
    NSLog(@"send data1=%@",data);
    if (param != nil)
    {
    
        NSString *tempStr = [NSString stringWithFormat:@"%@",param];
        [data appendData:[tempStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"send data2=%@",data);

    NSLog(@"+>>>>>>类型>>%d>>>>数据data>>%@",type,data);
    //发送数据
    [self.bleConnectManager sendData:data];
}



/**
 *  使用状态机的形式，发送数据
 */
-(void)didReceiveResponse
{
    NSLog(@"didReceiveResponse:%d",_state);
    
    switch (_state)
    {
        case BLE_INIT://
            [self getState:BLE_GETVERSION_ID];//获取蓝牙MAc地址请求
            [self getCurrentBandMacAddress];
            break;
        case BLE_GETVERSION_ID://得到手环软件的版本
            [self getState:BLE_BATTERY_LEVER];
            [self getCurrentBandVersionID];
            break;
        case BLE_BATTERY_LEVER://获取手环电量
            [self getState:BLE_GETTOTAL_STEPS];
            [self getCurrentBatteryLever];
            break;
        case BLE_GETTOTAL_STEPS://获取ui显示总步数
            [self getState:BLE_GETTOTAL_CALORIE];
            [self getCurrentTotalsStepToBand];
            break;
        case BLE_GETTOTAL_CALORIE://获取ui显示总卡路里数
            [self getState:BLE_TOTAL_SLEEP_TIME];
            [self getCurrentTotalCalorieToBand];
            break;
        case BLE_TOTAL_SLEEP_TIME://获取ui显示总睡眠数
            [self getState:BLE_DATA_REQUEST];
            [self getCurrentTotalSleepTimeToBand];
            break;
        case BLE_DATA_REQUEST://获取数据请求
            [self getState:BLE_SEND_DATETIME];
            [self getAllDataFromBand];
            break;
        case BLE_SEND_DATETIME://同步时间，时间格式暂未定义
            [self getState:BLE_SEND_USERINFO];
            [self sendSynTimeAndDateToBand];
            break;
        case BLE_SEND_USERINFO://同步个人信息
            [self getState:BLE_SEND_PERSONAL_GOAL];
            [self sendUserInfoToBand];
            break;
        case BLE_SEND_PERSONAL_GOAL://同步个人目标设置
            [self getState:BLE_SEND_LOSTSWICTCH];
            [self sendUserGoalToBand];
            break;
        case BLE_SEND_LOSTSWICTCH://同步防丢开关状态
            [self getState:BLE_SEND_AUTOSLEEP];
            [self sendPhoneLostSwitchState];
            break;
        case BLE_SEND_AUTOSLEEP://同步睡眠睡眠设置信息
            [self getState:BLE_SEND_ALARM];
            [self sendOutoSleepSettingToBand];
            break;
        case BLE_SEND_ALARM://同步闹钟设置信息
            [self getState:BLE_SEND_WEATHER];
            [self sendAlermSettingToBand];
            break;
        case BLE_SEND_WEATHER://同步天气
            [self getState:BLE_SEND_CITY];
            [self sendWeatherSettingToBand];
            break;
        case BLE_SEND_CITY://同步城市名称
            [self getState:BLE_SEND_DISTRUBTIME];
            [self sendCityNameToBand];
            break;
        case BLE_SEND_DISTRUBTIME://同步勿扰时间设置
            [self getState:BLE_IDLE];
           
            [self sendInDisturbTimeSettingToBand];
            break;
        case BLE_IDLE://同步勿扰时间设置
            _state=10001;
            [self getAllDataFromBand];
            break;
            /*
            case BLE_MCW_SWITCH_STATE://同步短信、电话、微信开关状态
            _state = BLE_IDLE;
            [self sendMCWSwitchState];
            break;
             case BLE_SEND_SPORTSETTING://发送运动提醒
             _state = BLE_SEND_WEATHER;
             [self sendSportSettingToBand];
             break;
             case BLE_HIGHTLIGHT://手环高亮开关
             _state = BLE_GESTURE_MODE;
             
             break;
             case BLE_GESTURE_MODE://转腕亮屏开关
             _state = BLE_IDLE;
             break;
             */
        default:
            break;
    }
}

-(void)getState:(BleAssistMessageState)state{

    if (_isSeparate) {
        _state = BLE_IDLE;//蓝牙处于空闲状态
    }else{
        _state = state;
    }
}

/**
 *  获取手环Mac地址
 */
- (void)getCurrentBandMacAddress
{
    [self sendSampleCMD:GET_NRF_BDADDR param:nil];
    
}
/**
 *  获取手环软件版本
 */
- (void)getCurrentBandVersionID
{
    [self sendSampleCMD:GET_VERSION_ID param:nil];
    
}
/**
 *  获取手环电量
 */
- (void)getCurrentBatteryLever
{
    [self sendSampleCMD:GET_BATTERY_LEVER param:nil];
    
}
/**
 *  获取BLE外设总步数
 */
- (void)getCurrentTotalsStepToBand
{
    [self sendSampleCMD:GET_TOTAL_STEPS param:nil];
}

/**
 *  获取BLE外设总卡路里数
 */
-(void)getCurrentTotalCalorieToBand
{
    [self sendSampleCMD:GET_TOTAL_CALORIE param:nil];
    
}
/**
 *  获取BLE外设总睡眠数
 */
-(void)getCurrentTotalSleepTimeToBand
{
    [self sendSampleCMD:GET_TOTAL_SLEEP_TIME param:nil];
    
}
/**
 *  获取所有数据
 */
-(void)getAllDataFromBand
{
    [self sendSampleCMD:SYNC_DATA_REQUEST param:nil];
    
}


-(void)getTotalStepDataFromBand
{
    [self sendSampleCMD:GET_TOTAL_STEPS param:nil];
    
}

-(void)getTotalSleepDataFromBand
{
    [self sendSampleCMD:GET_TOTAL_SLEEP_TIME param:nil];
    
}

-(void)getStepDetailDataFromBand
{
    [self sendSampleCMD:GET_TOTAL_STEPS param:nil];
    
}

-(void)getSleepDetailDataFromBand
{
    [self sendSampleCMD:GET_TOTAL_SLEEP_TIME param:nil];
    
}


/**
 *  发送同步时间数据
 */

-(void)sendSynTimeAndDateToBand
{
    //发送的时间格式暂未定义
    NSMutableData *timeandDate = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:DATE_TIME_SET withReserved:YES]];
    //本地时间
    synchronism_dateAndTime synchronismdateTime;
    //年份只需要传后两位
    synchronismdateTime.yesr = [BleSinglten getCurrentDateorTimeWithIndex:0]%100;
    synchronismdateTime.month = [BleSinglten getCurrentDateorTimeWithIndex:1];
    synchronismdateTime.date = [BleSinglten getCurrentDateorTimeWithIndex:2];
    synchronismdateTime.hour = [BleSinglten getCurrentDateorTimeWithIndex:3];
    synchronismdateTime.minute = [BleSinglten getCurrentDateorTimeWithIndex:4];
    synchronismdateTime.seconds = [BleSinglten getCurrentDateorTimeWithIndex:5];
    [timeandDate appendBytes:&synchronismdateTime length:sizeof(synchronism_dateAndTime)];
    NSLog(@"timeandDate:%@~~~%d",timeandDate,synchronismdateTime.yesr);
    
    //UTC 时间
    synchronism_dateAndTime synchronismdateUTCTime;
    synchronismdateUTCTime = [BleSinglten getCurrentTimeUTC];
    [timeandDate appendBytes:&synchronismdateUTCTime length:sizeof(synchronism_dateAndTime)];
    NSLog(@"SynchronismTime:%@",timeandDate);
    [self.bleConnectManager sendData:timeandDate];
}
/**
 *  发送用户信息
 */
-(void)sendUserInfoToBand
{
    t_userInfo *usermodel = [UserInfoManager getUserInfoDic];
    //个人信息
    NSMutableData *userInfoData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:USER_INFO withReserved:YES]];
    user_Info_data userInfoDataStruct;
    userInfoDataStruct.height = [usermodel.height integerValue];
    userInfoDataStruct.weight = [usermodel.weight integerValue];
    [userInfoData appendBytes:&userInfoDataStruct length:sizeof(user_Info_data)];
    [self.bleConnectManager sendData:userInfoData];
    
}
/**
 *  同步个人目标设置
 */
-(void)sendUserGoalToBand
{
//    UserTargetModel *userTargetModel = [UserTargetModel getUserTargetInfoDic];
//    //个人目标，目标卡路里/距离为预留均为两个字节
//    NSMutableData *usergoaloData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:PERSONAL_GOAL withReserved:YES]];
//    NSLog(@"~~usergoaloData~~~~%@",usergoaloData);
//    user_goal_data usergoalDataStruct;
//    usergoalDataStruct.stepGoal = [userTargetModel.stepTarget integerValue];
//    usergoalDataStruct.sleepGoal = [userTargetModel.sleepTarget integerValue];
//    
//    usergoalDataStruct.stepGoal = (usergoalDataStruct.stepGoal & 0xFF)<<8 | (usergoalDataStruct.stepGoal>>8);
//    usergoalDataStruct.sleepGoal = (usergoalDataStruct.sleepGoal & 0xFF)<<8 | (usergoalDataStruct.sleepGoal>>8);
//    usergoalDataStruct.calorieGoal = (usergoalDataStruct.calorieGoal & 0xFF)<<8 | (usergoalDataStruct.calorieGoal>>8);
//    [usergoaloData appendBytes:&usergoalDataStruct length:sizeof(user_goal_data)];
//    NSLog(@"sendUserGoalToBand %@",usergoaloData);
//    [self.bleConnectManager sendData:usergoaloData];
}

/**
 *  从数据库中取出保存的开关状态，发送到BLE端。
 */
- (void)sendPhoneLostSwitchState
{
    switch_state switchData;
    switchData.pageType = PHONE_LOST;
    //switchData.markState = 0x00;
    switchData.markState = 0x01;//防丢开关状态，默认没有，默认开启
    NSMutableData *sendData = [[NSMutableData alloc] initWithData:[BleSinglten intTochar:switchData.pageType withReserved:YES]];
    [sendData appendBytes:&switchData length:sizeof(switch_state)];
    
    NSLog(@"sendPhoneLostSwitchState %@",sendData);
    [self.bleConnectManager sendData:sendData];
}

/**
 *  同步睡眠设置到BLE外设
 */
-(void)sendOutoSleepSettingToBand
{
//    UserTargetModel *userTargetModel = [UserTargetModel getUserTargetInfoDic];
//    
//    NSMutableData *outoSleepData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:AUTO_ENTER_SLEEP withReserved:YES]];
//
//    sleep_package outoSleep;
//    NSArray *tempArray = [userTargetModel.startTime componentsSeparatedByString:@":"];
//    NSLog(@"userTargetModel.startTime=%@",userTargetModel.startTime);
//    if(tempArray.count>1)
//    {
//        outoSleep.startHour = [[tempArray objectAtIndex:0] intValue];
//        outoSleep.startMinutes = [[tempArray objectAtIndex:1]intValue];
//        
//        tempArray = [userTargetModel.endTime componentsSeparatedByString:@":"];
//        outoSleep.endhour = [[tempArray objectAtIndex:0] intValue];
//        outoSleep.endMinutes = [[tempArray objectAtIndex:1] intValue];
//        [outoSleepData appendBytes:&outoSleep length:sizeof(sleep_package)];
//        
//        NSLog(@"发送同步自动睡眠设置信息时间%@-%@:%@",userTargetModel.startTime,userTargetModel.endTime,outoSleepData);
//        [self.bleConnectManager sendData:outoSleepData];
//    }
//    else
//    {
//    [self getState:BLE_SEND_WEATHER];
//    [self sendAlermSettingToBand];
//    }
   
    
}
/**
 *  同步APP闹钟设置到手环
 */
-(void)sendAlermSettingToBand
{
    NSMutableArray * clocksArray = [[NSMutableArray alloc] initWithArray:[ AlarmManager getAlarmDicFromDB]];
    if ([clocksArray count] <= 0)
    {
        return;
    }
    
    NSMutableData *data = [[NSMutableData alloc] initWithData:[BleSinglten intTochar:NOTICE_ALERT_CLOCK withReserved:YES]];
    [clocksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        t_alarmModel *clockObj = [t_alarmModel convertDataToModel:obj];
        if ([clockObj.alarm_switch isEqualToString:@"1"])
        {
            NSDate *alarmTime = [DateHandle stringToDate:[AlarmManager minuteToTime:clockObj.startTimeMinute] withtype:1];
            NSString *timeStr = [DateHandle dateToString:alarmTime withType:1];
            NSArray *arr = [timeStr componentsSeparatedByString:@":"];
            user_Alarm alarm;
            alarm.alarmHour = [[arr objectAtIndex:0] intValue];
            alarm.alarmID = [clockObj.alarmId intValue];
            alarm.alarmMinutes = [[arr objectAtIndex:1] intValue];
            alarm.alarmDayofweek = [BleSinglten weekOfDayDistribution:[AlarmManager sortWeek:clockObj.days_of_week]];
            [data appendBytes:&alarm length:sizeof(user_Alarm)];
        }
    }];
    
    NSLog(@"alarmPackage:%@",data);
    [self.bleConnectManager sendData:data];
    
}
/**
 *  同步天气信息到手环
 */
-(void)sendWeatherSettingToBand{
    
    NSMutableData *weatherSetData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:NOTICE_WEAHTER withReserved:YES]];
    GetCityDataModel *model = [GetCityDataModel getDataModel];
    weather_package weatherPackage;
    if (model.weathType) {
        NSLog(@"天气类型%d",[model.weathType integerValue]);
        weatherPackage.weatherType = [model.weathType integerValue];
        weatherPackage.fahrenheit = [model.fahrenheit intValue];
        weatherPackage.centigrad = [model.centigrad intValue];
        weatherPackage.pm25 = [model.pm25 intValue];

    }
    [weatherSetData appendBytes:&weatherPackage length:sizeof(weather_package)];
    
    NSLog(@"同步天气信息到手环:%d-%@-%@-%@,data数据%@",[model.weathType integerValue],model.fahrenheit,model.centigrad,model.pm25,weatherSetData);
    [self.bleConnectManager sendData:weatherSetData];
}

/**
 *  同步城市信息到手环
 */
-(void)sendCityNameToBand{

    NSMutableData *weatherSetData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:NOTICE_CITY withReserved:YES]];
    GetCityDataModel *model = [GetCityDataModel getDataModel];
    NSString *city = @"";
    if (model.city) {
        city = model.city;
    }
    NSData* data = [city dataUsingEncoding:NSUTF8StringEncoding];
    [weatherSetData appendData:data];
    if (data.length>sizeof(city_package)) {//城市名超过17个字节
        //城市名17个字节+数据类型一个字节＋预留位一个字节
        weatherSetData = [[NSMutableData alloc]initWithData:[weatherSetData subdataWithRange:NSMakeRange(0, sizeof(city_package)+2)]];
    }else{//城市名小于或等于17个字节
        char value = [[NSNumber numberWithChar:0] charValue];
        NSMutableData *charData = [NSMutableData dataWithBytes:&value length:sizeof(char)];
        NSInteger rangelength =sizeof(city_package)- data.length;
        for (int i = 1; i<rangelength; i++) {
            [weatherSetData appendData:charData];
        }
    }
    NSLog(@"~~~~城市~~%@~~~~~~~~************sendCityNameToBand:%@",city,weatherSetData);
    [self.bleConnectManager sendData:weatherSetData];
}

/**
 *  同步勿扰模式开始结束时间
 */
-(void)sendInDisturbTimeSettingToBand
{
//        UserTargetModel *targetModel = [UserTargetModel getUserTargetInfoDic];
//       if ([targetModel.botherStatus intValue] == 1) {//勿扰模式开启
//           NSMutableData *callSetData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:IOS_CALL_SET withReserved:YES]];
//           bother_package botherSet;
//           NSString *hourString = targetModel.botherStart.length >0 ? targetModel.botherStart : @"8:00";
//           NSString *minutesString = targetModel.botherEnd.length >0 ? targetModel.botherEnd : @"23:00";
//           NSArray *tempArray = [hourString componentsSeparatedByString:@":"];
//           botherSet.startHour = [[tempArray objectAtIndex:0] intValue];
//           botherSet.startMinutes = [[tempArray objectAtIndex:1]intValue];
//           
//           tempArray = [minutesString componentsSeparatedByString:@":"];
//           botherSet.endhour = [[tempArray objectAtIndex:0] intValue];
//           botherSet.endMinutes = [[tempArray objectAtIndex:1] intValue];
//           
//           [callSetData appendBytes:&botherSet length:sizeof(bother_package)];
//           NSLog(@"勿扰模式开始时间%@-%@,data数据%@",hourString,minutesString,callSetData);
//           [self.bleConnectManager sendData:callSetData];
//       }else{
//           [self didReceiveResponse];
//       }
    
}


/**
 *  打开或者关闭相机
 *
 *  @param blean yes 为打开；no 为关闭
 */
- (void)openOrCloseCameraWithBlean:(BOOL)blean{
    NSData *data;
    if(blean){
        data = [[NSData alloc] initWithData:[BleSinglten intTochar:CAMERA_OPEN withReserved:YES]];
        NSLog(@"sendOpenCamera:%@",data);
        
    }else{
        data = [[NSData alloc]initWithData:[BleSinglten intTochar:CAMERA_CLOSE withReserved:YES]];
        NSLog(@"sendCloseCamera:%@",data);
        
    }
    [self.bleConnectManager sendData:data];
}

/**
 *  防丢、短信、电话、微信
 */
- (void)sendMCWSwitchState{
//    UserTargetModel *targetModel = [UserTargetModel getUserTargetInfoDic];
//    if ([targetModel.botherStatus intValue] == 1)
//    {//勿扰模式开启
//    //    NSMutableData *mcwSwitchState = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:MCW_SWITCH_STATE withReserved:YES]];
//    
//    }else{
//        [self didReceiveResponse];
//    }
}
- (void)sendDFUCommond{

    NSData *data = [[NSData alloc] initWithData:[BleSinglten intTochar:DFU_COMMAND withReserved:YES]];
    [self.bleConnectManager sendData:data];
}

- (void)foundMyPhone{
   [self sendSampleCMD:STOP_FIND_PHONE param:nil];
}




/**
 *  运动提醒

-(void)sendSportSettingToBand
{
    NSMutableData *sportSetData = [[NSMutableData alloc]initWithData:[BleSinglten intTochar:MOVE_SET withReserved:YES]];
    
    sport_alert_package sportAlertSetting;
    
    sportAlertSetting.intervalMinutes = 15;
    NSArray *tempArray = [NSArray new];
    BOOL sportSwitch = YES;
    
    NSString * startAMTime = @"8:00";
    tempArray = [startAMTime componentsSeparatedByString:@":"];
    sportAlertSetting.startHour_am = [[tempArray objectAtIndex:0] intValue];
    sportAlertSetting.startMinutes_am = [[tempArray objectAtIndex:1] intValue];
    
    NSString * endAMTime = @"10:00";
    tempArray = [endAMTime componentsSeparatedByString:@":"];
    sportAlertSetting.endhour_am = [[tempArray objectAtIndex:0] intValue];
    sportAlertSetting.endMinutes_am = [[tempArray objectAtIndex:1] intValue];
    
    NSString * startPMTime = @"18:00";
    tempArray = [startPMTime componentsSeparatedByString:@":"];
    sportAlertSetting.startHour_pm = [[tempArray objectAtIndex:0] intValue];
    sportAlertSetting.startMinutes_pm = [[tempArray objectAtIndex:1] intValue];
    NSString * endPMTime = @"20:00";
    tempArray = [endPMTime componentsSeparatedByString:@":"];
    sportAlertSetting.endhour_pm = [[tempArray objectAtIndex:0] intValue];
    sportAlertSetting.endMinutes_pm = [[tempArray objectAtIndex:1]intValue];
    
    
    NSArray *tempArray1 = @[@0,@1,@1,@1,@1,@1,@0];
    NSMutableArray *array1 = [NSMutableArray new];
    int a = [tempArray1.firstObject intValue];
    //日一二三四五六转为日六五四三二一
    for (int j = 1; j< 7; j++) {
        if (j==1) {
            [array1 addObject: tempArray1[j]];
        }else{
            [array1 insertObject:tempArray1[j] atIndex:0];
        }
    }
    [array1 insertObject:[NSNumber numberWithInt:a] atIndex:0];
    //最高位补0,日，六，五，四，三，二，一
    [array1 insertObject:[NSNumber numberWithInt:0] atIndex:0];//无用
    
    char weekDay = 0;
    for (int i = 0; i<array1.count; i++)
    {
        if ([array1[i]  isEqual: @YES])
        {
            int n = array1.count - 1 -i;
            weekDay = weekDay | (([array1[i] charValue] &0xFF) <<n);
        }
    }
    sportAlertSetting.weekForDay = weekDay;
    if (sportSwitch)
    {
        [sportSetData appendBytes:&sportAlertSetting length:sizeof(sport_alert_package)];
    }
    NSLog(@"运动提醒:%@",sportSetData);
    [self.bleConnectManager sendData:sportSetData];
    
}
 */
@end
