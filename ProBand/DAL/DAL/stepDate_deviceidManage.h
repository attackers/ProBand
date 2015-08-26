#import <Foundation/Foundation.h> 
#import "stepDate_deviceid_Model.h"
@interface stepDate_deviceidManage : NSObject {
}


+(NSArray *)getUnUploadPageList:(int)pageId;
+(int)updateFlag:(NSString *)Flag  byId:(NSString *)Id;
+(NSString *)getTotalStepByUserId:(NSString *)UserId date:(NSString *)date;
+(stepDate_deviceid_Model *)getModelById:(NSString *)Id;
+(NSDictionary *)getDictionaryById:(NSString *)Id;
+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(stepDate_deviceid_Model *)getModelByDate:(NSString *)Date;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+ (int)updateId:(NSString *)Id userId:(NSString *)userId mac:(NSString *)mac date:(NSString *)date steps:(NSString *)steps meters:(NSString *)meters calories:(NSString *)calories totalSteps:(NSString *)totalSteps totalDistance:(NSString *)totalDistance totalCalories:(NSString *)totalCalories sportDuration:(NSString *)sportDuration ;
+ (int)adduserId:(NSString *)userId mac:(NSString *)mac date:(NSString *)date steps:(NSString *)steps meters:(NSString *)meters calories:(NSString *)calories totalSteps:(NSString *)totalSteps totalDistance:(NSString *)totalDistance totalCalories:(NSString *)totalCalories sportDuration:(NSString *)sportDuration ;
/**************************************************************************************************/
/**
 *  从记步统计表中获取所有的记步数据
 *
 *  @param userID 用户ID
 *
 *  @return 返回所有的记步数据
 */
+(NSArray *)getAllStepDataWithUserID:(NSString *)userID;


@end