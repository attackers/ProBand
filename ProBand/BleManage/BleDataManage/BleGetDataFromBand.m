//
//  BleGetDataFromBand.m
//  BLE_DEMO
//
//  Created by jacy on 14/12/26.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BleGetDataFromBand.h"

#import "BleSendDataToBand.h"
//#import "original_dataManage.h"
#import "BluetoothManage.h"
#import "LocalNotifyManager.h"
#import "PlayAudioManager.h"
@interface BleGetDataFromBand()
{
    t_bluetooth_sourceData _bluetoothSourceData;     //源数据结构体
}



/**
 *  蓝牙MAC地址字符串
 */
@property(nonatomic, strong) NSString *macString;
/**
 *  数据临时存放数组
 */
@property (nonatomic, strong)NSMutableArray *dataSourceArray;

/**
 *  蓝牙连接管理
 */

/**
 *  用于发送一系列数据
 */
@property (nonatomic, strong)BleSendDataToBand *blesendDataToBand;
@end

@implementation BleGetDataFromBand
SINGLETON_SYNTHE

-(id)init
{
    if (self = [super init])
    {
        _dataSourceArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark BLEDataAdaptDelegate methods
/**
 *  APP接收到的数据的处理，包括按包头取出不同类型的有效的数据，
 *
 *  @param data 返回有效数据
 */
- (void)didReceiveDataFromBand:(NSData *)data
{
    if (data == nil || data.length<=0)
    {
        return;
    }
     NSLog(@"接收到的蓝牙数据1 %@",data);
    Wearable_package_t *wearblePackage = (Wearable_package_t *)data.bytes;
    NSData *resultData;
    if ([data length] > 3)
    {
        //有效数据长度 ＝数据总长度减去包头、数据类型、预留位各一个字节
        NSInteger num = [data length] - 3;
        resultData = [[NSData alloc] initWithBytes:wearblePackage->packageData length:num];
    }
    
    
    //NSLog(@"Wearable_package_t_header:%d",wearblePackage->hender);
    // NSLog(@"Wearable_package_t_Type:%d",wearblePackage->type);
    //NSLog(@"Wearable_package_t_reserved:%d",wearblePackage->reserved);
    //NSLog(@"Wearable_package_t_data:%s",wearblePackage->packageData);
    NSLog(@"接收到的蓝牙数据2 %@",resultData);
    /**
     *  根据不同的包头来处理不同的数据,不带ACK回应
     */
    switch (wearblePackage->type)
    {
            
        case RESPOND_MAC_TO_APP://得到mac地址
        {
            [self didReceiveMacAddressFromBand:resultData];
        }
            break;
        case RESPOND_VERSION_ID://得到版本id
        {
            [self didReceiveBandSoftwareVersion:resultData];
        }
            break;
        case RESPOND_BATTERY_LEVER://得到手环电量情况
        {
            [self didReceiveBatteryLeverFromBand:resultData];
        }
            break;
        case RESPOND_TOTAL_STEPS://得到ui显示总步数
        {
            [self didReceiveTotalUiStepfromBand:resultData];
        }
            break;
        case RESPOND_TOTAL_CALORIE://得到ui显示总卡路里数
        {
            [self didReceiveTotalUiCalofromBand:resultData];
        }
        break;
        case RESPOND_TOTAL_SLEEP_TIME://得到ui显示总睡眠数
        {
            [self didReceiveTotaluiSleepTimeFromBand:resultData];
        }
        break;
        case SYNC_DATA_CONFIRM://得到实时步数
        {
            NSLog(@"实时步数 接收完毕");
            
            
           [self didReceiveAllDetailDataFromBand:resultData];
            [self synchronizationDataFinish];//所有手环存储的数据传输完成。
            //[self feedBackDataToBand];
            if(self.getDataFromBandToApp){
                self.getDataFromBandToApp(resultData);
            }
            
        }
          
            break;
        case SPORT_DATA://获取数据
        {
            [self didReceiveAllDetailDataFromBand:resultData];
        }
            break;
        case SYNC_END://数据发送完成
        {
            NSLog(@"数据接收完毕,所有手环存储的数据传输完成");
            [self synchronizationDataFinish];//所有手环存储的数据传输完成。
            [self feedBackDataToBand];
            if(self.getDataFromBandToApp){
                self.getDataFromBandToApp(resultData);
            }
            
        }
            break;
            
        case FIND_PHONE:{//找手机的功能
            [[PlayAudioManager sharedInstance] playAudio:@"carina" audioType:@"aac"];
            NSDictionary* infoDic = @{FIND_IPHONE_NOTIFY:@"find_iphone_notify"};
            [[LocalNotifyManager sharedInstance] pushLocalNotifyAlertBody:@"您的手环正在呼叫您！" alertAction:@"打开" hasAction:YES messageDic:infoDic];
        }
            break;
        case CAMERA_SHUTTER:{//遥控拍照
            
            if(self.getDataFromBandToApp){
                self.getDataFromBandToApp(resultData);
            }
        }
            break;
        default:
            break;
    }
}

/**
 *  ACK回应数据，接收到的数据直接回馈包头即可
 *
 *  @param header 接收到的数据的类型
 *
 *  @return 返回需要ACK回应的数据
 */

-(void)feedBackDataToBand
{
    [[BleSendDataToBand sharedInstance] sendSampleCMD:SYNC_DATA_CONFIRM param:nil];
}

/**
 *  由于IOS系统的限制，在连接上BLE设备后APP主动去请求获得蓝牙MAC地址 ,并持久话该MAC地址以用于BLE设备与帐号的绑定
 *
 *  @param data 获得的原始数据
 */
-(void)didReceiveMacAddressFromBand:(NSData *)data
{
    if (_blesendDataToBand == nil)
    {
        _blesendDataToBand = [BleSendDataToBand sharedInstance];
    }
    
    
    _macString = [NSString stringWithFormat:@"%@",data];
    _macString = [_macString substringWithRange:NSMakeRange(1, [_macString length]-4)];
    _macString = [_macString stringByReplacingOccurrencesOfString:@" " withString:@""];
    _macString = [BleSinglten stringConvertAndInsert:_macString];
    NSLog(@"蓝牙mac地址～～～～%@",_macString);
    [BleSinglten setIDValue:_macString withKey:@"COLORBANDMACADDRESS"];
    /**
     *持久话重连Identifier
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVERECONNECTIDENTIFIER object:nil];

    /**
     *  使用接口绑定后，则继续使用状态机的形式来发送数据.
    _blesendDataToBand.state = BLE_GETVERSION_ID;
    [_blesendDataToBand didReceiveResponse];
     */
}

/**
 *  获取BLE设备的版本号 并持久化
 *
 *  @param data 接收到的源数据
 */
-(void)didReceiveBandSoftwareVersion:(NSData *)data
{
    Byte *testByte = (Byte *)[data bytes];
    NSMutableString *str = [NSMutableString new];
    for(int i=0;i<[data length];i++){
        printf("testByte = %d\n",testByte[i]);
        int num = testByte[i];
        if (i<9) {
            if (num>16) {
                [str appendFormat:@"%c",testByte[i]];
                NSLog(@"本信息～～～～～～%@",str);
            }else{
                [str appendFormat:@"%d",num];
                NSLog(@"软件版本信息～～～～～～%@",str);
            }

        }else{
            break;
        }
    }
    NSLog(@"软件版本信息～～～～～～%@",str);
    [BleSinglten setIDValue:str withKey:BANDSOFTWAREVERSIONFROMBAND];
}
/**
 *  得到手环电量情况
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveBatteryLeverFromBand:(NSData *)data{
    NSLog(@"手环电量信息～～～～～～%@",data);
}

/**
 *  获取BLE设备上的总步数
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotalUiStepfromBand:(NSData *)data
{
    UInt32 allsteps = 0;
    
    [data getBytes:&allsteps range:NSMakeRange(2, 2)];
    allsteps = (allsteps & 0xFF)<<8 | (allsteps >>8);
    allsteps = allsteps & 0x7FFF;
    NSLog(@"BLE设备上的总步数~~~~~~~~%ld",allsteps);
    [BleSinglten setIDValue:[NSString stringWithFormat:@"%ld",allsteps] withKey:UITODAYALLSTEPS];
}

/**
 *  获取BLE设备上总的卡路里
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotalUiCalofromBand:(NSData *)data
{
    UInt32 calo = 0;
    [data getBytes:&calo range:NSMakeRange(2, 2)];
    calo = (calo & 0xFF)<<8 | (calo >>8);
    calo = calo & 0x7FFF;
    NSLog(@"~~~BLE设备上总的卡路里~%ld",calo);
    [BleSinglten setIDValue:[NSString stringWithFormat:@"%ld",calo] withKey:UITODAYALLCALO];
}

/**
 *  获取BLE设备上总的睡眠数
 *
 *  @param data 接收到的原始数据(数据对于大小端存储要做处理)
 */
- (void)didReceiveTotaluiSleepTimeFromBand:(NSData *)data{

}
//实时计步数据
- (void)didReceiveRealTimeStepFromBand:(NSData *)data
{
   
  
}

/**
 *  获取手环详细
 *
 *  @param data 获取手环详细信息，计步睡眠
 */
- (void)didReceiveAllDetailDataFromBand:(NSData *)data
{

    UInt8 year = 0;
    UInt8 month = 0;
    UInt8 day = 0;
    UInt8 hour = 0;
    UInt8 minutes = 0;
    UInt8 type = 0;
    UInt16 count = 0;
    
    NSLog(@"返回运动数据 %@ length=%lu",data,(unsigned long)data.length);
    int start=0;
    if(data.length==8)
    {start=1;
    }
    [data getBytes:&year range:NSMakeRange(start, 1)];  //得到年份
    
    [data getBytes:&month range:NSMakeRange(start+1, 1)];
    
    [data getBytes:&day range:NSMakeRange(start+2, 1)];
    
    [data getBytes:&hour range:NSMakeRange(start+3, 1)];
    
    [data getBytes:&minutes range:NSMakeRange(start+4, 1)];
    
    [data getBytes:&type range:NSMakeRange(start+5, 1)];//后两个字节首位为数据类型，剩余为值
    //得到消息类型0为计步、1为睡眠
    type = type >> 7;
    [data getBytes:&count range:NSMakeRange(start+5, 2)];
    count = (count & 0xFF)<<8 | (count >>8); //高地位调换
    count = count & 0x7FFF;
    
  NSLog(@"日期 %d-%d-%d %d:%d 类型 %d,  %d",year,month,day,hour,minutes,type,count);
     int icount=[[NSString stringWithFormat:@"%d",count] intValue];
    if (icount ==0) {
        NSLog(@"步数为0 不处理");
        return;
    }
    if (icount>5000) {
        NSLog(@"步数>5000不处理");
        return;
    }
    //取出低15个字节
    int iyear=[[NSString stringWithFormat:@"%d",year] intValue];
    
    
    iyear=iyear+2000;
    
    
    NSString *time = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d",iyear,month,day,hour,minutes];
    
    NSLog(@"time=%@",time);
    //UTC时间转本地时间
   // NSString *date = [BleSinglten getNowDateFromatAnDate:time];
   // NSLog(@"date=%@",date);
    
    _bluetoothSourceData.sourceYear = year;
    _bluetoothSourceData.sourceMonth = month;
    _bluetoothSourceData.sourceDay = day;
    _bluetoothSourceData.sourceHour = hour;
    _bluetoothSourceData.sourceMinutes = minutes;
    _bluetoothSourceData.sourceCount = count;
    //所有数据全部插入数据库
    int currentYear =  [[PublicFunction getCurYear] intValue];
    if (iyear <= currentYear && iyear>currentYear-2)//从2015.1月开始且过滤大于当前年份的数据
        
    {
       
       /*
        [_dataSourceArray addObject:@{  
                                        @"date":[time componentsSeparatedByString:@" "][0],
                                        @"time":time,
                                        @"count":[NSString stringWithFormat:@"%d",count],
                                        @"type":[NSString stringWithFormat:@"%d",type]}];
        */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //插入某一条数据，若存在则更新:by Star
            NSString *sqlExist = [NSString stringWithFormat:@"select count(*) from t_original_data where userid = '%@' and time='%@'",[Singleton getUserID],time];
            BOOL exist = [DBOPERATOR checkTheDataExistOnDB:sqlExist];
            if (!exist) {
                NSString *insertSql =[NSString stringWithFormat:@"INSERT INTO  t_original_data (userId,flag,date,count,type,time)  VALUES ('%@','%@','%@','%@','%@','%@') ",[Singleton getUserID],@"0",[time componentsSeparatedByString:@" "][0],[NSString stringWithFormat:@"%d",count],[NSString stringWithFormat:@"%d",type],time];
                [DBOPERATOR insertDefaultDataToSQL:insertSql];
            }
        });
        
   
        
        
    }
    
    
    
}



/**
 *  同步数据完成,写入数据库
 */
-(void)synchronizationDataFinish
{
    if ([_dataSourceArray count] > 0)
    {
        //[DBOPERATOR insertToDB:@"t_original_data" withDicNeedAdd:@{@"userId":[Singleton getUserID]} withValue:_dataSourceArray withkey:@"time"];
        
         //[original_dataManage insertWithArray:_dataSourceArray];
        //[_dataSourceArray removeAllObjects];
        //将数据按日合并 保存到数据库
//        [AlgorithmHelper updateAllData];
//        
//        [original_dataManage updateAllFlag];//将数据标记已经合并保存
        
    }
    else
    {
        NSLog(@"没有新的数据");
    }
    [PublicFunction hiddenHUD];
}





@end

