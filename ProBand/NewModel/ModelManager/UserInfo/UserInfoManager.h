//
//  UserInfoManager.h
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "t_userInfo.h"
@interface UserInfoManager : NSObject

//model转字典
+ (NSDictionary *)dictionaryFromModel:(t_userInfo *)model;
//保存用户信息到plist文件
+(void)SaveUserInfo;
//从plist文件中取出Model
+ (t_userInfo *)getUserInfoDic;
//插入默认的用户信息。
+ (void)insertDefaultUserInfo:(t_userInfo *)userModel;

@end
