//
//  UserInforUnit.h
//  LenovoVB10
//
//  Created by fenda on 15/1/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "NetWorking.h"


@interface UserInforUnit : NetWorking

//从数据库中获取用户个人信息
+(UserInfoModel *)getUserInfoData:(NSString *)userID;
+(void)saveUserInfo:(UserInfoModel *)obj;
@end
