#import "stepDate_deviceid_Model.h"
@implementation stepDate_deviceid_Model


+(stepDate_deviceid_Model *)convertDataToModel:(NSDictionary *)aDictionary;
{
    stepDate_deviceid_Model *instance = [[stepDate_deviceid_Model alloc] init];
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