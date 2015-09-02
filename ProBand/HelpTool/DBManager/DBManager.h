//
//  DBManager.h
//  DBTest
//
//  Created by star.zxc on 15/8/24.
//  Copyright (c) 2015年 star.zxc. All rights reserved.
//该类旨在提供数据操作的更直观的接口，避免使用数据库语句

#import <Foundation/Foundation.h>
 
@interface DBManager : NSObject

#define DBMANAGER [DBManager shared]
+ (DBManager *)shared;

//插入单条数据
- (void)insertSingleDataToDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary;

//批量插入数据
- (void)insertArrayToDB:(NSString *)tableName withDataArray:(NSArray *)dataArray;

//更新某一条数据：若不存在则不能更新,同时需要一对键值
- (void)updateDataOnDB:(NSString *)tableName withDictionary:(NSDictionary *)aDictionary withKey:(NSString *)key withValue:(NSString *)value;

//取出表中所有数据
- (NSArray *)allDataFromDB:(NSString *)tableName;

//取出符合某个键值的数据：如果有进一步的要求请直接使用DBOperator类
- (NSArray *)dataFromDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;

//删除某个表
- (void)deleteTable:(NSString *)tableName;

//删除符合某个键值的数据
- (void)deleteDataFromTable:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;

//查询某数据是否存在
- (BOOL)checkDataExistOnDB:(NSString *)tableName withKey:(NSString *)key withValue:(NSString *)value;

//创建新的表：表字段类型全部为TEXT
- (void)createNewTable:(NSString *)tableName withKeyArray:(NSArray *)keyArray;
@end
