//
//  UserModelManager.h
//  LenovoVB10
//
//  Created by DONGWANG on 15/6/16.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModelManager : NSObject
//更新用户的目标值
+(void)saveUserTargetInfo:(UserTargetModel *)obj;
@end
