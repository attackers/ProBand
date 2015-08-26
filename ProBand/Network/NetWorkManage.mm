//
//  NetWorkManage.m
//  LenovoVB10
//
//  Created by fenda on 14/12/25.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "NetWorkManage.h"
#import "HomeNetUnit.h"
#import "GetWeatherUnit.h"
#import "RegisterNetUnit.h"
#import "LoginNetUnit.h"

#import "NSData+AES.h"
#import "Base64.h"
#import "NSString+MD5.h"

#import "FBEncryptorAES.h"
#import "NSData+Base64.h"
#import "HTTPManage.h"
#include "encrypt.h"
#import "SettingStatus.h"
//#import "SettingModelManager.h"
#import "AllModel.h"
#import "UserInfoModel.h"
#import "UserTargetModel.h"
#import "StepdownModel.h"
#import "AllModel.h"

#define  appid @"23398"
// 注册登录用此key 和iv
#define  AES_TOKEN_KEY "A46547336A7A1664F1418A46C4339155"
#define  AES_TOKEN_IV  "296718E8041FC067C9DA390043580247"

//数据交互用此key和iv
#define  AES_SERVICE_KEY "AF69E99E9FC36969A074E8BAC37D7338"
#define  AES_SERVICE_IV  "ED9FB68670850B23E99333807DDB60F4"


#define LoginRegisterUrl @"http://116.7.249.146:8169/"//@"http://192.168.2.231:8169/"

#define FDFileBoundary @"fenda"
#define FDNewLien @"\r\n"
#define FDEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
#define token ([Singleton getTokenInfo:@"token"])

@implementation NetWorkManage

/**
 *  获取拼接后的接口地址
 *
 *  @param baseUrl 基础公用接口
 *  @param url     接口名称
 *
 *  @return url
 */
+(NSString *)getUrlwithBaseUrlString:(NSString *)baseUrl withUrl:(NSString *)url{
    NSString *urlStr = HttpServerURL;
    if (url.length>0 && url != nil)
    {
        urlStr = [NSString stringWithFormat:@"%@%@",baseUrl,url];
       // NSLog(@"--->>>%@",urlStr);
    }
    return urlStr;
}
/**
 *  获取天气以及pm2.5的接口
 *
 *  @param cityName 此参数可以填写所要获取的城市(经纬度)
 *  @param flag     是否查询的是国外天气（是yes）
 *  @param block    结果通过block返回
 */
+(void)getWeatherInfoWithDic:(NSString *)cityName isForeignCity:(BOOL)flag block:(void (^)(BOOL,id))block{
    GetWeatherUnit *post = [GetWeatherUnit new];
    post.completion = ^(id result,BOOL succ){
     block(succ,result);
    };
    [post getWeatherInfo:cityName isForeignCity:flag];
  
}
/**
 *  获取注册验证码
 *
 *  @param params 字典参数
 *  @param block  结果通过block返回
 */
+(void)getRegisterVerifiyCode:(NSDictionary *)params block:(void (^)(BOOL,id))block{

    RegisterNetUnit *post = [RegisterNetUnit new];
    post.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    [post  startGet:@"https://uss.lenovomm.com/capt/1.2/getimage" params:params dataKey:nil];
}

/**
 *  登录
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)loginIN:(NSDictionary *)params withModel:(LoginModel *)loginModel  block:(void (^)(BOOL, id))block{
   
    LoginNetUnit *post = [LoginNetUnit new];
    post.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    NSString *url =[NSString stringWithFormat:@"https://uss.lenovomm.com/authen/1.2/tgt/user/get?%@=%@",loginModel.userTypeName,loginModel.userNameValue];
    NSLog(@"--->>>Star:%@",url);
    [post startRequestWithType:@"POST" withUrl:url  withInfo:params];
   
}
/**
 *  登录成功后获取某些特定值
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)loginInwithGetData:(NSDictionary *)params block:(void (^)(BOOL, id))block{
    
    LoginNetUnit *post = [LoginNetUnit new];
    post.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    [post  startGet:@"https://uss.lenovomm.com/authen/1.2/st/get" params:params dataKey:nil];   
}

/**
 *  注册
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)registerUser:(NSDictionary *)params withModel:(LoginModel *)loginModel  block:(void (^)(BOOL, id))block{
    RegisterNetUnit *post = [RegisterNetUnit new];
    post.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    NSString *url =[NSString stringWithFormat:@"https://uss.lenovomm.com/accounts/1.2/user/new/alldevice?%@=%@",loginModel.userTypeName,loginModel.userNameValue];
    NSLog(@"---0000->>>>>>>>%@=====>>>>>%@",url,params);
    
    
    [post startRequestWithType:@"POST" withUrl:url  withInfo:params];

}

+(void)registerUsername:(NSString *)Username password:(NSString *)password Nickname:(NSString *)Nickname  block:(void (^)(BOOL, id))block{
    RegisterNetUnit *post = [RegisterNetUnit new];
    post.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    //注册的APPID是10
    NSString *str=[NSString stringWithFormat:@"{\"userid\":\"%@\",\"appid\":\"10\",\"username\":\"%@\",\"password\":\"%@\",\"options\":\"1\"}",Username,Nickname,password];
    //NSString *str=@"{\"userid\":\"test221@bbb.ccc\",\"appid\":\"10\",\"username\":\"wqqq\",\"password\":\"222222\",\"options\":\"1\"}";

   
    
    string ss = encrypt::AESEncode([str UTF8String],AES_TOKEN_KEY,AES_TOKEN_IV);
    NSLog(@"str=%@",str);
    NSString *url =[NSString stringWithFormat:@"%@authentication.fcgi",weburl];
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];//[Base64 encode:AESData];//[AESData base64EncodedString];
    NSLog(@"base64String=%@",base64String);
    
    [post startRequestWithType:@"POST" withUrl:url  withInfo:@{
                                                               @"nsp_svc":@"authentication",
                                                               @"nsp_params":base64String,
                                                               @"finger_print":[base64String md5Encrypt],
                                                               @"nsp_ts":@"",
                                                              @"nsp_ver":@"",
                                                               @"access_token":@""
                                                              
                                                               }];
    
}

+(void)threadActionlogin:(NSString *)userIdStr withBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
   // NSLog(@"=======>>>>>>%@",userIdStr);
    request.completion = ^(id result,BOOL succ){
        block(succ,result);
    };
    NSString *str = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"appid\":\"23398\",\"options\":\"3\"}",userIdStr];
    //NSString *str = @"{\"userid\":\"1005647\",\"appid\":\"23398\",\"options\":\"3\"}";
    NSLog(@"=str%@",str);
    string ss = encrypt::AESEncode([str UTF8String],AES_TOKEN_KEY,AES_TOKEN_IV);
   // NSLog(@"----%s",ss.c_str());
    NSString *url =[NSString stringWithFormat:@"%@authentication.fcgi",LoginRegisterUrl];
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    
     NSLog(@"base64String %@",base64String);
    
    NSDictionary *dic = @{
                          @"nsp_svc":@"authentication",
                          @"nsp_params":base64String,
                          @"finger_print":[base64String md5Encrypt],
                          @"nsp_ts":@"",
                          @"nsp_ver":@"",
                          @"access_token":@""
                          };
    NSLog(@"第三方登录请求串为：%@",dic);
   // [request startRequestWithType:@"POST" withUrl:url withInfo:dic isUrlEncode:YES];
    [request startRequestWithType:@"POST" withUrl:url withInfo:dic];
   
    
    
}

+ (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}
-(void)registerUsername:(NSString *)Username password:(NSString *)password Nickname:(NSString *)Nickname
{
    
    
    
}

/**
 *  忘记密码
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)forgetSecrect:(NSDictionary *)params withTypeName:(NSString *)typeName  withName:(NSString *)name block:(void (^)(BOOL, id))block
{
    RegisterNetUnit *post = [RegisterNetUnit new];
    post.completion = ^(id result,BOOL succ){
        NSString *result1 = [Contants valuableCodeInTag:@"<Code>" andTag:@"</Code>" withString:result];
        
        block(YES,result1);
        
    };
     NSString *url = [NSString stringWithFormat:@"https://uss.lenovomm.com/accounts/1.2/passwd/forgot?%@=%@",typeName,name];
    [post startRequestWithType:@"POST" withUrl:url  withInfo:params];
    
}
/**
 *  重置密码
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)resetSecrect:(NSDictionary *)params withTypeName:(NSString *)typeName  withName:(NSString *)name block:(void (^)(BOOL, id))block
{
    RegisterNetUnit *post = [RegisterNetUnit new];
    post.completion = ^(id result,BOOL succ){
        NSString *result1 = [Contants valuableCodeInTag:@"<Code>" andTag:@"</Code>" withString:result];
        
        block(YES,result1);
        
    };
    NSString *url = [NSString stringWithFormat:@"https://uss.lenovomm.com/accounts/1.2/passwd/forgot_smsverify?%@=%@",typeName,name];
    [post startRequestWithType:@"POST" withUrl:url  withInfo:params];
    
}

+ (void)submitUserInfoToServer:(UserInfoModel *)user withUserImage:(NSData *)userImage withUnitsFormat:(NSString *)HeightStr withUnitWeight:(NSString *)weightStr withBlock:(void (^)(BOOL, id))block
{
    if (!token || !user || userImage.length == 0 || !HeightStr||!weightStr) return;
    // 非文件参数
    NSDictionary *params = @{@"access_token" : token};
    if (userImage.length <= 1048576){//1048576为1M
        [self upload:@"userImage.jpg" mimeType:nil fileData:userImage params:params];
    }
    
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    
    NSString *nsp_params =[NSString stringWithFormat:@"{\"setting\": \"{\\\"height\\\": \\\"%@\\\",\\\"heightFormat\\\": \\\"%@\\\",\\\"weight\\\": \\\"%@\\\",\\\"weightFormat\\\": \\\"%@\\\",\\\"birthday\\\": \\\"%@\\\",\\\"nikeName\\\":\\\"%@\\\",\\\"retstring\\\": \\\"\\\"}\",\"gender\": \"%@\",\"options\": \"1\"}",user.height, HeightStr,user.weight,weightStr,user.birthDay,user.userName,user.gender];
    NSLog(@"nsp_params:%@",nsp_params);
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 }];// isUrlEncode:YES
}

+ (void)getUserInfoFromServerWithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    
    NSString *nsp_params =@"\{\"options\":\"6\"}";
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    NSLog(@"base64String=%@",base64String);
     NSLog(@"token=%@",token);
    if(token.length>0)
    {
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 }];//isUrlEncode:YES
    }
}



+ (void)setUpUserTarget:(UserTargetModel *)userTarger withBlock:(void (^)(BOOL, id))block
{
    NSLog(@"setUpUserTarget: to server");
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //userid,stepTarget,startTime,endTime,sleepTarget,botherStart,botherEnd,botherStatus
    NSString *nsp_params = [NSString stringWithFormat:@"{\"setting\": \"{\\\"stepTarget\\\":\\\"%@\\\"}\",\"options\": \"2\"}",userTarger.stepTarget];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)getUserTargetFromServerWithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    NSString *nsp_params = @"\{\"options\":\"7\"}";
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)submitUserSetting:(AllModel *)models  WithBlock:(void (^)(BOOL, id))block
{
    if (token.length==0 || !models.setStatusObj || !models.clockModelArr.count || !models.tagetModelObj) return;
    
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };

    union switchStatus
    {
        struct{
            char cloudBackup:1;//一键备份
            char phoneAntiLost:1;//手机防丢
            char unlockPhone:1;//手机解锁
            char messageRefused:1;//拒接回短信
            char contactsReceiveOnly:1;//仅接收通讯录
            char searchPhone:1;        //手机查找
            char TwitterSwitch:1;
            char FaceBookSwitch:1;
            char WhatsappSwitch:1;
            char weatherSwitch:1;
            char batteryAlertSwitch:1;  //电量推送
            char wecatSwitch:1;
            char callSwitch:1;
            char smsSwitch:1;
        }switchs;
        unsigned int switchsS;
    }sss;
    memset(&sss, 0, sizeof(sss));
    sss.switchs.smsSwitch = *(char *)[models.setStatusObj.smsStatus UTF8String];
    sss.switchs.callSwitch = *(char *)[models.setStatusObj.callState UTF8String];
    sss.switchs.wecatSwitch = *(char *)[models.setStatusObj.wecatState UTF8String];
    sss.switchs.batteryAlertSwitch = *(char *)[models.setStatusObj.BatteryPowerPush UTF8String];
    sss.switchs.weatherSwitch = *(char *)[models.setStatusObj.weatherState UTF8String];
    sss.switchs.WhatsappSwitch = *(char *)[models.setStatusObj.WhatsappState UTF8String];
    sss.switchs.FaceBookSwitch = *(char *)[models.setStatusObj.FaceBookState UTF8String];
    sss.switchs.TwitterSwitch = *(char *)[models.setStatusObj.TwitterState UTF8String];
    sss.switchs.searchPhone = *(char *)[models.setStatusObj.FindPhone UTF8String];
    sss.switchs.phoneAntiLost = *(char*)[models.setStatusObj.LinkLostPhone UTF8String];
    sss.switchs.cloudBackup = *(char *)[models.setStatusObj.ColudBackUp UTF8String];
    
    NSLog(@"推送开关状态-->>%d", sss.switchsS);

    NSMutableString *stringM = [NSMutableString string];
    for (int i = 0; i < models.clockModelArr.count; i++) {
        ClockModel *model = models.clockModelArr[i];
        NSString *string = [NSString stringWithFormat:@"{\\\"alarmName\\\":\\\"%@\\\",\\\"alarmTime\\\":\\\"%@\\\",\\\"interval\\\":\\\"%@\\\",\\\"repeat\\\":\\\"%d\\\",\\\"status\\\":\\\"%@\\\"}",model.name,model.startTime,model.interval,btd([model.repeat UTF8String]),model.status];
        [stringM appendString:string];
        if (i < models.clockModelArr.count - 1) {
            [stringM appendString:@","];
        }
    }
    NSLog(@"手环闹钟---->>>%@",stringM);
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    NSLog(@"botherStart: %@",models.tagetModelObj.botherStart);
    NSLog(@"endTimeStart: %@",models.tagetModelObj.endTime);
    NSLog(@"botherStart: %@",models.tagetModelObj.botherStatus);
    
    NSString *nsp_params =[NSString stringWithFormat:@"{\"setting\":\"{\\\"alarms\\\":[%@],\\\"fazeStartTime\\\":\\\"%@\\\",\\\"fazeEndTime\\\":\\\"%@\\\",\\\"fazeSwitch\\\":\\\"%@\\\",\\\"swithchs\\\": \\\"%u\\\",\\\"clockDaile\\\":\\\"%@\\\",\\\"restarting\\\":\\\"保留字段\\\"}\",\"options\":\"3\"}",stringM,models.tagetModelObj.botherStart,models.tagetModelObj.botherEnd,models.tagetModelObj.botherStatus,sss.switchsS,models.setStatusObj.clockDaile];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)getUserSettingFromServerWithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    NSString *nsp_params = @"\{\"options\":\"8\"}";
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)bindingDevice:(NSString *)mac withBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //nsp_params :{"devmac":"FF:FF:FF:FF:FF:FF","options":"4"}
    NSString *nsp_params = [NSString stringWithFormat:@"{\"devmac\":\"%@\",\"options\":\"4\"}",mac];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)unBindingDeviceWithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //nsp_params :{"devmac":"FF:FF:FF:FF:FF:FF","options":"4"}
    NSString *nsp_params = @"\{\"options\":\"5\"}";
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"1",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)submitSportDataToServer:(stepDate_deviceid_Model *)stepDown withBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    //"total":"步数总和","calories":"","distance":"距离","datetime":"","reached":"是否达标","options":"1"
    //"total":"1000","calories":"1000","distance":"1000","datetime":"2015-04-03","reached":"2","options":"1"}
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //userId,mac,date,steps,meters,calories,totalSteps,totalDistance,totalCalories,sportDuration

    NSString *nsp_params = [NSString stringWithFormat:@"{\"total\":\"%@\",\"calories\":\"%@\",\"distance\":\"%@\",\"datetime\":\"%@\",\"reached\":\"2\",\"options\":\"1\"}",stepDown.totalSteps,stepDown.totalCalories,stepDown.totalDistance,stepDown.date];
    NSLog(@"1111-－－－－－%@",nsp_params);
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"3",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (BOOL)submitSportDataToServer:(stepDate_deviceid_Model *)stepDown
{
    NetWorking *request = [[NetWorking alloc]init];
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    
    NSString *nsp_params = [NSString stringWithFormat:@"{\"total\":\"%@\",\"calories\":\"%@\",\"distance\":\"%@\",\"datetime\":\"%@\",\"reached\":\"2\",\"options\":\"1\"}",stepDown.totalSteps,stepDown.totalCalories,stepDown.totalDistance,stepDown.date];
//    NSLog(@"------>%@",nsp_params);
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    BOOL result =  [request sendSyncRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                    @"nsp_svc":@"3",
                                                                    @"access_token":token,
                                                                    @"nsp_params":base64String,
                                                                    @"nsp_ts":@"",
                                                                    @"nsp_ver":@"",
                                                                    @"finger_print":@""
                                                                    } isUrlEncode:YES];
    return result;
}

+ (void)getSportDataFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //nsp_params :{"page":"1","dateend":"2015-04-04","datebegin":"2015-04-02","options":"2"}
    NSString *nsp_params = [NSString stringWithFormat:@"{\"page\":\"%d\",\"dateend\":\"%@\",\"datebegin\":\"%@\",\"options\":\"2\"}",page, dateEnd, dateBegin];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"3",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (void)submitSportDetailWithModel:(stepDate_deviceid_Model *)model   WithBlock:(void (^)(BOOL, id))block
{
    
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    NSString *nsp_params = [NSString stringWithFormat:@"{\"datetime\":\"%@\",\"detail\":\"%@\",\"options\":\"3\"}",model.date,model.steps];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"3",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (BOOL)submitSportDetailWithModel:(stepDate_deviceid_Model *)model
{
    NetWorking *request = [[NetWorking alloc]init];
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    NSString *nsp_params = [NSString stringWithFormat:@"{\"datetime\":\"%@\",\"detail\":\"%@\",\"options\":\"3\"}",model.date,model.steps];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    BOOL result =  [request sendSyncRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                                   @"nsp_svc":@"3",
                                                                                   @"access_token":token,
                                                                                   @"nsp_params":base64String,
                                                                                   @"nsp_ts":@"",
                                                                                   @"nsp_ver":@"",
                                                                                   @"finger_print":@""
                                                                                   } isUrlEncode:YES];
    return result;

}

+ (void)getSportDetailFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //@""
    NSString *nsp_params = [NSString stringWithFormat:@"{\"page\":\"%d\",\"dateend\":\"%@\",\"datebegin\":\"%@\",\"options\":\"4\"}",page, dateEnd, dateBegin];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"3",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}


+ (void)submitSleepData:(sleepDate_deviceid_Model *)model WithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    
    NSString *nsp_params = [NSString stringWithFormat:@"{\"deepsleep\":\"%@\",\"quality\":\"%@\",\"awaketime\":\"%@\",\"totaltime\":\"%@\",\"datetime\":\"%@\",\"lightsleep\":\"%@\",\"reached\":\"%@\",\"options\":\"1\"}",model.deepTime,model.quality,model.wakeTime,model.totalSleep,model.date,model.lightTime,@"0"];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"2",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
 
}

+ (BOOL)submitSleepData:(sleepDate_deviceid_Model *)model
{
    NetWorking *request = [[NetWorking alloc]init];
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    
    NSString *nsp_params = [NSString stringWithFormat:@"{\"deepsleep\":\"%@\",\"quality\":\"%@\",\"awaketime\":\"%@\",\"totaltime\":\"%@\",\"datetime\":\"%@\",\"lightsleep\":\"%@\",\"reached\":\"%@\",\"options\":\"1\"}",model.deepTime,model.quality,model.wakeTime,model.totalSleep,model.date,model.lightTime,@"0"];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    BOOL result =  [request sendSyncRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                                   @"nsp_svc":@"2",
                                                                                   @"access_token":token,
                                                                                   @"nsp_params":base64String,
                                                                                   @"nsp_ts":@"",
                                                                                   @"nsp_ver":@"",
                                                                                   @"finger_print":@""
                                                                                   } isUrlEncode:YES];
    return result;
}


/**
 *  获取睡眠数据
 *
 *  @param dateBegin 查询开始日期(必选) 参数格式:2015-04-04
 *  @param dateEnd   查询截止日期(必选) 参数格式:2015-04-04
 *  @param page      查询页码(必选 不可以为0)
 *  @param block     结果通过block返回
 */
+ (void)getSleepDataFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //{\"page\":\"1\",\"dateend\":\"2015-04-17\",\"datebegin\":\"2015-04-16\",\"options\":\"2\"}
    NSString *nsp_params = [NSString stringWithFormat:@"{\"page\":\"%d\",\"dateend\":\"%@\",\"datebegin\":\"%@\",\"options\":\"2\"}",page,dateEnd,dateBegin];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"2",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
    
}

+ (void)submitSleepDetail:(sleepDate_deviceid_Model *)model WithBlock:(void (^)(BOOL, id))block
{
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //@"{\"datetime\":\"2015-04-16\",\"detail\":\"11\",\"options\":\"3\"}"
    NSString *nsp_params = [NSString stringWithFormat:@"{\"datetime\":\"%@\",\"detail\":\"%@\",\"options\":\"3\"}",model.date,model.sleeps];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"2",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

+ (BOOL)submitSleepDetail:(sleepDate_deviceid_Model *)model
{
    NetWorking *request = [[NetWorking alloc]init];
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //@"{\"datetime\":\"2015-04-16\",\"detail\":\"11\",\"options\":\"3\"}"
    NSString *nsp_params = [NSString stringWithFormat:@"{\"datetime\":\"%@\",\"detail\":\"%@\",\"options\":\"3\"}",model.date,model.sleeps];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    BOOL result =  [request sendSyncRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                                   @"nsp_svc":@"2",
                                                                                   @"access_token":token,
                                                                                   @"nsp_params":base64String,
                                                                                   @"nsp_ts":@"",
                                                                                   @"nsp_ver":@"",
                                                                                   @"finger_print":@""
                                                                                   } isUrlEncode:YES];
    return result;
}

+ (void)getSleepDetailFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block
{
    
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //@""
    NSString *nsp_params = [NSString stringWithFormat:@"{\"page\":\"%d\",\"dateend\":\"%@\",\"datebegin\":\"%@\",\"options\":\"4\"}",page,dateEnd,dateBegin];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"2",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
}

//test
+ (void)checkIsLoginwith:(NSDictionary *)params block:(void (^)(BOOL,id))block{

    HomeNetUnit *post = [HomeNetUnit new];
    post.completion = ^(id result,BOOL succ){
        
        block(succ,result);
    };
    [post startPost:[self getUrlwithBaseUrlString:HttpServerURL withUrl:@""] params:params  dataKey:nil];
//    [post downloadfilewithURL:[self getUrlwithBaseUrlString:DownloadFileURL withUrl:@""] withUnzip:YES];
}

/*将以字符串形式存储在s地址中的二进制数字转换为对应的十进制数字*/
int btd(const char *s)
{
    if (s == NULL) return 0;
    int rt=0;
    int i,n=0;
    
    while (s[n]) n++;
    
    for (--n,i=n; i>=0; i--)
        rt|=(s[i]-48)<<(n-i);
    
    return rt;
}


//+(void)submitClockInfon:(ClockModel *)params block:(void(^)(BOOL,id))block
//{
//    NSString *str = [NSString stringWithFormat:@"{\"alarms\":[{\"alarmName\":\"dinnerAlarm\",\"alarmTime\":\"18:15\",\"interval\":10,\"repeat\":127},{\"alarmName\":\"dinnerAlarm\",\"alarmTime\":\"18:15\",\"interval\":10,\"repeat\":127},{\"alarmName\":\"dinnerAlarm\",\"alarmTime\":\"18:15\",\"interval\":10,\"repeat\":127}],\"fazeEndTime\":\"18:00\",\"fazeStartTime\":\"10:00\",\"switchSetting\":[1,1,0,0,1]}"];
//}

+ (void)upload:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:@"http://116.7.249.146:8169/userimageupload.fcgi"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSMutableData *body = [NSMutableData data];
    
    // 1.文件参数
    [body appendData:FDEncode(@"--")];
    [body appendData:FDEncode(FDFileBoundary)];
    [body appendData:FDEncode(FDNewLien)];
    
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_image\"; filename=\"%@\"", filename];
    NSLog(@"%@",disposition);
    [body appendData:FDEncode(disposition)];
    [body appendData:FDEncode(FDNewLien)];
    
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@", mimeType];
    [body appendData:FDEncode(type)];
    [body appendData:FDEncode(FDNewLien)];
    
    [body appendData:FDEncode(FDNewLien)];
    [body appendData:fileData];
    [body appendData:FDEncode(FDNewLien)];
    
    // 2.非文件参数
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendData:FDEncode(@"--")];
        [body appendData:FDEncode(FDFileBoundary)];
        [body appendData:FDEncode(FDNewLien)];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
        [body appendData:FDEncode(disposition)];
        [body appendData:FDEncode(FDNewLien)];
        
        [body appendData:FDEncode(FDNewLien)];
        [body appendData:FDEncode([obj description])];
        [body appendData:FDEncode(FDNewLien)];
    }];
    
    // 3.结束标记
    [body appendData:FDEncode(@"--")];
    [body appendData:FDEncode(FDFileBoundary)];
    [body appendData:FDEncode(@"--")];
    [body appendData:FDEncode(FDNewLien)];
    
    request.HTTPBody = body;
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", FDFileBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
 __block NetWorkManage *blockSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"---Star-upLoad-:%@",resultStr);
        //将token保存到中
//        if (blockSelf.result) {
//            blockSelf.result(response, data, connectionError);
//            NSString *str = [NSString stringWithFormat:@"%@",data];
//            NSLog(@"---Star:%@",str);
//        }
    }];
    
}

+ (void)getUserImage:(void (^)(id))complete
{
    NSString *tokenTemp = [NetWorkManage URLEncodeStringFromString:token];
    NSString *strURL = [NSString stringWithFormat:@"%@userimage.fcgi?access_token=%@",LoginRegisterUrl,tokenTemp];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
   // NSHTTPURLResponse *response;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //response = response;
        complete(data);
        
    }];
    //return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
}
 //检查软件版本 options 1  android版本 2  ios版本 3 bluetooth版本 4 factory版本  5 ST版本
+ (void)checkBandVersionWithOptions:(int)options  WithBlock:(void (^)(BOOL, id))block
{
   if(token.length>0)
   {
   
   
    NetWorking *request = [[NetWorking alloc]init];
    request.completion = ^(id result,BOOL success){
        block(success,result);
    };
    
    NSString *url =[NSString stringWithFormat:@"%@fcgi-bin/platform/bin/rest.fcgi",weburl];
    //@""
    NSString *nsp_params = [NSString stringWithFormat:@"{\"options\":\"%d\"}",options];
    string ss = encrypt::AESEncode([nsp_params UTF8String],AES_SERVICE_KEY,AES_SERVICE_IV);
    NSString *base64String=  [NSString stringWithCString:ss.c_str() encoding:[NSString defaultCStringEncoding]];
    [request startRequestWithType:@"POST" withUrl:url withInfo:@{
                                                                 @"nsp_svc":@"4",
                                                                 @"access_token":token,
                                                                 @"nsp_params":base64String,
                                                                 @"nsp_ts":@"",
                                                                 @"nsp_ver":@"",
                                                                 @"finger_print":@""
                                                                 } isUrlEncode:YES];
   }
}
@end
