//
//  TargetModelManager.m
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "TargetModelManager.h"

@implementation TargetModelManager

+(NSString *)getStepTargetByUserId:(NSString *)UserId date:(NSString *)date
{

    NSString *selectStr = [NSString stringWithFormat:@"select stepTarget from t_targetInfo where userid='%@' and  startTime ='%@'",UserId,date];
    NSArray *array = [DBOPERATOR getDataForSQL:selectStr];
    NSString *totalStep=@"10000";
    if ([array count]>0)
    {
        UserTargetModel *targetModel = [UserTargetModel convertDataToModel:array[0]];
        totalStep = targetModel.stepTarget;
    }
    
    if([totalStep rangeOfString:@"null"].location!=NSNotFound)
    {
        return @"10000";
    }
    return  totalStep;
}


+(NSString *)getStepTargetByUserId:(NSString *)UserId
{
    
    NSString *selectStr = [NSString stringWithFormat:@"select stepTarget from t_targetInfo where userid='%@'",UserId];
    NSArray *array = [DBOPERATOR getDataForSQL:selectStr];

    NSString *totalStep=@"10000";
    if ([array count]>0)
    {
        UserTargetModel *targetModel = [UserTargetModel convertDataToModel:array[0]];
        totalStep = targetModel.stepTarget;
    }
    if([totalStep rangeOfString:@"null"].location!=NSNotFound)
    {
        return @"10000";
    }
    return  totalStep;
}


+(void)saveStepTarget:(NSString *)stepTarget  startTime:(NSString *)startTime   userid:(NSString *)userid
{

    NSString *selectSql=[NSString stringWithFormat:@"SELECT *  FROM t_targetInfo where userid='%@' ",userid];
    NSString *insertStr = [NSString stringWithFormat:@"insert into t_targetInfo (stepTarget , userid) values ('%@','%@') ",stepTarget,userid];
    NSString *updateStr = [NSString stringWithFormat:@"update t_targetInfo set stepTarget = '%@' where  userid='%@'",stepTarget,userid];

    [DBOPERATOR insertDataToSQL:insertStr updatesql:updateStr withExsitSql:selectSql];
}


+(NSString *)getSleepTargetByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString *totalStep=@"480";
    NSString *slectSql = [NSString stringWithFormat:@"select sleepTarget from t_targetInfo where userid = '%@'",[Singleton getUserID]];
    NSArray *arr =  [DBOPERATOR getDataForSQL:slectSql];
    if (arr.count>0)
    {
        NSDictionary *dic = arr[0];
        if (dic[@"sleepTarget"])
        {
            
            return totalStep = dic[@"sleepTarget"];
        }
    }
    
    return  totalStep;
}




@end
