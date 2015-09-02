//
//  UserTargetUnit.m
//  LenovoVB10
//
//  Created by fenda on 15/1/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserTargetUnit.h"

@implementation UserTargetUnit

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

//+(UserTargetModel *)getUserTargetInfoObj
//{
//    
//    NSString *selectSql = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",[Singleton getUserID]];
//    NSArray *tarGetArr = [DBOPERATOR getDataForSQL:selectSql];
//    if (tarGetArr.count ==0) {
//        return [UserTargetModel new];
//    }
//    UserTargetModel *tarGetObj = [UserTargetModel convertDataToModel:tarGetArr[0]];
//    return tarGetObj;
//    
//}
//+(void)saveUserTargetInfo:(UserTargetModel *)obj
//{
//
//    NSString *sqlStr = [NSString stringWithFormat:@"insert into t_targetInfo(userid,stepTarget) values('%@','%@')",[Singleton getUserID],obj.stepTarget];
//    NSString *sqlUpdate = [NSString stringWithFormat:@"update t_targetInfo set stepTarget='%@' where userid = '%@'",obj.stepTarget,[Singleton getUserID]];
//    NSString *selectSql = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",[Singleton getUserID]];
//    [DBOPERATOR insertDataToSQL:sqlStr updatesql:sqlUpdate withExsitSql:selectSql];
//    
//    [UserTargetModel setUserTargetInfo];
//}
//
//+(void)saveWristbandBother:(UserTargetModel *)obj
//{
//    NSString *selectStr = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",[Singleton getUserID]];
//    NSString *insertStr = [NSString stringWithFormat:@"insert into t_targetInfo(userid,botherStart,botherEnd,botherStatus) values('%@','%@','%@','%@')",[Singleton getUserID],obj.botherStart,obj.botherEnd,obj.botherStatus];
//    NSString *updateStr = [NSString stringWithFormat:@"update t_targetInfo set botherStart = '%@',botherEnd = '%@',botherStatus = '%@' where userid = '%@'",obj.botherStart,obj.botherEnd,obj.botherStatus,[Singleton getUserID]];
//    [DBOPERATOR insertDataToSQL:insertStr updatesql:updateStr withExsitSql:selectStr];
//    [UserTargetModel setUserTargetInfo];
//}
@end
