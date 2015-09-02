//
//  UserInfoManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

//model转字典
+ (NSDictionary *)dictionaryFromModel:(t_userInfo *)model
{
    NSDictionary *dic = @{@"age":model.age,
                          @"gender":model.gender,
                          @"height":model.height,
                          @"mac":model.mac,
                          @"imageUrl":model.imageUrl,
                          @"userid":model.userid,
                          @"userName":model.username,
                          @"weight":model.weight};
    return dic;
}

//保存用户信息到plist文件
+(void)SaveUserInfo
{
    NSArray *userData = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_userInfo where userid = '%@'",[Singleton getUserID]]];
    if (userData.count>0)
    {
        [XlabTools setStringValue:userData[0] defaultKey:UserInfoTable];
    }
}

+ (t_userInfo *)getUserInfoDic
{
    t_userInfo *userModel = [t_userInfo new];
    NSDictionary *userinfo = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoTable];
    if (userinfo != nil)
    {
        userModel = [t_userInfo convertDataToModel:userinfo];
        return  userModel;
    }
    return nil;
}


+ (void)insertDefaultUserInfo:(t_userInfo *)userModel
{
    
    NSString *selectStr = [NSString stringWithFormat:@"select count(*) from t_userInfo where userid = '%@' and mac = '%@'",[Singleton getUserID],userModel.mac];
    
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_userInfo (userid,username,gender,age,height,weight,imageUrl,mac) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",
                        [Singleton getUserID],
                        userModel.username,
                        userModel.gender,
                        userModel.age,
                        userModel.height,
                        userModel.weight,
                        userModel.imageUrl,
                        userModel.mac];
    
    
    NSString *Updatesql=[NSString stringWithFormat:@"UPDATE t_userInfo SET username = '%@' , height = '%@' , weight = '%@' , gender = '%@' , age = '%@' , imageUrl = '%@'  where  userid = '%@' and mac = '%@'",
                         userModel.username,
                         userModel.height,
                         userModel.weight,
                         userModel.height,
                         userModel.age,
                         userModel.imageUrl,
                         [Singleton getUserID],
                         userModel.mac];
    [DBOPERATOR insertDataToSQL:sqlStr updatesql:Updatesql withExsitSql:selectStr];
    //持久化用户信息
    [self SaveUserInfo];
}

@end
