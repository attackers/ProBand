//
//  FMDBTool.m
//  ProBand
//
//  Created by star.zxc on 15/6/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DataBase.h"
#import "SleepDataManager.h"
#import "DailyDataManager.h"
#import "ExerciseDataManager.h"
@implementation FMDBTool
{
    FMDBManage *manager;
}
SINGLETON_SYNTHE

- (id)init
{
    self= [super init];
    if (self) {
        manager = [FMDBManage shareFMDBManage];
        manager.delegate = self;
    }
    return self;
}
- (void)createDefaultTable
{
    [self createUserInfoTable];
    [self createSettingTable];
    [self createStepDataTable];
    [self createExerciseTable];
    [self createSleepDataTable];
    [self createAlarmTable];
}
/**
 *  下面的方法分别创建各个表
 */
//创建个人信息的表
- (void)createUserInfoTable
{
    [manager createDataBaseTable:UserInfoTable propertyAndType:@"userid text,username text,age int,gender int,height int,weight int,mac text,keys text"];
}
//创建设置信息的表
- (void)createSettingTable
{
    [manager createDataBaseTable:SettingInfoTable propertyAndType:@"event int,state int,mac text,keys text"];
}
//创建计步数据的表
- (void)createStepDataTable
{
    [manager createDataBaseTable:StepDataTable propertyAndType:@"mac text,time int,steps int,meters int,kCalories float,isUpload int,keys text"];
}
//创建训练数据的表
- (void)createExerciseTable
{
    [manager createDataBaseTable:ExerciseDataTable propertyAndType:@"mac text,time int,exercise int,steps int,meters int,kCalories float,isUpload int,keys text"];
}
//创建睡眠数据的方法
- (void)createSleepDataTable
{
    [manager createDataBaseTable:SleepDataTable propertyAndType:@"mac text,time int,sleeps int,isUpload int,keys text"];
}
//创建闹钟的表
- (void)createAlarmTable
{
    [manager createDataBaseTable:AlarmTable propertyAndType:@"mac text,id int,from_device int,startTimeMinute int,days_of_week int,interval_time int,notification text,switch int,keys text"];
}

//向数据库插入测试数据:首先测试睡眠
- (void)addTestData
{
    //测试时间
    NSDate *tmpStart = [NSDate date];
        [self addOneDayDataWithYear:2014 dayIndex:1];

    [self addDailyTestData];
    NSLog(@"添加测试数据完毕");
    
    //插入单条数据
    NSDictionary *sleepData = @{@"mac":@"100.100.100.100",@"time":@13329,@"sleeps":@13443,@"isUpload":@1};
    [[FMDBManage shareFMDBManage]insertDataFromTable:SleepDataTable insertValueDic:sleepData];
    
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入一个月测试数据花费时间%fms",deltaTime*1000);
}
//添加某年中某天的测试数据：dayIndex为0-364（判断是否闰年）
- (void)addOneDayDataWithYear:(NSInteger)year dayIndex:(NSInteger)dayIndex
{
    //获取该天开始时刻的时间戳
    long timeStamp = (year - 1970)*365*24*60*60+24*60*60*dayIndex;
    NSMutableArray *insertArray = [NSMutableArray array];
    //每天480个点
    for (int i = 0; i < 480; i ++)
    {
        long currentTimeStamp = timeStamp+3*60*i;
        //存到数据库是否会有问题
        int sleepData = arc4random()%3;
        NSDictionary *dic = @{@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:currentTimeStamp],@"sleeps":[NSNumber numberWithInt:sleepData],@"isUpload":[NSNumber numberWithInt:0]};
        [insertArray addObject:dic];
        //[manager insertDataFromTable:SleepDataTable insertValueDic:dic];
    }
    [DBOPERATOR insertArrayToDB:SleepDataTable withValue:insertArray];
}

- (void)addDailyTestData
{
    NSMutableArray *insertArray = [NSMutableArray array];
    //直接插入一年的数据
//    for (int i = 0; i<12; i++)
//    {
       for (int j = 0; j < 30; j ++)
        {
            for (int k = 0; k < 480; k ++)
            {
                long timeSleep = (2014-1970)*365*24*60*60+60*60*24*30*1+60*60*24*1+60*3*k;
                int stepData = arc4random()%180;
                NSDictionary *dailyDic = @{@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:timeSleep],@"steps":[NSNumber numberWithInt:stepData],@"meters":[NSNumber numberWithInt:(int)stepData*0.7],@"kCalories":[NSNumber numberWithFloat:stepData*1.23],@"isUpload":[NSNumber numberWithInt:0]};
                [insertArray addObject:dailyDic];
            }
       }
    //}
    [DBOPERATOR insertArrayToDB:StepDataTable withValue:insertArray];
}
//需要保证只插入一次
- (void)addAllTestData
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:HAS_INSERT_DATA];
    if (str && str.length > 0)
    {
        return;
    }
        [self insertStepTestData];
        [self insertSleepTestData];
        [self insertExerciseTestData];
        [self collectStepData];
        [self collectSleepData];
        [self collectExerciseData];
    [[NSUserDefaults standardUserDefaults]setObject:@"hasInsertData" forKey:HAS_INSERT_DATA];
}

- (void)collectStepData
{
    NSDate *tmpStart = [NSDate date];
    [DailyDataManager collectAllDailyData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"计步数据汇总时间为%fms",deltaTime*1000);
}
- (void)insertStepTestData
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970];
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 45000; i ++)
    {
        NSDictionary *stepDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+60*i],@"steps":[NSNumber numberWithInt:arc4random()%180],@"meters":[NSNumber numberWithInt:(int)180*0.7],@"kCalories":[NSNumber numberWithFloat:arc4random()%150],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:stepDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:StepDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
}
//exercise属性表示快跑，慢跑，静止等,汇总数据时需要注意
- (void)insertExerciseTestData
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起:一分钟一条
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970]
    ;
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 45000; i ++)
    {
        NSDictionary *exerciseDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+60*i],@"steps":[NSNumber numberWithInt:arc4random()%180],@"exercise":[NSNumber numberWithInt:arc4random()%3+1],@"meters":[NSNumber numberWithInt:(int)180*0.7],@"kCalories":[NSNumber numberWithFloat:arc4random()%150],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:exerciseDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:ExerciseDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
}

- (void)collectExerciseData
{
    NSDate *tmpStart = [NSDate date];
    [ExerciseDataManager collectAllExerciseData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"计步数据汇总时间为%fms",deltaTime*1000);
}

//插入睡眠数据
- (void)insertSleepTestData
{
    //批量插入数据:插入15000条作为一个月的模拟数据,从2015年4月1日起
    NSDate *date = [DateHandle stringToDate:@"2015-04-01" withtype:2];
    NSTimeInterval second = [date timeIntervalSince1970];
    NSMutableArray *stepDataArray = [NSMutableArray array];
    for (int i = 0; i < 45000; i ++)
    {
        //睡眠数据为0，1，2，3，0表示没有数据
        NSDictionary *exerciseDataDic = @{@"userid":[Singleton getUserID],@"mac":[Singleton getMacSite],@"time":[NSNumber numberWithLong:second+60*i],@"sleeps":[NSNumber numberWithInt:arc4random()%4],@"isRead":[NSNumber numberWithInt:0]};
        [stepDataArray addObject:exerciseDataDic];
    }
    //除去添加数据的时间
    //测试插入15000条数据的时间：约5秒,15000条数据能否缩减到1s内？0.6s?
    NSDate *tmpStart = [NSDate date];
    [DBOPERATOR insertDataArrayToDB:SleepDataTable withDataArray:stepDataArray];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    NSLog(@"插入时间为%fms",deltaTime*1000);
}

- (void)collectSleepData
{
    NSDate *tmpStart = [NSDate date];
    [SleepDataManager collectAllSleepData];
    double deltaTime = [[NSDate date]timeIntervalSinceDate:tmpStart];
    //汇总时间太久，能否加快？20s
    NSLog(@"睡眠数据汇总时间为%fms",deltaTime*1000);
}

@end
