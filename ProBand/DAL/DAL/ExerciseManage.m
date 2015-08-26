#import "ExerciseManage.h"
#import "DataBase.h"
@implementation ExerciseManage
+(NSArray *)findAll{
	return [self findBySql:@"SELECT * FROM t_Exercise order by id desc"];	
}
+(NSArray *)getPageList:(int)pageId
{       
	NSInteger fromRow=pageId*15;
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_Exercise order by id desc limit %ld,15",(long)fromRow];
	return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_Exercise where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_Exercise where id=%@",Id]];
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
NSMutableArray *Exercises = [[NSMutableArray alloc] init];
while ([rs next]) {
	NSLog(@"next");
Exercise_Model *model= [[Exercise_Model alloc] init];
 model=[self initModel:model ResultSet:rs]; 
 	[Exercises addObject:model];
 }
[rs close];
[dataBase close];
return Exercises;
}
+(Exercise_Model *)initModel:(Exercise_Model *)model ResultSet:(FMResultSet *)rs{
model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
model.StartTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"StartTime"]];
model.StopTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"StopTime"]];
model.Step = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Step"]];
model.Distance = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Distance"]];
model.Calories = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Calories"]];
model.Speed = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Speed"]];
model.AddTime = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"AddTime"]];
model.UserId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"UserId"]];
model.Flag = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Flag"]];
    NSLog(@"Id =%@ StartTime =%@ StopTime =%@ Step =%@ Distance =%@ Calories =%@ Speed =%@ AddTime =%@ UserId =%@ Flag =%@ ",model.Id,model.StartTime,model.StopTime,model.Step,model.Distance,model.Calories,model.Speed,model.AddTime,model.UserId,model.Flag);
 return model;}
+(Exercise_Model *)getModelById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_Exercise where id=%@",Id]];
Exercise_Model *model= [[Exercise_Model alloc] init];
 while ([rs next]) {
 model=[self initModel:model ResultSet:rs]; 
 }
return  model;
 }
+ (int) count{
	FMDatabase *dataBase = [DataBase setup];
	int ExerciseCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_Exercise "] intValue];
	[dataBase close];
	return ExerciseCount;
}
+ (int)getMaxId
{
	FMDatabase *dataBase = [DataBase setup];
int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_Exercise "] intValue];
if (maxid==1) {
 maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='Exercise' "] intValue]+1;
}
	[dataBase close];
	return maxid+1;
}
+(int)updateId:(NSString *)Id StartTime:(NSString *)StartTime StopTime:(NSString *)StopTime Step:(NSString *)Step Distance:(NSString *)Distance Calories:(NSString *)Calories Speed:(NSString *)Speed AddTime:(NSString *)AddTime UserId:(NSString *)UserId Flag:(NSString *)Flag 
{
	FMDatabase *dataBase = [DataBase setup];
	NSString *time=[DataBase getCurDateTime];
NSString *sql=[NSString stringWithFormat:@"UPDATE t_Exercise SET    StartTime = '%@' , StopTime = '%@' , Step = '%@' , Distance = '%@' , Calories = '%@' , Speed = '%@' , AddTime = '%@' , UserId = '%@' , Flag = '%@'    where id= '%@'",  StartTime,StopTime,Step,Distance,Calories,Speed,AddTime,UserId,Flag,Id
]; BOOL bResult = [dataBase executeUpdate:sql];
	[dataBase close];
	return bResult;
}
+ (int)remove:(NSString *) ID{
	FMDatabase *dataBase = [DataBase setup];
BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_Exercise WHERE ID = %@",ID]];	[dataBase close];
	return bResult;
}
+ (long long)addStartTime:(NSString *)StartTime StopTime:(NSString *)StopTime Step:(NSString *)Step Distance:(NSString *)Distance Calories:(NSString *)Calories Speed:(NSString *)Speed AddTime:(NSString *)AddTime UserId:(NSString *)UserId Flag:(NSString *)Flag {
	FMDatabase *dataBase = [DataBase setup];
	NSLog(@"addtitle");
long long lastId=0;
NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_Exercise (StartTime,StopTime,Step,Distance,Calories,Speed,AddTime,UserId,Flag)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@') ",StartTime,StopTime,Step,Distance,Calories,Speed,AddTime,UserId,Flag]; 
   if( [dataBase executeUpdate:sql])
 {
lastId=[dataBase lastInsertRowId];
}
	[dataBase close];
	return lastId;
}
@end
