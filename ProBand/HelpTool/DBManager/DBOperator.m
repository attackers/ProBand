//
//  DBOperator.m
//  LenovoVB10
//
//  Created by jacy on 14/12/5.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "DBOperator.h"
#import "Singleton.h"
#import "FMDatabaseAdditions.h"

@interface DBOperator()

//以下为基础数据库操作，不允许外部调用
- (NSError*)errorWithMessage:(NSString*)message;
- (NSArray *)basequeryForSQL:(NSString *)sql db:(FMDatabase*)db;
- (NSError*)updateForSQL:(NSString *)sql db:(FMDatabase*)db;
//查询条数据是否存在
- (BOOL)checkRecordExist:(NSString*)sql db:(FMDatabase *)db;
- (BOOL)checkTheDataExistOnDB:(NSString *)sql;
@end

@implementation DBOperator

+ (DBOperator *)shared
{
    static DBOperator* _operator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operator = [[DBOperator alloc] init];
    });
    return _operator;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self checkUserDatabase];
    }
    return self;
}

// 检测沙盒中是否有数据库文件，没有则从资源库拷贝到沙盒
- (void)checkUserDatabase
{
    NSString *dataBaseName = [Singleton getUserID];
    if (dataBaseName != nil)
    {
        [self checkDatabase:@"Proband.sqlite" targetName:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    }
}

- (void)checkDatabase:(NSString *)orginName targetName:(NSString *)targetName
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
        NSLog(@"文件路径为:%@",defaultDBPath);
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
    
    if (success) {
        _fmdb = [[FMDatabase alloc] initWithPath:writeDBPath];
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
        
        if (![_fmdb open]) {
            NSLog(@"open db failed.");
        }
        NSLog(@"%@", writeDBPath);
    }
    
}
//＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃基本数据库操作＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
- (NSError*)errorWithMessage:(NSString*)message {
    NSDictionary* errorMessage = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"LenovoVB10" code:1000 userInfo:errorMessage];
}
//基础数据库操作(不要直接使用，请在数据库队列中使用)
- (NSArray *)basequeryForSQL:(NSString *)sql db:(FMDatabase*)db
{
    __block NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        [array addObject:[result resultDictionary]];
    }
    
    //deal with null
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (dic in array) {
        NSArray *keys = [dic allKeys];
        
        for (NSString *key in keys) {
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:nil forKey:key];
            }
        }
    }
    return array;
}

- (NSError*)updateForSQL:(NSString *)sql db:(FMDatabase*)db
{
    BOOL success = NO;
    sql = [sql stringByReplacingOccurrencesOfString:@"'(null)'" withString:@"NULL"];
    success = [db executeUpdate:sql];
    if (!success) {
        NSLog(@"%@", db.lastError);
    }
    if ([db.lastError.localizedDescription isEqualToString:@"not an error"]) {
        return nil;
    }
    return db.lastError;
}

//查询条数据是否存在
- (BOOL)checkRecordExist:(NSString*)sql db:(FMDatabase *)db
{
    
    int count = 0;
    BOOL exist = NO;
    count = [db intForQuery:sql];
    if (count<=0) {
        exist = NO;
    }else{
        exist = YES;
    }
    return exist;
}
- (BOOL)checkTheDataExistOnDB:(NSString *)sql
{
    __block BOOL result = NO;
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        result = [self checkRecordExist:sql db:db];
    }];
    return result;
}

//＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃可直接调用的数据库接口：增删改查＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
/*********************************************数据库增操作***************/
/**
 *  插入某一条数据
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *
 *  @return error
 */
- (NSError *)insertDefaultDataToSQL:(NSString *)sql
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    __block NSError *error = 0x00;
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
            NSLog(@"~~~~exsit~~~~%@",error);
        }];
    
    return error;
}
/**
 *  插入某一条数据
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *
 *  @return error
 */
- (NSError *)insertDataToSQL:(NSString *)sql
                withExsitSql:(NSString *)sqlexsit
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
            NSLog(@"~~~~exsit~~~~%@",error);
        }];
    }else{//已经存在
        error = [self errorWithMessage:@"该条数据已经存在，不能进行插入操作!"];
        NSLog(@"~~~~~~~~%@",error);
    }
    
    return error;
}
/**
 *  插入某一条数据，若存在则更新
 *
 *  @param sql       sql 语句如：[NSString stringWithFormat:@"INSERT INTO tablename(a,b,c)VALUES('%@','%@','%@')",1,2,3]
 *  @param updateSql updateSql 语句如：[NSString stringWithFormat:@"UPDATE tablename SET a ='%@',b ='%@' where key ='%@',a,b,c]
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *
 *  @return error
 */
- (NSError *)insertDataToSQL:(NSString *)sql
                   updatesql:(NSString *)updateSql
               withExsitSql:(NSString *)sqlexsit
{
    if (self.dataOperationqueue == nil)
    {
        self.dataOperationqueue = [FMDatabaseQueue databaseQueueWithPath:self.fmdb.databasePath];
    }
    
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
         NSLog(@"不存在");
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
        }];
    }else{//已经存在，则更新
        NSLog(@"已经存在,更新");
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:updateSql db:db];
        }];
    }
    
    return error;
}
/**
 *  批处理数据的共用类
 *
 *  @param dbname     表名
 *  @param addDic     需要添加valueArray数组中字典没有的键值对（以字典形式），无需添加则设置为nil
 *  @param valueArray 需要添加valueArray数组，数组中包含的为字典类型数据
 *  @param key        关键字
 */
-(void)insertToDB:(NSString *)dbname
   withDicNeedAdd:(NSDictionary *)addDic
        withValue:(NSArray *)valueArray
          withkey:(NSString *)key
{
    
    
    if ([valueArray count] <= 0)
    {
        return;
    }
    
    if ([_fmdb open])
    {
        NSMutableArray *resultSleepArray = [NSMutableArray new];
        //NSLog(@"valueArray=%@",valueArray);
        NSString *userid=[Singleton getUserID];
        //NSLog(@"userid=%@",userid);
        for (int number = 0; number < valueArray.count; number++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[valueArray objectAtIndex:number]];
           // BOOL blean = [self checkTheDataExistOnDB:dbname withKey:key withValue:[dic objectForKey:key]];
             NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",dbname,key,[dic objectForKey:key]];
            int count=[[_fmdb stringForQuery:sql] intValue];
            NSLog(@"sql=%@",sql);
              //NSLog(@"dic=%@",dic);
            //过滤掉已经存在数据
            if (count==0)
            {
                NSMutableArray *keyArray =[NSMutableArray new];
                [keyArray addObjectsFromArray:[dic allKeys]];
               
                
                NSMutableString *keyStr = [NSMutableString new];
                [keyStr appendString:[NSString stringWithFormat:@"INSERT INTO %@ (userid,",dbname]];
                NSMutableString *valueStr = [NSMutableString new];
                [valueStr appendString:[NSString stringWithFormat:@") VALUES (%@,",userid]];
                
                NSString *sql = nil;
                for (int i=0; i<keyArray.count; i++) {
                    
                    if (i==keyArray.count -1) {
                        [keyStr appendString:[NSString stringWithFormat:@"%@",keyArray[i]]];
                        [valueStr appendString:[NSString stringWithFormat:@"'%@')",[dic objectForKey:keyArray[i]]]];
                        sql = [NSString stringWithFormat:@"%@%@",keyStr,valueStr];
                        [resultSleepArray addObject:sql];
                    }else{
                        [keyStr appendString:[NSString stringWithFormat:@"%@,",keyArray[i]]];
                        [valueStr appendString:[NSString stringWithFormat:@"'%@',",[dic objectForKey:keyArray[i]]]];
                        
                    }
                }
            }
        };
        
        //使用事务处理
        [_fmdb beginTransaction];
        for (NSString *sql in resultSleepArray)
        {
            if (![_fmdb executeUpdate:sql]) {
                NSLog(@"～～～～～～～～插入失败");
            }
            else
            {
                NSLog(@"插入成功 sql=%@",sql);
            }
        }
        [_fmdb commit];
         [_fmdb close];
        /*
        //       NSLog(@"~~~~~%@",resultSleepArray);
        //使用事务处理
        [_fmdb beginTransaction];
        @try {
            for (NSString *sql in resultSleepArray) {
                if (![_fmdb executeUpdate:sql]) {
                    NSLog(@"～～～～～～～～插入失败");
                }
            }
            
        }
        @catch (NSException *exception) {
            [_fmdb rollback];
            NSLog(@"错误信息：%@",[exception description]);
        }
        @finally {
            //最后一起提交
            [_fmdb commit];
            [_fmdb close];
        }*/
        
    }
    
}

/**********************************************数据库增操作***************/


/**********************************************数据库删除操作***************/
/**
 *  删除整个表
 *
 *  @param tableHeader 表名
 *
 *  @return NSError
 */
-(NSError *)deleteDateToSqlite:(NSString *)tableHeader
{
    __block NSError *error = 0x00;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ ",tableHeader];
    BOOL exsit = [self checkTheDataExistOnDB:sql];
    if (!exsit) {
        error = [self errorWithMessage:@"该表为空!"];
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'",tableHeader];
            error = [self updateForSQL:sql db:db];
        }];
    }
    return error;
    
}

/**
 *  删除表中符合某一条件的所有数据或某一条数据
 *
 *  @param sqlexsit  判断符合条件的数据是否存在sql语句 如：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",tableName,key,value];
 *  @param deleteSql   数据库操作语句 如[NSString stringWithFormat:@"DELETE FROM '%@' where date < '%@'",tableName,20141010];
 *
 *  @return NSError
 */

-(NSError *)deleteDataToSqlitewithSqlexsit:(NSString *)sqlexsit
                                  deleteSql:(NSString *)deleteSql
{
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        error = [self errorWithMessage:@"符合该条件的数据不存在，不能进行删除操作!"];
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:deleteSql db:db];
        }];
    }
    return error;
}
/**********************************************数据库删除操作***************/


/**********************************************数据库更新修改操作***************/
/**
 *  更新某一条数据
 *
 *  @param sqlexsit  判断该条数据是否存在sql语句：[NSString stringWithFormat:@"select count(*) from tableName where %@ = '%@'",key,value];
 *  @param sql    sql语句如：[NSString stringWithFormat:@"UPDATE tablename SET a ='%@',b ='%@' where key ='%@',a,b,value]
 *
 *  @return error
 */
- (NSError *)updateTheDataToDbWithExsitSql:sqlexsit
                       withSql:(NSString *)sql
{
    
    __block NSError *error = 0x00;
    BOOL exsit = [self checkTheDataExistOnDB:sqlexsit];
    if (!exsit) {
        error = [self errorWithMessage:@"该条数据不存在，不能进行更新操作!"];
        NSLog(@"该条数据不存在，不能进行更新操作!");
    }else{
        [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
            error = [self updateForSQL:sql db:db];
        }];
    }
    return error;
}

/**********************************************数据库更新修改操作***************/


/**********************************************数据库查询操作***************/
/**
 *  查询符合某条数据是否存在
 *
 *  @param tableName 表名
 *  @param key       关键字
 *  @param value     关键字对应的值
 *
 *  @return bool值
 */
- (BOOL)checkTheDataExistOnDB:(NSString *)tableName
                      withKey:(NSString *)key
                    withValue:(NSString *)value
{
    __block BOOL result = NO;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'",tableName,key,value];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        result = [self checkRecordExist:sql db:db];
    }];
    return result;
}


/**
 *  取出某表中所有的数据
 *
 *  @param tableName 表名
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)queryAllDataForSQL:(NSString *)tableName
{
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        array = [self basequeryForSQL:sql db:db];
    }];
    return array;
    
}
/**
 *  获取某特定条件的数据
 *
 *  @param sql sql语句如：[NSString stringWithFormat:@"select * from tablename where userid = '%@'",[Singleton getUserID]]
 *
 *  @return 返回数组类型数据
 */
- (NSArray *)getDataForSQL:(NSString *)sql
{
    NSLog(@"sql=%@",sql);
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:sql db:db];
    }];
    return array;
}

/**
 *  取出数据库中特定范围的值
 *
 *  @param tableName 表名
 *  @param key 关键字
 *  @param from      在某一个范围内的开始值
 *  @param end       在某一个范围内的结束值
 *
 *  @return 返回数组
 */
- (NSArray *)queryForSQL:(NSString *)tableName
                 keyName:(NSString *)key
                    from:(NSString *)from
                     end:(NSString *)end
{
    NSString *resultSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ BETWEEN '%@' AND '%@'",tableName,key,from,end];
    //    NSLog(@"~~~~sql:~%@",resultSql);
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:resultSql db:db];
    }];
    return array;
    
    
}
/**
 *  按升/降序取出数据库中特定范围的值
 *
 *  @param tableName 表名
 *  @param key 关键字
 *  @param from      在某一个范围内的开始值
 *  @param end       在某一个范围内的结束值
 *  @param ascField  排序类型，默认的排序顺序为升序ASC，降序为DES
 *
 *  @return 返回数组
 */
- (NSArray *)queryOrderByForSQL:(NSString *)tableName
                        keyName:(NSString *)key
                           from:(NSString *)from
                            end:(NSString *)end
                       ascField:(NSString *)ascField
{
    NSString *resultSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ BETWEEN '%@' AND '%@' ORDER BY %@",tableName,key,from,end,ascField];
    __block  NSArray *array = [NSMutableArray array];
    [self.dataOperationqueue inDatabase:^(FMDatabase *db) {
        array = [self basequeryForSQL:resultSql db:db];
    }];
    return array;
    
    
}

/**
 *  从指定的数据库中取某个特定字段的数据
 *
 *  @param tableName      表头
 *  @param fieldNameArray 表中的所有字段数组
 *  @param key            关键字
 *  @param value          关键字对应的value
 *
 *  @return 取出的一条数据，以键值对的形式放入字典中。
 */

-(NSDictionary *)getDataFromDataBaseName:(NSString *)tableName
                          fieldNameArray:(NSArray *)fieldNameArray
                             checkoutKey:(NSString *)key
                           CheckOutValue:(NSString *)value
{
    if ([fieldNameArray count] <= 0)
    {
        return nil;
    }
    NSDictionary *resultDic = [NSDictionary new];
    if ([_fmdb open])
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",tableName,key,value];
        FMResultSet *set = [_fmdb executeQuery:sql];
        NSInteger i = 0;
        while ([set next])
        {
            [resultDic setValue:[set stringForColumn:[fieldNameArray objectAtIndex:i]] forKey:[fieldNameArray objectAtIndex:i]];
            i++;
        }
    }
    
    return resultDic;
}

//批量向表中插入数据:首先构造插入语句，最后批量提交,by Star
- (void)insertArrayToDB:(NSString *)tableName withValue:(NSArray *)valueArray
{
    if ([_fmdb open])
    {
        //存储数据库语句的数组
        NSMutableArray *sqlArray = [NSMutableArray array];
        for (NSDictionary *dic in valueArray)
        {
            NSArray *keyArray = [dic allKeys];
            NSArray *valueArray = [dic allValues];
            NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
            for (int i = 0; i < keyArray.count; i ++)
            {
                if (i < keyArray.count-1)
                {
                    [insertSql appendFormat:@"%@,",keyArray[i]];
                }
                else
                {
                    [insertSql appendFormat:@"%@) ",keyArray[i]];
                }
            }
            [insertSql appendString:@"VALUES("];
            for (int i = 0; i < valueArray.count; i ++)
            {
                if (i < valueArray.count-1)
                {
                    [insertSql appendFormat:@"'%@',",valueArray[i]];
                }
                else
                {
                    [insertSql appendFormat:@"'%@')",valueArray[i]];
                }
            }
            //NSLog(@"插入语句：%@",insertSql);
            [sqlArray addObject:insertSql];
        }
        //使用事务处理
        [_fmdb beginTransaction];
        for (NSString *sql in sqlArray)
        {
            if (![_fmdb executeUpdate:sql])
            {
                NSLog(@"~~~~~事务插入失败");
            }
//            else
//            {
//                NSLog(@"插入成功");
//            }
        }
        [_fmdb commit];
        [_fmdb close];
    }

}

//执行事务语句:数组元素为sql语句,保证插入数组不为空
- (void)insertDataArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray
{
    if ([_fmdb open])
    {
        [_fmdb beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < dataArray.count; i ++)
            {
                NSDictionary *dic = dataArray[i];
                NSArray *keyArray = [dic allKeys];
                NSArray *valueArray = [dic allValues];
                NSMutableString *insertSql = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName];
                for (int i = 0; i < keyArray.count; i ++)
                {
                    if (i < keyArray.count-1)
                    {
                        [insertSql appendFormat:@"%@,",keyArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"%@) ",keyArray[i]];
                    }
                }
                [insertSql appendString:@"VALUES("];
                for (int i = 0; i < valueArray.count; i ++)
                {
                    if (i < valueArray.count-1)
                    {
                        [insertSql appendFormat:@"'%@',",valueArray[i]];
                    }
                    else
                    {
                        [insertSql appendFormat:@"'%@')",valueArray[i]];
                    }
                }

                BOOL a = [_fmdb executeUpdate:insertSql];
                if (!a) {
                    NSLog(@"插入失败1");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_fmdb rollback];
        }
        @finally {
            if (!isRollBack) {
                [_fmdb commit];
            }
        }
        [_fmdb close];
    }
}
- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)dic
{
    NSArray *array = [NSArray arrayWithObject:dic];
    [self insertDataArrayToDB:tableName withDataArray:array];
}
- (void)createDataBaseTable:(NSString*)tableName propertyAndType:(NSString*)property
{
    if ([self.fmdb open])
    {
        /**
         *  判断表是否存在,如果不存在，就创建表
         */
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName ];
        FMResultSet *rs = [self.fmdb executeQuery:existsSql];
        if ([rs next]) {
            
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", (long)count);
            if (count == 1) {
                NSLog(@"log_keepers table is existed.");
                return;
            }
            
            NSString *table = [NSString stringWithFormat:@"CREATE TABLE  %@ (%@)",tableName,property];
            BOOL ok = [self.fmdb executeUpdate:table];
            if (ok) {
                NSLog(@"ok");
            }
        }
        [rs close];
    }
    [self.fmdb close];
}
@end