#import <Foundation/Foundation.h> 
#import "UserTargetModel.h"
@interface targetInfoManage : NSObject {
}
+(UserTargetModel *)getModelById:(NSString *)Id;
+(NSDictionary *)getDictionaryById:(NSString *)Id;+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+ (int)updateId:(NSString *)Id userid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget botherStart:(NSString *)botherStart botherEnd:(NSString *)botherEnd botherStatus:(NSString *)botherStatus ;

+ (int)adduserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget botherStart:(NSString *)botherStart botherEnd:(NSString *)botherEnd botherStatus:(NSString *)botherStatus ;
+(int)saveStepTarget:(NSString *)stepTarget  startTime :(NSString *)startTime   userid:(NSString *)userid;
/**
 *  以下两个方法添加by Star，用于修改数据库中用户目标的数据（如果数据不存在则需要添加该数据）
 *
 */
+ (BOOL)updateUserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget;
+ (BOOL)addUserid:(NSString *)userid stepTarget:(NSString *)stepTarget startTime:(NSString *)startTime endTime:(NSString *)endTime sleepTarget:(NSString *)sleepTarget;

//获取睡眠目标
+(NSString *)getSleepTargetByUserId:(NSString *)UserId date:(NSString *)date;
//获取运动目标
+(NSString *)getStepTargetByUserId:(NSString *)UserId date:(NSString *)date;

//解析从服务器拉回来的用户信息的json数据
+(UserTargetModel *)ParserSeverInfo:(id)result;

@end