#import <Foundation/Foundation.h> 
@interface alarm_Model : NSObject
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *interval_switch;
@property (nonatomic, strong) NSString *repeat_switch;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *from_device;
@property (nonatomic, strong) NSString *startTimeMinute;
@property (nonatomic, strong) NSString *days_of_week;
@property (nonatomic, strong) NSString *interval_time;
@property (nonatomic, strong) NSString *notification;
@property (nonatomic, strong) NSString *status;

+ (alarm_Model *)convertDataToModel:(NSDictionary *)aDictionary;
+ (NSDictionary *)dictionaryFromModel:(alarm_Model *)model;
+ (NSString *)minuteToTime:(NSString *)minuteStr;
@end
