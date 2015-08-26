//
//  UserInfoModel.m
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/16.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel


+(UserInfoModel *)convertDataToModel:(NSDictionary *)aDictionary;
{
    UserInfoModel *instance = [[UserInfoModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}
//model转字典
+ (NSDictionary *)dictionaryFromModel:(UserInfoModel *)model
{
    NSDictionary *dic = @{@"Id":model.Id,@"birthDay":model.birthDay,@"gender":model.gender,@"height":model.height,@"heightUnit":model.heightUnit,@"imageUrl":model.imageUrl,@"userId":model.userId,@"userName":model.userName,@"weight":model.weight,@"weightUnit":model.weightUnit};
    return dic;
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"gender:%@,birthDay:%@,height:%@,heightUnit:%@,weight:%@,weightUnit:%@",_gender,_birthDay,_height,_heightUnit,_weight,_weightUnit];
}

+(void)setUserInfo{
    NSArray *userData = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_userInfo where userid = '%@'",[Singleton getUserID]]];
    if (userData.count>0) {
      [[NSUserDefaults standardUserDefaults] setObject:userData[0] forKey:@"UserInfo"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (UserInfoModel *)getUserInfoDic{
    UserInfoModel *userModel = [UserInfoModel new];
    NSDictionary *userinfo = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    userModel = [UserInfoModel convertDataToModel:userinfo];
    return  userModel;
}

/*对数据库操作*/
+(UserInfoModel *)getUserInfoData:(NSString *)userID
{
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from t_userInfo where userId = '%@'",userID];
    NSArray *userArr = [DBOPERATOR getDataForSQL:sqlStr];
    if (userArr.count > 0) {
        
        return [UserInfoModel convertDataToModel:userArr[0]];
    }
    else
    {
        return nil;
    }
}

+(UserInfoModel *)parserUserInfoL:(id)result
{
    UserInfoModel *obj = nil;
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([dic[@"retcode"] intValue] == 10000) {
        obj = [[UserInfoModel alloc]init];
        NSString *retstring = dic[@"retstring"];
        NSData *retstData = [retstring dataUsingEncoding:NSUTF8StringEncoding];
        if (!retstData) {
            return nil;
        }
        NSDictionary *temDic = [NSJSONSerialization JSONObjectWithData:retstData options:NSJSONReadingMutableContainers error:nil][0];
        if(!temDic)
        {
            return nil;
        }
        obj.gender = [NSString stringWithFormat:@"%@",temDic[@"gender"]];
        NSString *personalSetting = temDic[@"personalSetting"];
        NSDictionary *perDic = [NSJSONSerialization JSONObjectWithData:[personalSetting dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        obj.birthDay = perDic[@"birthday"];
        obj.height = perDic[@"height"];
        obj.weight = perDic[@"weight"];
        obj.userName = perDic[@"nikeName"];
        NSString *heightUnit = perDic[@"heightFormat"];
        NSString *weightUnit = perDic[@"weightFormat"];
        obj.imageUrl = [Contants getPicturefromCaches];
        if ([heightUnit isEqualToString:@"1"]) {
            
            obj.heightUnit = NSLocalizedString(@"ft", nil);
        }
        else
        {
            obj.heightUnit = NSLocalizedString(@"cm", nil);
        }
        if ([weightUnit isEqualToString:@"0"]) {
            obj.weightUnit = NSLocalizedString(@"kg", nil);
        }
        else
        {
            obj.weightUnit = NSLocalizedString(@"lbs", nil);
        }
        [Singleton setValues:heightUnit withKey:@"heightFormat"];
        [Singleton setValues:weightUnit withKey:@"weightFormat"];
        NSLog(@"perDic---%@",perDic);
    }
    //    if (obj)
    //    {
    //        [UserInforUnit saveUserInfo:obj];
    //    }
    //
    NSLog(@"-----%@",dic);
    return obj;
}

@end
