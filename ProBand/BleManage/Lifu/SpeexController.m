//
//  SpeexController.m
//  BLEManager
//
//  Created by attack on 15/7/29.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "SpeexController.h"
#import "speex.h"
#import <iflyMSC/iflyMSC.h>
#include <stdio.h>
#import "GetDataForPeriphera.h"
#import "EKEventManager.h"
#define FRAME_SIZE 160
#define ENCODE_FRAME_SIZE 20

@interface SpeexController ()<IFlySpeechRecognizerDelegate>
{
    IFlySpeechUnderstander *_iflySpeechRecognizer;
    
}

@end

@implementation SpeexController
+ (SpeexController *)shareSpeexController
{

   static SpeexController *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[SpeexController alloc]init];
    });
    return s;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *initString = [[NSString alloc]initWithFormat:@"appid=%@",@"55b58286"];
    [IFlySpeechUtility createUtility:initString];
}
- (void)setVoiceData:(NSMutableData *)voiceData
{
    if (![voiceData isEqualToData:_voiceData]) {
        _voiceData = voiceData;
    }
    [self writeDataToFile:_voiceData];
}
/*
 从外面接收来的数据写入到文件当中
 */
- (void)writeDataToFile:(NSData *)data
{
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString*  path = [documentsDirectory stringByAppendingPathComponent:@"/Documentation"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL tag = [manager fileExistsAtPath:path isDirectory:NULL];
    
    if (!tag) {
        tag =  [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        path = [path stringByAppendingPathComponent:@"VoiceSpeex.dat"];
        
    }else{
        
        path = [path stringByAppendingPathComponent:@"VoiceSpeex.dat"];
    }
    NSFileManager *fileManager =  [[NSFileManager alloc]init];
    
    BOOL ok = [fileManager createFileAtPath:path contents:nil attributes:nil];
    if (ok) {
        [data writeToFile:path atomically:NO];
    }
    [self speexManageinfomation];
}
/****************对接收并存储在本地的数据进行speex解压缩***********************/
- (void)speexManageinfomation
{
    NSMutableData *pcmOutData  = [NSMutableData data];
    NSArray *pathArraySP =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorySP = [pathArraySP objectAtIndex:0];
    NSString*  path = [documentsDirectorySP stringByAppendingPathComponent:@"/Documentation"];
    path = [path stringByAppendingPathComponent:@"VoiceSpeex.dat"];
    const char *filePath = [path UTF8String];
    NSMutableData *getSpeexData = [NSMutableData data];
    FILE *fStream;
    fStream = fopen(filePath, "r");
    if (fStream == NULL) {
        return;
    }
    
    char outChar[20];
    
    SpeexBits bits;
    void *de_code;
    speex_bits_init(&bits);
    de_code = speex_decoder_init(&speex_nb_mode);
    int frame_size = 1;;
    int ctl = speex_decoder_ctl(de_code, SPEEX_SET_ENH, &frame_size);
    short output_frame[160];//用于存储解析过后的数据；
    while (!feof(fStream)) {
        int  n_len = fread(outChar, sizeof(char), 20, fStream);//获取20char类型数据放入outchar
        speex_bits_reset(&bits);
        speex_bits_read_from(&bits, outChar, sizeof(outChar));//读取20byte数据待解析
        [getSpeexData appendBytes:outChar length:sizeof(outChar)];//拼接获取数据
        if (n_len == 20) {
            int deco = speex_decode_int(de_code, &bits, output_frame);//解析数据并存入output_frame
            [pcmOutData appendBytes:output_frame length:sizeof(output_frame)];
        }
        
    }
    speex_bits_destroy(&bits);
    speex_decoder_destroy(de_code);
    fclose(fStream);
    
    
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString* _pcmpath = [documentsDirectory stringByAppendingPathComponent:@"/Documentation"];
    
    NSFileManager *manager = [[NSFileManager alloc]init];
    BOOL tag = [manager fileExistsAtPath:_pcmpath isDirectory:NULL];
    
    if (!tag) {
        tag =  [manager createDirectoryAtPath:_pcmpath withIntermediateDirectories:YES attributes:nil error:nil];
        _pcmpath = [_pcmpath stringByAppendingPathComponent:@"voice.dat"];
        
    }else{
        _pcmpath = [_pcmpath stringByAppendingPathComponent:@"voice.dat"];
    }
    
    NSFileManager *fileManagers =  [[NSFileManager alloc]init];

    
    if (![fileManagers fileExistsAtPath:_pcmpath]) {
        BOOL   ok = [fileManagers createFileAtPath:_pcmpath contents:nil attributes:nil];
    }
    [pcmOutData writeToFile:_pcmpath atomically:NO];
    [self initIFlySpeechUnderstander];
}

#pragma  mark ******************* iFlySpeechUnder ************************

- (void)initIFlySpeechUnderstander
{
    
    _iflySpeechRecognizer = [IFlySpeechUnderstander sharedInstance];
    _iflySpeechRecognizer.delegate = self;
    [_iflySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    [_iflySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
    [_iflySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
    [_iflySpeechRecognizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iflySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    [_iflySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
    [_iflySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iflySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iflySpeechRecognizer setParameter:@"-1" forKey:[IFlySpeechConstant AUDIO_SOURCE]];
    
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *stringFile = [documentsDirectory stringByAppendingPathComponent:@"/Documentation/voice.dat"];
//    NSString *localFile = [[NSBundle mainBundle]pathForResource:@"解码" ofType:@"dat"];
    
    NSData *data = [NSData dataWithContentsOfFile:stringFile];
    [_iflySpeechRecognizer startListening];
    //从文件中读取音频
    int count = 10;
    unsigned long audioLen = data.length/count;
    for (int i =0 ; i< count-1; i++) {    //分割音频
        char * part1Bytes = malloc(audioLen);
        NSRange range = NSMakeRange(audioLen*i, audioLen);
        [data getBytes:part1Bytes range:range];
        NSData * part1 = [NSData dataWithBytes:part1Bytes length:audioLen];
        
        int ret = [_iflySpeechRecognizer writeAudio:part1];//写入音频，让SDK识别
        free(part1Bytes);
        if(!ret) {     //检测数据发送是否正常
            NSLog(@"%s[ERROR]",__func__);
            [_iflySpeechRecognizer stopListening];
            
            return;
        }
    }
    //处理最后一部分
    unsigned long writtenLen = audioLen * (count-1);
    char *part3Bytes = malloc(data.length-writtenLen);
    NSRange range = NSMakeRange(writtenLen, data.length-writtenLen);
    [data getBytes:part3Bytes range:range];
    NSData *part3 = [NSData dataWithBytes:part3Bytes length:data.length%writtenLen];
    
    [_iflySpeechRecognizer writeAudio:part3];
    free(part3Bytes);
    [_iflySpeechRecognizer stopListening];//音频数据写入完成，进入等待状态
    
}
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    
    //    NSLog(@"results : %@",results);
    NSDictionary *dic = results[0];
    //    NSArray *array = [dic allKeys];
    //    if (array!=nil) {
    //
    //        NSString *string = array[0];
    //        NSLog(@"%@",string);
    //    }
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSMutableDictionary *scheduleDic = [NSMutableDictionary dictionary];
    
    NSDictionary *dicJSON = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([dicJSON objectForKey:@"semantic"]) {
        NSDictionary *semanticDic = [dicJSON objectForKey:@"semantic"];
        if ([semanticDic objectForKey:@"slots"]) {
            NSDictionary *subSemanticDic = [semanticDic objectForKey:@"slots"];
            [scheduleDic setValue:[subSemanticDic objectForKey:@"content"] forKey:@"content"];
            if ([subSemanticDic objectForKey:@"datetime"]) {
                
                NSDictionary *slotsDic = [subSemanticDic objectForKey:@"datetime"];
                [scheduleDic setValue:[slotsDic objectForKey:@"time"] forKey:@"time"];
                [scheduleDic setValue:[slotsDic objectForKey:@"timeOrig"] forKey:@"timeOrig"];
                if ([slotsDic objectForKey:@"dateOrig"]) {
                    
                    [scheduleDic setValue:[slotsDic objectForKey:@"dateOrig"] forKey:@"dateOrig"];
                    
                }
                [scheduleDic setValue:[slotsDic objectForKey:@"date"] forKey:@"date"];
                NSDate *startDate = [self returnScheduleDate:[slotsDic objectForKey:@"date"] time:[slotsDic objectForKey:@"time"]];
                [[EKEventManager shareEKEventManager] createEventWithTitle:@"提醒" startDate:startDate endDate:startDate notes:[subSemanticDic objectForKey:@"content"]];
            
                if (scheduleDefaults) {
                    NSArray *array = scheduleDefaults;
                    NSMutableArray *schArray = [NSMutableArray arrayWithArray:array];
                    [schArray addObject:scheduleDic];
                    saveScheduleDefaults(schArray);
                }else{
                    NSArray *array = [NSArray arrayWithObjects:scheduleDic, nil];
                    saveScheduleDefaults(array);
                }
            }
        }
        
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
    NSLog(@"听写结果：%@",result);
    
}
- (void)onError:(IFlySpeechError *)errorCode
{
    NSLog(@"Error:%@",errorCode.errorDesc);
    
}
- (void)onVolumeChanged:(int)volume
{
}
- (void)onBeginOfSpeech
{
}
- (void)onEndOfSpeech
{
    
}
- (NSDate*)returnScheduleDate:(NSString *)date time:(NSString *)time
{
    NSDateFormatter *datef = [[NSDateFormatter alloc]init];
    [datef setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *dateSt = [date stringByAppendingFormat:@" %@",time];
    NSDate *schDate = [datef dateFromString:dateSt];
    return schDate;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
