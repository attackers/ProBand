//
//  ThirdPartyLoginManager.h
//  LenovoVB10
//
//  Created by star.zxc on 15/4/14.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdPartyUserModel.h"
@interface ThirdPartyLoginManager : NSObject<UIAlertViewDelegate>

//几个必须的选项会获取，其他不确定
@property (nonatomic, strong)ThirdPartyUserModel *thirdPartyModel;
@property (nonatomic, strong)void(^postSkitInfo)(NSInteger infoInteger);
@property (nonatomic, assign)BOOL hasLogin;//判断是否登录
SINGLETON

//- (void)loginSinaWeibo;
- (void)loginSinaWeiboWithBlock:(void (^)(NSDictionary *,BOOL))block;

- (void)loginWeixin;

//- (void)loginQQSpace;
- (void)loginQQSpaceWithBlock:(void (^)(NSDictionary *,BOOL))block;

- (void)loginWeixinWithBlock:(void (^)(NSDictionary *,BOOL))block;
@end
