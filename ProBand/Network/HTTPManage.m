//
//  HTTPManage.m
//  LenovoVB10
//
//  Created by zhuzhuxian on 15/4/10.
//  Copyright (c) 2015年 fenda. All rights reserved.
//



#import "HTTPManage.h"
#import "FitDataSource_Model.h"
#import "FitDataType_Model.h"
#import "FitDataPoint_Model.h"
#import "FitDataSet_Model.h"

#define APP_KEY         @"SG1505105378"
#define VERSION         @"1.0"
#define OPEN_ID         [Singleton getValueWithKey:@"open_id"]
#define USER_TYRE       [Singleton getValueWithKey:@"user_type"]
#define APP_SIGNATURE   @"EB379F9D0BE5FFF9E970CF3FA70FB5E8"
/*
 *  public static final int FORMAT_FLOAT = 0;
 *  public static final int FORMAT_INT32 = 1;
 *  public static final int FORMAT_STRING = 2;
 *  public static final int FORMAT_DOUBLE = 3;
 */

//responseData: {"state":0,"message":"","content":"{\"fitDataSourceId\":118,\"fitDevice\":{\"deviceId\":\"666666\",\"manufacturer\":\"fenda\",\"model\":\"110\",\"type\":3,\"version\":\"1.0\"},\"fitApplication\":{\"appKey\":\"SG1505105378\",\"packageName\":\"com.fendateam.ProBand\",\"detailUrl\":\"\",\"name\":\"ProBand\",\"version\":\"\"}}"}
#define HTTP_CREATE_FIT_DATA_SOURCE             @"http://iot.lenovo.com/fitness/createFitDataSource"
#define HTTP_GET_FIT_DATA_SOURCE                @"http://iot.lenovo.com/fitness/getFitDataSource"
#define HTTP_GET_FIT_DATA_SOURCE_BY_CONDITION   @"http://iot.lenovo.com/fitness/getFitDataSourceByCondition"
#define HTTP_LIST_FIT_DATA_SOURCE               @"http://iot.lenovo.com/fitness/listFitDataSource"
#define HTTP_CREATE_FIT_DATA_TYPE               @"http://iot.lenovo.com/fitness/createFitDataType"
#define HTTP_UPLOAD_FIT_DATA_POINT              @"http://iot.lenovo.com/fitness/uploadFitDataPoint"
#define HTTP_UPLOAD_FIT_DATA_SET                @"http://iot.lenovo.com/fitness/uploadFitDataSet"
#define HTTP_GET_FIT_DATA_SET                   @"http://iot.lenovo.com/fitness/getFitDataSet"
#define HTTP_UPLOAD_FIT_EVENT                   @"http://iot.lenovo.com/fitness/insertFitEvent"
#define HTTP_GET_FIT_EVENT                      @"http://iot.lenovo.com/fitness/getFitEvent"
#define HTTP_GET_STATISTICS                     @"http://iot.lenovo.com/fitness/statistics"
#define HTTP_UPLOAD_PICTURE                     @"http://iot.lenovo.com/attachment/image/upload"
#define identifier [[NSBundle mainBundle] bundleIdentifier]
@implementation HTTPManage

+ (void)createFitDataSourceWithFitDataSourceModel:(FitDataSource_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    //    NSString *fitApplication = @"{\"appKey\":\"SG1505105378\",\"detailUrl\":\"http://run.lenovo.com.cn\",\"name\":\"ProBand\",\"packageName\":\"com.fendateam.ProBand\",\"version\":\"1.0.0\"}";
    //    NSString *fitDevice = @"{\"deviceId\":\"666666\",\"manufacturer\":\"fenda\",\"model\":\"110\",\"version\":\"1.0\",\"type\":3}";
    
    NSString *fitApplication = [NSString stringWithFormat:@"{\"appKey\":\"%@\",\"detailUrl\":\"%@\",\"name\":\"%@\",\"packageName\":\"%@\",\"version\":\"%@\"}",model.appModel.appKey,model.appModel.detailUrl,model.appModel.name,model.appModel.packageName,model.appModel.version];
    
    NSString *fitDevice = [NSString stringWithFormat:@"{\"deviceId\":\"%@\",\"manufacturer\":\"%@\",\"model\":\"%@\",\"version\":\"%@\",\"type\":3}",model.deviceModel.deviceId,model.deviceModel.manufacturer,model.deviceModel.model,model.deviceModel.version];
    NSString *fitDataSource=[NSString stringWithFormat:@"{\"fitApplication\":%@,\"fitDevice\":%@}",fitApplication,fitDevice];
    
    [request postToPath:HTTP_CREATE_FIT_DATA_SOURCE ParaDic:@{
                                                              @"open_id":OPEN_ID,
                                                              @"version":VERSION,
                                                              @"user_type":USER_TYRE,
                                                              @"app_key":APP_KEY,
                                                              @"app_signature":APP_SIGNATURE,
                                                              @"fitDataSource":fitDataSource
                                                              }];
    
    
}

+ (void)getFitDataSourceBySourceId:(int)fitDataSourceId  Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !fitDataSourceId) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    [request postToPath:HTTP_GET_FIT_DATA_SOURCE ParaDic:@{
                                                           @"open_id":OPEN_ID,
                                                           @"version":VERSION,
                                                           @"user_type":USER_TYRE,
                                                           @"app_key":APP_KEY,
                                                           @"app_signature":APP_SIGNATURE,
                                                           @"fitDataSourceId":[NSNumber numberWithInt:fitDataSourceId]
                                                           }];
}

+ (void)getFitDataSourceByFitDeviceModel:(FitDevice_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    NSString *fitDevice = [NSString stringWithFormat:@"{\"deviceId\":\"%@\",\"manufacturer\":\"%@\",\"model\":\"%@\",\"version\":\"%@\",\"type\":3}",model.deviceId,model.manufacturer,model.model,model.version];
    //        NSString *fitDevice = @"{\"deviceId\":\"666666\",\"manufacturer\":\"fenda\",\"model\":\"110\",\"version\":\"1.0\",\"type\":3}";
    [request postToPath:HTTP_GET_FIT_DATA_SOURCE_BY_CONDITION ParaDic:@{
                                                                        @"open_id":OPEN_ID,
                                                                        @"version":VERSION,
                                                                        @"user_type":USER_TYRE,
                                                                        @"app_key":APP_KEY,
                                                                        @"app_signature":APP_SIGNATURE,
                                                                        @"fitDevice":fitDevice
                                                                        }];
}

+ (void)getFitDataSourceListWithblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    [request postToPath:HTTP_LIST_FIT_DATA_SOURCE ParaDic:@{
                                                            @"open_id":OPEN_ID,
                                                            @"version":VERSION,
                                                            @"user_type":USER_TYRE,
                                                            @"app_key":APP_KEY,
                                                            @"app_signature":APP_SIGNATURE
                                                            }];
}

+ (void)createCustomFitDataTypeWithFitDataTypeModel:(FitDataType_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    NSMutableString *stringM = [NSMutableString string];
    for (int i = 0; i < model.fitfields.count; i++) {
        FitField_Model *fitFieldModel = model.fitfields[i];
        NSString *string = [NSString stringWithFormat:@"{\"name\":\"%@\",\"format\":%d}",fitFieldModel.name,fitFieldModel.format];
        [stringM appendString:string];
        if (i < model.fitfields.count - 1) {
            [stringM appendString:@","];
        }
    }
    
    NSString *fitDataType = [NSString stringWithFormat:@"{\"fitFields\":[%@],\"name\":\"%@\"}",stringM,model.name];
    
    [request postToPath:HTTP_CREATE_FIT_DATA_TYPE ParaDic:@{
                                                            @"open_id":OPEN_ID,
                                                            @"version":VERSION,
                                                            @"user_type":USER_TYRE,
                                                            @"app_key":APP_KEY,
                                                            @"app_signature":APP_SIGNATURE,
                                                            @"fitDataType":fitDataType
                                                            }];
}

+ (void)uploadFitDataPointWithFitDataPointModel:(FitDataPoint_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    NSMutableString *stringM = [NSMutableString string];
    for (int i = 0; i < model.values.count; i++) {
        FitValue_Model *fitValueModel = model.values[i];
        NSString *string = [NSString stringWithFormat:@"{\"value\":\"%@\",\"format\":%d}",fitValueModel.value,fitValueModel.format];
        [stringM appendString:string];
        if (i < model.values.count - 1) {
            [stringM appendString:@","];
        }
    }
    
    //    NSString *fitDataPoint = @"{\"fitValues\":[{\"value\":\"5245AABB245\",\"format\":2},{\"value\":\"201507011720\",\"format\":2},{\"value\":\"fenda\",\"format\":2}],\"fitDataTypeName\":\"com.lenovo.settings.heartbeat\",\"startTime\":1427267012142,\"endTime\":1427267013142,\"fitDataSourceId\":118}";
    NSString *fitDataPoint = [NSString stringWithFormat:@"{\"fitValues\":[%@],\"fitDataTypeName\":\"%@\",\"startTime\":%ld,\"endTime\":%ld,\"fitDataSourceId\":%d}", stringM, model.fitDataTypeName, model.startTime, model.entTime, model.fitDataSourceId];
    [request postToPath:HTTP_UPLOAD_FIT_DATA_POINT ParaDic:@{
                                                             @"open_id":OPEN_ID,
                                                             @"version":VERSION,
                                                             @"user_type":USER_TYRE,
                                                             @"app_key":APP_KEY,
                                                             @"app_signature":APP_SIGNATURE,
                                                             @"fitDataPoint":fitDataPoint
                                                             }];
    
}

+ (void)uploadFitDataSetWithFitDataSetModel:(FitDataSet_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    NSMutableString *stringM = [NSMutableString string];
    for (int i = 0; i < model.FitDataPoints.count; i++)
    {
        
        FitDataPoint_Model *fitDataPoint = model.FitDataPoints[i];
        
        NSMutableString *tempStr = [NSMutableString string];
        for (int j = 0; j < fitDataPoint.values.count; j++)
        {
            FitValue_Model *value = fitDataPoint.values[j];
            NSString *string = [NSString stringWithFormat:@"{\"value\":\"%@\",\"format\":%d},",value.value,value.format];
            
            if (j == fitDataPoint.values.count-1) {
                [tempStr appendString:[NSString stringWithFormat:@"{\"value\":\"%@\",\"format\":%d}",value.value,value.format]];
            }else{
                [tempStr appendString:string];
            }
            
        }
        
        NSString *fitDataP = [NSString stringWithFormat:@"{\"fitValues\":[%@],\"fitDataTypeName\":\"%@\",\"startTime\":%ld,\"endTime\":%ld,\"fitDataSourceId\":%d}", tempStr, fitDataPoint.fitDataTypeName, fitDataPoint.startTime, fitDataPoint.entTime, fitDataPoint.fitDataSourceId];
        
        [stringM appendString:fitDataP];
        if (i < model.FitDataPoints.count - 1) {
            [stringM appendString:@","];
        }
    }
    
    
    NSString *fitDataSet = [NSString stringWithFormat:@"{\"fitDataPoints\":[%@], \"fitDataTypeName\":\"%@\", \"fitDataSourceId\":%d, \"minStartTime\":\"%ld\",\"maxEntTime\":\"%ld\"}", stringM, model.fitDataTypeName, model.fitDataSourceId, model.minStartTime, model.maxEntTime];
    NSLog(@"%@", fitDataSet);
//    
//    NSString *str = @"{\"fitDataPoints\":[{\"fitValues\":[{\"value\":\"5\",\"format\":2},{\"value\":\"19\",\"format\":2},{\"value\":\"15\",\"format\":2},{\"value\":\"1\",\"format\":2},{\"value\":\"120\",\"format\":2},{\"value\":\"鬼鬼祟祟\",\"format\":2},{\"value\":\"0\",\"format\":2},{\"value\":\"1\",\"format\":2},{\"value\":\"0\",\"format\":2}],\"fitDataTypeName\":\"com.lenovo.appdemo.userAlarm\",\"startTime\":1436151478,\"endTime\":1436151500,\"fitDataSourceId\":6186}], \"fitDataTypeName\":\"com.lenovo.appdemo.userAlarm\", \"fitDataSourceId\":6186, \"minStartTime\":\"1436151478\",\"maxEntTime\":\"1436151500\"}";
    [request postToPath:HTTP_UPLOAD_FIT_DATA_SET ParaDic:@{
                                                             @"open_id":OPEN_ID,
                                                             @"version":VERSION,
                                                             @"user_type":USER_TYRE,
                                                             @"app_key":APP_KEY,
                                                             @"app_signature":APP_SIGNATURE,
                                                             @"fitDataSet":fitDataSet
                                                             }];
}

+ (void)getFitDataSetWithFitDataSetModel:(FitDataSet_Model *)model Withblock:(void (^)(NSData *,NSError *))block
{
    if (!OPEN_ID || !USER_TYRE || !model) return;
    
    HttpBase *request = [[HttpBase alloc]init];
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    //nextPageIndex=0&endTime=1427267221610&dataSourceId=2&user_type=QQ&fitDataTy peName=com.lenovo.running&app_key=SG1503205676&app_signature=e61abff2b829f6e9a2dc77ee166867af&startTime =1427180821610
    [request postToPath:HTTP_GET_FIT_DATA_SET ParaDic:@{
                                                        @"open_id":OPEN_ID,
                                                        @"version":VERSION,
                                                        @"user_type":USER_TYRE,
                                                        @"app_key":APP_KEY,
                                                        @"app_signature":APP_SIGNATURE,
                                                        @"dataSourceId":[NSNumber numberWithInt:model.fitDataSourceId],
                                                        @"startTime":[NSNumber numberWithLong:model.minStartTime],
                                                        @"endTime":[NSNumber numberWithLong:model.maxEntTime],
                                                        @"fitDataTypeName":model.fitDataTypeName,
                                                        @"nextPageIndex":[NSNumber numberWithInt:0]
                                                        }];
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}
+(void)getTokenWithblock:(void (^)(NSData *,NSError *))block
{
    
    HttpBase *request = [[HttpBase alloc]init];
    // NSLog(@"=======>>>>>>%@",userIdStr);
    request.requestBlock = ^(NSData *resultData,NSError *error)
    {
        block(resultData,error);
    };
    
    NSString *paras=@"grant_type=\"client_credentials\"&client_id=\"YXA6Jujt8O16EeSau_e63Ryq-g\"&client_secret=\"YXA6k48yIneEM6EUMp0lRGgM2szVYaQ\"";
    
    [request postToPath:@"https://a1.easemob.com/fendaxlab/vb10/token" ParaDic:@{
                                                                                 @"grant_type":@"client_credentials",
                                                                                 @"client_id":@"YXA6Jujt8O16EeSau_e63Ryq-g",
                                                                                 @"client_secret":@"YXA6k48yIneEM6EUMp0lRGgM2szVYaQ",
                                                                                 }];
    
}

-(void)registerUsername:(NSString *)Username password:(NSString *)password Nickname:(NSString *)Nickname  block:(void (^)(NSData *,NSError *))block
{
    HttpBase *request = [[HttpBase alloc]init];
    // NSLog(@"=======>>>>>>%@",userIdStr);
    request.requestBlock = ^(NSData *resultData,NSError *error){
        block(resultData,error);
    };
    
    
    [request getWithPath:@"authentication.fcgi" ParaDic:@{
                                                          @"grant_type":@"client_credentials",
                                                          @"client_id":@"YXA6Jujt8O16EeSau_e63Ryq-g",
                                                          @"client_secret":@"YXA6k48yIneEM6EUMp0lRGgM2szVYaQ",
                                                          }];
    
    
}

+(void)uploadImageWithUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName  block:(void (^)(NSData *,NSError *))block
{
    HttpBase *request = [[HttpBase alloc]init];
    // NSLog(@"=======>>>>>>%@",userIdStr);
    request.requestBlock = ^(NSData *resultData,NSError *error){
        block(resultData,error);
    };
    
    [request uploadImageToUrl:urlString ParaDic:ParaDic andImage:img imageName:imageName];
    
}

+(void)downloadImageWithUrl:(NSString *)urlString  block:(void (^)(NSData *,NSError *))block
{
    HttpBase *request = [[HttpBase alloc]init];
    // NSLog(@"=======>>>>>>%@",userIdStr);
    request.requestBlock = ^(NSData *resultData,NSError *error){
        block(resultData,error);
    };
    
    [request getWithPath:urlString ParaDic:nil];
    
}

@end
