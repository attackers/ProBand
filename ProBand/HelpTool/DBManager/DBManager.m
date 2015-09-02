//
//  DBManager.m
//  DBTest
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//

#import "DBManager.h"
#import "DBOperator.h"
@implementation DBManager

+ (DBManager *)shared
{
    static DBManager* _operator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operator = [[DBManager alloc] init];
    });
    return _operator;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary
{
    NSArray *array = [NSArray arrayWithObject:aDictionary];
    [self insertArrayToDB:tableName withDataArray:array];
}
- (void)insertArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray
{
    [DBOPERATOR insertDataArrayToDB:tableName withDataArray:dataArray];
}

- (void)updateDataOnDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    NSMutableArray *allKey = [NSMutableArray arrayWithArray:[aDictionary allKeys]];
    if ([allKey containsObject:key])
    {
        [allKey removeObject:key];
        NSMutableString *updateSql = [[NSMutableString alloc]initWithFormat:@"UPDATE %@ SET ",tableName];
        for (NSString *aKey in allKey)
        {
            [updateSql appendFormat:@"%@ = '%@',",aKey,aDictionary[aKey]];
        }
        [updateSql deleteCharactersInRange:NSMakeRange(updateSql.length-1, 1)];//移除最后一个逗号
        [updateSql appendFormat:@" where %@ = '%@'",key,value];
        NSError *error = [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
        if (error) {
            NSLog(@"更新出现错误");
        }
    }
    else
    {
        NSLog(@"字典中不包含所提供的键，请检查");
    }
}
- (NSArray *)allDataFromDB:(NSString *)tableName
{
    return [DBOPERATOR queryAllDataForSQL:tableName];
}
- (NSArray *)dataFromDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,key,value];
    return [DBOPERATOR getDataForSQL:sql];
}
- (void)deleteTable:(NSString *)tableName
{
    NSError *error = [DBOPERATOR deleteDateToSqlite:tableName];
    if (error) {
        NSLog(@"删除表失败");
    }
}
- (void)deleteDataFromTable:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'",tableName,key,value];
    NSError *error = [DBOPERATOR deleteDataToSqlitewithSqlexsit:sqlexist deleteSql:deleteSql];
    if (error) {
        NSLog(@"删除数据失败");
    }
}
- (BOOL)checkDataExistOnDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    return [DBOPERATOR checkTheDataExistOnDB:sql];
}
- (void)createNewTable:(NSString *)tableName withKeyArray:(NSArray *)keyArray
{
    NSMutableString *sqlStr = [NSMutableString string];
    for (NSString *key in keyArray)
    {
        [sqlStr appendFormat:@"%@ TEXT,",key];
    }
    [sqlStr deleteCharactersInRange:NSMakeRange(sqlStr.length-1, 1)];
    [DBOPERATOR createDataBaseTable:tableName propertyAndType:sqlStr];
}
@end
