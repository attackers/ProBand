#import "stepDate_deviceidManage.h"
#import "DataBase.h"
#import "Singleton.h"

@implementation stepDate_deviceidManage
+(NSArray *)findAll{
	return [self findBySql:@"SELECT * FROM t_stepDate_deviceid order by id desc"];	
}
+(NSArray *)getUnUploadPageList:(int)pageId
{
    // NSInteger fromRow=pageId*15;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_stepDate_deviceid where flag=0  order by id desc"];
    return [self findBySql:sql];
}
+(int)updateFlag:(NSString *)Flag  byId:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    //NSString *time=[DataBase getCurDateTime];
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET   flag = '%@'    where id= '%@'",Flag,Id];
    BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}



+(NSArray *)getPageList:(int)pageId
{       
	NSInteger fromRow=pageId*15;
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_stepDate_deviceid order by id desc limit %ld,15",(long)fromRow];
	return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_stepDate_deviceid where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where id=%@",Id]];
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
NSMutableArray *stepDate_deviceids = [[NSMutableArray alloc] init];
while ([rs next]) {
	//NSLog(@"next");
stepDate_deviceid_Model *model= [[stepDate_deviceid_Model alloc] init];
model=[self initModel:model ResultSet:rs];
   // NSLog(@"Id =%@ userId =%@ mac =%@ date =%@ steps =%@ meters =%@ calories =%@ totalSteps =%@ totalDistance =%@ totalCalories =%@ sportDuration =%@ ",model.Id,model.userId,model.mac,model.date,model.steps,model.meters,model.calories,model.totalSteps,model.totalDistance,model.totalCalories,model.sportDuration);
    
	[stepDate_deviceids addObject:model];
 }
[rs close];
[dataBase close];
return stepDate_deviceids;
}

+(stepDate_deviceid_Model *)getModelById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_stepDate_deviceid where id=%@",Id]];
stepDate_deviceid_Model *model= [[stepDate_deviceid_Model alloc] init];
 while ([rs next]) {
     model=[self initModel:model ResultSet:rs];
}
return  model;
 }

+(stepDate_deviceid_Model *)getModelByDate:(NSString *)Date
{FMDatabase *dataBase = [DataBase setup];
     NSString  *format=@"%Y-%m-%d";
    NSString *sql=[NSString stringWithFormat:@"select * from t_stepDate_deviceid where userid='%@' and  strftime('%@',Date)='%@' ",[Singleton getUserID],format,[DataBase getCurDate]];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    stepDate_deviceid_Model *model= [[stepDate_deviceid_Model alloc] init];
    while ([rs next]) {
        model=[self initModel:model ResultSet:rs];
    }
    return  model;
}


+(NSString *)getTodayStep
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select totalstep from t_original_data where userid='%@' and  strftime('%@',Date)='%@'  and type='0'",[Singleton getUserID],format,[DataBase getCurDate]];
    id obj= [dataBase stringForQuery:sql];
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return  @"0";
}

+(NSString *)getTotalStepByUserId:(NSString *)UserId date:(NSString *)date
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select totalSteps from t_stepDate_deviceid where userid='%@' and  strftime('%@',Date)='%@' ",UserId,format,date]];
    NSString *totalStep=@"0";
    while ([rs next])
    {
        totalStep= [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalSteps"]];
    }
    return  totalStep;
}

+(stepDate_deviceid_Model *)initModel:(stepDate_deviceid_Model *)model ResultSet:(FMResultSet *)rs
{
    
    model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
    model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
    model.mac = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"mac"]];
    model.date = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]];
    model.steps = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"steps"]];
    model.meters = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"meters"]];
    model.calories = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"calories"]];
    model.totalSteps = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalSteps"]];
    model.totalDistance = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalDistance"]];
    model.totalCalories = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalCalories"]];
    model.sportDuration = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"sportDuration"]];
    
    return model;
}

+ (int) count{
	FMDatabase *dataBase = [DataBase setup];
	int stepDate_deviceidCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_stepDate_deviceid "] intValue];
	[dataBase close];
	return stepDate_deviceidCount;
}
+ (int)getMaxId
{
	FMDatabase *dataBase = [DataBase setup];
int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_stepDate_deviceid "] intValue];
if (maxid==1) {
 maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='stepDate_deviceid' "] intValue]+1;
}
	[dataBase close];
	return maxid+1;
}
+(int)updateId:(NSString *)Id userId:(NSString *)userId mac:(NSString *)mac date:(NSString *)date steps:(NSString *)steps meters:(NSString *)meters calories:(NSString *)calories totalSteps:(NSString *)totalSteps totalDistance:(NSString *)totalDistance totalCalories:(NSString *)totalCalories sportDuration:(NSString *)sportDuration 
{
	FMDatabase *dataBase = [DataBase setup];
	NSString *time=[DataBase getCurDateTime];
NSString *sql=[NSString stringWithFormat:@"UPDATE t_stepDate_deviceid SET    userId = '%@' , mac = '%@' , date = '%@' , steps = '%@' , meters = '%@' , calories = '%@' , totalSteps = '%@' , totalDistance = '%@' , totalCalories = '%@' , sportDuration = '%@'    where id= '%@'",  userId,mac,date,steps,meters,calories,totalSteps,totalDistance,totalCalories,sportDuration,Id
]; BOOL bResult = [dataBase executeUpdate:sql];
	[dataBase close];
	return bResult;
}
+ (int)remove:(NSString *) ID
{
	FMDatabase *dataBase = [DataBase setup];
BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_stepDate_deviceid WHERE ID = %@",ID]];	[dataBase close];
	return bResult;
}
+ (int)adduserId:(NSString *)userId mac:(NSString *)mac date:(NSString *)date steps:(NSString *)steps meters:(NSString *)meters calories:(NSString *)calories totalSteps:(NSString *)totalSteps totalDistance:(NSString *)totalDistance totalCalories:(NSString *)totalCalories sportDuration:(NSString *)sportDuration {
	FMDatabase *dataBase = [DataBase setup];
	NSLog(@"addtitle");
int lastId=0;
NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_stepDate_deviceid (userId,mac,date,steps,meters,calories,totalSteps,totalDistance,totalCalories,sportDuration)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') ",userId,mac,date,steps,meters,calories,totalSteps,totalDistance,totalCalories,sportDuration];
   if( [dataBase executeUpdate:sql])
 {
lastId=[dataBase lastInsertRowId];
}
	[dataBase close];
	return lastId;
}


+(NSArray *)getAllStepDataWithUserID:(NSString *)userID
{
    NSString *sql = [NSString stringWithFormat:@"select *from t_stepDate_deviceid where userId = '%@' order by date desc ",userID];
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithArray:[self findBySql:sql]];
    return  resultArr;
}




@end
