//
//  DataBase.m
//  BookManage
//
//  Created by WangChao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
@implementation DataBase
//单例
+ (FMDatabase *)setup
{
    
    NSString *dataBaseName = [Singleton getUserID];
    static FMDatabase* _operator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operator = [self checkDatabase:@"Proband.sqlite" targetName:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];;
        
    });
    if ([_operator open]) {
        
    }
    return _operator;
}

// 检测沙盒中是否有数据库文件，没有则从资源库拷贝到沙盒
+(FMDatabase *)checkDatabase:(NSString *)orginName targetName:(NSString *)targetName
{
    BOOL success;
    NSString *dbFile = orginName;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writeDBPath = [documentsDirectory stringByAppendingPathComponent:targetName];
    success = [fileManager fileExistsAtPath:writeDBPath];
    
    if (!success) {//沙盒中没有数据库
        // 检测资源库里面是否有数据库文件
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFile];
        success = [fileManager fileExistsAtPath:defaultDBPath];
        
        if (success) {
            // 将数据库文件从资源库拷贝到沙盒中
            success  = [fileManager copyItemAtPath:defaultDBPath toPath:writeDBPath error:&error];
            if (!success) {
                NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }else{
            NSLog(@"资源库中没有数据库文件：%@~~~%@",writeDBPath, defaultDBPath);
        }
    }
    if (success)
    {
        FMDatabase *dbPointer = [[FMDatabase alloc] initWithPath:writeDBPath];
        //self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
        
        if (![dbPointer open]) {
            NSLog(@"open db failed.");
        }
        return dbPointer;
        //NSLog(@"%@", writeDBPath);
    }
    
    return nil;
}
+(void)updateTable
{
    FMDatabase *dataBase = [self setup];
    NSString * sql=@"";
    int num=0;
    sql=@"SELECT count(*) as count  FROM sqlite_master  where name='t_sleepDate_deviceid' and sql like('%Flag%')";
    num=[[dataBase stringForQuery:sql] intValue];
    if (num==0)
    {
        sql=@"ALTER TABLE  t_sleepDate_deviceid ADD COLUMN Flag  INTEGER ";
        [dataBase executeUpdate:sql];
        sql=@"ALTER TABLE  t_stepDate_deviceid ADD COLUMN Flag  INTEGER ";
        [dataBase executeUpdate:sql];
        
        sql=@"ALTER TABLE  t_original_data ADD COLUMN Flag  INTEGER ";
        if ([dataBase executeUpdate:sql])
        {
            NSLog(@"Add column  Flag success");
        }
       
        
    }

}

+(NSString *)getStrBySql:(NSString *)sql
{
	FMDatabase *dataBase = [DataBase setup];
	NSString *str=[dataBase stringForQuery:sql];
	
	[dataBase close];
	return str;
}
+(NSArray *)getArrBySql:(NSString *)sql column:(NSString *)column
{
	FMDatabase *dataBase = [DataBase setup];
	NSMutableArray *arr=[[NSMutableArray alloc] init];
	FMResultSet *rs;
	rs = [dataBase executeQuery:sql];
	while ([rs next]) {
		
		[arr addObject:[rs objectForColumnName:column]];
	}
	[rs close];
	[dataBase close];
	NSLog(@"arr=%@",arr);
	return arr ;
}
+(NSString *)getCurDateTime
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSDate *now = [[NSDate alloc] init];
	
	NSString *theDate = [dateFormat stringFromDate:now];
	NSString *theTime = [timeFormat stringFromDate:now];
	
	NSString *ret=[NSString stringWithFormat:@"%@ %@",theDate,theTime];
	
	
    //NSLog(@"%@",ret);
	return ret;
}
+(NSString *)getCurDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *ret=[NSString stringWithFormat:@"%@",theDate];
    
    
    //NSLog(@"%@",ret);
    return ret;
}

@end
