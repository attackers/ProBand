//
//  FMDBTool.h
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBManage.h"
@interface FMDBTool : NSObject<FMDBDataDelegate>

SINGLETON
/**
 *  创建默认的数据库和表
 */
- (void)createDefaultTable;
/**
 *  添加测试数据：一年的？
 */
- (void)addTestData;

- (void)addDailyTestData;

- (void)addAllTestData;
@end
