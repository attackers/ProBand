 //
//  GetDataForPeriphera.m
//  BLEManager
//
//  Created by attack on 15/7/13.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "GetDataForPeriphera.h"
#import "BLEManage.h"
#import "speex.h"
#import "MusicPlay.h"
#import <iflyMSC/iflyMSC.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SpeexController.h"
#import "HistoryDataInfomation.h"
@interface GetDataForPeriphera()
{
    dispatch_source_t timer;
}

@end
@implementation GetDataForPeriphera
{
    MusicPlay *playManage;
    NSMutableData *voiceData;
}
+ (GetDataForPeriphera*)shareDataForPeriphera
{
    static GetDataForPeriphera *gd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gd = [[GetDataForPeriphera alloc]init];
    });
    return gd;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getDataFromBLEManage];
        playManage = [[MusicPlay alloc]init];
        voiceData = [NSMutableData data];
    }
    return self;
}
- (void)getDataFromBLEManage
{
    BLEManage *ble = [BLEManage shareCentralManager];
    [ble getPeripheralData:^(NSData *data) {
        
        [self setDataTypeString:data];
        
    }];

    
}
- (void)setDataTypeString:(NSData*)data
{
    const unsigned char *byte = (Byte*)[data bytes];
    
    NSString *string = [NSString stringWithFormat:@"%02hhu", byte[1]];
    int i = [string intValue];
    switch (i) {
        case 21://语音传输
        {
            string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            if (comType == 22) {
                [self getvoice:data];
                
            }else{
                
                SpeexController *sp = [SpeexController shareSpeexController];
                sp.view.frame = CGRectZero;
                sp.voiceData = voiceData;
                voiceData = [NSMutableData data];
                [[UIApplication sharedApplication].keyWindow addSubview:sp.view];
            }
            
        }
            break;
        case 23://闹钟
        {
            string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            [self alarmList:comType alarmData:data];
        }
            break;
        case 24://找手机
        {
            string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            [self findPhoneCommand:comType];
        }
            break;
        case 25://音乐控制
        {
            string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            [self commandPlayType:comType];
            
        }
            break;
        case 26://获取电量
        {
            string = [NSString stringWithFormat:@"%02x", byte[7]];
            
        }
            break;
        case 28://个人目标
        {
            string = [NSString stringWithFormat:@"%02x", byte[3]];
            int comType = [string intValue];
            [self personalDataType:comType Data:data];
            
        }
        case 29://历史数据
        {
            //            string = [NSString stringWithFormat:@"%02x", byte[3]];
            //            int comType = [string intValue];
            //            [self personalDataType:comType Data:data];
            HistoryDataInfomation *his = [HistoryDataInfomation shareHistoryDataInfomation];
            if (his.bandHistoryData) {
                his.bandHistoryData(data);
            }
            
        }
            break;
        default:
            break;
    }
    
};

- (void)commandPlayType:(int)type
{
    switch (type) {
        case 21:
        {
            [playManage play];
            NSLog(@"commandPlayType:21");
        }
            break;
        case 22:
        {
            [playManage pause];
            NSLog(@"commandPlayType:22");
            
        }
            break;
        case 23:
        {
            [playManage skipToPreviousItem];
            NSLog(@"commandPlayType:23");
            
        }
            break;
        case 24:
        {
            [playManage skipToNextItem];
            NSLog(@"commandPlayType:24");
            
        }
            break;
        case 25:
        {
            [playManage addVolume];
            NSLog(@"commandPlayType:25");
            
        }
            break;
            
        case 26:
        {
            [playManage reduceVolume];
            NSLog(@"commandPlayType:26");
            
        }
            break;
            
        case 27:
        {
            NSLog(@"song: %@",[playManage getSongName]);
            NSLog(@"commandPlayType:27");
            
        }
            break;
        default:
            break;
    }
    
}
- (void)getvoice:(NSData*)data
{
    //
    NSData *subData = [data subdataWithRange:NSMakeRange(4, 16)];
    //    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDiretory = [pathArray objectAtIndex:0];
    //    NSString *path = [documentsDiretory stringByAppendingString:@"/Documentation/VoiceSpeex.dat"];
    //    NSFileManager *manage = [[NSFileManager alloc]init];
    //    if (![manage fileExistsAtPath:path]) {
    //
    //        [manage createFileAtPath:path contents:nil attributes:nil];
    //    }
    //    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    //
    //    [fileHandle seekToEndOfFile];
    //    [fileHandle writeData:subData];
    //    [fileHandle closeFile];
    [voiceData appendData:subData];
    
}
#pragma mark ************************* 找手机 **********************************
- (void)findPhoneCommand:(int)cmd
{
    switch (cmd) {
        case 21:
        {
            int interval = 2;
            int leeway = 0;
            __weak GetDataForPeriphera *weakSelf = self;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            if (timer) {
                dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), interval * NSEC_PER_SEC, leeway);
                dispatch_source_set_event_handler(timer, ^{
                    [weakSelf phoneVibrate];
                });
                dispatch_resume(timer);
            }
        }
            break;
        case 22:
        {
            if (timer) {
                dispatch_source_cancel(timer);
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)phoneVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
#pragma mark ******************* 闹钟 ************************
- (void)alarmList:(int)type alarmData:(NSData*)data
{
    switch (type) {
        case 25:
        {
            NSMutableArray *uintArray = [NSMutableArray array];
            const char *byte = (char*)[data bytes];
            for (int i = 7; i<16; i++) {
                NSString *string = [NSString stringWithFormat:@"%02x", byte[i]];
                UInt8 value = [self returnUInt8:string];
                NSLog(@"by = %hhu",value);
                [uintArray addObject:[NSNumber numberWithInteger:value]];
            }
            
            if (_alarmArray) {
                _alarmArray(uintArray);
            }
        }
            break;
            
        default:
            break;
    }
}
- (UInt8)returnUInt8:(NSString*)stg
{
    int f = [self returnStgInt:[stg substringWithRange:NSMakeRange(0, 1)]];
    int s = [self returnStgInt:[stg substringWithRange:NSMakeRange(1, 1)]];
    return f*16+s;
}
- (int)returnStgInt:(NSString*)stg
{
    NSString *stringA = @"[a|A]{1}";
    NSString *stringB = @"[b|B]{1}";
    NSString *stringC = @"[c|C]{1}";
    NSString *stringD = @"[d|D]{1}";
    NSString *stringE = @"[e|E]{1}";
    NSString *stringF = @"[f|F]{1}";
    
    NSRange range = [stg rangeOfString:stringA options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 10;
    }
    range = [stg rangeOfString:stringB options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 11;
    }
    range = [stg rangeOfString:stringC options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 12;
    }
    range = [stg rangeOfString:stringD options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 13;
    }
    range = [stg rangeOfString:stringE options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 14;
    }
    range = [stg rangeOfString:stringF options:NSRegularExpressionSearch];
    if (range.length>0) {
        return 15;
    }
    return [stg intValue];
}
- (void)returnMyAlarmList:(MyAlarmList)myAlarm
{
    _alarmArray = ^(NSMutableArray *array){
        myAlarm(array);
    };
}

#pragma mark ******************* 个人目标 ************************

- (void)personalDataType:(int)type Data:(NSData*)data
{
    
    switch (type) {
        case 22:
        {
            NSData *subData = [data subdataWithRange:NSMakeRange(12, 4)];
            UInt32 u = [self NSDataToUInt:subData];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%d",(unsigned int)u] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [al show];
        }
            break;
        case 24:
        {
            
        }
            break;
        case 25:
        {
            
        }
            break;
        default:
            break;
    }
    
}
-(UInt32) NSDataToUInt:(NSData *)data
{
    unsigned char bytes[4];
    [data getBytes:bytes length:4];
    UInt32 n = ((bytes[0]&0xFF)<<24) | (((bytes[1]>>8)&0xFF)<<16) | (((bytes[2]>>16)&0xFF)<<8) | ((bytes[3] >>24)&0xFF);
    return n;
}

@end
