//
//  StepDataDeviceidManager.h
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepDataDeviceidManager : NSObject

//更新标志位
+(void)updateFlag:(NSString *)Flag;
//获取到flag为0的数据
+(NSArray *)getUnUploadStep;
//批量更新Flage
+ (void)updateFlag:(NSString *)flag withArray:(NSArray *)array;
//获取step数据条数
+ (int) count;
//插入step数据
+(void)insertWithStepDateArray:(NSArray *)stepDateArray withFlag:(NSString *)flag;
//更新几步数据
+(void)updateWithStepDetailArray:(NSArray *)stepDetailArray;
+(NSArray *)getPageList:(int)pageId;
+(NSArray *)getAllStepDataWithUserID:(NSString *)userID;
@end
