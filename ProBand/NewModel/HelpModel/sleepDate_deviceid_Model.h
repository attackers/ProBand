#import <Foundation/Foundation.h> 
@interface sleepDate_deviceid_Model : NSObject 
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *sleeps;
@property (nonatomic, strong) NSString *lightTime;
@property (nonatomic, strong) NSString *deepTime;
@property (nonatomic, strong) NSString *wakeTime;
@property (nonatomic, strong) NSString *quality;
@property (nonatomic, strong) NSString *totalSleep;

/**
 *  添加数据映射，方便初始化
 *
 *  @param aDictionary 需要初始化的字典参数
 *
 *  @return 初始化好的model
 */

+(sleepDate_deviceid_Model *)convertDataToModel:(NSDictionary *)aDictionary;
@end