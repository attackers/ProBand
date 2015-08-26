#import "alarmManage.h"
#import "DataBase.h"
@implementation alarmManage
+ (NSArray *)findAll
{
    return [self findBySql:@"SELECT * FROM t_alarm order by id asc"];
}

+ (NSArray *)getPageList:(int)pageId
{
    NSInteger fromRow=pageId*15;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_alarm order by id desc limit %ld,15",(long)fromRow];
    return [self findBySql:sql];
}

+ (NSArray *)find:(NSString *)title
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_alarm where title like %@%@%@",@"'%",title,@"%'"];
    return [self findBySql:sql];
}

+ (NSDictionary *)getDictionaryById:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_alarm where id=%@",Id]];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    int count=[rs columnCount];
    while ([rs next]){
        for (int i=0; i<count; i++){
            NSString *columnName=[NSString stringWithFormat:@"%@",[rs columnNameForIndex:i]];
            NSString *columnValue = [NSString stringWithFormat:@"%@",[rs objectForColumnName:columnName]];
            [dic setObject:columnValue forKey:columnName];
        }
    }
    [rs close];
    NSDictionary *dics=[NSDictionary dictionaryWithDictionary:dic];
    return  dics;
}

+ (NSArray *)findBySql:(NSString *)sql
{
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs;
    rs = [dataBase executeQuery:sql];
    NSMutableArray *alarms = [[NSMutableArray alloc] init];
    while ([rs next]) {
        alarm_Model *model= [[alarm_Model alloc] init];
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"id"]];
        model.userid = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userid"]];
        model.interval_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_switch"]];
        model.repeat_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"repeat_switch"]];
        model.mac = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"mac"]];
        model.from_device = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"from_device"]];
        model.startTimeMinute = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"startTimeMinute"]];
        model.days_of_week = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"days_of_week"]];
        model.interval_time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_time"]];
        model.notification = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"notification"]];
        model.status = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"switch"]];
        [alarms addObject:model];
    }
    [rs close];
    [dataBase close];
    return alarms;
}

+ (alarm_Model *)getModelById:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_alarm where id=%@",Id]];
    alarm_Model *model= [[alarm_Model alloc] init];
    while ([rs next]) {
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"id"]];
        model.userid = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userid"]];
        model.interval_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_switch"]];
        model.repeat_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"repeat_switch"]];
        model.mac = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"mac"]];
        model.from_device = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"from_device"]];
        model.startTimeMinute = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"startTimeMinute"]];
        model.days_of_week = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"days_of_week"]];
        model.interval_time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_time"]];
        model.notification = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"notification"]];
        model.status = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"switch"]];
    }
    return  model;
}

+ (int)count{
    FMDatabase *dataBase = [DataBase setup];
    int alarmCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_alarm "] intValue];
    [dataBase close];
    return alarmCount;
}

+ (int)getMaxId
{
    FMDatabase *dataBase = [DataBase setup];
    int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_alarm "] intValue];
    if (maxid==1) {
        maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='alarm' "] intValue]+1;
    }
    [dataBase close];
    return maxid+1;
}
+ (int)updateId:(NSString *)Id userId:(NSString *)userId AlarmId:(NSString *)AlarmId startTime:(NSString *)startTime repeat:(NSString *)repeat name:(NSString *)name interval:(NSString *)interval status:(NSString *)status
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql = [NSString stringWithFormat:@"UPDATE alarm SET userId = '%@', AlarmId = '%@', startTime = '%@', repeat = '%@', name = '%@', interval = '%@', status = '%@' where id= '%@'",  userId,AlarmId,startTime,repeat,name,interval,status,Id];
    BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}

+ (int)remove:(NSString *)ID
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_alarm WHERE ID = %@",ID]];
    [dataBase close];
    return bResult;
}

+ (int)addDataToDB:(alarm_Model *)model
{
    FMDatabase *dataBase = [DataBase setup];
    int lastId = 0;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO  t_alarm (userid, interval_switch, repeat_switch, mac, id, from_device, startTimeMinute, days_of_week, interval_time, notification, switch) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@') ",model.userid,model.interval_switch,model.repeat_switch,model.mac,model.Id, model.from_device,model.startTimeMinute,model.days_of_week,model.interval_time,model.notification,model.status];
    NSLog(@"%@", sql);
    if([dataBase executeUpdate:sql])
    {
        NSLog(@"插入成功!!!!");
        lastId=[dataBase lastInsertRowId];
    }
    NSLog(@"%d", lastId);
    [dataBase close];
    return lastId;
}

+ (int)updateModel:(alarm_Model *)model ByModelId:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_alarm SET userId = '%@', interval_switch = '%@', repeat_switch = '%@', mac = '%@', from_device = '%@', startTimeMinute = '%@', days_of_week = '%@',interval_time = '%@', notification = '%@', switch = '%@' where id= '%@'", model.userid,model.interval_switch,model.repeat_switch, model.mac, model.from_device, model.startTimeMinute, model.days_of_week, model.interval_time, model.notification, model.status, model.Id];
    
    BOOL bResult = [dataBase executeUpdate:sql];
    NSLog(@"sql = %@, result = %d", sql, bResult);
    [dataBase close];
    return bResult;
}

+ (int)adduserId:(NSString *)userId AlarmId:(NSString *)AlarmId startTime:(NSString *)startTime repeat:(NSString *)repeat name:(NSString *)name interval:(NSString *)interval status:(NSString *)status
{
    FMDatabase *dataBase = [DataBase setup];
    int lastId = 0;
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_alarm (userId,AlarmId,startTime,repeat,name,interval,status)  VALUES ('%@','%@','%@','%@','%@','%@','%@') ",userId,AlarmId,startTime,repeat,name,interval,status];
    if( [dataBase executeUpdate:sql])
    {
        lastId=[dataBase lastInsertRowId];
    }
    [dataBase close];
    return lastId;
}

+ (int)getLastAlarmId
{
    if ([self count] == 0) return 0;

    NSString *sql = @"SELECT * FROM t_alarm order by id desc limit 0,1";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs;
    rs = [dataBase executeQuery:sql];
    alarm_Model *model= [[alarm_Model alloc] init];
    while ([rs next]) {
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"id"]];
        model.userid = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userid"]];
        model.interval_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_switch"]];
        model.repeat_switch = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"repeat_switch"]];
        model.mac = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"mac"]];
        model.from_device = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"from_device"]];
        model.startTimeMinute = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"startTimeMinute"]];
        model.days_of_week = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"days_of_week"]];
        model.interval_time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"interval_time"]];
        model.notification = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"notification"]];
        model.status = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"switch"]];
    }
    [rs close];
    [dataBase close];
    
    return [model.Id intValue];
}

@end
