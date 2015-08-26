#import <Foundation/Foundation.h> 
#import "UserInfoModel.h"
@interface userInfoManage : NSObject {
}
+(UserInfoModel *)getModelById:(NSString *)Id;+(NSDictionary *)getDictionaryById:(NSString *)Id;+ (NSArray *)findBySql:(NSString *)sql;
+ (NSArray *)findAll;
+(id)find:(NSString *)title;
+ (int)count;
+(NSArray *)getPageList:(int)pageId;
+ (int)remove:(NSString *)ID;
+(int)getMaxId;
+ (int)updateId:(NSString *)Id userId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit ;
+ (int)adduserId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit;

/**
 *  添加by Star：修改用户信息的方法
 *
 *  @param UserInfoModel
 *
 *  @return 成功或失败
 */
+ (BOOL)updateUserId:(NSString *)userId userName:(NSString *)userName height:(NSString *)height weight:(NSString *)weight gender:(NSString *)gender birthDay:(NSString *)birthDay imageUrl:(NSString *)imageUrl weightUnit:(NSString *)weightUnit heightUnit:(NSString *)heightUnit;
//解析从服务器拉回来的用户信息的json数据
+(UserInfoModel *)ParserSeverInfo:(id)result;



@end