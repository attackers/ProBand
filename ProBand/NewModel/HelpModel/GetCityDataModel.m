//
//  GetCityDataModel.m
//  LenovoVB10
//
//  Created by jacy on 15/1/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "GetCityDataModel.h"

@implementation GetCityDataModel
+(GetCityDataModel *)convertDataToModel:(NSDictionary *)aDictionary
{
    GetCityDataModel *instance = [GetCityDataModel new];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}
+(void)saveWeather:(NSDictionary *)weathInfoDic
{
    NSString *dateStr = weathInfoDic[@"dateStr"];
    NSDictionary *dataDic = weathInfoDic[@"weather"][0];
    
    NSString *cityName = dataDic[@"currentCity"];
    NSString *pmStr = dataDic[@"pm25"];
    NSArray *weathArr = dataDic[@"weather_data"];
    
    NSString *str = weathArr[0][@"date"];
    NSString *weathStr = weathArr[0][@"weather"];
    weathStr = [weathStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    int weathType = 0;
    if ([weathStr isEqualToString:@"小雨"]||[weathStr isEqualToString:@"大雨"]||[weathStr isEqualToString:@"中雨"]||[weathStr isEqualToString:@"暴雨"]) {
        weathType = 2;
    }
    else if ([weathStr isEqualToString:@"阴天"])
    {
        weathType = 1;
    }
    else if ([weathStr isEqualToString:@"晴天"]||[weathStr isEqualToString:@"多云"])
    {
        weathType = 0;
    }
    else if ([weathStr isEqualToString:@"大雪"]||[weathStr isEqualToString:@"小雪"]||[weathStr isEqualToString:@"中雪"])
    {
        weathType = 3;
    }
    NSString *str2 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *temperatureArr = [str2 componentsSeparatedByString:@"："];
    if (temperatureArr.count>1)
    {
        NSString *temperatureStr = temperatureArr[1];
        NSString *resultStr = [temperatureStr substringWithRange:NSMakeRange(0, temperatureStr.length - 2)];
        NSString *resultF =[NSString stringWithFormat:@"%.2f",([resultStr floatValue] *1.8 +32)];
        
        //    NSLog(@"~~~~%@~~~~~~%@",dateStr,temperatureArr[0]);
        
        NSDictionary *weathResultDic = @{@"date":dateStr,
                                         @"city":cityName,
                                         @"weathType":[NSString stringWithFormat:@"%d",weathType],
                                         @"Fahrenheit":resultF,
                                         @"centigrad":resultStr,
                                         @"pm25":pmStr};
        NSLog(@"~~~~~%@",weathResultDic);
        [[NSUserDefaults standardUserDefaults]setObject:weathResultDic forKey:@"weather"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
    
    
}
+ (GetCityDataModel*)getDataModel{
    GetCityDataModel *model = [GetCityDataModel new];
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:@"weather"];
    if (dic) {
        model =[self convertDataToModel:dic];
    }
    return model;
}

@end
