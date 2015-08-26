//
//  UserModelManager.m
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserModelManager.h"

@implementation UserModelManager

+(void)saveUserTargetInfo:(UserTargetModel *)obj
{
    
    NSString *sqlStr = [NSString stringWithFormat:@"insert into t_targetInfo(userid,stepTarget) values('%@','%@')",obj.userid,obj.stepTarget];
    NSString *sqlUpdate = [NSString stringWithFormat:@"update t_targetInfo set stepTarget='%@' where userid = '%@'",obj.stepTarget,obj.userid];
    NSString *selectSql = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",obj.userid];
    [DBOPERATOR insertDataToSQL:sqlStr updatesql:sqlUpdate withExsitSql:selectSql];
    [UserTargetModel setUserTargetInfo];
}


@end
