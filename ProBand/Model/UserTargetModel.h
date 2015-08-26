//
//  UserTargetModel.h
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/31.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface UserTargetModel : BaseModel
@property (nonatomic, strong) NSString *Id;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *stepTarget;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *sleepTarget;
@property (nonatomic,strong) NSString *botherStart;
@property (nonatomic,strong) NSString *botherEnd;
@property (nonatomic,strong) NSString *botherStatus;
@property (nonatomic,strong) NSString *clockDaile;


+(UserTargetModel *)convertDataToModel:(NSDictionary *)aDictionary;

+(void)setUserTargetInfo;
+(UserTargetModel *)getUserTargetInfoDic;

/**
 *  添加by Star：从数据库获取特定userid的目标信息
 *
 *  @param userID 用户id
 *
 *  @return 本model
 */
+(UserTargetModel *)getUserTargetData:(NSString *)userID;

+(UserTargetModel*)parseTargetStepTarget:(id)reslut;
@end
