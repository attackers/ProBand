//
//  GetWeatherUnit.h
//  LenovoVB10
//
//  Created by fenda on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorking.h"

@interface GetWeatherUnit : NetWorking
/**
 *  获取天气的接口
 *
 *  @param cityName 此参数可以填写所要获取的城市(经纬度)
 *  @param flag     是否查询的是国外天气（是yes）
 *  @param block    结果通过block返回
 */
-(void)getWeatherInfo:(NSString *)cityName isForeignCity:(BOOL)flag;
/**
 *  获取PM2.5
 *
 *  @param cityName 城市名
 */
-(void)getAboutPM25WithCity:(NSString *)cityName;

@end
