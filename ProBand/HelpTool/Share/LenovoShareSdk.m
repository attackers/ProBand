//
//  LenovoShareSdk.m
//  ShareSDKTest
//
//  Created by yumiao on 14/12/2.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "LenovoShareSdk.h"
#import "WeiboSDK.h"
#import <FacebookConnection/FacebookConnection.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <RennSDK/RennSDK.h>
#import <RenRenConnection/RenRenConnection.h>
#import "WXApiObject.h"
#import "YXApi.h"
#import "YXApiObject.h"
#import  <YiXinConnection/YiXinConnection.h>

@implementation LenovoShareSdk
+ (id)sharedInstance
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      shared = [[self alloc]init];
                  });
    return shared;
}

- (id)init
{
    if(self = [super init])
    {
        _viewDelegate = [[LenoveViewDelegate alloc] init];
    }
    return self;
}

- (void)initData{
    
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"8c0539e5eb5a"];//2661a1e0fd34
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    [self initializePlat];
    _interfaceOrientationMask = SSInterfaceOrientationMaskAll;
    
}

#pragma mark -share sdk methods
- (void)initializePlat
{
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    //可能有一定延迟：需等待
//    [ShareSDK  connectSinaWeiboWithAppKey:@"1453632810"
//                                appSecret:@"4984d131b1ede805595886fdd6f27841"
//                              redirectUri:@"http://www.sina.com"
//                              weiboSDKCls:[WeiboSDK class]];
//    
//    // 连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
//    // http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"
//                                   wbApiCls:[WeiboApi class]];
//    
//    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           wechatCls:[WXApi class]];
//    
//    //[ShareSDK connectWeChatSessionWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249" wechatCls:[WXApi class]];
//
//    
//    //开启QQ空间网页授权开关
//    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
//    [app setIsAllowWebAuthorize:YES];
//    /*100371282
//     *aed9b0303e3ed1e27bae87c33761161d
//     */
//    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:@"1104547436"
//                           appSecret:@"Q9MXvqEBdd99qzWY"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    /*1104541588
//     *
//     */
//    //添加QQ应用  注册网址  http://open.qq.com/
//    [ShareSDK connectQQWithQZoneAppKey:@"1104547436" //@"100371282"
//                     qqApiInterfaceCls:[QQApiInterface class]
//     
//                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    //    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
    //                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
    //                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    //可能有一定延迟：需等待
    [ShareSDK  connectSinaWeiboWithAppKey:@"2346652703"
                                appSecret:@"e9b3592d9902d4b41df96804682dc321"
                              redirectUri:@"http://www.sina.com"
                              weiboSDKCls:[WeiboSDK class]];
    
    // 连接腾讯微博开放平台应用以使用相关功能，此应用需要引用：801307650 TencentWeiboConnection.framework
    // http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
    [ShareSDK connectTencentWeiboWithAppKey:@"801567809"
                                  appSecret:@"f019c6437f0841309d1257da12a68619"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           wechatCls:[WXApi class]];
//    
//    //[ShareSDK connectWeChatSessionWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    //[ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249" wechatCls:[WXApi class]];
    //wx47b9e96f02abd536
    //0c39a670c28df5edb448405050299b45

    
    //[ShareSDK connectWeChatSessionWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    //顺序不一样呦区别？
    [ShareSDK connectWeChatWithAppId:@"wx5a370462011ad716" appSecret:@"098ed83632be7e918723567690810354" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx5a370462011ad716" wechatCls:[WXApi class]];
    
    //开启QQ空间网页授权开关
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    /*100371282
     *aed9b0303e3ed1e27bae87c33761161d
     */
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104753352"
                           appSecret:@"KracDM2EwDs51TQX"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    /*1104541588
     *
     */
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104753352" //@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
     
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    //添加Twitter应用  注册网址  https://dev.twitter.com
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    // 连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
    // http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
    //(已申请成功)
    [ShareSDK connectKaiXinWithAppKey:@"393969701522cf4d97e3a3864883ba9f"
                            appSecret:@"c426b88bcad90242bcfb5a8729dc538f"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    // 连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
    // http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
    //(已申请,审核中)
    //    [ShareSDK connectRenRenWithAppId:@"270179"
    //                              appKey:@"29b65efad46f43e7bab0f788839ada01"
    //                           appSecret:@"5ea6d6265a14466f9b8b06be14150d98"
    //                   renrenClientClass:[RennClient class]];
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
    
    [ShareSDK connectRenRenWithAppId:@"477149"
                              appKey:@"d93753f117884817b92dd961ccb00f59"
                           appSecret:@"20c8813a21214e08a683df56b0d4fca1"
                   renrenClientClass:[RennClient class]];
    
    //连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
    //http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
    //(已申请,审核中)
    //        [ShareSDK connectYiXinWithAppId:@"yx672960a1cfa149f4b521131092bd75b2"
    //                               yixinCls:[YXApi class]];
    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
                           yixinCls:[YXApi class]];
    
    
    
}

- (void)popShareView:(id)sender
{
    
    //开启QQ空间网页授权开关
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    id<ISSFacebookApp> facebookApp =(id<ISSFacebookApp>)[ShareSDK getClientWithType:ShareTypeFacebook];
    [facebookApp setIsAllowWebAuthorize:YES];
    
//    id<ISSSinaWeiboApp> sinaApp = (id<ISSSinaWeiboApp>)[ShareSDK getClientWithType:ShareTypeSinaWeibo];
//    [sinaApp setSsoEnabled:YES];
    
    id<ISSCAttachment> shareImage = nil;
    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage;          //分享的类型
    shareImage = [ShareSDK pngImageWithImage:[self screenshot]];     //得到要分享的image
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我在使用联想手环"
                                       defaultContent:@"我在使用联想手环"
                                                image:shareImage
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:shareType];
    
    
    //腾讯微博
    [publishContent addTencentWeiboUnitWithContent:@"我在使用联想手环" image:shareImage];
    
    //新浪微博
    [publishContent addSinaWeiboUnitWithContent:@"我在使用联想手环" image:shareImage];

    
    //开心网
    [publishContent addKaiXinUnitWithContent:@"我在使用联想手环" image:shareImage];
    //QQ好友
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage] content:@"我在使用联想手环" title:@"QQ好友" url:nil image:shareImage];
    
    
    //QQ空间
    //此处的url,site不能为空先随便写上
    [publishContent addQQSpaceUnitWithTitle:@"QQ空间" url:@"http://www.baidu.com" site:nil fromUrl:nil comment:nil summary:@"我在使用联想手环" image:shareImage type:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage] playUrl:nil nswb:nil];
    
    //定制易信好友信息
    [publishContent addYiXinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage]
                                        content:@"我在使用联想手环"
                                          title:@"易信好友"
                                            url:nil
                                     thumbImage:nil
                                          image:shareImage
                                   musicFileUrl:nil
                                        extInfo:nil
                                       fileData:nil];
    
    
    
    //定义易信朋友圈信息
    [publishContent addYiXinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage]
                                         content:@"我在使用联想手环"
                                           title:@"易信朋友圈"
                                             url:nil
                                      thumbImage:nil
                                           image:shareImage
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil];

    
    //定制人人网信息
    [publishContent addRenRenUnitWithName:@"人人网"
                              description:@"我在使用联想手环"
                                      url:nil
                                  message:nil
                                    image:shareImage
                                  caption:nil];

    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage]
                                         content:@"我在使用联想手环"
                                           title:@"微信好友!"
                                             url:nil
                                      thumbImage:nil
                                           image:shareImage
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText|SSPublishContentMediaTypeImage]
                                          content:@"我在使用联想手环"
                                            title:@"微信朋友圈!"
                                              url:nil
                                       thumbImage:nil
                                            image:shareImage
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //Twitter
    [publishContent addTwitterWithContent:@"我在使用联想手环" image:shareImage];
    
    //Facebook
    [publishContent addFacebookWithContent:@"我在使用联想手环" image:shareImage];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:(id)_viewDelegate];
    
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //定义分享界面
    NSArray *typeArray = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeRenren,
                          ShareTypeKaixin,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeYiXinSession,
                          ShareTypeYiXinTimeline,
                          ShareTypeFacebook,
                          ShareTypeQQ,
                          ShareTypeQQSpace,
                          ShareTypeTwitter,
                          nil];
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"//分享视图标题
                                                              oneKeyShareList:typeArray           //一键分享菜单
                                                               qqButtonHidden:NO                  //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:NO                 //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:NO                 //是否显示键盘
                                                            shareViewDelegate:(id)_viewDelegate      //分享视图委托
                                                          friendsViewDelegate:(id)_viewDelegate      //好友视图委托
                                                        picViewerViewDelegate:(id)_viewDelegate];    //图片浏览视图委托
    //弹出分享菜单
//    NSArray *shareListArray = [ShareSDK getShareListWithType:
//                               ShareTypeSinaWeibo,
//                               ShareTypeTencentWeibo,
//                               //                               ShareType163Weibo,
//                               //                               ShareTypeDouBan,
//                               ShareTypeRenren,
//                               ShareTypeKaixin,
//                               ShareTypeWeixiSession,
//                               ShareTypeWeixiTimeline,
//                               //ShareTypeFacebook,
//                               ShareTypeQQ,
//                               ShareTypeQQSpace,
//                              // ShareTypeTwitter,
//                               ShareTypeYiXinTimeline,
//                               ShareTypeYiXinSession,
//                               nil];
    
    NSArray *shareListArray = [ShareSDK getShareListWithType:
                               ShareTypeSinaWeibo,
                               ShareTypeWeixiSession,
                               ShareTypeWeixiTimeline,
                               ShareTypeQQ,
                               ShareTypeQQSpace,
                               ShareTypeRenren,
                               //                               ShareTypeYiXinTimeline,
                               //                               ShareTypeYiXinSession,
                               nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareListArray
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",[error errorDescription]] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                                    [alert show];
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
    
}

/**
 
 *截图功能
 
 */
- (UIImage*)screenshot
{
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else{
       // UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
