//
//  LoginModel.h
//  LenovoVB10
//
//  Created by yumiao on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel

@property (nonatomic, strong) NSString *Id;
// 取值为以下字符串值： email、msisdn，一律小写
@property (nonatomic, copy) NSString* userTypeName;
// 取值为：email地址或手机号。
@property (nonatomic, copy) NSString* userNameValue;
// 用户设置的账号密码。
@property (nonatomic, copy) NSString* password;
// 随机数（8~20位长，允许0-9数字和a-zA-Z字母），用于关联所生成的验证码图形信息。
@property (nonatomic, copy) NSString* t;
// 图形验证码中的字符串值。
@property (nonatomic, copy) NSString* c;
// 值为[y,n]之一,为y则当账号为msisdn时发短信校验码,为n或其它非y的值,则发链接。
@property (nonatomic, copy) NSString* getcode;
// 用来标识发起请求的应用。字符串，最大200个字符。超过长度会被截掉超长的字符。
@property (nonatomic, copy) NSString* source;
@property (nonatomic, copy) NSString* deviceidtype;
@property (nonatomic, copy) NSString* deviceid;
@property (nonatomic, copy) NSString* devicecategory;
@property (nonatomic, copy) NSString* devicevendor;
@property (nonatomic, copy) NSString* devicefamily;
@property (nonatomic, copy) NSString* devicemodel;
// 操作系统版本，什么系统，什么版本
@property (nonatomic, copy) NSString* osversion;
// 出厂时间，格式:yyyy-MM-DD HH:mm:ss
@property (nonatomic, copy) NSString* productiondate;
// 解包时间，格式:yyyy-MM-DD HH:mm:ss
@property (nonatomic, copy) NSString* unpackdate;
@property (nonatomic, copy) NSString* extrainfo;
@property (nonatomic, copy) NSString* imsi;
@property (nonatomic,strong)NSString * userId;
// 语言，本期支持zh-CN和en，默认为zh-CN。
@property (nonatomic, copy) NSString* lang;

@property (nonatomic, copy) NSString* realm;


- (NSString *)toTgtPostBodyParam:(LoginModel *)obj;

@end
