//
//  GetWeather.h
//  BLEManager
//
//  Created by attack on 15/7/17.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GetWeather : NSObject<CLLocationManagerDelegate>
+(GetWeather*)shareGetWeather;
/**
 *  通过传输坐标获取天气
 *
 *  @param coord 坐标
 */
- (void)getweather:(CLLocation*)coord;
/**
 *  转换成发送给手环的数据
 *
 *  @return 转换后的数据
 */
- (NSData*)weatherByte;

@end
