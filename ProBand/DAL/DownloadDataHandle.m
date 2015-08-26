//
//  DownloadDataHandle.m
//  LenovoVB10
//
//  Created by Echo on 15/6/15.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DownloadDataHandle.h"
#import "StepDataDeviceidManager.h"
#import "SleepDataDeviceidManager.h"

@interface DownloadDataHandle ()
{
    NSMutableArray *stepDateArr;
    NSMutableArray *stepDetailArr;
    NSMutableArray *sleepDateArr;
    NSMutableArray *sleepDetailArr;
    int stepPage;
    int stepDetailPage;
    int sleepPage;
    int sleepDetailPage;
}
@end

@implementation DownloadDataHandle

- (void)getStepDataInsertToDB
{
    if(![PublicFunction isConnect]) return;
    
    NSString *curentDate = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:YES];
    stepPage = 1;
    if ([StepDataDeviceidManager count] == 0) {
        NSLog(@"%d", [StepDataDeviceidManager count]);
        [self getStepDataWithpage:stepPage withDate:curentDate];
    }
    stepDetailPage = 1;
   [self getStepDetailDataWithpage:stepDetailPage withDate:curentDate];
    
}
- (void)getSleepDataInsertToDB
{
    if(![PublicFunction isConnect]) return;
    
    NSString *curentDate = [DateHandle getCurentDateByType:@"yyyy-MM-dd" withUTC:YES];
    
    sleepPage = 1;
    if ([SleepDataDeviceidManager count] == 0) {
        NSLog(@"%d", [SleepDataDeviceidManager count]);
        [self getSleepDataWithpage:sleepPage withDate:curentDate];
    }
    
    sleepDetailPage = 1;
    [self getSleepDetailDataWithpage:sleepDetailPage withDate:curentDate];
}

- (void)getStepDataWithpage:(int)page withDate:(NSString *)curentDate
{
    [NetWorkManage getSportDataFromDateBegin:@"2015-01-01" andDateEnd:curentDate withPage:page WithBlock:^(BOOL success, id result) {
        if (!result) return;
        NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"retcode"] intValue]== 10000) {
            if ([dic objectForKey:@"retstring"]) {
                stepDateArr = [NSJSONSerialization JSONObjectWithData:[dic[@"retstring"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"~~~~stepDateArr~~~~~%@",stepDateArr);
                if ([stepDateArr count] == 100){
                    stepPage++;
                    [self getStepDataWithpage:stepPage withDate:curentDate];
                }
                [StepDataDeviceidManager insertWithStepDateArray:stepDateArr withFlag:@"1"];
                [stepDateArr removeAllObjects];
            }
        }
    }];
}

- (void)getStepDetailDataWithpage:(int)page withDate:(NSString *)date
{
    [NetWorkManage getSportDetailFromDateBegin:@"2015-01-01" andDateEnd:date withPage:page WithBlock:^(BOOL success, id result) {
        if (result){
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"retcode"] intValue]== 10000) {
                if ([dic objectForKey:@"retstring"]) {
                    stepDetailArr = [NSJSONSerialization JSONObjectWithData:[dic[@"retstring"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@------000---",stepDetailArr);
                    if ([stepDetailArr count] == 100){
                        stepDetailPage++;
                        [self getStepDetailDataWithpage:stepDetailPage withDate:date];
                    }
                    [StepDataDeviceidManager updateWithStepDetailArray:stepDetailArr];
                    [stepDetailArr removeAllObjects];
                }
            }
        }
        
    }];
}

- (void)getSleepDataWithpage:(int)page withDate:(NSString *)date
{
    [NetWorkManage getSleepDataFromDateBegin:@"2015-01-01" andDateEnd:date withPage:page WithBlock:^(BOOL success, id result) {
        if (result) {
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"retcode"] intValue]== 10000) {
                if ([dic objectForKey:@"retstring"]) {
                    sleepDateArr = [NSJSONSerialization JSONObjectWithData:[dic[@"retstring"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    if ([sleepDateArr count] == 100){
                        sleepPage++;
                        [self getSleepDataWithpage:sleepPage withDate:date];
                    }
                    [SleepDataDeviceidManager insertWithSleepDateArray:sleepDateArr withFlag:@"1"];
                    [sleepDateArr removeAllObjects];
                }
            }
        }
    }];
}

- (void)getSleepDetailDataWithpage:(int)page withDate:(NSString *)date
{
    [NetWorkManage getSleepDetailFromDateBegin:@"2015-01-01" andDateEnd:date withPage:page WithBlock:^(BOOL success, id result) {
        if (result){
            NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"retcode"] intValue]== 10000) {
                if ([dic objectForKey:@"retstring"]) {
                    sleepDetailArr = [NSJSONSerialization JSONObjectWithData:[dic[@"retstring"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    if ([sleepDetailArr count] == 100){
                        sleepDetailPage++;
                        [self getSleepDetailDataWithpage:sleepDetailPage withDate:date];
                    }
                    [SleepDataDeviceidManager updateWithSleepDetailArray:sleepDetailArr];
                    [sleepDetailArr removeAllObjects];
                }
            }
        }
    }];
}

@end
