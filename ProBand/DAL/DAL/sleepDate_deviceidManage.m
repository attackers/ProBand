#import "sleepDate_deviceidManage.h"
#import "DataBase.h"
@implementation sleepDate_deviceidManage
+(NSArray *)findAll{
	return [self findBySql:@"SELECT * FROM t_sleepDate_deviceid order by id desc"];	
}
+(NSArray *)getUnUploadPageList:(int)pageId
{
   // NSInteger fromRow=pageId*15;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_sleepDate_deviceid order by id desc where flag=0 "];
    return [self findBySql:sql];
}
+(int)updateFlag:(NSString *)Flag  byId:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    //NSString *time=[DataBase getCurDateTime];
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET   flag = '%@'    where id= '%@'",Flag,Id];
    BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}
+(NSArray *)getPageList:(int)pageId
{       
	NSInteger fromRow=pageId*15;
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_sleepDate_deviceid order by id desc limit %ld,15",(long)fromRow];
	return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_sleepDate_deviceid where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_sleepDate_deviceid where id=%@",Id]];
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
+ (NSArray *) findBySql:(NSString *)sql
{
	FMDatabase *dataBase = [DataBase setup];
	FMResultSet *rs;
	rs = [dataBase executeQuery:sql];
NSMutableArray *sleepDate_deviceids = [[NSMutableArray alloc] init];
while ([rs next]) {
	//NSLog(@"next");
sleepDate_deviceid_Model *model= [[sleepDate_deviceid_Model alloc] init];
model=[self initModel:model ResultSet:rs];
	[sleepDate_deviceids addObject:model];
 }
[rs close];
[dataBase close];
return sleepDate_deviceids;
}
+(sleepDate_deviceid_Model *)getModelByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString  *format=@"%Y-%m-%d";
   
    FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId='%@' and strftime('%@',date)='%@' ",UserId,format,date]];
sleepDate_deviceid_Model *model= [[sleepDate_deviceid_Model alloc] init];
 while ([rs next]) {
     model=[self initModel:model ResultSet:rs];
}
    
return  model;
}


+(NSString *)getTotalSleepByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select totalSleep from t_sleepDate_deviceid where userid='%@' and  strftime('%@',Date)='%@' ",UserId,format,date]];
    NSString *totalStep=@"0";
    while ([rs next])
    {
       totalStep= [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalSleep"]];
    }
    return  totalStep;
}

+(sleepDate_deviceid_Model *)initModel:(sleepDate_deviceid_Model *)model ResultSet:(FMResultSet *)rs
{
    
    model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
    model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
    model.date = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]];
    model.sleeps = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"sleeps"]];
    model.lightTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"lightTime"]];
    model.deepTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"deepTime"]];
    model.wakeTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"wakeTime"]];
    model.quality = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"quality"]];
    model.totalSleep = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalSleep"]];
    
    // NSLog(@"Id =%@ userId =%@ date =%@ sleeps =%@ lightTime =%@ deepTime =%@ wakeTime =%@ quality =%@ totalSleep =%@ ",model.Id,model.userId,model.date,model.sleeps,model.lightTime,model.deepTime,model.wakeTime,model.quality,model.totalSleep);
    
    return model;
}
+ (int) count{
	FMDatabase *dataBase = [DataBase setup];
	int sleepDate_deviceidCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_sleepDate_deviceid "] intValue];
	[dataBase close];
	return sleepDate_deviceidCount;
}
+ (int)getMaxId
{
	FMDatabase *dataBase = [DataBase setup];
int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_sleepDate_deviceid "] intValue];
if (maxid==1) {
 maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='sleepDate_deviceid' "] intValue]+1;
}
	[dataBase close];
	return maxid+1;
}
+(int)updateUserId:(NSString *)Id date:(NSString *)date sleeps:(NSString *)sleeps lightTime:(NSString *)lightTime deepTime:(NSString *)deepTime wakeTime:(NSString *)wakeTime quality:(NSString *)quality totalSleep:(NSString *)totalSleep;
{
	FMDatabase *dataBase = [DataBase setup];
	//NSString *time=[DataBase getCurDateTime];
NSString *sql=[NSString stringWithFormat:@"UPDATE t_sleepDate_deviceid SET sleeps = '%@' , lightTime = '%@' , deepTime = '%@' , wakeTime = '%@' , quality = '%@' , totalSleep = '%@'    where userId= '%@' and date = '%@'",sleeps,lightTime,deepTime,wakeTime,quality,totalSleep,Id,date
]; BOOL bResult = [dataBase executeUpdate:sql];
	[dataBase close];
	return bResult;
}


+ (int)remove:(NSString *) ID{
	FMDatabase *dataBase = [DataBase setup];
BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_sleepDate_deviceid WHERE ID = %@",ID]];	[dataBase close];
	return bResult;
}
+ (long long)adduserId:(NSString *)userId date:(NSString *)date sleeps:(NSString *)sleeps lightTime:(NSString *)lightTime deepTime:(NSString *)deepTime wakeTime:(NSString *)wakeTime quality:(NSString *)quality totalSleep:(NSString *)totalSleep {
	FMDatabase *dataBase = [DataBase setup];
	NSLog(@"addtitle");
long long lastId=0;
    
NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_sleepDate_deviceid (userId,date,sleeps,lightTime,deepTime,wakeTime,quality,totalSleep)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@') ",userId,date,sleeps,lightTime,deepTime,wakeTime,quality,totalSleep]; 
   if( [dataBase executeUpdate:sql])
 {
lastId=[dataBase lastInsertRowId];
}
	[dataBase close];
	return lastId;
}

+(NSArray *)getAllSleepInfoByuserId:(NSString *)userID
{
    NSString *sql = [NSString stringWithFormat:@"select *from t_sleepDate_deviceid where userId = '%@' order by date desc ",userID];
     FMDatabase *dataBase = [DataBase setup];
    FMResultSet *resultSet = [dataBase executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:0];
    while ([resultSet next])
    {
      sleepDate_deviceid_Model *model= [[sleepDate_deviceid_Model alloc] init];
      model=[self initModel:model ResultSet:resultSet];
      [resultArr addObject:model];
    }
    return  resultArr;
}


+(void)insertSleepDetailInfo:(sleepDate_deviceid_Model *)sleepObj
{
    NSString *selectSql = [NSString stringWithFormat:@"select * from t_sleepDate_deviceid where userId = '%@' and date = '%@'",sleepObj.userId,sleepObj.date];
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *resultSet = [dataBase executeQuery:selectSql];
    if (![resultSet next]) {
        
        [sleepDate_deviceidManage adduserId:sleepObj.userId date:sleepObj.date sleeps:sleepObj.sleeps lightTime:sleepObj.lightTime deepTime:sleepObj.deepTime wakeTime:sleepObj.wakeTime quality:sleepObj.quality totalSleep:sleepObj.totalSleep];
    }
    else
    {
       [sleepDate_deviceidManage updateUserId:sleepObj.userId date:sleepObj.date sleeps:sleepObj.sleeps lightTime:sleepObj.lightTime deepTime:sleepObj.deepTime wakeTime:sleepObj.wakeTime quality:sleepObj.quality totalSleep:sleepObj.totalSleep];
    }
}
@end
