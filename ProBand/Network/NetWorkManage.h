//
//  NetWorkManage.h
//  LenovoVB10
//
//  Created by fenda on 14/12/25.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
#import "stepDate_deviceid_Model.h"
#import "sleepDate_deviceid_Model.h"
#import "settingInfo_Model.h"
@class t_userInfo;
@class t_stepData;

@class StepdownModel;
@class AllModel;
#import "SettingStatus.h"
static  NSString * const HttpServerURL = @"http://api.vmall.com/rest.php";
static  NSString * const DownloadFileURL = @"";
@interface NetWorkManage : NSObject
//@property(nonatomic, copy)void (^result)(NSURLResponse *response, NSData *data, NSError *connectionError);

/**
 *  获取拼接后的接口地址
 *
 *  @param baseUrl 基础公用接口
 *  @param url     接口名称
 *
 *  @return url
 */
+(NSString *)getUrlwithBaseUrlString:(NSString *)baseUrl withUrl:(NSString *)url;
/**
 *  获取天气以及pm2.5的接口
 *
 *  @param cityName 此参数可以填写所要获取的城市(经纬度)
 *  @param flag     是否查询的是国外天气（是yes）
 *  @param block    结果通过block返回
 */
+(void)getWeatherInfoWithDic:(NSString *)cityName isForeignCity:(BOOL)flag block:(void (^)(BOOL,id))block;

/**
 *  获取注册验证码
 *
 *  @param params 字典参数
 *  @param block  结果通过block返回
 */
+(void)getRegisterVerifiyCode:(NSDictionary *)params block:(void (^)(BOOL,id))block;

// 第三方登陆
+(void)threadActionlogin:(NSString *)userIdStr withBlock:(void (^)(BOOL, id))block;

/**
 *  登录
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)loginIN:(NSDictionary *)params withModel:(LoginModel *)loginModel  block:(void (^)(BOOL, id))block;
/**
 *  登录成功后获取某些特定值
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)loginInwithGetData:(NSDictionary *)params  block:(void (^)(BOOL, id))block;
/**
 *  注册
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)registerUser:(NSDictionary *)params withModel:(LoginModel *)loginModel  block:(void (^)(BOOL, id))block;
+(void)registerUsername:(NSString *)Username password:(NSString *)password Nickname:(NSString *)Nickname  block:(void (^)(BOOL, id))block;
/**
 *  忘记密码
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)forgetSecrect:(NSDictionary *)params withTypeName:(NSString *)typeName  withName:(NSString *)name block:(void (^)(BOOL,id))block;

/**
 *  重置密码
 *
 *  @param params 参数
 *  @param block  结果通过block返回
 */
+(void)resetSecrect:(NSDictionary *)params withTypeName:(NSString *)typeName  withName:(NSString *)name block:(void (^)(BOOL, id))block;

/**
 *  提交用户信息至服务器
 *
 *  @param user  用户Model
 *  @param block 结果通过block返回
 */
+ (void)submitUserInfoToServer:(t_userInfo *)user withUserImage:(NSData *)userImage withUnitsFormat:(NSString *)HeightStr withUnitWeight:(NSString *)weightStr withBlock:(void (^)(BOOL, id))block;

/**
 *  从服务器获取用户信息
 *
 *  @param block 结果通过block返回
 */
+ (void)getUserInfoFromServerWithBlock:(void (^)(BOOL, id))block;

/**
 *  提交个人目标至服务器
 *
 *  @param userTarger 用户目标Model
 *  @param block      结果通过block返回
 */
+ (void)setUpUserTarget:(t_stepData *)userTarger withBlock:(void (^)(BOOL, id))block;
/**
 *  获取个人目标
 *
 *  @param block 结果通过block返回
 */
+ (void)getUserTargetFromServerWithBlock:(void (^)(BOOL, id))block;

/**
 *  提交设备设置至服务器
 *
 *  @param models        Models
 *  @param block         结果通过block返回
 */
+ (void)submitUserSetting:(AllModel *)models WithBlock:(void (^)(BOOL, id))block;
/**
 *  获取用户设置
 *
 *  @param block 结果通过block返回
 */
+ (void)getUserSettingFromServerWithBlock:(void (^)(BOOL, id))block;

/**
 *  绑定设备
 *
 *  @param mac   mac地址
 *  @param block 结果通过block返回
 */
+ (void)bindingDevice:(NSString *)mac withBlock:(void (^)(BOOL, id))block;
/**
 *  解除设备绑定
 *
 *  @param block 结果通过block返回
 */
+ (void)unBindingDeviceWithBlock:(void (^)(BOOL, id))block;

/**
 *  提交运动数据至服务器
 *
 *  @param stepDown StepdownModel 运动Model
 *  @param block    结果通过block返回
 */
+ (void)submitSportDataToServer:(stepDate_deviceid_Model *)stepDown withBlock:(void (^)(BOOL, id))block;

+ (BOOL)submitSportDataToServer:(stepDate_deviceid_Model *)stepDown;
/**
 *  从服务器获取运动数据
 *
 *  @param dateBegin 查询开始日期(必选) 参数格式:2015-04-04
 *  @param dateEnd   查询截止日期(必选) 参数格式:2015-04-04
 *  @param page      查询页码(必选 不可以为0)
 *  @param block     结果通过block返回
 */
+ (void)getSportDataFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block;



/**
 *  从服务器获取运动数据详情
 *
 *  @param dateBegin 查询开始日期(必选) 参数格式:2015-04-04
 *  @param dateEnd   查询截止日期(必选) 参数格式:2015-04-04
 *  @param page      查询页码(必选 不可以为0)
 *  @param block     结果通过block返回
 */
+ (void)getSportDetailFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block;

/**
 *  提交睡眠数据
 *
 *  @param block 结果通过block返回
 */
+ (void)submitSleepData:(sleepDate_deviceid_Model *)model WithBlock:(void (^)(BOOL, id))block;

+ (BOOL)submitSleepData:(sleepDate_deviceid_Model *)model;
/**
 *  获取睡眠数据
 *
 *  @param dateBegin 查询开始日期(必选) 参数格式:2015-04-04
 *  @param dateEnd   查询截止日期(必选) 参数格式:2015-04-04
 *  @param page      查询页码(必选 不可以为0)
 *  @param block     结果通过block返回
 */
+ (void)getSleepDataFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block;


/**
 *  提交运动数据详情
 *
 *  @param block 结果通过block返回
 */
+ (void)submitSportDetailWithModel:(stepDate_deviceid_Model *)model   WithBlock:(void (^)(BOOL, id))block;

+ (BOOL)submitSportDetailWithModel:(stepDate_deviceid_Model *)model;
/**
 *  获取睡眠数据详情
 *
 *  @param dateBegin 查询开始日期(必选) 参数格式:2015-04-04
 *  @param dateEnd   查询截止日期(必选) 参数格式:2015-04-04
 *  @param page      查询页码(必选 不可以为0)
 *  @param block     结果通过block返回
 */
+ (void)getSleepDetailFromDateBegin:(NSString *)dateBegin andDateEnd:(NSString *)dateEnd withPage:(NSInteger)page WithBlock:(void (^)(BOOL, id))block;
/**
 *  提交睡眠数据详情
 *
 *  @param block 结果通过block返回

 */
+ (void)submitSleepDetail:(sleepDate_deviceid_Model *)model WithBlock:(void (^)(BOOL, id))block;

+ (BOOL)submitSleepDetail:(sleepDate_deviceid_Model *)model;

/**
 *  获取用户图像
 *
 *  @return 用户图像
 */
+ (void)getUserImage:(void (^)(id))complete;
//test
+ (void)checkIsLoginwith:(NSDictionary *)params block:(void (^)(BOOL,id))block;

//检查软件版本 options 1  android版本 2  ios版本 3 bluetooth版本 4 factory版本  5 ST版本
+ (void)checkBandVersionWithOptions:(int)options  WithBlock:(void (^)(BOOL, id))block;

@end
