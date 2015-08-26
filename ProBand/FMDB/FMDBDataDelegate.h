//
//  FMDBDataDelegate.h
//  FMDBManage
//
//  Created by attack on 15/6/25.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@protocol FMDBDataDelegate <NSObject>
/**
 *  用于数据库查询传值
 *
 *  @param fSet 参数为FMDB返回值原型
 */
- (void)requestDelegateData:(NSMutableArray*)fSetArray;
@end
