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

//向数据库插入默认的用户信息
+ (void)insertDefaultInfo;
//更新用户信息：不存在则插入
+ (void)updateInfoWithModel:(t_userInfo *)model;
@end
