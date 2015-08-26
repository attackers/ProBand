#import <Foundation/Foundation.h>
#import "original_data_Model.h"
@interface original_dataManage : NSObject {
}

//1 是睡眠数据 0是跑步数据
+(NSArray *)getUnSaveDateArray:(NSString *)userid;
+(original_data_Model *)getModelById:(NSString *)Id;
+(NSDictionary *)getDictionaryById:(NSString *)Id;
+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(int)updateAllFlag;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageListByDate:(NSString *)Date;
+(NSArray *)getAllStepData;
+(NSArray *)getAllSleepData;
+(NSArray *)getModelArrayBySQL:(NSString *)sql;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
//按照3分钟一条数据，初始化一个字典
+(NSMutableArray *)getInitDictionaryByDate:(NSString *)date;
//按照3分钟一条数据，初始化一个字典
+(NSMutableArray *)getInitDictionary;
+ (int) countByDate:(NSString *)date;
+ (int)removeAllSleepData;
+ (int)removeAllStepData;
+ (int)removeByDate:(NSString *)date;
+ (int)removeAllData;
+ (int)removeNull;
+(void)addTestData;

//根据每周统计步数 type 0是跑步 1是睡眠
+(NSString *)getTotalWeekStepByYear:(NSString *)year   type:(NSString *)type;
//按月份统计跑步数据 type 0是跑步 1是睡眠
+(NSMutableDictionary *)getMonthStepByYear:(NSString *)year  type:(NSString *)type;
//按年统计跑步数据 type 0是跑步 1是睡眠
+(NSMutableDictionary *)getYearStepByType:(NSString *)type;
//按天统计跑步数据 type 0是跑步 1是睡眠
+(NSMutableDictionary *)getDayStepByYear:(NSString *)year  type:(NSString *)type;

//统计某天每4个小时 跑步睡眠数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getEveryFourHoursCountByType:(NSString *)type Date:(NSString *)Date;
//按日期类型统计跑步时间 卡路里 距离  type 0是跑步 1是睡眠
+(NSArray *)getCaloriesDistanceMinuteByType:(NSString *)type dateFormatType:(NSString *)dateFormatType  fromDate:(NSString *)fromDate toDate:(NSString *)toDate;
//日期类型统计深睡 浅睡 清醒 数据
+(NSMutableDictionary *)getSleepCategoryByDateFormatType:(NSString *)dateFormatType  fromDate:(NSString *)fromDate toDate:(NSString *)toDate;
//按日期类型统计跑步睡眠数据  type 0是跑步 1是睡眠
+(NSMutableDictionary *)getTotalCountByType:(NSString *)type dateFormatType:(NSString *)dateFormatType  fromDate:(NSString *)fromDate toDate:(NSString *)toDate;

//根据日期获取当天的卡路里消耗
+(float)getCaloriesByDate:(NSString *)Date;
//获取所有日期 天
+(NSArray *)getAllDateArray:(NSString *)userid;
+(NSString *)getTodayStep;
//根据日期获取总步数
+(NSString *)getTotalStepByDay:(NSString *)day;
//根据日期获取总运动时间
+(NSString *)getTotalSportTimeByDay:(NSString *)day;
//根据日期获取距离卡路里和运动时间
+(NSString *)getDistanceCalorieMinutesByDay:(NSString *)day;
//根据日期获取睡眠总时间
+(NSString *)getTotalSleepTimeByDay:(NSString *)day;
//根据日期获取睡眠总时间
+(NSString *)getTotalSleepTimeByDay:(NSString *)day;
//根据日期获取深睡浅睡和清醒时间
+(NSString *)getSleepCategoryTimeByDay:(NSString *)day;

+ (int)updateId:(NSString *)Id userId:(NSString *)userId date:(NSString *)date count:(NSString *)count type:(NSString *)type time:(NSString *)time ;
+ (long)adduserId:(NSString *)userId date:(NSString *)date count:(NSString *)count type:(NSString *)type time:(NSString *)time MacAddress:(NSString *)MacAddress  OriginalHEX:(NSString *)OriginalHEX  Flag:(NSString *)Flag;
+(void)insertWithArray:(NSArray *)valueArray;
+(NSArray *)getPageList:(int)pageId type:(NSString *)types;
+(NSArray *)getSleepPageList:(int)pageId;
+(NSArray *)getStepPageList:(int)pageId;

@end