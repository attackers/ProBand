//
//  DataBase.h
//  BookManage
//
//  Created by WangChao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <PlausibleDatabase/PlausibleDatabase.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#define GetDataBase [DataBase setup]
@interface DataBase : NSObject {

}
+(void)updateTable;
+ (FMDatabase *)setup;
+(NSString *)getCurDateTime;
+(NSString *)getCurDate;

/*
 
 CREATE TABLE t_alarm (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text,
 AlarmId text,
 startTime DATETIME,
 repeat text,
 name text,
 interval text,
 status text
 );
 
 CREATE TABLE t_original_data (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text,
 date  DATETIME,
 count text DEFAULT(null),
 type text,
 time  DATETIME
 );
 
 CREATE TABLE t_settingInfo (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text,
 smsStatus text,
 callState text DEFAULT(null),
 weatherState text,
 wecatState text,
 photoState text,
 masterSwitch text,
 setLock text,
 findphoneState text
 );
 
 CREATE TABLE t_sleepDate_deviceid (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text DEFAULT(null),
 date text,
 sleeps text,
 lightTime text,
 deepTime text,
 wakeTime text,
 quality text,
 totalSleep text
 );
 
 CREATE TABLE t_stepDate_deviceid (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text,
 mac text,
 date text,
 steps text,
 meters text,
 calories text,
 totalSteps text,
 totalDistance text,
 totalCalories text,
 sportDuration text
 );
 CREATE TABLE t_targetInfo (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userid text,
 stepTarget text,
 startTime  DATETIME,
 endTime  DATETIME,
 sleepTarget text,
 botherStart text,
 botherEnd text,
 botherStatus text
 );
 
 CREATE TABLE t_userInfo (
 "Id"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
 userId text,
 userName text,
 height text,
 weight text,
 gender text,
 birthDay  DATETIME,
 imageUrl text,
 weightUnit text,
 heightUnit text
 );

 
 
 
 
 */

@end
