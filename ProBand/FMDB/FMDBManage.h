//
//  FMDBManage.h
//  FMDBManage
//
//  Created by attack on 15/6/24.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDBDataDelegate.h"
@interface FMDBManage : NSObject
@property (nonatomic,assign)id<FMDBDataDelegate>delegate;
+(FMDBManage*)shareFMDBManage;
/**
 *  创建数据库表
 *
 *  @param tableName 要创建的表名
 *  @param valueArray       要创建的表的内容，以数组形式传入格式为@[属性名 属性类型，属性名 属性类型，属性名 属性类型.......]，属性类型TEXT、INTEGER、DATA、BOOL
 */
- (void)createDataBaseTable:(NSString*)tableName propertyAndType:(NSString*)property;
/**
 *  插入数据
 *
 *  @param tableName 需要插入数据的表名
 *  @param dic       需要插入的数据，以字典形式key:value传参
 */
- (void)insertDataFromTable:(NSString*)tableName insertValueDic:(NSDictionary*)dic;
/**
 *  更新数据
 *
 *  @param tableName 所要更新的表数据
 *  @param updataDic 需要更新的数据，以字典形式key:value传参
 */
- (void)upDataFromTable:(NSString*)tableName updataValue:(NSDictionary*)updataDic;
/**
 *  删除数据
 *
 *  @param tableName 所要删除数据的表名
 *  @param key       所要删除的字段
 *  @param value     所要删除字段的值
 */
- (void)deleteDataFromTable:(NSString*)tableName deleteKey:(NSString*)key deleteValue:(NSString*)value;
/**
 *  查询表中数据
 *
 *  @param tableName 所要查询的表名
 *
 *  @return 返回一个数组信息
 */
- (void)selectDataFromtable:(NSString*)tableName;

//添加by Star
- (NSMutableArray *)getDataFromtable:(NSString*)tableName;

@end

