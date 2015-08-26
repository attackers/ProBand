#import "original_data_Model.h"
@implementation original_data_Model

+(original_data_Model *)convertDataToModel:(NSDictionary *)aDictionary;
{
    original_data_Model *instance = [[original_data_Model alloc] init];
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