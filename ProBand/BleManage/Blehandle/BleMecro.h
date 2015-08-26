//
//  BleMecro.h
//  BLE_DEMO
//
//  Created by jacy on 14/12/25.
//  Copyright (c) 2014年 fenda. All rights reserved.
//


/**
 *  服务uuid
 */
#define BLETRANSFER_CHARARCTERISTIC_SERVICE_UUID   @"6e400001-b5a3-f393-e0a9-e50e24dcca9f"
/**
 *  写特性uuid，写入数据
 */
#define BLETRABSFER_CHARARCTERISTIC_WRITE_UUID     @"6e400002-b5a3-f393-e0a9-e50e24dcca9f"
/**
 *  读特性uuid，读出数据
 */
#define BLETRABSFER_CHARARCTERRISTIC_RADE_UUID    @"6e400003-b5a3-f393-e0a9-e50e24dcca9f"

/**
 *  持久化手环连接状态
 */
#define BTLECONNECTSTATE            @"BTLEConnectState"

/**
 *  用于持久化已连接设备生成的UUID，是唯一的
 */
#define BLEConnectedPeripheralUUID  @"BLEConnectedPeripheralUUID"
/**
 *  连接成功或者失败发起通知
 */
#define BTLECONTECTSUCCESSORFAILNOYIFY  @"BTLEContectSuccessOrFailNotify"

/**
 * 从手环端读取的软件版本
 */
#define BANDSOFTWAREVERSIONFROMBAND            @"bandSoftwareVersionFromBand"

/**
 * BLE设备与APP连接握手协议
 */
#define BLE_CONNECT_CHECKOUTKEY_STRING    @"fendaxlab"

/**
 *   UI显示总步数
 */
#define UITODAYALLSTEPS                  @"todayAllSteps"
/**
 *  UI显示总卡路里
 */
#define UITODAYALLCALO                   @"todayAllCalo"

/**
 *持久话重连Identifier
 */
#define SAVERECONNECTIDENTIFIER          @"saveReconnectIdentifier"

/**
 寻找手机
 */
#define FIND_IPHONE_NOTIFY               @"find_iphone_notify"

/**
 控制alert弹出的次数,避免多次弹出
 */
#define ALERTINFO_POPBOX                 @"alertInfo_popBox"

/**
 *蓝牙设备名称
 */
#define BANDNAME                         @"ANCS_BAI"



#define ISCAMERA                         @"IsCamera"//是否处于拍照模式

/**
 *是否进入dfu升级模式
 */
#define ENTER_DFU_MODE                   @"Enter DFU mode"

/**
 * DFU升级文件名
 */
#define BANDSOFTWAREVERSIONFROMVERSION_FULL    @"VB10 V00.00.07.hex"
/**
 *蓝牙交互的协议头
 */

/*数据格式：
 +---------------+-------------------------------+
 |消息类型	|数据				|
 +---------------+-------------------------------+
 */
/*

#define  NOTICE_INCALL             	0x01 //二包:  数据内容 ：{消息头标志（0xBB,0x11）+消息内容【手机号/联系人（32个字节）】}
#define  NOTICE_SHORT_MESSAGE           0x02 //分多包:数据内容 ：{消息头标志（0xBB,0x22）+消息内容【标题（24个字节）内容（32个字节）】}
#define  NOTICE_WECAT_MESSAGE           0x03 //分多包:数据内容 ：{消息头标志（0xBB,0x33）+消息内容【标题（18个字节）内容（32个字节）】}
#define  NOTICE_TWITTER_MESSAGE         0x08 //分多包:数据内容 ：{消息头标志（0xBB,0x44）+消息内容【标题（18个字节）内容（32个字节）】}
#define  NOTICE_FACEBOOK_MESSAGE        0x09 //分多包:数据内容 ：{消息头标志（0xBB,0x55）+消息内容【标题（18个字节）内容（32个字节）】}
#define  NOTICE_WHATSAPP_MESSAGE        0x14 //分多包:数据内容 ：{消息头标志（0xBB,0x66）+消息内容【标题（18个字节）内容（32个字节）】}


#define  NOTICE_ALERT_CLOCK		0x04

#define  CALL_END		 	0x06 //phone-->dev
#define  CALL_LOST                      0x07 //不进行处理
#define  CALL_MUTE                      0x10 //电话静音 （安卓）
#define  CALL_REJECT                    0x11 //电话拒接  （安卓）
#define  IOS_CALL_SET                   0x12 //来电开始和结束设置


#define  NOTICE_CITY                    0x13 //推送城市名
#define  NOTICE_WEAHTER                 0x05 //推送天气

//camera&music events:  from 0x21 to 0x2f        // 0x20 reserve
#define CAMERA_OPEN		        0x21  //相机打开
#define CAMERA_CLOSE 		    	0x22  //相机关闭
#define CAMERA_SHUTTER			0x23  //拍照


//local events:  from 0x31 to 0x5f        // 0x30 reserve


#define	  DATE_TIME_SET		         0x31   //全部使用UTC时间，添加时区。
#define   FIND_PHONE		         0x32   //寻手机
#define   ALERM_SET                      0x33	//闹钟设置
#define   KEY_APP                        0x34    //去掉

#define   PERSONAL_PROFILE               0x35	//个人信息
#define   PHONE_LOST                     0x36   //手机APP校验
#define   MOVE_SET                       0x37	//久坐设置


#define   DFU_COMMAND                    0x39   //升级
#define   MUTE_LOSTPHONE                 0x3a   //没有暂时
#define   STOP_FIND_PHONE		 0x3c  // 停止寻找手机
#define   AUTO_ENTER_SLEEP               0x3d   //自动进入睡眠设置

#define   SYSTEM_RECOVER                 0x3e   //去掉
#define   SYSTEM_SET_DEFAULT		 0x3f   //去掉
#define   DATA_STOREIN_LOCAL(ios)	 0x40   //IOS APP被干掉
#define   SCREEN_HIGH_LIGHT              0x41   //去掉

#define   SCREEN_DARK_LIGHT              0x42   //去掉
#define   ACTIVE_GESTURE_MODE            0x43   //去掉
#define   CANCLE_GESTURE_MODE            0x44   //去掉
#define   PERSONAL_GOAL	                 0x45   //个人目标

#define   PHONE_ACTIVE_DISCONNECT        0x46   //APP主动断开
#define   APP_SEND_HISTORE_DATA          0x47   //去掉
#define   APP_SET_WRISTBAND_INTO_SAVING_POWER  	0x48 //去掉
#define   APP_SET_WRISTBAND_ENTER_POWER_OFF  	0x49 //去掉

#define   APP_SET_LOST_SWITCH_ON             	0x4a //去掉
#define   APP_SET_LOST_SWITCH_OFF  		0x4b //去掉


//Get the local imformation from 0x60 to 0x7f
#define   GET_NRF_BDADDR(ios)           0x61  //获取手环地址
#define   GET_VERSION_ID                0x62  //获取手环版本
#define   GET_BATTERY_LEVER             0x63  //获取电池电量
#define   GET_ST_VERSION                0x64  //获取ST版本这里可以变成获取NRF版本

#define   GET_SPROT_REMINDER		0x65  //获取运动提醒
#define   GET_AUTO_SLEEP_TIME		0x66  //获取自动进入睡眠时间
#define   GET_ALARM			0x67  //获取闹钟设置
#define   GET_USERINFO			0x68  //获取个人信息

#define   GET_BRACELET_TIME		0x69  //获取手环时间
#define   GET_TOTAL_STEPS		0x6a  //获取手环步数
#define   GET_TOTAL_CALORIE		0x6b  //获取手环卡路里


#define	  GET_TOTAL_SLEEP_TIME		0x6c  //获取手环睡眠时间


//respond for the command from 0x80 to 0x9f //下面是对应的回复
#define   RESPOND_MAC_TO_APP(ios)           0x81
#define   RESPOND_VERSION_ID                0x82
#define   RESPOND_BATTERY_LEVER             0x83
#define   RESPOND_ST_VERSION                0x84

#define	  RESPOND_SPORT_REMINDER	    0x85
#define   RESPOND_AUTO_SLEEP_TIME	    0x86
#define   RESPOND_ALARM			    0x87
#define   RESPOND_USER_INFO		    0x88

#define   RESPOND_DEVICE_TIME		    0x89
#define   RESPOND_TOTAL_STEPS		    0x8a
#define   RESPOND_TOTAL_CALORIE		    0x8b
#define	  RESPOND_TOTAL_SLEEP_TIME	    0x8c

//sport imformation  from 0xa0 to 0xaf
#define UPDATE_DATA_WHEN_WRISTBAND_CONNECTED        0xa1 //去掉
#define UPDATE_DATA_REQUEST   			    0xa2 //获取历史运送数据
#define UPDATE_DATA_REQUEST_TODAY   		    0xa3 //获取特定时间运动数据
#define UPDATE_DATA   		        	    0xa4 //运动数据
#defein UPDATE_END                      	    0xa5// 数据发送完成

//Test command from 0xb0 to 0xcf
#define SENSOR_ORI_DATA_GET                 0xb1
#define RESPOND_SENSOR_ORI_DATA             0xb2
#define MOTO_ENABLE			    0xb3
#define MOTO_DISBALE                        0xb4
*/

typedef enum
{
      AllPACK_HEADER                        = 0xCC,//所有数据的包头
      SET_RESERVED                          = 0x00,//预留位
      NOTICE_INCALL              	        = 0x01, //二包:  数据内容 ：{消息头标志（0xBB,0x11）+消息内容【手机号/联系人（32个字节）】}
      NOTICE_SHORT_MESSAGE                  = 0x02, //分多包:数据内容 ：{消息头标志（0xBB,0x22）+消息内容【标题（24个字节）内容（32个字节）】}
      NOTICE_WECAT_MESSAGE                  = 0x03, //分多包:数据内容 ：{消息头标志（0xBB,0x33）+消息内容【标题（18个字节）内容（32个字节）】}
      NOTICE_ALERT_CLOCK                    = 0x04,//同步闹钟设置√
      NOTICE_WEAHTER                        = 0x05,//推送天气
      CALL_END                              = 0x06, //phone-->dev
      CALL_LOST                             = 0x07,//不进行处理
      NOTICE_TWITTER_MESSAGE                = 0x08, //分多包:数据内容 ：{消息头标志（0xBB,0x44）+消息内容【标题（18个字节）内容（32个字节）】}
      NOTICE_FACEBOOK_MESSAGE               = 0x09, //分多包:数据内容 ：{消息头标志（0xBB,0x55）+消息内容【标题（18个字节）内容（32个字节）】}
      CALL_MUTE                             = 0x10,//电话静音 （安卓）
      CALL_REJECT                           = 0x11,//电话拒接  （安卓）
      IOS_CALL_SET                          = 0x12,//勿扰模式开始和结束时间设置√
      NOTICE_CITY                           = 0x13,//推送城市名√
    
    
      CAMERA_OPEN                           = 0x21,//相机打开√
      CAMERA_CLOSE                          = 0x22,//相机关闭√
      CAMERA_SHUTTER                        = 0x23,//拍照√
    
    
      DATE_TIME_SET                         = 0x31,//全部使用UTC时间，添加时区。√
      MCW_SWITCH_STATE                      = 0x32,//短信开关状态、来电开关状态、微信开关状态
      ALERM_SET                             = 0x33,//闹钟设置√
      APP_KEY                               = 0x34,//√
    
      USER_INFO                             = 0x35,//同步用户信息√
      SOS                                   = 0x36,//手机防丢√
      MOVE_SET                              = 0x37,//同步运动提醒设置信息
    
      DFU_COMMAND                           = 0x39,//DFU升级
      MUTE_LOSTPHONE                        = 0x3a,//没有暂时
      FIND_PHONE                            = 0x3b,//找手机√
      STOP_FIND_PHONE                       = 0x3c,//停止寻找手机
      AUTO_ENTER_SLEEP                      = 0x3d,//同步睡眠设置√
    
      PHONE_LOST                            = 0x3e,//手机防丢√
      DATA_STOREIN_LOCAL                    = 0x40,//IOS APP被干掉?
      PERSONAL_GOAL                         = 0x45,//个人目标√
      PHONE_ACTIVE_DISCONNECT               = 0x46,//APP主动断开
    
      //Get the local imformation from 0x60 to 0x7f
      GET_NRF_BDADDR                        = 0x61,//获取手环地址(IOS)√
      GET_VERSION_ID                        = 0x62,//获取手环版本√
      GET_BATTERY_LEVER                     = 0x63,//获取手环电池电量√
      GET_ST_VERSION                        = 0x64,//获取ST版本这里可以变成获取NRF版本，获取手环固件的版本
    
      GET_SPROT_REMINDER                    = 0x65,//
      GET_AUTO_SLEEP_TIME                   = 0x66,//
      GET_ALARM                             = 0x67,//
      GET_USERINFO                          = 0x68,//
      GET_BRACELET_TIME                     = 0x69,
    
      GET_TOTAL_STEPS                       = 0x6a,//获取手环步数√
      GET_TOTAL_CALORIE                     = 0x6b,//获取手环卡路里√
      GET_TOTAL_SLEEP_TIME                  = 0x6c,//获取手环睡眠时间√
    
      MUSIC_VOL_ADD                         = 0x71,
      MUSIC_VOL_DES                         = 0x72,
      MUSIC_NEXT                            = 0x73,
      MUSIC_PRE                             = 0x74,
      MUSIC_PLAY_PAUSE                      = 0x75,

    //0x80 --- 0x9f,下面是对应的回复
      RESPOND_MAC_TO_APP                    = 0x81,//IOS
      RESPOND_VERSION_ID                    = 0x82,//√
      RESPOND_BATTERY_LEVER                 = 0x83,//√
      RESPOND_ST_VERSION                    = 0x84,
        
      RESPOND_SPORT_REMINDER                = 0x85,
      RESPOND_AUTO_SLEEP_TIME               = 0x86,
      RESPOND_ALARM                         = 0x87,
      RESPOND_USER_INFO                     = 0x88,
        
      RESPOND_DEVICE_TIME                   = 0x89,
      RESPOND_TOTAL_STEPS                   = 0x8a,//√
      RESPOND_TOTAL_CALORIE                 = 0x8b,
      RESPOND_TOTAL_SLEEP_TIME              = 0x8c,
        
      //sport imformation  from 0xa0 to 0xaf
      SYNC_DATA_CONFIRM                     = 0xa1,//ACK回应数据，接收到的数据直接回馈包头即可
      SYNC_DATA_REQUEST    			        = 0xa2,//获取数据√
      UPDATE_DATA_REQUEST_TODAY             = 0xa3,//获取特定时间运动数据
      SPORT_DATA     		        	    = 0xa4,//回复：运动数据√
      SYNC_END                      	    = 0xa5,//数据发送完成√
      SLEEP_DATA                            = 0xa6,//睡眠数据

    
    
    //Test command from 0xb0 to 0xcf
      SENSOR_ORI_DATA_GET                   = 0xb1,
      RESPOND_SENSOR_ORI_DATA               = 0xb2,
      MOTO_ENABLE                           = 0xb3,
      MOTO_DISBALE                          = 0xb4,
      UNKNOWN                               = 0xff,
    
    
}WEARABLE_PACKAGEHEADER;

#pragma pack(1)

/**
 *  顺序化的通过蓝牙发送给手环设置数据时的判断
 */

typedef NS_ENUM(NSInteger, BleAssistMessageState)
{
    //初始化状态
    BLE_INIT,//？
    
    //得到蓝牙MAC地址
    BLE_GETMACADDRESS,
    
    //得到手环软件的版本
    BLE_GETVERSION_ID,
    
    // 得到手环固件的版本
    BLE_GETSTVERSION,
    
    //获取手环电量
    BLE_BATTERY_LEVER,
    
    //获取ui显示总步数
    BLE_GETTOTAL_STEPS,
    
    //获取ui显示总卡路里数
    BLE_GETTOTAL_CALORIE,
    
    //获取ui显示总睡眠数
    BLE_TOTAL_SLEEP_TIME,
    
    //获取手环数据请求
    BLE_DATA_REQUEST,
    
    //同步日期时间
    BLE_SEND_DATETIME,
    
    //同步个人信息
    BLE_SEND_USERINFO,
    
    //同步个人目标设置
    BLE_SEND_PERSONAL_GOAL,
    
    //同步防丢开关状态
    BLE_SEND_LOSTSWICTCH,
    
    //同步睡眠设置信息
    BLE_SEND_AUTOSLEEP,
    
    //同步闹钟
    BLE_SEND_ALARM,
    
    //同步天气
    BLE_SEND_WEATHER,
    
    //同步城市名称
    BLE_SEND_CITY,
    
    //同步勿扰模式时间
    BLE_SEND_DISTRUBTIME,
    
    //同步短信、电话、微信开关状态
    BLE_MCW_SWITCH_STATE,
    
    //同步运动提醒
    BLE_SEND_SPORTSETTING,//X
    
    //同步短信
    BLE_SEND_MESSAGE,//X
    
    //同步微信／twitter/facebook
    BLE_SEND_CHAT_MESSAGE,//X

    //手环高亮开关
    BLE_HIGHTLIGHT,//X
    
    //转腕亮屏开关
    BLE_GESTURE_MODE,//X
    
    //蓝牙处于空闲状态
    BLE_IDLE,
};
//**********************************发送到BLE设备的数据结构体********************************
/**
 *  同步时间格式
 */
typedef struct _synchronism_dateAndTime
{
    UInt8 yesr;
    UInt8 month;
    UInt8 date;
    UInt8 hour;
    UInt8 minute;
    UInt8 seconds;
}synchronism_dateAndTime;
/**
 *  用户信息
 */
typedef struct _user_Info_Data
{
    UInt8 height ;
    UInt8 weight ;
}user_Info_data;

//个人目标
typedef struct _user_goal_Data
{
    UInt16  stepGoal;
    UInt16  calorieGoal;
    UInt16  distance;
    UInt16  sleepGoal;
}user_goal_data;

//按钮状态
typedef struct _switch_state
{
    
    UInt8 pageType;
    UInt8 markState;
    
}switch_state;

/**
 *  睡眠提醒
 */
typedef struct _sleep_package
{
    UInt8 startHour;
    UInt8 startMinutes;
    UInt8 endhour;
    UInt8 endMinutes;
    
}sleep_package;

//用户闹钟
typedef struct _user_Alarm
{
    UInt8 alarmID;
    UInt8 alarmHour;
    UInt8 alarmMinutes;
    UInt8 alarmDayofweek;
    
}user_Alarm;
/**
 *  天气信息
 */
typedef struct _weather_package
{
    UInt8 weatherType;
    UInt8 fahrenheit;//华氏温度
    UInt8 centigrad;//摄氏温度
    UInt8 pm25;
    
}weather_package;

/**
 *  城市信息
 */
typedef struct _city_package
{
    char cityName[17];
    
}city_package;

/**
 *  勿扰模式
 */
typedef struct _bother_package
{
    UInt8 startHour;
    UInt8 startMinutes;
    UInt8 endhour;
    UInt8 endMinutes;
    
}bother_package;
//**********************************发送到BLE设备的数据结构体********************************

//**********************************BLE设备发送过来的源数据包结构体********************************
/**
 *  BLE设备发送过来的源数据包
 */
typedef struct _wearable_package
{
    UInt8 hender;
    UInt8 type;
    UInt8 reserved;
    char packageData[];
    
}Wearable_package_t;
/**
 *  借助结构体来取出特定的字节序
 */
typedef struct _t_bluetooth_sourceData
{
    UInt8  sourceYear;
    UInt8   sourceMonth;
    UInt8   sourceDay;
    UInt8   sourceHour;
    UInt8   sourceMinutes;
    UInt8   sourceType;
    UInt16   sourceCount;
    float   sourceCal;
    float   sourceDistance;
    char    *localTime;
    double  intervalTIme;
}t_bluetooth_sourceData;
//**********************************BLE设备发送过来的源数据包结构体********************************



//运动提醒
/*
typedef struct _sport_alert_package
{
    UInt8   intervalMinutes;
    UInt8   startHour_am;
    UInt8   startMinutes_am;
    char    weekForDay;
    UInt8   endhour_am;
    UInt8   endMinutes_am;
    UInt8   startHour_pm;
    UInt8   startMinutes_pm;
    UInt8   endhour_pm;
    UInt8   endMinutes_pm;
    
}sport_alert_package;
*/
