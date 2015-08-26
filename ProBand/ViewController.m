//
//  ViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ViewController.h"
#import <iflyMSC/iflyMSC.h>

@interface ViewController ()<IFlySpeechRecognizerDelegate>
{
    IFlySpeechUnderstander *_iflySpeechRecognizer;

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *initString = [[NSString alloc]initWithFormat:@"appid=%@",@"55bb53f2"];
    [IFlySpeechUtility createUtility:initString];
    [self initIFlySpeechUnderstander];
    // Do any additional setup after loading the view, typically from a nib.
}

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
    //    [_iflySpeechRecognizer setParameter:@"2.0" forKey:[IFlySpeechConstant NLP_VERSION]];
    [_iflySpeechRecognizer setParameter:@"-1" forKey:[IFlySpeechConstant AUDIO_SOURCE]];
    
    NSString *stringPath = [[NSBundle mainBundle]pathForResource:@"pcm" ofType:@"pcm"];
    [_iflySpeechRecognizer startListening];
    
    NSArray *savePath =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectorysave = [savePath objectAtIndex:0];
    NSString *pathsaveData = [documentsDirectorysave stringByAppendingPathComponent:@"/Documentation/语音PCM.pcm"];
    
    
    NSData *data = [NSData dataWithContentsOfFile:stringPath];    //从文件中读取音频
    
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
    char * part3Bytes = malloc(data.length-writtenLen);
    NSRange range = NSMakeRange(writtenLen, data.length-writtenLen);
    [data getBytes:part3Bytes range:range];
    NSData * part3 = [NSData dataWithBytes:part3Bytes length:data.length-writtenLen];
    
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
    //    NSDictionary *dic = results [0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
