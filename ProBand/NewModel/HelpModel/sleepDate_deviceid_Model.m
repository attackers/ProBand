#import "sleepDate_deviceid_Model.h"
@implementation sleepDate_deviceid_Model



-(NSString *)description
{
    return [NSString stringWithFormat:@"----===>>%@",_date];
}

+(sleepDate_deviceid_Model *)convertDataToModel:(NSDictionary *)aDictionary;
{
    sleepDate_deviceid_Model *instance = [[sleepDate_deviceid_Model alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}


- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
    
}
@end