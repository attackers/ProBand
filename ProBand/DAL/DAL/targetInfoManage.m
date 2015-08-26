#import "targetInfoManage.h"
#import "DataBase.h"
@implementation targetInfoManage
+(NSArray *)findAll{
	return [self findBySql:@"SELECT * FROM t_targetInfo order by id desc"];	
}
+(NSArray *)getPageList:(int)pageId
{       
	NSInteger fromRow=pageId*15;
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_targetInfo order by id desc limit %ld,15",(long)fromRow];
	return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_targetInfo where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_targetInfo where id=%@",Id]];
 NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
int count=[rs columnCount];
 while ([rs next]){for (int i=0; i<count; i++)
 {
  NSString *columnName=[NSString stringWithFormat:@"%@",[rs columnNameForIndex:i]];
  NSString *columnValue = [NSString stringWithFormat:@"%@",[rs objectForColumnName:columnName]];
  [dic setObject:columnValue forKey:columnName];
 }
}
[rs close];
NSDictionary *dics=[NSDictionary dictionaryWithDictionary:dic];
return  dics;
 }
+(NSString *)getSleepTargetByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select sleepTarget from t_targetInfo where userid='%@' and  strftime('%@',botherStart)='%@' ",UserId,format,date]];
    NSString *totalStep=@"8";
    while ([rs next])
    {
        totalStep= [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"sleepTarget"]];
    }
    return  totalStep;
}

+(NSString *)getStepTargetByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select stepTarget from t_targetInfo where userid='%@' and  strftime('%@',startTime)='%@' ",UserId,format,date]];
    NSString *totalStep=@"5000";
    while ([rs next])
    {
        totalStep= [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"stepTarget"]];
    }
    return  totalStep;
}


+ (NSArray *) findBySql:(NSString *)sql
{
	FMDatabase *dataBase = [DataBase setup];
	FMResultSet *rs;
	rs = [dataBase executeQuery:sql];
NSMutableArray *targetInfos = [[NSMutableArray alloc] init];
while ([rs next]) {
	//NSLog(@"next");
UserTargetModel *model= [[UserTargetModel alloc] init];
model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
model.userid = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userid"]];
model.stepTarget = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"stepTarget"]];
model.startTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"startTime"]];
model.endTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"endTime"]];
model.sleepTarget = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"sleepTarget"]];
model.botherStart = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherStart"]];
model.botherEnd = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherEnd"]];
model.botherStatus = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherStatus"]];
	[targetInfos addObject:model];
 }
[rs close];
[dataBase close];
return targetInfos;
}
+(UserTargetModel *)getModelById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_targetInfo where id=%@",Id]];
UserTargetModel *model= [[UserTargetModel alloc] init];
 while ([rs next]) {
model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
model.userid = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userid"]];
model.stepTarget = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"stepTarget"]];
model.startTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"startTime"]];
model.endTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"endTime"]];
model.sleepTarget = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"sleepTarget"]];
model.botherStart = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherStart"]];
model.botherEnd = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherEnd"]];
model.botherStatus = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"botherStatus"]];
}
return  model;
 }
+ (int) count{
	FMDatabase *dataBase = [DataBase setup];
	int targetInfoCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_targetInfo "] intValue];
	[dataBase close];
	return targetInfoCount;
}
+ (int)getMaxId
{
	FMDatabase *dataBase = [DataBase setup];
int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_targetInfo "] intValue];
if (maxid==1) {
 maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='targetInfo' "] intValue]+1;
}
	[dataBase close];
	return maxid+1;
}
+(int)updateId:(NSString *)Id userid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget botherStart:(NSString *)botherStart botherEnd:(NSString *)botherEnd botherStatus:(NSString *)botherStatus 
{
	FMDatabase *dataBase = [DataBase setup];
	NSString *time=[DataBase getCurDateTime];
NSString *sql=[NSString stringWithFormat:@"UPDATE t_targetInfo SET    userid = '%@' , stepTarget = '%@' , startTime = '%@' , endTime = '%@' , sleepTarget = '%@' , botherStart = '%@' , botherEnd = '%@' , botherStatus = '%@'    where id= '%@'",  userid,stepTarget,startTime,endTime,sleepTarget,botherStart,botherEnd,botherStatus,Id
]; BOOL bResult = [dataBase executeUpdate:sql];
	[dataBase close];
	return bResult;
}
/**
 *  添加by Star:只更新部分数据
 */
+ (BOOL)updateUserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_targetInfo SET  userid = '%@',stepTarget = '%@',startTime = '%@',endTime = '%@',sleepTarget = '%@' where userid = '%@'",userid,stepTarget,startTime,endTime,sleepTarget,userid];
    BOOL result = [dataBase executeUpdate:sql];
    [dataBase close];
    return result;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
+ (BOOL)addUserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget
{
    FMDatabase *dataBase = [DataBase setup];
    int lastId = 0;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_targetInfo(userid,stepTarget,startTime,endTime,sleepTarget) VALUES ('%@','%@','%@','%@','%@')",userid,stepTarget,startTime,endTime,sleepTarget];
    if ([dataBase executeUpdate:sql]) {
        lastId = [dataBase lastInsertRowId];
    }
    [dataBase close];
    return lastId;
}

+(int)saveStepTarget:(NSString *)stepTarget  startTime :(NSString *)startTime   userid:(NSString *)userid
{
    FMDatabase *dataBase = [DataBase setup];
   
    NSString *sql =@"";
    //NSString  *format=@"%Y%m%d";
    sql=[NSString stringWithFormat:@"SELECT count(*)  FROM t_targetInfo where startTime='%@' and userid='%@' ",startTime,userid];
    int count=[[dataBase stringForQuery:sql] intValue];
    if (count==0)
    {
        //更新主界面目标值
        sql = [NSString stringWithFormat:@"insert into t_targetInfo (stepTarget ,startTime , userid) values ('%@','%@','%@') ",stepTarget,startTime,userid];
    }
    else
    {
        //更新主界面目标值
        sql = [NSString stringWithFormat:@"update t_targetInfo set stepTarget = '%@' where startTime = '%@' and userid='%@'",stepTarget,startTime,userid];
    }
    
    
    BOOL bResult = [dataBase executeUpdate:sql];
    if (bResult) {
        NSLog(@" 保存成功 目标步数");
    }
    else
    {
        NSLog(@" 保存失败");
    }
    [dataBase close];
    return bResult;

}


+(NSString *)getStepTarget:(NSString *)stepTarget  withStartTime :(NSString *)startTime   AndUserid:(NSString *)userid
{
    FMDatabase *dataBase = [DataBase setup];
    
    NSString *sql =@"";
    //NSString  *format=@"%Y%m%d";
    sql=[NSString stringWithFormat:@"SELECT stepTarget  FROM t_targetInfo where startTime='%@' and userid='%@' ",startTime,userid];
    id obj=[dataBase stringForQuery:sql] ;
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    [dataBase close];
    return @"5000";
    
}


+ (int)remove:(NSString *) ID{
	FMDatabase *dataBase = [DataBase setup];
BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_targetInfo WHERE ID = %@",ID]];	[dataBase close];
	return bResult;
}
+ (int)adduserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget botherStart:(NSString *)botherStart botherEnd:(NSString *)botherEnd botherStatus:(NSString *)botherStatus {
	FMDatabase *dataBase = [DataBase setup];
	NSLog(@"addtitle");
int lastId=0;
NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_targetInfo (userid,stepTarget,startTime,endTime,sleepTarget,botherStart,botherEnd,botherStatus)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@') ",userid,stepTarget,startTime,endTime,sleepTarget,botherStart,botherEnd,botherStatus]; 
   if( [dataBase executeUpdate:sql])
 {
lastId=[dataBase lastInsertRowId];
}
	[dataBase close];
	return lastId;
}

+(UserTargetModel *)ParserSeverInfo:(id)result
{
    UserTargetModel *obj = [[UserTargetModel alloc]init];
   NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if ([dataDic[@"retcode"] integerValue]==10000) {
        NSArray *retstringArr = [NSJSONSerialization JSONObjectWithData:[dataDic[@"retstring"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *tempDic = retstringArr[0];
        NSDictionary *goalsettingDic = [NSJSONSerialization JSONObjectWithData:[tempDic[@"goalsetting"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"----goalsettingDic---%@~~~~~~~~~~",goalsettingDic);
        
        obj.stepTarget = goalsettingDic[@"stepTarget"];
        
    }
  
    
   
   
    return obj;
}

@end
