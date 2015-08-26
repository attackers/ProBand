//
//  AssisitTool.h
//  ProBand
//
//  Created by star.zxc on 15/6/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssisitTool : NSObject

+ (instancetype)shareInstance;
/**
 *  判断是否为有效的银行卡号
 *
 *  @param cardNo 银行卡号
 *
 *  @return bool值
 */
+ (BOOL)checkCardNo:(NSString *)cardNo;
/**
 *  判断是否为有效的邮箱
 *
 *  @param str 邮箱地址
 *
 *  @return bool值
 */
+ (BOOL) isValidEmail:(NSString *)str;
/**手机号
 *  判断是否为有效的
 *
 *  @param str 手机号
 *
 *  @return bool值
 */
+ (BOOL) isValidPhoneNumber:(NSString *)str;

+ (BOOL)isFirstEnterApp;
@end
