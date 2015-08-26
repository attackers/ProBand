//
//  t_userInfo.h
//  ProBand
//
//  Created by star.zxc on 15/8/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface t_userInfo : BaseModel

@property (nonatomic, copy)NSString *imageUrl;

@property (nonatomic, copy)NSString *userid;

@property (nonatomic, copy)NSString *username;

@property (nonatomic, copy)NSString *age;

@property (nonatomic, copy)NSString *gender;

@property (nonatomic, copy)NSString *height;

@property (nonatomic, copy)NSString *weight;

@property (nonatomic, copy)NSString *mac;

+ (t_userInfo *)convertDataToModel:(NSDictionary *)aDcitionary;


@end
