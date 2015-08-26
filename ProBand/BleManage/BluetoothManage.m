//
//  BluetoothManage.m
//  iiTagBluetooth
//
//  Created by shi hu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

#import "BluetoothManage.h"
#import "DefaultValueManage.h"
#import "PublicFunction.h"
#import "BleGetDataFromBand.h"
#import "BleSendDataToBand.h"
#import "BleSinglten.h"

@interface BluetoothManage()
{

}
@property (nonatomic, strong)BleGetDataFromBand *getDataFromBand;
@property (nonatomic,strong) NSMutableArray *RSSIArray;
@property (nonatomic,strong) NSMutableArray *DeviceNameArray;
@end
@implementation BluetoothManage
//SINGLETON_SYNTHE

@synthesize foundPeripheralAddress;
@synthesize foundPeripherals;
@synthesize connectedServices;

@synthesize serviceUUIDString;
@synthesize connectedPeripheral;
@synthesize PeripheralAddress;
@synthesize TimerReadRSSI;
@synthesize centralManager;
@synthesize writeCharacteristic;


+ (id) sharedInstance2
{
	static BluetoothManage	*this	= nil;
	if (!this)
		this = [[BluetoothManage alloc] init];
	return this;
}
+ (id)sharedInstance
{
    static BluetoothManage	*this= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                     this = [[self alloc]init];
                  });
    return this;
}

- (id) init
{
    self = [super init];
    if (self)
    {
     
        
		pendingInit = YES;
		//centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.centralManager.delegate=self;
        self.foundPeripheralAddress = [[NSMutableArray alloc] init];
		self.foundPeripherals = [[NSMutableArray alloc] init];
		connectedServices = [[NSMutableArray alloc] init];
        _RSSIArray=[[NSMutableArray alloc] init];
        _DeviceNameArray=[[NSMutableArray alloc] init];
         _getDataFromBand = [BleGetDataFromBand sharedInstance];
	}
    return self;
}
- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals %@",peripherals);
	//CBPeripheral	*peripheral=(CBPeripheral*)[peripherals objectAtIndex:0];
	CBPeripheral	*peripheral=nil;
	/* Add to list. */
	for (peripheral in peripherals) 
    {
        NSLog(@"connectPeripheral");
        if (peripheral==self.connectedPeripheral) 
        {
            //self.connectedPeripheral=[peripheral retain];
            [self connectPeripheral:peripheral];
        }
		
	}
    NSLog(@"reload4");
}

- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didRetrievePeripheral");
	[self connectPeripheral:peripheral];
    NSLog(@"reload5");
	
}

- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
    NSLog(@"didFailToRetrievePeripheralForUUID");
	/* Nuke from plist. */
	//[self removeSavedDevice:UUID];
}
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    static CBCentralManagerState previousState = -1;
    
    NSLog(@"centralManagerDidUpdateState");
    switch ([self.centralManager state])
    {
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");
            [self clearDevices];
            self.isConnectedBLE=NO;
            /* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1) {
                // [discoveryDelegate discoveryStatePoweredOff];
            }
            break;
        }
        case CBCentralManagerStateUnauthorized:
        { NSLog(@"CBCentralManagerStateUnauthorized");
            /* Tell user the app is not allowed. */
            break;
        }
        case CBCentralManagerStateUnknown:
        { NSLog(@"CBCentralManagerStateUnknown");
            /* Bad news, let's wait for another event. */
            break;
        }
        case CBCentralManagerStatePoweredOn:
        { NSLog(@"CBCentralManagerStatePoweredOn");
            pendingInit = NO;
            
            if ([BleSinglten getIDFromKey:BLEConnectedPeripheralUUID] != nil)
            {
                [self loadSavedDevices];
            }
         // [self startScanning];
            
            break;
        }
        case CBCentralManagerStateResetting:
        { NSLog(@"CBCentralManagerStateResetting");
            //[self clearDevices];
            // [self.delegate alarmServiceDidReset];
            pendingInit = YES;
            break;
        }
    }
    previousState = [self.centralManager state];
}
- (void) startAutoScan
{
    AutoScan=YES;
    self.serviceUUIDString=SERVICE_UUID;
}
- (void) startScan
{
    AutoScan=NO;
    self.serviceUUIDString=SERVICE_UUID;
}
- (void) scanBle
{
    AutoScan=NO;
    self.serviceUUIDString=SERVICE_UUID;
    [self startScanning];
}
- (void) scanBleAuto
{
    if (device_picker)
    {
     device_picker = nil;
        
    }
    
    AutoScan=YES;
    self.serviceUUIDString=SERVICE_UUID;
    [self startScanning];
}
- (void) startScanning
{
  
        NSLog(@"startScan");
       
        
        if (self.connectedPeripheral)
        {
            if (self.connectedPeripheral.state== CBPeripheralStateConnected)
            {
                [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
            }
         
            self.connectedPeripheral=nil;
        }
       
        [self clearDevices];//清理前一次搜索到的蓝牙设备
        
        if (!AutoScan)
        {
            if (!device_picker)
            {
                device_picker = [[AlertTableView alloc] initWithCaller:self data:nil title:@"Choose Device" andContext:nil];
                [device_picker show];
                 [device_picker setFrame:CGRectMake((SCREEN_WIDTH-300)/2, (SCREEN_HEIGHT-420)/2, 300, 420)];
            }
            
        }
        else
        {
            
            
        }
        NSLog(@"start Scan for %@",self.serviceUUIDString);
   
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUIDString]] options:nil];
    
}

// handle choice of device from picker
-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context
{
    NSLog(@"%@", [NSString stringWithFormat:@"Index %d clicked %@", row,context]);
    
    if (row>=0) 
    {
        NSLog(@"11");
        //CBPeripheral	*peripheral;
        //NSArray			*devices;
        if ([self.foundPeripherals count]>0) 
        {  
            NSLog(@"1111");
            NSLog(@"foundPeripheralAddress=%@",self.foundPeripheralAddress);
            if (row<[self.foundPeripheralAddress count]) {
                [DefaultValueManage savePeripheral:[self.foundPeripheralAddress objectAtIndex:row]];
                self.PeripheralAddress=[self.foundPeripheralAddress objectAtIndex:row];
                NSLog(@"selectPeripheralAddress=%@",self.PeripheralAddress);
                self.connectedPeripheral = (CBPeripheral*)[self.foundPeripherals objectAtIndex:row];//(CBPeripheral*)
            }
            [self.connectedPeripheral setDelegate:self];
            //if (![peripheral isConnected]) 
            //{
                if (self.connectedPeripheral&&self.connectedPeripheral.state== CBPeripheralStateConnected)
                {
                    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
                }
                [self connectPeripheral:self.connectedPeripheral];
                NSLog(@"[foundPeripheralAddress=%@",self.foundPeripheralAddress);
            //}
        }
    }
    
     device_picker = nil;
    [self stopScanDevice];
}
- (void) stopScanDevice
{
    NSLog(@"stopscan");
    
	[self.centralManager stopScan];
}
-(CBPeripheral *)getMaxRSSIperipheral
{
    if (self.foundPeripherals.count>0)
    {
        NSNumber * max = [self.RSSIArray valueForKeyPath:@"@max.intValue"];
        NSInteger idx = [self.RSSIArray indexOfObject:max];
        CBPeripheral *peripheral=[self.foundPeripherals objectAtIndex:idx];
        return peripheral;
    }
    return nil;
}
-(NSString  *)getMaxRSSIperipheralName
{
    if (self.foundPeripherals.count>0)
    {
        NSNumber * max = [_RSSIArray valueForKeyPath:@"@max.intValue"];
        NSInteger idx = [_RSSIArray indexOfObject:max];
        return [_DeviceNameArray objectAtIndex:idx];
    }
    return @"";
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral self.serviceUUIDString=%@",self.serviceUUIDString);
    NSLog(@"advertisementData=%@",advertisementData);
    NSString *address=[NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataManufacturerData"]];
    if (address==nil)  { NSLog(@"address is nil");}
    
    if (![self.foundPeripherals containsObject:peripheral])
    { 
        if (peripheral!=self.connectedPeripheral)
        {
            if(!self.foundPeripherals)
         {
          self.foundPeripherals=[[NSMutableArray alloc] init];
         }
            [self.foundPeripherals addObject:peripheral];
            [self.foundPeripheralAddress addObject:address];
            [_RSSIArray addObject:RSSI];
            [_DeviceNameArray addObject:[NSString stringWithFormat:@"%@ %@",peripheral.name,RSSI]];
        }
    }
    if (!AutoScan) 
    {
       
        [device_picker addListItem:[NSString stringWithFormat:@"%@ %@",peripheral.name,RSSI]];
       
     
    }
        NSLog(@"reload6 RSSI=%@",RSSI);
        if (AutoScan) 
        { 
            NSLog(@"is autoscan");
           // NSArray *savePeripheral=[DefaultValueManage getSavePeripheral];
            NSLog(@"address=%@  self.PeripheralAddress=%@",address,self.PeripheralAddress);
            //NSLog(@"savePeripheral=%@",savePeripheral);
            if ([address isEqualToString:self.PeripheralAddress]) 
            { 
                //self.connectedPeripheral=[peripheral retain];
                
                [self.centralManager stopScan];
                NSLog(@" containsObject address");
                if (self.connectedPeripheral.state!= CBPeripheralStateConnected)
                {      if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
                   {
                    [self.delegate showReturnStatus:@"Find" address:self.PeripheralAddress];
                   }
                    [self connectPeripheral:peripheral];
                }
            }
            else 
            {
                NSLog(@"not containsObject address");
                NSArray *savePeripheral=[DefaultValueManage getSavePeripheral];
                if ([savePeripheral count]==0) 
                {
                    if (!device_picker) 
                    {
                        device_picker = [[AlertTableView alloc] initWithCaller:self data:nil title:@"Choose Device" andContext:nil];
                        // show the picker
                        [device_picker show];
                          [device_picker setFrame:CGRectMake((SCREEN_WIDTH-300)/2, (SCREEN_HEIGHT-420)/2, 300, 420)];
                    } 
                    [device_picker addListItem:[NSString stringWithFormat:@"%@ %@",peripheral.name,address]];
                }
            }
        }
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"connectPeripheral");
   
   if (peripheral.state!= CBPeripheralStateConnected)
    {
        NSLog(@"connecting Peripheral");
        [self.centralManager stopScan];
        
		[self.centralManager connectPeripheral:peripheral options:nil];
        
        //保存连接过的设备
        if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
        {
            [self.delegate showReturnStatus:@"Connecting" address:self.PeripheralAddress];
        }
        
	}
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"disconnectPeripheral");
	[self.centralManager cancelPeripheralConnection:peripheral];
}
-(void) disconnectCurPeripheral:(int)index
{
    [self clearDevices];
}
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
   // [self stopScanDevice];//连接上了就停止扫描
   // [self removeAllSavedDevice];
   //[self addSavedDevice:peripheral.UUID];
    
    NSLog(@"didConnectPeripheral peripheral.uuid=%@",peripheral.UUID);
    if (self.connectStatusBlock)
    {
        self.connectStatusBlock(ConnectSuccess);
    }
    self.isConnectedBLE=YES;
    CBUUID	*serviceUUID	= [CBUUID UUIDWithString:self.serviceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID,[CBUUID UUIDWithString:self.serviceUUIDString],[CBUUID UUIDWithString:@"180F"],[CBUUID UUIDWithString:@"2A98"], nil];//1880 [CBUUID UUIDWithString:@"1880"], 
    if (self.connectedPeripheral) 
    {
        self.connectedPeripheral=nil;
    }
    
    [DefaultValueManage savePeripheralsWithIdentifiers:[DefaultValueManage peripheralIdentiferToString:peripheral.identifier]];
    
    [BleSinglten setIDValue:[BleSinglten peripheralIdentiferToStringFromNsuuid:peripheral.identifier] withKey:BLEConnectedPeripheralUUID];
    
    self.connectedPeripheral=peripheral;
    [self.connectedPeripheral discoverServices:serviceArray];
    self.connectedPeripheral.delegate=self;
    
    if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
    {
     [self.delegate showReturnStatus:ConnectSuccess address:self.PeripheralAddress];
    }
    NSLog(@"reload7");
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
    //[PublicFunction showNotification:@"FailToConnectPeripheral"];
    //[self connectLastPeripheral];
    if (AutoScan) 
    {
    }
    if (self.connectStatusBlock)
    {
        self.connectStatusBlock(ConnectFail);
    }
self.isConnectedBLE=NO;
     // [self startScanningForUUIDString:self.serviceUUIDString isAutoScan:YES];
    if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
    {
    [self.delegate showReturnStatus:ConnectFail address:self.PeripheralAddress];
    }
}
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral");
    if (self.connectStatusBlock)
    {
        self.connectStatusBlock(disConnect);
    }
    
    self.isConnectedBLE=NO;
    if (AutoScan) 
    {
        //self.connectedPeripheral=peripheral;
    }
    if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
    {
    [self.delegate showReturnStatus:disConnect address:self.PeripheralAddress];
    }
}
-(void)stopLastConnect
{
    if (self.connectedPeripheral&&self.connectedPeripheral.state== CBPeripheralStateConnected)
    {
     [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
    }
}
-(void)connectLastPeripheral
{
    if (self.connectedPeripheral) 
    {
        
        [self connectPeripheral:self.connectedPeripheral];
    }
}

- (void) clearDevices
{
    NSLog(@"clearDevices");
    if (self.foundPeripherals&&[self.foundPeripherals count]>0)
    {
        @try 
        {   
            if ([self.foundPeripherals count]>0)
            {
                [self.foundPeripherals removeAllObjects];
                [self.foundPeripheralAddress removeAllObjects];
                [_RSSIArray removeAllObjects];
                [_DeviceNameArray removeAllObjects];
                
            }
        }
        @catch (NSException *exception) 
        {
            
        }
        @finally
        {
            
        }
    }
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{  
    NSLog(@"didDiscoverServices");
   // [peripheral discoverCharacteristics:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"ABCD"]] forService:service];
    
    if (peripheral==self.connectedPeripheral) 
    {
        for (CBService *aService in peripheral.services) 
        {
            [peripheral discoverCharacteristics:nil forService:aService];
        }
    }
    if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnStatus:address:)])
    {
      [self.delegate showReturnStatus:@"didDiscoverServices" address:self.PeripheralAddress];
    }
}

-(void)sendData:(NSData *)toSend  //serviceUUID:(NSString *)serviceUUID writeUUID:(NSString *)writeUUID
{
    
    NSMutableData *usergoaloData = [[NSMutableData alloc] init];
    [usergoaloData appendData:[PublicFunction HexStringToData:@"cc"]];
    [usergoaloData appendData:toSend];
    

    NSLog(@"toSend =%@",usergoaloData);
    if (self.connectedPeripheral&&self.writeCharacteristic)
    {
        NSLog(@"22");
        if (self.connectedPeripheral.state== CBPeripheralStateConnected)
        {
            NSLog(@"33");
            self.connectedPeripheral.delegate=self;
           // [self writeValue:0x1813 characteristicUUID:0x2A4E p:self.connectedPeripheral data:toSend];
            [self.connectedPeripheral writeValue:usergoaloData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
           // [self.connectedPeripheral readRSSI];
        }
    }
}
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSLog(@"Discovered characteristics for Service UUID: \'%@\'", service.UUID);
    if ([[DefaultValueManage getLostOrComeValue] isEqualToString:@"stop"]) 
    {
        // return;
    }
	NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    
	if (peripheral != self.connectedPeripheral) 
    {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    for (characteristic in characteristics) 
    {
        NSLog(@" characteristic.uuid=%@ characteristic.value=%@",characteristic.UUID,characteristic.value);
       
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:WRITE_UUID]])
        {
                //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
               // [peripheral readValueForCharacteristic:characteristic]; //读取属性的值，在didUpdateValueForCharacteristic接收
                //[peripheral readRSSI];
                //[self initTimer:peripheral];
            self.writeCharacteristic=characteristic;
            NSString *mainString = [NSString stringWithFormat:@"111111111"];
            NSData *mainData= [mainString dataUsingEncoding:NSUTF8StringEncoding];
            [peripheral writeValue:mainData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            
                NSLog(@"readRSSI1");
                NSLog(@"discovered characteristic %@", [characteristic UUID]);
        }
        else
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
           // [peripheral readValueForCharacteristic:characteristic]; //读取属性的值，在didUpdateValueForCharacteristic接收
            [peripheral readRSSI];

        }
	}
}
- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristic");
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    //[peripheral readValueForCharacteristic:characteristic];
    if (self.writeCharacteristic == characteristic)
    {
         [[BleSendDataToBand sharedInstance] didReceiveResponse];
    }
    
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
      NSLog(@"returnValue=%@",characteristic.value);
       //NSLog(@"didUpdateValueForCharacteristic");
	if (peripheral != self.connectedPeripheral) 
    {
		NSLog(@"Wrong peripheral\n");
		return ;
	}
    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    NSString *uuid=[NSString stringWithFormat:@"%@",characteristic.UUID];
    NSLog(@"uuid=%@",uuid);
 
    [self.getDataFromBand didReceiveDataFromBand:characteristic.value];
    
    if (self.writeCharacteristic == characteristic)
    {
        
         [[BleSendDataToBand sharedInstance] didReceiveResponse];
    }
    /*
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]||[characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A1B"]]) //2A1B
    {
        //电量
        const uint8_t *reportData = [characteristic.value bytes];
        
        //NSLog(@"Battery Level for %@ is %d", peripheral.name, reportData[0]);
       // NSLog(@"电量＝%d 信号＝%d",reportData[0],reportData[1]);
        if (reportData)
        {
            if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnMessage:type:)])
            {
                [self.delegate showReturnMessage:[NSString stringWithFormat:@"%d",reportData[0]] type:@"Battery"];
            }
        }
    }

    NSString *returnMessage = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] ;
    
    if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnMessage:type:)])
    {
        [self.delegate showReturnMessage:[NSString stringWithFormat:@"%@\n%@",characteristic.value,returnMessage]  type:@"Battery"];
    }
     */
    
}




- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"peripheral.name %@ RSSI:%@ ", peripheral.name, peripheral.RSSI);
    if (peripheral.RSSI) 
    {  if(self.delegate&&[self.delegate conformsToProtocol:@protocol(BluetoothManageDelegate)] && [self.delegate respondsToSelector:@selector(showReturnMessage:type:)])
       {
        [self.delegate showReturnMessage:[NSString stringWithFormat:@"%@",peripheral.RSSI] type:@"RSSI"];
       }
    }
    else 
    {
        [self stopTimer];
    }
}
-(void)initTimer:(CBPeripheral *)peripheral
{
    NSLog(@"initTimer");

    //定时器
    self.TimerReadRSSI = [NSTimer scheduledTimerWithTimeInterval:(5.0)
                                                          target:self
                                                        selector:@selector(readRSSILoop:)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void)readRSSILoop:(CBPeripheral *)peripheral
{
    NSLog(@"readRSSILoop");
    if (self.connectedPeripheral) 
    {
        [self.connectedPeripheral readRSSI];
    }
    else 
    {
        NSLog(@"self.thePeripheral 为空");
        [self stopTimer];
        //[self clearDevices];
    }
}
-(void)stopTimer
{
   // NSLog(@"stopTimer");
    if (self.TimerReadRSSI) 
    {        NSLog(@"stopTimer"); 
        [self.TimerReadRSSI invalidate];
        self.TimerReadRSSI = nil;
    }
}
- (void) loadSavedDevices
{
    self.serviceUUIDString=SERVICE_UUID;
    
    if ([BleSinglten getIDFromKey:BLEConnectedPeripheralUUID] != nil)
    {
        NSString *identifier = [BleSinglten getIDFromKey:BLEConnectedPeripheralUUID];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:identifier];
        if (uuid) {
            //@通过传入一个@[uuid]数组来检索外围设备
            NSArray *array = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
            if (array.count>0) {
                CBPeripheral *periheral = array[0];
                
                NSLog(@"name=%@",self.connectedPeripheral.name);
                //连接状态或正在连接状态，则取消再重连
                if (self.connectedPeripheral) {
                    if (self.connectedPeripheral.state == CBPeripheralStateConnected)
                    {
                        [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
                    }

                }
                
                if(self.centralManager)
                {
                    self.centralManager.delegate=self;
                    [self.centralManager connectPeripheral:periheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey:[NSNumber numberWithBool:YES]}];
                    self.connectedPeripheral=periheral;
                }
                
            }
        }
        
        
    }
    else
    {
        //[self startScanDevice];
    }
    
    
}


- (void) addSavedDevice:(CFUUIDRef) uuid
{
  
    NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;
    //if (![storedDevices isKindOfClass:[NSArray class]])
      NSArray	*storedDevices=[[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    if ([storedDevices isKindOfClass:[NSArray class]]) 
    {
        //newDevices = [NSMutableArray arrayWithArray:storedDevices];
         newDevices=[[NSMutableArray alloc] init];
    }
	else 
    {
         NSLog(@"Can't find/create an array to store the uuid");
         newDevices=[[NSMutableArray alloc] init] ;
    }
     NSLog(@"uuid=%@",uuid);
    uuidString = CFUUIDCreateString(NULL, uuid);
    NSLog(@"uuidString=%@",uuidString);
    if (uuidString) {
        if (![newDevices containsObject:(__bridge NSString*)uuidString]) 
        {
            [newDevices addObject:(__bridge NSString*)uuidString];
            
        }
        CFRelease(uuidString);
    }
    
    NSLog(@"newDevices=%@",newDevices);
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)removeSavedDevice:(CFUUIDRef)uuid
{
    NSLog(@"removeSavedDevice");
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;
    
	if ([storedDevices isKindOfClass:[NSArray class]]) 
    {
		newDevices = [NSMutableArray arrayWithArray:storedDevices];
        
		uuidString = CFUUIDCreateString(NULL, uuid);
		if (uuidString) {
			[newDevices removeObject:(__bridge NSString*)uuidString];
            CFRelease(uuidString);
        }
		/* Store */
		[[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)removeAllSavedDevice
{
   
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"StoredDevices"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	
}
-(void)readValue:(CBPeripheral *)p
{
    //[self readValue:TI_KEYFOB_PROXIMITY_ALERT_UUID characteristicUUID:TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID p:p];
}
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristics = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristics) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    p.delegate=self;
    [p readValueForCharacteristic:characteristics];
}
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    
    NSLog(@"writeValue %@",data);
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristics = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristics)
    {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    NSLog(@"begin write");
    
    [p writeValue:data forCharacteristic:characteristics type:CBCharacteristicWriteWithoutResponse];
    [p setNotifyValue:YES forCharacteristic:characteristics];
    [p readValueForCharacteristic:characteristics];
    
}
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}
-(UInt16) swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}



- (void) dealloc
{
    NSLog(@"ble manage dealloc");
    self.connectedPeripheral=nil;
    centralManager=nil;
    self.TimerReadRSSI=nil;
    self.serviceUUIDString=nil;
   
    self.PeripheralAddress=nil;
    
}
@end


