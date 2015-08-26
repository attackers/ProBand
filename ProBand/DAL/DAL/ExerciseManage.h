#import <Foundation/Foundation.h> 
#import "Exercise_Model.h"
@interface ExerciseManage : NSObject {
}
+(Exercise_Model *)getModelById:(NSString *)Id;+(NSDictionary *)getDictionaryById:(NSString *)Id;+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+ (int)updateId:(NSString *)Id StartTime:(NSString *)StartTime StopTime:(NSString *)StopTime Step:(NSString *)Step Distance:(NSString *)Distance Calories:(NSString *)Calories Speed:(NSString *)Speed AddTime:(NSString *)AddTime UserId:(NSString *)UserId Flag:(NSString *)Flag ;
+ (long long)addStartTime:(NSString *)StartTime StopTime:(NSString *)StopTime Step:(NSString *)Step Distance:(NSString *)Distance Calories:(NSString *)Calories Speed:(NSString *)Speed AddTime:(NSString *)AddTime UserId:(NSString *)UserId Flag:(NSString *)Flag ;
@end