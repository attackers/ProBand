#import <Foundation/Foundation.h> 
#import "alarm_Model.h"
@interface alarmManage : NSObject

+ (alarm_Model *)getModelById:(NSString *)Id;

+ (NSDictionary *)getDictionaryById:(NSString *)Id;

+ (NSArray *)findBySql:(NSString *)sql;

+ (NSArray *)findAll;

+ (id)find:(NSString *)title;

+ (int)count;

+ (NSArray *)getPageList:(int)pageId;

+ (int)remove:(NSString *)ID;

+ (int)getMaxId;

+ (int)updateId:(NSString *)Id userId:(NSString *)userId AlarmId:(NSString *)AlarmId startTime:(NSString *)startTime repeat:(NSString *)repeat name:(NSString *)name interval:(NSString *)interval status:(NSString *)status;

+ (int)addDataToDB:(alarm_Model *)model;

+ (int)adduserId:(NSString *)userId AlarmId:(NSString *)AlarmId startTime:(NSString *)startTime repeat:(NSString *)repeat name:(NSString *)name interval:(NSString *)interval status:(NSString *)status;

+ (int)updateModel:(alarm_Model *)model ByModelId:(NSString *)Id;

+ (int)getLastAlarmId;
@end
