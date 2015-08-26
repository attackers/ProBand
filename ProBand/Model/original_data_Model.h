#import <Foundation/Foundation.h> 
@interface original_data_Model : NSObject 
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *Flag;
@property (nonatomic, strong) NSString *MacAddress;
@property (nonatomic, strong) NSString *OriginalHEX;

+(original_data_Model *)convertDataToModel:(NSDictionary *)aDictionary;
@end