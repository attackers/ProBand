#import "alarm_Model.h"
@implementation alarm_Model

+ (alarm_Model *)convertDataToModel:(NSDictionary *)aDictionary
{
    alarm_Model *model = [[alarm_Model alloc] init];
    
    model.userid = aDictionary[@"userid"];
    model.interval_switch = aDictionary[@"interval_switch"];
    model.repeat_switch = aDictionary[@"repeat_switch"];
    model.Id = aDictionary[@"id"];
    model.from_device = aDictionary[@"from_device"];
    model.days_of_week = aDictionary[@"days_of_week"];
    model.interval_time = aDictionary[@"interval_time"];
    model.notification = aDictionary[@"notification"];
    model.status = aDictionary[@"switch"];
    
    return model;
}

+ (NSDictionary *)dictionaryFromModel:(alarm_Model *)model
{
    NSDictionary *dic = @{
                            @"userid":model.userid,
                            @"interval_switch":model.interval_switch,
                            @"repeat_switch":model.repeat_switch,
                            @"smart_switch":@"0",
                            @"mac":model.mac,
                            @"id":model.Id,
                            @"from_device":@"0",
                            @"startTimeMinute":model.startTimeMinute,
                            @"days_of_week":model.days_of_week,
                            @"interval_time":model.interval_time,
                            @"notification":model.notification,
                            @"switch":model.status
                          };
    return dic;
}

+ (NSString *)minuteToTime:(NSString *)minuteStr
{
    NSString *hour = [NSString stringWithFormat:@"%.2d", [minuteStr intValue]/60];
    NSString *min = [NSString stringWithFormat:@"%.2d", [minuteStr intValue]%60];
    NSString *time = [NSString stringWithFormat:@"%@:%@",hour,min];
    return time;
}
/*
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
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"userid = %@, interval_switch = %@, repeat_switch = %@, mac = %@, Id = %@, from_device = %@, startTimeMinute = %@, days_of_week = %@, interval_time = %@, notification = %@, status = %@",self.userid, self.interval_switch,self.repeat_switch, self.mac, self.Id, self.from_device, self.startTimeMinute, self.days_of_week, self.interval_time, self.notification, self.status];
}

@end
