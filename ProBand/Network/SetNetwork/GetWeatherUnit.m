//
//  GetWeatherUnit.m
//  LenovoVB10
//
//  Created by fenda on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "GetWeatherUnit.h"


static GetWeatherUnit *sharedObj = nil;

@implementation GetWeatherUnit

- (void)requestComplete:(id)result{
  
    
        if (self.completion) {
            self.completion(result,YES);
        }
}


-(void)getWeatherInfo:(NSString *)cityName isForeignCity:(BOOL)flag
{
        //获取国外天气开辟一个线程
        if(flag)
        {

            NSString *paraStr = [NSString stringWithFormat:@"%@",[GetWeatherUnit phonetic:cityName]];
            NSDictionary *parameDic = @{@"q":paraStr,@"format":@"json",@"includelocation":@"yes",@"key":@"4xb7ngwu6wa5qagss7x5c97y"};
            [self startGet:[NetWorkManage getUrlwithBaseUrlString:@"http://api.worldweatheronline.com" withUrl:@"free/v1/weather.ashx"] params:parameDic dataKey:nil];
            
        }
        //获取国内天气
        else
        {
            NSDictionary *parameDic = @{@"location":cityName,@"output":@"json",@"ak":@"6tYzTvGZSOpYB5Oc2YGGOKt8"};
            [self startGet:[NetWorkManage getUrlwithBaseUrlString:@"http://api.map.baidu.com" withUrl:@"/telematics/v3/weather"] params:parameDic dataKey:nil];
            
        }
   
}
-(void)getAboutPM25WithCity:(NSString *)cityName{
    //获取pm2.5
    NSDictionary *parameDic = @{@"token":@"4esfG6UEhGzNkbszfjAp",@"city":cityName,@"stations":@"no"};
    [self startGet:[NetWorkManage getUrlwithBaseUrlString:@"http://www.pm25.in" withUrl:@"/api/querys/pm2_5.json"] params:parameDic dataKey:nil];
}


//拼音转汉字
+ (NSString *) phonetic:(NSString*)sourceString {
    
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return [source stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
