//
//  UserInfoModel.h
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/16.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface UserInfoModel : BaseModel
@property (nonatomic, strong) NSString *Id;
@property (nonatomic,strong) NSString *birthDay;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *heightUnit;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSString *weightUnit;



+(UserInfoModel *)convertDataToModel:(NSDictionary *)aDictionary;

+ (NSDictionary *)dictionaryFromModel:(UserInfoModel *)aDcitionary;

+(void)setUserInfo;
+ (UserInfoModel *)getUserInfoDic;

/*对数据库操作*/
+(UserInfoModel *)getUserInfoData:(NSString *)userID;

+(UserInfoModel *)parserUserInfoL:(id)result;
@end
