//
//  NetWorking.h
//  LenovoVB10
//
//  Created by fenda on 14/12/23.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkBase.h"
@interface NetWorking : NSObject
@property (nonatomic,copy) void (^completion) (id result, BOOL succ);
//获取数据
/**
 *  get 获取数据
 *
 *  @param url    下载地址
 *  @param params 请求参数字典
 *  @param key    节点字段名，可为nil
 */
- (void) startGet:(NSString *)url
           params:(NSDictionary *)params
          dataKey:(NSString *)key;
/**
 *  post 获取数据
 *
 *  @param url    下载地址
 *  @param params 请求参数字典
 *  @param key    节点字段名，可为nil
 */
- (void)startPost:(NSString *)url
           params:(NSDictionary *)params
          dataKey:(NSString *)key;

//上传数据
/**
 *  post 上传数据
 *
 *  @param url    上传地址
 *  @param params 需要上传的参数名
 *  @param files  需要上传的文件
 *  @param key    节点字段名，可为nil
 */
- (void)startPost:(NSString *)url
           params:(NSDictionary *)params
            files:(NSArray *)files
          dataKey:(NSString *)key;
/**
 *  文件下载请求,不支持断点下载 ，断点下载请使用BreakDownload类，此项目没有用到，暂不导入
 *
 *  @param urlstr 文件下载地址 如 @"http://localhost/itcast/videos/01.mp4"
 *  @param unzip 是否需要解压
 */
- (void)downloadfilewithURL:(NSString *)downloadUrl withUnzip:(BOOL)unzip;


/**
 *  在vb10中登陆、注册、找回密码等接口为特列，故添加此接口
 *
 *  @param type 请求类型
 *  @param url  请求地址
 *  @param dic  需要拼接的参数
 isUrlEncode 是否需要url加密
 */
- (void)startRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic  isUrlEncode:(BOOL)isUrlEncode;

- (void)startRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic;

//虚函数
- (void)startRequest;
//回调
- (void)requestComplete:(id)result;

- (BOOL)sendSyncRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic isUrlEncode:(BOOL)isUrlEncode;
@end
