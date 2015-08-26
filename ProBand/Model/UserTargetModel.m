//
//  UserTargetModel.m
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/31.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "UserTargetModel.h"

@implementation UserTargetModel

+(UserTargetModel *)convertDataToModel:(NSDictionary *)aDictionary
{
    UserTargetModel *instance = [[UserTargetModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}


+(void)setUserTargetInfo{
    NSArray *userTargetData = [DBOPERATOR getDataForSQL:[NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",[Singleton getUserID]]];
    if (userTargetData.count>0) {
        [[NSUserDefaults standardUserDefaults] setObject:userTargetData[0] forKey:@"UserTargetInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

+ (UserTargetModel *)getUserTargetInfoDic{
    UserTargetModel *userModel = [UserTargetModel new];
    NSDictionary *userinfo = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"UserTargetInfo"];
    userModel = [UserTargetModel convertDataToModel:userinfo];
    return  userModel;
}

/*对数据库操作*/
+(UserTargetModel *)getUserTargetData:(NSString *)userID
{
    
    NSString *sqlStr = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",userID];
    NSArray *userArr = [DBOPERATOR getDataForSQL:sqlStr];
    if (userArr.count > 0) {
        
        return [UserTargetModel convertDataToModel:userArr[0]];
    }
    else
    {
        return nil;
    }
}

+(UserTargetModel *)parseTargetStepTarget:(id)reslut
{
    UserTargetModel *obj = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[reslut dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([dic[@"retcode"] intValue]==10000) {
        
        NSString *retString = dic[@"retstring"];
        if ([retString dataUsingEncoding:NSUTF8StringEncoding]) {
            
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[retString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil][0];
            if (tempDic==nil) {
                return obj;
            }
            NSString *goalsetting = tempDic[@"goalsetting"];
            NSDictionary *goalsetDic = [NSJSONSerialization JSONObjectWithData:[goalsetting dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            obj = [UserTargetModel new];
            obj.stepTarget = goalsetDic[@"stepTarget"];
            NSLog(@"tempDic-----%@",tempDic);
        }
    }
    return obj;
}

@end
