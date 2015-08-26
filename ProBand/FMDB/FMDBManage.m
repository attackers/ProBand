//
//  FMDBManage.m
//  FMDBManage
//
//  Created by attack on 15/6/24.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "FMDBManage.h"
@interface FMDBManage()
{
    FMDatabase *database;
}
@end
@implementation FMDBManage
+(FMDBManage *)shareFMDBManage
{
    static FMDBManage *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manage = [[FMDBManage alloc]init];
        
        
    });
    return manage;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createDatabase];
    }
    return self;
}
- (void)createDatabase
{
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"/Documentation"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL tag = [manager fileExistsAtPath:path isDirectory:NULL];
    
    if (!tag) {
        tag =  [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        path = [path stringByAppendingPathComponent:@"/fenda.db"];
        
    }else{
        path = [path stringByAppendingPathComponent:@"/fenda.db"];
    }
    database = [FMDatabase databaseWithPath:path];
    if (![database open]) {
        NSLog(@"打开数据库失败");
        NSLog(@"%@",database.lastErrorMessage);
        return;
    }
    [database close];
}
/**
 *  创建数据库表
 *
 *  @param tableName 要创建的表名
 *  @param property       要创建的表的内容，传入格式为@"属性名 属性类型，属性名 属性类型，属性名 属性类型......."，属性类型TEXT、INTEGER、DATA、BOOL
 */
- (void)createDataBaseTable:(NSString*)tableName propertyAndType:(NSString*)property
{
    if ([database open]) {
        /**
         *  判断表是否存在,如果不存在，就创建表
         */
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName ];
        FMResultSet *rs = [database executeQuery:existsSql];
        if ([rs next]) {
            
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", count);
            if (count == 1) {
                NSLog(@"log_keepers table is existed.");
                return;
            }
            
            NSString *table = [NSString stringWithFormat:@"CREATE TABLE  %@ (%@)",tableName,property];
            BOOL ok = [database executeUpdate:table];
            if (ok) {
                NSLog(@"ok");
            }
        }
        [rs close];
    }
    [database close];
}

- (void)insertDataFromTable:(NSString*)tableName insertValueDic:(NSDictionary*)dic
{
    if ([database open]) {
        
        /**
         *  判断表是否存在,如果不存在，就创建表
         */
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName ];
        FMResultSet *rs = [database executeQuery:existsSql];
        NSMutableArray *valuesArray = [NSMutableArray array];
        if ([rs next]) {
            
            NSArray *keys = [dic allKeys];
            NSString *keyString;
            NSString *valuesString;
            NSString *orIn;
            for (int i = 0; i<keys.count; i++) {
                if (i == 0) {
                    
                    keyString = keys[i];
                    valuesString = @"[dic objectForKey:keys[0]]",
                    orIn = @"?";
                    
                }else{
                    
                    keyString = [NSString stringWithFormat:@"%@,%@",keyString,keys[i]];
                    NSString *vstg = [NSString stringWithFormat:@"[dic objectForKey:keys[%d]]",i];
                    valuesString = [NSString stringWithFormat:@"%@,%@",valuesString,vstg];
                    orIn = [NSString stringWithFormat:@"%@,%@",orIn,@"?"];

                }
                
                [valuesArray addObject:[dic objectForKey:keys[i]]];

            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES(%@)",tableName,keyString,orIn];
             BOOL insert =  [database executeUpdate:sql withArgumentsInArray:valuesArray];
                if (insert) {
                    NSLog(@"insert ok");
                }
//            }
        }
        
        [rs close];
    }
    [database close];
}
- (void)deleteDataFromTable:(NSString*)tableName deleteKey:(NSString*)key deleteValue:(NSString*)value
{
    
    if ([database open]) {
        
        NSString*  deleteSql = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", tableName,key,value];
        BOOL ok = [database executeUpdate:deleteSql];
        if (ok) {
            NSLog(@"delete ok");
        }else{
            
            NSLog(@"Error:%@",database.lastErrorMessage);
        }
    }
    [database close];
    
}
- (void)upDataFromTable:(NSString*)tableName updataValue:(NSDictionary*)updataDic
{
    if ([database open]) {
        
        NSString *updateSql = @"";
        NSArray *keys = updataDic.allKeys;
        for (int i = 0; i<keys.count; i++) {
            updateSql = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ = '%@'", tableName,keys[i],[updataDic objectForKey:keys[i]]];
            BOOL ok = [database executeUpdate:updateSql];
            if (ok) {
                NSLog(@"update ok");
            }
        }
    }
    [database close];
}
- (void)selectDataFromtable:(NSString*)tableName
{
    if ([database open]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@",tableName];
        NSMutableArray *fSetArray = [NSMutableArray array];
        FMResultSet *rs = [database executeQuery:sqlString];
        while([rs next]) {
            
//            NSLog(@"%@ %@",[rs stringForColumn:@"nameSt"],[rs stringForColumn:@"image"]);
            
            NSString *keys = [rs stringForColumn:@"keys"];
            NSArray *keysArray = [keys componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *keyName in keysArray) {
                
                [dic setValue:[rs stringForColumn:keyName] forKey:keyName];
            }
            [fSetArray addObject:dic];
        }

        [self.delegate requestDelegateData:fSetArray];
        [rs close];
    }
    [database close];
}

- (NSMutableArray *)getDataFromtable:(NSString*)tableName
{
    if ([database open]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@",tableName];
        NSMutableArray *fSetArray = [NSMutableArray array];
        FMResultSet *rs = [database executeQuery:sqlString];
        while([rs next]) {
            
            //            NSLog(@"%@ %@",[rs stringForColumn:@"nameSt"],[rs stringForColumn:@"image"]);
            
            NSString *keys = [rs stringForColumn:@"keys"];
            NSArray *keysArray = [keys componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *keyName in keysArray) {
                
                [dic setValue:[rs stringForColumn:keyName] forKey:keyName];
            }
            [fSetArray addObject:dic];
        }
        
       // [self.delegate requestDelegateData:fSetArray];
        [rs close];
         [database close];
        return fSetArray;
    }
    return nil;
}

@end
