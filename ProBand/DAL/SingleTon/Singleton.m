//
//  Singleton.m
//  LenovoVB10
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton
+ (instancetype)shareInstance{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(NSString *)getUserID{
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USERID];
    if (!userid) {
        //TODO 暂时测试用，不需要登录
        userid =@"10";
    }
    return userid;
}
//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] setBool:loginState forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolState:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultKey];
}

+(void)setValues:(NSString *)value withKey:(NSString *)keyStr
{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:keyStr];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(id)getValueWithKey:(NSString *)keyStr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];
}
+(NSString *)getInfo:(NSString *)keyStr
{
   return [[NSUserDefaults standardUserDefaults]objectForKey:keyStr];
}

+(void)removeLogin
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"postkey"];
}

+ (NSString*)getMacSite
{
    NSString *mac = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USERID];
    if (!mac) {
        mac = @"100.100.100.100";
    }
    return mac;
}
+ (void)updateUserId:(NSString *)userid
{
    [[NSUserDefaults standardUserDefaults]setObject:userid forKey:CURRENT_USERID];
}
+ (void)updateMacSite:(NSString *)mac
{
    [[NSUserDefaults standardUserDefaults]setObject:mac forKey:CURRENT_MACSITE];
}
+(NSString *)getTokenInfo:(NSString *)keyStr
{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:keyStr];
    if (token) {
        return token;
    }
    return @"";
}

+ (void)setSettingStatus
{
//    NSArray *tempArr = [SettingStatusUnit getSettinginfo];
//    if (tempArr>0)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:[tempArr firstObject] forKey:PHONEASSISTSTATE];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

+ (NSMutableArray *)arrayFromRepeatArray:(NSArray *)array
{
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in array)
    {
        if (![result containsObject:obj])
        {
            [result addObject:obj];
        }
    }
    return  result;
}
@end
