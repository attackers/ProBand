//
//  GetWeather.m
//  BLEManager
//
//  Created by attack on 15/7/17.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "GetWeather.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#define md5 @"c2cc0ac684f84bfab63e2c50852ca4b8"
#define appid @"2147"
#define url @"http://route.showapi.com/9-5"
@interface GetWeather()
{
    CLLocationManager * locationManager;
    NSString *weatherSg;
    NSString *quality;
    NSString *city;
    NSString *pm;
    NSString *temperature;
    NSString *tzone;
}
@end
@implementation GetWeather
+(GetWeather*)shareGetWeather
{
    static GetWeather *g = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g = [[GetWeather alloc]init];
    });
    return g;
}

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)getweather:(CLLocation*)coord
{
    CLLocationCoordinate2D coor = coord.coordinate;
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.requestSerializer.timeoutInterval = 20;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:appid,@"showapi_appid",md5,@"showapi_sign",[self returenCurrentDate],@"showapi_timestamp",@"3",@"from",[NSString stringWithFormat:@"%.2f",coor.latitude],@"lat",[NSString stringWithFormat:@"%.2f",coor.longitude],@"lng",nil];
    NSLog(@"%@",dic);
    __weak GetWeather *weakSelf = self;
    [manage POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSData *data = operation.responseData;
        if (data!= nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *arrayDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"showapi_res_body"]];
            NSDictionary *now = [NSDictionary dictionaryWithDictionary:[arrayDic objectForKey:@"now"]];
            [weakSelf setValue:now];
        }
    }];
    
}
- (void)setValue:(NSDictionary*)now
{
    NSDictionary *aqiDetail = [now objectForKey:@"aqiDetail"];
    weatherSg = [now objectForKey:@"weather"];
    quality = [aqiDetail objectForKey:@"quality"];
    city = [aqiDetail objectForKey:@"area"];
    pm = [aqiDetail objectForKey:@"pm2_5"];
    temperature = [now objectForKey:@"temperature"];
    NSLog(@"%@ %@ %@ %@",weatherSg,quality,city,temperature);
    NSLog(@"%@ %@ %@ %@",[now objectForKey:@"weather"],[aqiDetail objectForKey:@"quality"],[aqiDetail objectForKey:@"area"],[now objectForKey:@"temperature"]);
}
- (NSData*)weatherByte
{
    UInt8 wValue = [self returenWeather:weatherSg];
    UInt8 tValue = [temperature integerValue];
    UInt16  pValue = [pm integerValue];
    NSString *cValue = city;
    NSMutableData *data = [NSMutableData dataWithBytes:&wValue length:sizeof(wValue)];
    [data appendBytes:&tValue length:sizeof(tValue)];
    [data appendBytes:&pValue length:sizeof(pValue)];
    [data appendData:[cValue dataUsingEncoding:NSUTF8StringEncoding]];
    return data;    
}
- (NSString*)returenCurrentDate
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fDate = [[NSDateFormatter alloc]init];
    [fDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [fDate stringFromDate:date];
    return dateString;
}
- (UInt8)returenWeather:(NSString*)stg
{
    NSString *zSelectString1 = @"[阴|云]{1}";
    NSString *zSelectString2 = @"[雨]{1}";
    NSString *zSelectString3 = @"[晴]{1}";
    NSString *zSelectString4 = @"[雷]{1}";
    NSRange ra1 = [stg rangeOfString:zSelectString1 options:NSRegularExpressionSearch];
    if (ra1.length!=0) {
        return 1;
    }
    NSRange ra2 = [stg rangeOfString:zSelectString2 options:NSRegularExpressionSearch];
    if (ra2.length!=0) {
        return 2;
    }  NSRange ra3 = [stg rangeOfString:zSelectString3 options:NSRegularExpressionSearch];
    if (ra3.length!=0) {
        return 3;
    }
    NSRange ra4 = [stg rangeOfString:zSelectString4 options:NSRegularExpressionSearch];
    if (ra4.length!=0) {
        return 4;
    }
    return 0;
}
@end
