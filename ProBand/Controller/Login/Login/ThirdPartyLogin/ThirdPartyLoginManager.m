 //
//  ThirdPartyLoginManager.m
//  LenovoVB10
//
//  Created by star.zxc on 15/4/14.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ThirdPartyLoginManager.h"
#import "NetWorkManage.h"

@implementation ThirdPartyLoginManager

SINGLETON_SYNTHE
- (id)init
{
    self = [super init];
    if (self) {
        _thirdPartyModel = [[ThirdPartyUserModel alloc]init];
        _hasLogin = NO;
    }
    return self;
}

//将第三方用户提交到服务器
- (void)loginServer
{
    [NetWorkManage threadActionlogin:_thirdPartyModel.userId withBlock:^(BOOL hasLogin, id result) {
        if (hasLogin) {
            
            NSString *message = [NSString stringWithFormat:@"%@:%@, %@id：%@",NSLocalizedString(@"The_third_party_user_currently_logged_on_to", nil),_thirdPartyModel.nickName,NSLocalizedString(@"logged_user", nil),_thirdPartyModel.userId];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"prompt", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (void)loginSinaWeiboWithBlock:(void (^)(NSDictionary *,BOOL))block
{
    //nil
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"---Star:%d",result);//为什么已登录还会显示result为NO
        if (result)
        {
            _hasLogin = YES;
            //成功登录后，判断该用户的ID是否在自己的数据库中
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户
            //[self reloadStateWithType:ShareTypeSinaWeibo];
            //显示用户昵称
            id<ISSPlatformUser>currentUser = [ShareSDK currentAuthUserWithType:ShareTypeSinaWeibo];
            NSLog(@"%@",currentUser.nickname);
          
            
            _thirdPartyModel.userId = currentUser.uid;
            _thirdPartyModel.nickName = currentUser.nickname;
            _thirdPartyModel.headImageUrl = currentUser.profileImage;
            
            NSDictionary *sinaWeiboDic = @{@"userId":_thirdPartyModel.userId,@"nickName":_thirdPartyModel.nickName};
            [[NSUserDefaults standardUserDefaults]setObject:sinaWeiboDic forKey:SINAWEIBO_ACCOUNT];
            
            //调用block
            block(sinaWeiboDic,result);
            [self loginServer];
            //[[AppDelegate getAPPDelegate] pushHomeViewController];
        }
        else
        {
            _hasLogin = NO;
            [PublicFunction hiddenHUD];
            [[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"login_failed", nil)];
            NSLog(@"登录失败");
        }
    }];

}

- (void)loginWeixin
{
    BOOL couldInWeibo = [ShareSDK hasAuthorizedWithType:ShareTypeWeixiTimeline];
    if (couldInWeibo)
    {
        NSLog(@"拥有进入微信的权限：已登录");
    }
    else
    {
        NSLog(@"不具有进入微信的权限: 未登录");
        [ShareSDK authWithType:ShareTypeWeixiSession options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            if (state == SSAuthStateSuccess)
            {
                NSLog(@"授权成功");
            }
            else
            {
                NSLog(@"授权失败");
            }
        }];
    }
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               NSLog(@"-----StarWEIXIN:%d",result);
                               if (result)
                               {
                                   _hasLogin = YES;
                                   //[self reloadStateWithType:ShareTypeWeixiSession];
                                   //显示用户昵称
                                   id<ISSPlatformUser>currentUser = [ShareSDK currentAuthUserWithType:ShareTypeWeixiSession];
                                   NSLog(@"%@",currentUser.nickname);
     
                                   
                                   _thirdPartyModel.userId = currentUser.uid;
                                   _thirdPartyModel.nickName = currentUser.nickname;
                                   _thirdPartyModel.headImageUrl = currentUser.profileImage;
                                   
                                    [self loginServer];
                               }
                               else
                               {
                                   _hasLogin = NO;
                               }
                           }];
}
- (void)loginWeixinWithBlock:(void (^)(NSDictionary *,BOOL))block
{
    //添加授权选项
    id<ISSAuthOptions>authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"微信登录：%d",result);
        if (error) {
            NSLog(@"登录错误:%@",error);
        }
        if (result) {
            //显示用户昵称
            id<ISSPlatformUser>currentUser = [ShareSDK currentAuthUserWithType:ShareTypeWeixiSession];
            NSLog(@"%@",currentUser.nickname);
        }
        id<ISSPlatformUser>currentUser = [ShareSDK currentAuthUserWithType:ShareTypeWeixiSession];
        NSLog(@"---NickName:%@--%@",currentUser.nickname,userInfo.nickname);
        
        NSDictionary *weixinDic = @{@"userId":currentUser.uid,@"nickName":currentUser.nickname};
        block(weixinDic,result);
    }];
}

- (void)loginQQSpaceWithBlock:(void (^)(NSDictionary *,BOOL))block
{
    //qq不支持网页授权，所以使用QQ空间：如何使用手机上的QQ交互?会超时连接,为什么会返回NO?
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"-----QQ:Star:%d",result);
        if (result)
        {
            _hasLogin = YES;
            //[self reloadStateWithType:ShareTypeQQSpace];
            //显示用户昵称
            id<ISSPlatformUser>currentUser = [ShareSDK currentAuthUserWithType:ShareTypeQQSpace];
            NSLog(@"%@",currentUser.nickname);

            _thirdPartyModel.userId = currentUser.uid;
            _thirdPartyModel.nickName = currentUser.nickname;
            _thirdPartyModel.headImageUrl = currentUser.profileImage;
            
            NSDictionary *QQDic = @{@"userId":_thirdPartyModel.userId,@"nickName":_thirdPartyModel.nickName};
            [[NSUserDefaults standardUserDefaults]setObject:QQDic forKey:QQ_ACCOUNT];
            block(QQDic,result);
             [self loginServer];
        }
        else
        {
            _hasLogin = NO;
            //NSLog(@"如果您的手机上未安装QQ，将不能使用QQ第三方登录");//弹出提示？
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登录失败"];
        }
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
           // [[AppDelegate getAPPDelegate]pushHomeViewController];
            if (self.postSkitInfo) {
                self.postSkitInfo(0);
            }
        }
            break;
            
        default:
            break;
    }
}
@end
