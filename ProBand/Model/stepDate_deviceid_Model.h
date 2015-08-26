#import <Foundation/Foundation.h> 
@interface stepDate_deviceid_Model : NSObject 
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *steps;
@property (nonatomic, strong) NSString *meters;
@property (nonatomic, strong) NSString *calories;
@property (nonatomic, strong) NSString *totalSteps;
@property (nonatomic, strong) NSString *totalDistance;
@property (nonatomic, strong) NSString *totalCalories;
@property (nonatomic, strong) NSString *sportDuration;


/**
 *  添加数据映射，方便初始化
 *
 *  @param aDictionary 需要初始化的字典参数
 *
 *  @return 初始化好的model
 */

+(stepDate_deviceid_Model *)convertDataToModel:(NSDictionary *)aDictionary;


@end