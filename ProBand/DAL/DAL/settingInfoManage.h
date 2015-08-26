#import <Foundation/Foundation.h> 
#import "settingInfo_Model.h"
@interface settingInfoManage : NSObject {
}
+(settingInfo_Model *)getModelById:(NSString *)Id;
+(NSDictionary *)getDictionaryById:(NSString *)Id;
+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+ (int)updateId:(NSString *)Id userId:(NSString *)userId smsStatus:(NSString *)smsStatus callState:(NSString *)callState weatherState:(NSString *)weatherState wecatState:(NSString *)wecatState photoState:(NSString *)photoState masterSwitch:(NSString *)masterSwitch setLock:(NSString *)setLock findphoneState:(NSString *)findphoneState ;
+ (int)adduserId:(NSString *)userId smsStatus:(NSString *)smsStatus callState:(NSString *)callState weatherState:(NSString *)weatherState wecatState:(NSString *)wecatState photoState:(NSString *)photoState masterSwitch:(NSString *)masterSwitch setLock:(NSString *)setLock findphoneState:(NSString *)findphoneState ;

@end