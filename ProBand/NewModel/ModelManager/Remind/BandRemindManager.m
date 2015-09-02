//
//  BandRemindManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BandRemindManager.h"

@implementation BandRemindManager
SINGLETON_SYNTHE

//只能插入一次
- (void)insertDefaultSwitch
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hasInsertDefaultRemind"]==nil) {
        NSMutableArray *switcharray = [NSMutableArray array];
        for (int i = 1; i <10; i ++)//9个开关
        {
            NSDictionary *dic = @{@"event":[NSString stringWithFormat:@"%d",i],
                                  @"state":@"1",
                                  @"userid":[Singleton getUserID],
                                  @"mac":[Singleton getMacSite]};
            [switcharray addObject:dic];
        }
        [DBOPERATOR insertDataArrayToDB:SettingInfoTable withDataArray:switcharray];
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"hasInsertDefaultRemind"];
    }
}

- (void)updateStateWithIndex:(int)switchIndex
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where event = '%d'",SettingInfoTable,switchIndex];
    NSArray *array = [DBOPERATOR getDataForSQL:sql];
    NSDictionary *dic = array[0];
    if (dic && [dic[@"state"] intValue]>0)//如果是开的
    {
        NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where event = '%d'",SettingInfoTable,switchIndex];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET state='%@',userid='%@',mac='%@' where event = '%d'",SettingInfoTable,@"0",[Singleton getUserID],[Singleton getMacSite],switchIndex];
        [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
    }
    else if (dic && [dic[@"state"] intValue]==0)
    {
        NSString *sqlexist = [NSString stringWithFormat:@"select count(*) from %@ where event = '%d'",SettingInfoTable,switchIndex];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET state='%@',userid='%@',mac='%@' where event = '%d'",SettingInfoTable,@"1",[Singleton getUserID],[Singleton getMacSite],switchIndex];
        [DBOPERATOR updateTheDataToDbWithExsitSql:sqlexist withSql:updateSql];
    }
}

+ (NSArray *)switchArrayForBandRemind
{
    //转化为BOOL值的数组
    NSArray *array = [DBOPERATOR queryAllDataForSQL:SettingInfoTable];
    NSMutableArray *boolArray = [NSMutableArray array];
    for (int i = 1; i < 10; i ++)
    {
        for (NSDictionary *dic in array)
        {
            int event = [dic[@"event"] intValue];
            if (event==i)
            {
                if ([dic[@"state"] isEqualToString:@"1"])
                {
                    [boolArray addObject:[NSNumber numberWithBool:YES]];
                }
                else
                {
                    [boolArray addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }
    }
    return boolArray;
}
@end
