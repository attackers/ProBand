#import <Foundation/Foundation.h> 
#import "sleepDate_deviceid_Model.h"
@interface sleepDate_deviceidManage : NSObject
{
    
}

+(NSArray *)getUnUploadPageList:(int)pageId;
+(int)updateFlag:(NSString *)Flag  byId:(NSString *)Id;
+(NSString *)getTotalSleepByUserId:(NSString *)UserId date:(NSString *)date;
+(sleepDate_deviceid_Model *)getModelByUserId:(NSString *)UserId date:(NSString *)date;
+(NSDictionary *)getDictionaryById:(NSString *)Id;
+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+(int)updateUserId:(NSString *)Id date:(NSString *)date sleeps:(NSString *)sleeps lightTime:(NSString *)lightTime deepTime:(NSString *)deepTime wakeTime:(NSString *)wakeTime quality:(NSString *)quality totalSleep:(NSString *)totalSleep;
+ (long long)adduserId:(NSString *)userId date:(NSString *)date sleeps:(NSString *)sleeps lightTime:(NSString *)lightTime deepTime:(NSString *)deepTime wakeTime:(NSString *)wakeTime quality:(NSString *)quality totalSleep:(NSString *)totalSleep ;

///新加的方法
+(NSArray *)getAllSleepInfoByuserId:(NSString *)userID;

+(void)insertSleepDetailInfo:(sleepDate_deviceid_Model *)sleepObj;



@end