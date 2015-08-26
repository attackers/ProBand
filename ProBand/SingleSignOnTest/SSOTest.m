//
//  SSOTest.m
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "SSOTest.h"
#import "FitDataSource_Model.h"
#import "FitDataType_Model.h"
#import "FitDataPoint_Model.h"
#import "FitDataSet_Model.h"

#define FitDataTypeName     @"com.lenovo.settings.heartbeat"

@interface SSOTest()

@end

@implementation SSOTest

- (void)initUploadEnvAndSubmitUUID
{
    [self createFitDataSource];
}

- (void)getUUIDFromServerWithBlock:(void(^)(NSString *))uuid
{
    FitDataSet_Model *model = [[FitDataSet_Model alloc] init];
    NSString *sourId = [Singleton getValueWithKey:@"fitDataSourceId"];
    if (!sourId) return;
    model.fitDataSourceId = [sourId intValue];
    model.fitDataTypeName = @"com.lenovo.settings.heartbeat";
    model.minStartTime = 1436151478;
    model.maxEntTime = 1436151500;
    model.nextPageIndex = 0;
    [HTTPManage getFitDataSetWithFitDataSetModel:model Withblock:^(NSData *result, NSError *error) {
        if (result.length) {
            NSDictionary *resultDic =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"state"] intValue] == 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resultDic[@"content"] dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                NSArray *arr = dic[@"fitDataPoints"];
                if (arr.count != 0) {
                    NSArray *fitValuesArr = arr[0][@"fitValues"];
                    NSLog(@"uuid = %@", fitValuesArr[0][@"value"]);
                    uuid(fitValuesArr[0][@"value"]);
                }
                
            }
        }
    }];
}

- (void)uploadCurrentDevicesUUID
{
    [self uploadFitDataPoint];
}

//创建FitDataSource，服务器会返回FitDataSourceId,通过[Singleton getValueWithKey:@"fitDataSourceId"]获取fitDatasourceId
- (void)createFitDataSource
{
    FitApplication_Model *app = [[FitApplication_Model alloc] init];
    app.appKey = @"SG1505105378";
    app.detailUrl = @"http://run.lenovo.com.cn";
    app.name = @"ProBand";
    app.packageName = @"com.fendateam.ProBand";
    app.version = @"1.0.0";
    
    FitDevice_Model *dev = [[FitDevice_Model alloc] init];
    dev.deviceId = @"666666";
    dev.manufacturer = @"fenda";
    dev.model = @"110";
    dev.version = @"1.0";
    
    FitDataSource_Model *model = [[FitDataSource_Model alloc] init];
    model.appModel = app;
    model.deviceModel = dev;
    
    [HTTPManage createFitDataSourceWithFitDataSourceModel:model Withblock:^(NSData *result, NSError *error) {
        if (result.length) {
            NSDictionary *resultDic =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"state"] intValue] == 0) {
                NSString *str = resultDic[@"content"];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                NSString *sourceId = dic[@"fitDataSourceId"];
                
                [Singleton setValues:sourceId withKey:@"fitDataSourceId"];
                NSLog(@"CreateFitDataSource  success");
                NSLog(@"Echo-------->>>>>>fitDataSourceId = %@", [Singleton getValueWithKey:@"fitDataSourceId"]);
                [self createCustomFitDataType];
            }
        }
    }];
}

//创建心跳包数据类型
- (void)createCustomFitDataType
{
    FitField_Model *UUID = [[FitField_Model alloc] init];
    UUID.name = @"uuid";
    UUID.format = 2;
    
    FitField_Model *currentTime = [[FitField_Model alloc] init];
    currentTime.name = @"current_time";
    currentTime.format = 2;
    
    FitField_Model *manufacturer = [[FitField_Model alloc] init];
    manufacturer.name = @"manufacturer";
    manufacturer.format = 2;
    
    NSArray *arr = @[UUID, currentTime, manufacturer];
    
    FitDataType_Model *model = [[FitDataType_Model alloc] init];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:arr];
    model.fitfields = temp;
    model.name = @"com.lenovo.settings.heartbeat";
    
    [HTTPManage createCustomFitDataTypeWithFitDataTypeModel:model Withblock:^(NSData *result, NSError *error) {
        if (result.length) {
            NSDictionary *resultDic =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"state"] intValue]==0 || [resultDic[@"state"] intValue]==304) {
                NSLog(@"CreateCustomFitData  success");
                [self uploadFitDataPoint];
            }
        }
    }];
}

//上传UUID.其中UUID包含在FitDataPoint中
- (void)uploadFitDataPoint
{
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    // NSTimeInterval返回的是double类型，输出会显示为10位整数加小数点加一些其他值
    //    // 如果想转成int型，必须转成long long型才够大。
    //    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    //    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    //    NSLog(@"%@",curTime);
    
    FitValue_Model *UUID = [[FitValue_Model alloc] init];
    UUID.value = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    UUID.format = 2;
    
    FitValue_Model *currentTime = [[FitValue_Model alloc] init];
    currentTime.value = @"1436151478";
    currentTime.format = 2;
    
    FitValue_Model *manufacturer = [[FitValue_Model alloc] init];
    manufacturer.value = @"fenda";
    manufacturer.format = 2;
    
    NSArray *arr = @[UUID, currentTime, manufacturer];
    
    FitDataPoint_Model *model = [[FitDataPoint_Model alloc] init];
    model.values = [NSMutableArray arrayWithArray:arr];
    model.fitDataTypeName = @"com.lenovo.settings.heartbeat";
    model.startTime = 1436151478;
    model.entTime = 1436151500;
    //    if (sourceId) {
    NSString *sourId = [Singleton getValueWithKey:@"fitDataSourceId"];
    model.fitDataSourceId = [sourId intValue];
    //    }
    
    [HTTPManage uploadFitDataPointWithFitDataPointModel:model Withblock:^(NSData *result, NSError *error) {
        if (result.length) {
            NSString *resultStr =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@" resultStr = %@  error = %@", resultStr, error.description);
        }
    }];
}

//获取UUID，UUID包含在fitDataSet中
+ (void)getFitDataSet
{
    FitDataSet_Model *model = [[FitDataSet_Model alloc] init];
    NSString *sourId = [Singleton getValueWithKey:@"fitDataSourceId"];
    model.fitDataSourceId = [sourId intValue];
    model.fitDataTypeName = @"";
    model.minStartTime = 1436151478;
    model.maxEntTime = 1436151500;
    model.nextPageIndex = 0;
    [HTTPManage getFitDataSetWithFitDataSetModel:model Withblock:^(NSData *result, NSError *error) {
        NSString *resultStr =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" resultStr = %@  error = %@", resultStr, error.description);
    }];
}

- (void)initNet
{
    FitApplication_Model *app = [[FitApplication_Model alloc] init];
    app.appKey = @"SG1505105378";
    app.detailUrl = @"http://run.lenovo.com.cn";
    app.name = @"ProBand";
    app.packageName = @"com.fendateam.ProBand";
    app.version = @"1.0.0";
    
    FitDevice_Model *dev = [[FitDevice_Model alloc] init];
    dev.deviceId = @"666666";
    dev.manufacturer = @"fenda";
    dev.model = @"110";
    dev.version = @"1.0";
    
    FitDataSource_Model *model = [[FitDataSource_Model alloc] init];
    model.appModel = app;
    model.deviceModel = dev;
    
    [HTTPManage createFitDataSourceWithFitDataSourceModel:model Withblock:^(NSData *result, NSError *error) {
        if (result.length) {
            NSDictionary *resultDic =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"state"] intValue] == 0) {
                NSString *str = resultDic[@"content"];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                NSString *sourceId = dic[@"fitDataSourceId"];
                
                [Singleton setValues:sourceId withKey:@"fitDataSourceId"];
                NSLog(@"CreateFitDataSource  success");
                NSLog(@"Echo-------->>>>>>fitDataSourceId = %@", [Singleton getValueWithKey:@"fitDataSourceId"]);
            }
        }
    }];
}
@end
