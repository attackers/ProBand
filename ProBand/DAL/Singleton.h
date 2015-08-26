//
//  Singleton.h 单列模式
//  LenovoVB10
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define savePassword_key @"savePassword_key"
#define password_key @"password_key"
#define username_key @"username_key"
@interface Singleton : NSObject
+ (instancetype)shareInstance;

+(NSString *)getUserID;
//持久化BOOL状态值
+(id)getValueWithKey:(NSString *)keyStr;
+(BOOL)getBoolState:(NSString *)defaultKey;
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey;
+(void)setValues:(NSString *)value withKey:(NSString *)keyStr;
+(void)removeLogin;
+(NSString *)getInfo:(NSString *)keyStr;
//添加默认的mac地址：by Star
+ (NSString*)getMacSite;
+(NSString *)getTokenInfo:(NSString *)keyStr;
+ (void)updateUserId:(NSString *)userid;
+ (void)updateMacSite:(NSString *)mac;
//持久话开关信息
+ (void)setSettingStatus;
//去除数组中重复的元素
+ (NSMutableArray *)arrayFromRepeatArray:(NSArray *)array;
@end
