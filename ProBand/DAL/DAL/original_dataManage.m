#import "original_dataManage.h"
#import "DataBase.h"
#import "AlgorithmHelper.h"
@implementation original_dataManage

+(NSArray *)findAll
{
    return [self findBySql:@"SELECT * FROM t_original_data order by id desc"];
}
+(NSArray *)getAllStepData
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type=0 order by id asc "];
    return [self findBySql:sql];
}
+(NSArray *)getAllSleepData
{
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type=1 order by id asc "];
    return [self findBySql:sql];
}

+(NSArray *)getPageListByDate:(NSString *)Date
{
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where date='%@' and type='0' order by id desc ",Date];
    return [self findBySql:sql];
}

+(NSArray *)getPageList:(int)pageId type:(NSString *)type
{
    NSInteger fromRow=pageId*50;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type='%@' order by id desc limit %ld,50",type,(long)fromRow];
    return [self findBySql:sql];
}
+(NSArray *)getSleepPageList:(int)pageId
{
    NSInteger fromRow=pageId*50;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type=1 order by id desc limit %ld,50",(long)fromRow];
    return [self findBySql:sql];
}
+(NSArray *)getStepPageList:(int)pageId
{
    NSInteger fromRow=pageId*50;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where type=0 order by id desc limit %ld,50",(long)fromRow];
    return [self findBySql:sql];
}
+ (int)removeByDate:(NSString *)date
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data where date='%@'",date]];
    [dataBase close];
    return bResult;
}
+(NSString *)getTodayStep
{
    NSString  *format=@"%Y-%m-%d";// COALESCE(MAX(id)+1, 0)
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select  COALESCE(sum(count), 0)  as count from t_original_data where userid='%@' and  strftime('%@',Date)='%@'  and type='0'",[Singleton getUserID],format,[DataBase getCurDate]];
    id obj= [dataBase stringForQuery:sql];
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return  @"0";
}
+(NSString *)getTotalStepByDay:(NSString *)day
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select COALESCE(sum(count), 0) as count from t_original_data where userid='%@' and  strftime('%@',Date)='%@'  and type='0'",[Singleton getUserID],format,day];
    id obj= [dataBase stringForQuery:sql];
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return  @"0";
}

//按周统计跑步数据  type 0是跑步 1是睡眠
+(NSString *)getTotalWeekStepByYear:(NSString *)year type:(NSString *)type
{
    //NSString  *format=@"%Y-%m-%d";
    NSString  *formatWeek=@"%W";
    FMDatabase *dataBase = [DataBase setup];
    //NSString *sql=[NSString stringWithFormat:@"select  strftime('%@',Date) as week,COALESCE(sum(count), 0) as count from t_original_data where userid='%@' and  strftime('%@',Date)='%@'  and type='0' group by strftime('%@',Date) order by date desc ",formatWeek,[Singleton getUserID],format,year,formatWeek];
    
    NSString *sql=[NSString stringWithFormat:@"select  strftime('%@',Date) as week,COALESCE(sum(count), 0) as count from t_original_data where  type='%@' group by strftime('%@',Date) order by date desc ",formatWeek,type,formatWeek];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableString *str=[[NSMutableString alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *week = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"week"]];
        [str appendString:[NSString stringWithFormat:@"week=%@,count=%@",week,count]];
        //NSLog(@"count=%@ totalMet=%d totalCal=%d totalMinitus =%d",count,totalMet,totalCal,totalMinitus);
    }
    NSLog(@"strweek=%@",str);
    return  str;
}


//按月份统计跑步数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getMonthStepByYear:(NSString *)year type:(NSString *)type
{
    //NSString  *format=@"%Y-%m-%d";
    NSString  *formatMonth=@"%Y-%m";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select  strftime('%@',Date) as month,COALESCE(sum(count), 0) as count from t_original_data where  type='%@' group by strftime('%@',Date) order by date desc ",formatMonth,type,formatMonth];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"month"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"month dic=%@",dic);
    return  dic;
}

//按年统计跑步数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getYearStepByType:(NSString *)type
{
    //NSString  *format=@"%Y-%m-%d";
    NSString  *formatMonth=@"%Y";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select  strftime('%@',Date) as month,COALESCE(sum(count), 0) as count from t_original_data where  type='%@' group by strftime('%@',Date) order by date desc ",formatMonth,type,formatMonth];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"month"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"year dic=%@",dic);
    return  dic;
}
//按日期类型统计 卡路里 type 0是跑步 1是睡眠
+(float)getCaloriesByDate:(NSString *)Date
{
    NSString  *dateFormat=@"%Y-%m-%d";
    
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    [sql appendString:[NSString stringWithFormat:@" select  strftime('%@',time) as trendDate,[count] ",dateFormat]];
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type='%@' ",@"0"]];
    [sql appendString:[NSString stringWithFormat:@" and  strftime('%@',time)='%@' ",dateFormat,Date]];
    [sql appendString:[NSString stringWithFormat:@"  order by time desc "]];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    float cal=0;
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        cal += [AlgorithmHelper getCalorieFromStep:[count integerValue]];//计算每3分钟的卡路里
        
    }
    return  cal;
}


//按天统计跑步数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getDayStepByYear:(NSString *)year  type:(NSString *)type
{
    //NSString  *format=@"%Y-%m-%d";
    NSString  *formatMonth=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select  strftime('%@',Date) as month,COALESCE(sum(count), 0) as count from t_original_data where  type='%@' group by strftime('%@',Date) order by date desc ",formatMonth,type,formatMonth];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"month"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"day dic=%@",dic);
    return  dic;
}
//按日期类型统计跑步时间 卡路里 距离  type 0是跑步 1是睡眠
+(NSArray *)getCaloriesDistanceMinuteByType:(NSString *)type dateFormatType:(NSString *)dateFormatType  fromDate:(NSString *)fromDate toDate:(NSString *)toDate
{
    NSString  *dateFormat=[self getFormat:dateFormatType];
    //NSString  *dayFormat=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    [sql appendString:[NSString stringWithFormat:@" select  strftime('%@',time) as trendDate,[count] ",dateFormat]];
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type='%@' ",type]];
    
    [sql appendString:[NSString stringWithFormat:@" and  time between '%@' and '%@'",fromDate,toDate]];
    
    [sql appendString:[NSString stringWithFormat:@"  order by date desc "]];
    FMResultSet *rs = [dataBase executeQuery:sql];
    float met=0;
    float cal=0;
    int minute=0;
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        met += [AlgorithmHelper getDistanceFromStep:[count integerValue]];//计算每3分钟的距离
        cal += [AlgorithmHelper getCalorieFromStep:[count integerValue]];//计算每3分钟的卡路里
        minute+=3;
        
    }
    return  @[[NSString stringWithFormat:@"%1.3f",cal],[NSString stringWithFormat:@"%1.3f",met],[NSString stringWithFormat:@"%d",minute]];
}

//统计某天每4个小时 跑步睡眠数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getEveryFourHoursCountByType:(NSString *)type Date:(NSString *)Date
{
    NSString  *dateFormat=@"%J";
    NSString  *dayFormat=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    [sql appendString:[NSString stringWithFormat:@" select  cast((strftime('%@',[time])  - strftime('%@','%@'))*24/4 as int) as trendDate,COALESCE(sum(count), 0) as count ",dateFormat,dateFormat,Date]];
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type='%@' ",type]];
    [sql appendString:[NSString stringWithFormat:@" and  strftime('%@',time)='%@' ",dayFormat,[PublicFunction getCurDay]]];
    [sql appendString:[NSString stringWithFormat:@" group by trendDate order by date desc "]];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"trendDate"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"dateFormat=%@ dic=%@",dateFormat,dic);
    return  dic;
}

//统计某天每4个小时 睡眠数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getEveryFourHoursSleepByDate:(NSString *)Date
{
    NSString  *dateFormat=@"%J";
    NSString  *dayFormat=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    [sql appendString:[NSString stringWithFormat:@" select  cast((strftime('%@',[time])  - strftime('%@','%@'))*24/4 as int) as trendDate,COALESCE(sum(count), 0) as count ",dateFormat,dateFormat,Date]];
    
    
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type=1 "]];
    [sql appendString:[NSString stringWithFormat:@" and  strftime('%@',time)='%@' ",dayFormat,[PublicFunction getCurDay]]];
    [sql appendString:[NSString stringWithFormat:@" group by trendDate order by date desc "]];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"trendDate"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"dateFormat=%@ dic=%@",dateFormat,dic);
    return  dic;
}

//按日期类型统计跑步睡眠数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getTotalCountByType:(NSString *)type dateFormatType:(NSString *)dateFormatType  fromDate:(NSString *)fromDate toDate:(NSString *)toDate
{
    NSString  *dateFormat=[self getFormat:dateFormatType];
    
    NSString  *dayFormat=@"%Y-%m-%d";
    
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    
    [sql appendString:[NSString stringWithFormat:@" select  strftime('%@',time) as trendDate,COALESCE(sum(count), 0) as count ",dateFormat]];
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type='%@' ",type]];
    if ([dateFormatType isEqualToString:FormatTypeHour])
    {
        [sql appendString:[NSString stringWithFormat:@" and  strftime('%@',time)='%@' ",dayFormat,[PublicFunction getCurDay]]];
    }
    else
    {
        [sql appendString:[NSString stringWithFormat:@" and  time between '%@' and '%@'",fromDate,toDate]];
    }
    
    [sql appendString:[NSString stringWithFormat:@" group by strftime('%@',time) order by date desc ",dateFormat]];
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        // NSString *totalMinutes = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"totalMinutes"]];
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        NSString *month = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"trendDate"]];
        [dic setObject:count forKey:month];
    }
    NSLog(@"dateFormat=%@ dic=%@",dateFormat,dic);
    return  dic;
}


//-----------------------------------------------------------------------------------------------------

//日期类型统计深睡 浅睡 清醒 数据
+(NSMutableDictionary *)getSleepCategoryByDateFormatType:(NSString *)dateFormatType fromDate:(NSString *)fromDate toDate:(NSString *)toDate
{
    NSString  *dateFormat=[self getFormat:dateFormatType];
    NSString  *dayFormat=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSMutableString *sql=[[NSMutableString alloc] init];
    
    //当天每隔4小时的统计数据
    //[sql appendString:[NSString stringWithFormat:@" select  cast((strftime('%@',[time])  - strftime('%@','%@'))*24/4 as int) as trendDate, ",dateFormat,dateFormat,[PublicFunction getCurDay]]];
    [sql appendString:[NSString stringWithFormat:@"select  strftime('%@',time) as TrendDate,",dateFormat]];
    [sql appendString:@"COALESCE(sum(CASE WHEN count>0 and count <60 THEN 3  ELSE 0 END), 0) as deepSleep , "];
    [sql appendString:@"COALESCE(sum(CASE WHEN count>=60 and count <90 THEN 3  ELSE 0 END), 0) as lightSleep , "];
    [sql appendString:@"COALESCE(sum(CASE WHEN count>=90  THEN 3  ELSE 0 END), 0) as wake "];
    [sql appendString:[NSString stringWithFormat:@" from t_original_data where  type='1' "]];
    
    
    if ([dateFormatType isEqualToString:FormatTypeHour])
    {
        [sql appendString:[NSString stringWithFormat:@" and  strftime('%@',time)='%@'",dayFormat,[PublicFunction getCurDay]]];
    }
    else
    {
        [sql appendString:[NSString stringWithFormat:@" and  time between '%@' and '%@'",fromDate,toDate]];
    }
    
    [sql appendString:[NSString stringWithFormat:@" group by TrendDate order by date desc "]];
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    while ([rs next])
    {
        NSString *deepSleep = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"deepSleep"]];
        NSString *lightSleep = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"lightSleep"]];
        NSString *wake = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"wake"]];
        NSString *TrendDate = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"TrendDate"]];
        [dic setObject:[NSString stringWithFormat:@"%@,%@,%@",deepSleep,lightSleep,wake] forKey:TrendDate];
    }
    NSLog(@"Sleep category dic=%@",dic);
    return  dic;
}


+(NSString *)getFormat:(NSString *)dateFormatType
{
    NSString  *dateFormat=@"";
    
    if ([dateFormatType isEqualToString:FormatTypeHour]) {
        dateFormat=@"%H"; //@"%J"
    }
    else if ([dateFormatType isEqualToString:FormatTypeDay]) {
        dateFormat=@"%Y-%m-%d";
    }
    else if ([dateFormatType isEqualToString:FormatTypeWeek]) {
        dateFormat=@"%W";
    }
    else if ([dateFormatType isEqualToString:FormatTypeMonth]) {
        dateFormat=@"%Y-%m";
    }
    else if ([dateFormatType isEqualToString:FormatTypeYear]) {
        dateFormat=@"%Y";
    }
    return dateFormat;
}

+(NSString *)getTotalSportTimeByDay:(NSString *)day
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select COALESCE(sum(1)*3, 0)  as time from t_original_data where count>0 and  userid='%@' and  strftime('%@',Date)='%@'  and type='0'",[Singleton getUserID],format,day];
    id obj= [dataBase stringForQuery:sql];
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return  @"0";
}

+(NSString *)getDistanceCalorieMinutesByDay:(NSString *)day
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select count,time from t_original_data where count>0 and  userid='%@' and  strftime('%@',Date)='%@'  and type='0'",[Singleton getUserID],format,day];
    FMResultSet *rs = [dataBase executeQuery:sql];
    int totalMet=0;
    int totalCal=0;
    int totalMinitus=0;
    while ([rs next])
    {
        NSString *count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        // NSString *time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"time"]];
        totalMet+= [AlgorithmHelper getDistanceFromStep:[count integerValue]];//计算每3分钟的距离
        totalCal+= [AlgorithmHelper getCalorieFromStep:[count integerValue]];//计算每3分钟的卡路里
        totalMinitus+=3;
        
        //NSLog(@"count=%@ totalMet=%d totalCal=%d totalMinitus =%d",count,totalMet,totalCal,totalMinitus);
    }
    
    
    return  [NSString stringWithFormat:@"%d,%d,%d",totalMet,totalCal,totalMinitus];
}


//met = [AlgorithmHelper getDistanceFromStep:[objt integerValue]/3]*3;//计算每3分钟的距离
//cal = [AlgorithmHelper getCalorieFromStep:[objt integerValue]/3]*3;//计算每3分钟的卡路里

//根据日期获取睡眠总时间
+(NSString *)getTotalSleepTimeByDay:(NSString *)day
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select count(*)   as totaltime from t_original_data where count>0 and userid='%@' and  strftime('%@',Date)='%@'  and type='1'",[Singleton getUserID],format,day];
    id obj= [dataBase stringForQuery:sql];
    if (obj) {
        return [NSString stringWithFormat:@"%d",[obj intValue]*3];
    }
    return  @"0";
}
//根据日期获取深睡浅睡和清醒时间
+(NSString *)getSleepCategoryTimeByDay:(NSString *)day
{
    NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"select  COALESCE(sum(CASE WHEN count<60 THEN 3 ELSE 0 END), 0)  AS deepSleep ,  COALESCE(sum(CASE WHEN count>=60 and count <90 THEN 3 ELSE 0 END), 0)  AS lightSleep ,  COALESCE(sum(CASE WHEN count>=90 THEN 3 ELSE 0 END), 0)  AS wake  from t_original_data where  count>0  and userid='%@' and  strftime('%@',Date)='%@'  and type='1'",[Singleton getUserID],format,day];
    FMResultSet *rs = [dataBase executeQuery:sql];
    
    //modify by  fly
    
    int lightSleep=0;
    int deepSleep=0;
    int wake=0;
    while ([rs next])
    {
        
        deepSleep = [[rs objectForColumnName:@"deepSleep"] intValue];
        lightSleep = [[rs objectForColumnName:@"lightSleep"] intValue];
        wake= [[rs objectForColumnName:@"wake"] intValue];
        
        
    }
    NSLog(@"deepSleep =%d,lightSleep= %d,wake =%d",deepSleep,lightSleep,wake);
    return  [NSString stringWithFormat:@"%d,%d,%d",deepSleep,lightSleep,wake];
}




+(NSArray *)getModelArrayBySQL:(NSString *)sql
{
    //NSInteger fromRow=pageId*15;
    // NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data order by id desc limit %ld,15",(long)fromRow];
    return [self findBySql:sql];
}
+ (NSArray *)find:(NSString *)title
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM t_original_data where title like %@%@%@",@"'%",title,@"%'"];	return [self findBySql:sql];
}
+(NSDictionary *)getDictionaryById:(NSString *)Id
{FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_original_data where id=%@",Id]];
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
    NSMutableArray *original_datas = [[NSMutableArray alloc] init];
    NSMutableString *str=[[NSMutableString alloc] init];
    while ([rs next]) {
        //NSLog(@"next");
        original_data_Model *model= [[original_data_Model alloc] init];
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
        model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
        model.date = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]];
        model.count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        model.type = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"type"]];
        model.time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"time"]];
        
        model.time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"time"]];
        model.MacAddress = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"MacAddress"]];
        model.OriginalHEX = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"OriginalHEX"]];
        [str appendString:[NSString stringWithFormat:@"time=%@ count=%@ hex=%@ mac=%@\n",model.time,model.count,model.OriginalHEX,model.MacAddress]];
        NSLog(@"time=%@ count=%@",model.time,model.count);
        [original_datas addObject:model];
    }
    //NSLog(@"str=\n%@",str);
    [rs close];
    [dataBase close];
    return original_datas;
}

+(original_data_Model *)getModelById:(NSString *)Id
{
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from t_original_data where id=%@",Id]];
    original_data_Model *model= [[original_data_Model alloc] init];
    while ([rs next]) {
        model.Id = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"Id"]];
        model.userId = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"userId"]];
        model.date = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]];
        model.count = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"count"]];
        model.type = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"type"]];
        model.time = [NSString stringWithFormat:@"%@",[rs objectForColumnName:@"time"]];
    }
    return  model;
}

+(NSArray *)getUnSaveDateArray:(NSString *)userid
{
    // NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select distinct date from t_original_data where userid='%@' and flag =0 ",userid]];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([rs next])
    {
        [array addObject:[NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]]];
    }
    NSLog(@"UnSaveDateArray =%@",array);
    return  [NSArray arrayWithArray:array];
    
}
//按照3分钟一条数据，初始化一个字典
+(NSMutableArray *)getInitDictionaryByDate:(NSString *)date
{
    NSMutableArray *dic=[[NSMutableArray alloc] init];
    for (int i=0; i<24; i++)
    {
        for (int j=0; j<60; j++)
        {
            if (j%3==0)
            {
                NSString *time=[NSString stringWithFormat:@"%@ %02d:%02d",date,i,j];
                //NSLog(@"time=%@",time);
                [dic setValue:@"0" forKey:time];
            }
        }
    }
    return dic;
}
//按照3分钟一条数据，初始化一个字典
+(NSMutableArray *)getInitDictionary
{
    NSMutableArray *dic=[[NSMutableArray alloc] init];
    for (int i=0; i<24; i++)
    {
        for (int j=0; j<60; j++)
        {
            if (j%3==0)
            {
                NSString *time=[NSString stringWithFormat:@"%02d:%02d",i,j];
                //NSLog(@"time=%@",time);
                [dic setValue:@"0" forKey:time];
            }
        }
    }
    return dic;
}

+(NSArray *)getAllDateArray:(NSString *)userid
{
    // NSString  *format=@"%Y-%m-%d";
    FMDatabase *dataBase = [DataBase setup];
    FMResultSet *rs = [dataBase executeQuery:[NSString stringWithFormat:@"select distinct date from t_original_data where userid='%@' ",userid]];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([rs next])
    {
        [array addObject:[NSString stringWithFormat:@"%@",[rs objectForColumnName:@"date"]]];
    }
    NSLog(@"AllDateArray =%@",array);
    return  [NSArray arrayWithArray:array];
    
}

+ (int) countByDate:(NSString *)date
{
    FMDatabase *dataBase = [DataBase setup];
    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) AS Count FROM t_original_data  where date='%@' ",date];
    int original_dataCount=[[dataBase stringForQuery:sql] intValue];
    [dataBase close];
    return original_dataCount;
}
+ (int) count{
    FMDatabase *dataBase = [DataBase setup];
    int original_dataCount=[[dataBase stringForQuery:@"SELECT COUNT(*) AS Count FROM t_original_data "] intValue];
    [dataBase close];
    return original_dataCount;
}
+ (int)getMaxId
{
    FMDatabase *dataBase = [DataBase setup];
    int maxid = [[dataBase stringForQuery:@"SELECT COALESCE(MAX(id)+1, 0) AS maxid FROM  t_original_data "] intValue];
    if (maxid==1) {
        maxid = [[dataBase stringForQuery:@"select seq from sqlite_sequence where name='original_data' "] intValue]+1;
    }
    [dataBase close];
    return maxid+1;
}
+(int)updateAllFlag
{
    FMDatabase *dataBase = [DataBase setup];
    //NSString *time=[DataBase getCurDateTime];
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_original_data SET   flag=1 " ];
    
    BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}

+(int)updateId:(NSString *)Id userId:(NSString *)userId date:(NSString *)date count:(NSString *)count type:(NSString *)type time:(NSString *)time
{
    FMDatabase *dataBase = [DataBase setup];
    //NSString *time=[DataBase getCurDateTime];
    NSString *sql=[NSString stringWithFormat:@"UPDATE t_original_data SET    userId = '%@' , date = '%@' , count = '%@' , type = '%@' , time = '%@'    where id= '%@'",  userId,date,count,type,time,Id
                   ]; BOOL bResult = [dataBase executeUpdate:sql];
    [dataBase close];
    return bResult;
}
+ (int)removeNull
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data WHERE count=0 "]];	[dataBase close];
    return bResult;
}
+ (int)removeAllData
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data  "]];	[dataBase close];
    return bResult;
}
+ (int)removeAllSleepData
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data WHERE type=1 "]];	[dataBase close];
    return bResult;
}
+ (int)removeAllStepData
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data WHERE type=0 "]];	[dataBase close];
    return bResult;
}
+ (int)remove:(NSString *) ID
{
    FMDatabase *dataBase = [DataBase setup];
    BOOL bResult = [dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_original_data WHERE ID = %@",ID]];	[dataBase close];
    return bResult;
}
+ (long)adduserId:(NSString *)userId date:(NSString *)date count:(NSString *)count type:(NSString *)type time:(NSString *)time  MacAddress:(NSString *)MacAddress  OriginalHEX:(NSString *)OriginalHEX  Flag:(NSString *)Flag
{
    FMDatabase *dataBase = [DataBase setup];
    NSLog(@"addtitle");
    long lastId=0;
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_original_data (userId,date,count,type,time,MacAddress,OriginalHEX,Flag)  VALUES ('%@','%@','%@','%@','%@','%@','%@','%@') ",userId,date,count,type,time,MacAddress,OriginalHEX,Flag];
    if( [dataBase executeUpdate:sql])
    {
        lastId=[dataBase lastInsertRowId];
    }
    //[dataBase close];
    return lastId;
}


+(void)insertWithArray:(NSArray *)valueArray
{
    FMDatabase *_fmdb= [DataBase setup];
    if ([valueArray count] <= 0)
    {
        return;
    }
    if ([_fmdb open])
    {
        NSMutableArray *resultSleepArray = [NSMutableArray new];
        // NSLog(@"valueArray=%@",valueArray);
        NSString *userid=[Singleton getUserID];
        
        for (int number = 0; number < valueArray.count; number++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[valueArray objectAtIndex:number]];
            
            NSString *sql = [NSString stringWithFormat:@"select count(*) from t_original_data where userid = '%@' and time='%@'",userid,[dic objectForKey:@"time"]];
            int count=[[_fmdb stringForQuery:sql] intValue];
            NSLog(@"sql=%@",sql);
            NSLog(@"count=%d",count);
            if (count==0)
            {
                NSString *sql=[NSString stringWithFormat:@"INSERT INTO  t_original_data (userId,flag,date,count,type,time)  VALUES ('%@','%@','%@','%@','%@','%@') ",userid,@"0",[dic objectForKey:@"date"],[dic objectForKey:@"count"],[dic objectForKey:@"type"],[dic objectForKey:@"time"]];
                [resultSleepArray addObject:sql];
            }
        };
        
        //使用事务处理
        [_fmdb beginTransaction];
        for (NSString *sql in resultSleepArray)
        {
            if (![_fmdb executeUpdate:sql]) {
                NSLog(@"～～～～～～～～插入失败,sql=%@",sql);
            }
            else
            {
                NSLog(@"插入成功 sql=%@",sql);
            }
        }
        [_fmdb commit];
        [_fmdb close];
        
        
    }
    
}


+(void)addTestData
{
    NSArray *typeArray=@[@"0",@"1"];
    NSArray *yearArray=@[@"2014",@"2015"];
    NSArray *monthArray=@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    NSArray *dayArray=@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    NSArray *hourArray=@[@"01:10",@"02:10",@"03:10",@"04:10",@"05:10",@"06:10",@"07:10",@"08:10",@"09:10",@"10:10",@"11:10",@"12:10",@"13:10",@"14:10",@"15:10",@"16:10",@"17:10",@"18:10",@"19:10",@"20:10",@"21:10",@"22:10",@"23:10"];
    
    NSString *dateTime=@"";
    NSString *sqlString=@"";
    NSString *userid=[Singleton getUserID];
    NSMutableArray *sqlArray=[[NSMutableArray alloc] init];
    for (int t=0; t<typeArray.count; t++)
    {
        NSString *types=[typeArray objectAtIndex:t];
        for (int i=0; i<yearArray.count; i++)
        {
            for (int j=0; j<monthArray.count;j++)
            {
                for (int k=0; k<dayArray.count;k++)
                {
                    for (int l=0; l<hourArray.count;l++)
                    {
                        int value = arc4random() % 100;
                        
                        dateTime=[NSString stringWithFormat:@"%@-%@-%@ %@",[yearArray objectAtIndex:i],[monthArray objectAtIndex:j],[dayArray objectAtIndex:k],[hourArray objectAtIndex:l]];
                        NSString *date=[[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
                        sqlString=[NSString stringWithFormat:@"INSERT INTO  t_original_data (userId,flag,date,count,type,time)  VALUES ('%@','%@','%@','%d','%@','%@') ",userid,@"1",date,value,types,dateTime];
                        [sqlArray addObject:sqlString];
                        
                    }
                }
            }
        }
    }
    
    NSLog(@"sqlArray count=%lu",(unsigned long)sqlArray.count);
    FMDatabase *_fmdb= [DataBase setup];
    //使用事务处理
    [_fmdb beginTransaction];
    for (NSString *sql in sqlArray)
    {
        if (![_fmdb executeUpdate:sql]) {
            NSLog(@"～～～～～～～～插入失败,sql=%@",sql);
        }
        else
        {
            NSLog(@"add success");
        }
    }
    [_fmdb commit];
    [_fmdb close];
    
}


@end
