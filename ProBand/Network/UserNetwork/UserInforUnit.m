//
//  UserInforUnit.m
//  LenovoVB10
//
//  Created by fenda on 15/1/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserInforUnit.h"

@implementation UserInforUnit

//回调方法重写 ，由于每个接口retCode值不同，故这里由各子类去实现,test
- (void)requestComplete:(id)result{
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary *)result;
        NSArray *allKeys = [dic allKeys];
        //根据接口返回字段相印的修改retCode
        if ([allKeys containsObject:@"retCode"]) {
            NSString *code = [dic objectForKey:@"retCode"];
            if ([code intValue] == 0  && code) {
                flag = YES;
            }
        }
    }
    
    if (self.completion) {
        self.completion(result,flag);
    }
}



///*对数据库操作*/
//+(UserInfoModel *)getUserInfoData:(NSString *)userID
//{
//
//    NSString *sqlStr = [NSString stringWithFormat:@"select * from t_userInfo where userId = '%@'",userID];
//    NSArray *userArr = [DBOPERATOR getDataForSQL:sqlStr];
//    if (userArr.count > 0) {
//        
//        return [UserInfoModel convertDataToModel:userArr[0]];
//    }
//    else
//    {
//        return nil;
//    }
//}
//+(void)saveUserInfo:(UserInfoModel *)obj
//{
//    if (!obj.userName) {
//        
//        obj.userName = @"账号昵称";
//    }
//    if (!obj.userId) {
//        
//        obj.userId = [Singleton getUserID];
//    }
//    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_userInfo (userId,userName,gender,birthDay,height,weight,imageUrl,heightUnit,weightUnit) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",obj.userId,obj.userName,obj.gender,obj.birthDay,obj.height,obj.weight,obj.imageUrl,obj.heightUnit,obj.weightUnit];
//    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE t_userInfo SET userName = '%@',gender ='%@', birthDay = '%@', height = '%@', weight = '%@', imageUrl = '%@',heightUnit = '%@',weightUnit = '%@' where userId ='%@'",obj.userName,obj.gender,obj.birthDay,obj.height,obj.weight,obj.imageUrl,obj.heightUnit,obj.weightUnit,obj.userId];
//    NSString *selectSql = [NSString stringWithFormat:@"select * from t_userInfo where userId = '%@'",obj.userId];
//    [DBOPERATOR insertDataToSQL:sqlStr updatesql:sqlUpdate withExsitSql:selectSql];
//    [UserInfoModel setUserInfo];
//}

@end
