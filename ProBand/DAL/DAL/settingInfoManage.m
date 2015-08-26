#import "settingInfoManage.h"
#import "DataBase.h"
@implementation settingInfoManage
+(NSArray *)findAll{
	return [self findBySql:@"SELECT * FROM t_settingInfo order by id desc"];	
}
+(NSArray *)getPageList:(int)pageId
{       
	NSInteger fromRow=pageId*15;
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_settingInfo order by id desc limit %ld,15",(long)fromRow];
	return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_settingInfo where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_settingInfo where id=%@",Id]];
 NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
int count=[rs columnCount];
 while ([rs next])
 {
     //[rs resultDictionary];
     for (int i=0; i<count; i++)
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
NSMutableArray *settingInfos = [[NSMutableArray alloc] init];
while ([rs next]) {
	//NSLog(@"next");
settingInfo_Model *model= [[settingInfo_Model alloc] init];
model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
model.smsStatus = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"smsStatus"]];
model.callState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"callState"]];
model.weatherState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weatherState"]];
model.wecatState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"wecatState"]];
model.photoState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"photoState"]];
model.masterSwitch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"masterSwitch"]];
model.setLock = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"setLock"]];
model.findphoneState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"findphoneState"]];
	[settingInfos addObject:model];
 }
[rs close];
[dataBase close];
return settingInfos;
}
+(settingInfo_Model *)getModelById:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_settingInfo where id=%@",Id]];
settingInfo_Model *model= [[settingInfo_Model alloc] init];
 while ([rs next]) {
model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
model.smsStatus = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"smsStatus"]];
model.callState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"callState"]];
model.weatherState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"weatherState"]];
model.wecatState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"wecatState"]];
model.photoState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"photoState"]];
model.masterSwitch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"masterSwitch"]];
model.setLock = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"setLock"]];
model.findphoneState = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"findphoneState"]];
}
return  model;
 }
+ (int) count{
	FMDatabase *dataBase = [DataBase setup];
	int settingInfoCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_settingInfo "] intValue];
	[dataBase close];
	return settingInfoCount;
}
+ (int)getMaxId
{
	FMDatabase *dataBase = [DataBase setup];
int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_settingInfo "] intValue];
if (maxid==1) {
 maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='settingInfo' "] intValue]+1;
}
	[dataBase close];
	return maxid+1;
}
+(int)updateId:(NSString *)Id userId:(NSString *)userId smsStatus:(NSString *)smsStatus callState:(NSString *)callState weatherState:(NSString *)weatherState wecatState:(NSString *)wecatState photoState:(NSString *)photoState masterSwitch:(NSString *)masterSwitch setLock:(NSString *)setLock findphoneState:(NSString *)findphoneState 
{
	FMDatabase *dataBase = [DataBase setup];
	NSString *time=[DataBase getCurDateTime];
NSString *sql=[NSString stringWithFormat:@"UPDATE settingInfo SET    userId = '%@' , smsStatus = '%@' , callState = '%@' , weatherState = '%@' , wecatState = '%@' , photoState = '%@' , masterSwitch = '%@' , setLock = '%@' , findphoneState = '%@'    where id= '%@'",  userId,smsStatus,callState,weatherState,wecatState,photoState,masterSwitch,setLock,findphoneState,Id
]; BOOL bResult = [dataBase executeUpdate:sql];
	[dataBase close];
	return bResult;
}
+ (int)remove:(NSString *) ID{
	FMDatabase *dataBase = [DataBase setup];
BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_settingInfo WHERE ID = %@",ID]];	[dataBase close];
	return bResult;
}
+ (int)adduserId:(NSString *)userId smsStatus:(NSString *)smsStatus callState:(NSString *)callState weatherState:(NSString *)weatherState wecatState:(NSString *)wecatState photoState:(NSString *)photoState masterSwitch:(NSString *)masterSwitch setLock:(NSString *)setLock findphoneState:(NSString *)findphoneState {
	FMDatabase *dataBase = [DataBase setup];
	NSLog(@"addtitle");
int lastId=0;
NSString *sql=[NSString stringWithFormat:@"INSERT INTO  settingInfo (userId,smsStatus,callState,weatherState,wecatState,photoState,masterSwitch,setLock,findphoneState)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@') ",userId,smsStatus,callState,weatherState,wecatState,photoState,masterSwitch,setLock,findphoneState]; 
   if( [dataBase executeUpdate:sql])
 {
lastId=[dataBase lastInsertRowId];
}
	[dataBase close];
	return lastId;
}
@end
