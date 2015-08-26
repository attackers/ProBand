//
//  SSOTest.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSOTest : NSObject

/**
 *
 * 初始化上传和提交uuid
 * 获取
 */
- (void)initUploadEnvAndSubmitUUID;

/**
 *
 *
 * 从服务器获取uuid
 *
 *
 */
- (void)getUUIDFromServerWithBlock:(void(^)(NSString *))uuid;

/**
 *
 *  上传但前的设备uuid
 **/

- (void)uploadCurrentDevicesUUID;

/**
 *
 * 上传fitDataSource
 * 通过[Singleton getValueWithKey:@"fitDataSourceId"]获取fitDataSourceId
 *
 */
- (void)initNet;


@end
