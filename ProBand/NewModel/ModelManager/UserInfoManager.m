//
//  UserInfoManager.m
//  ProBand
//
//  Created by star.zxc on 15/8/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+ (void)insertDefaultInfo
{
    NSDictionary *dic = @{@"imageUrl":@"",
                          @"userid":[Singleton getUserID],
                          @"username":@"LiMing",
                          @"age":@"gender",
                          @"gender":@"0",
                          @"height":@"170",
                          @"weight":@"60",
                          @"mac":[Singleton getMacSite]};
    NSArray *array = [NSArray arrayWithObject:dic];
    [DBOPERATOR insertDataArrayToDB:@"t_userInfo" withDataArray:array];
}
//更新用户信息
+ (void)updateInfoWithModel:(t_userInfo *)model
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_userInfo(imageUrl,userid,username,age,gender,height,weight,mac) VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",model.imageUrl,model.userid,model.username,model.age,model.gender,model.height,model.weight,model.mac];
    //NSString *se
#warning -写到此处
}
@end
