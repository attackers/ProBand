//
//  Contants.h,基础设置类，公用设置方法
//  LenovoVB10
//
//  Created by fenda on 14/11/28.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>


#define SINGLETON + (id)sharedInstance;
#define SINGLETON_SYNTHE \
+ (id)sharedInstance\
{\
static id shared = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,\
^{\
shared = [[self alloc]init];\
});\
return shared;\
}

@interface Contants : NSObject
/**
 *  配色
 *
 *  @param rgbValue UIColorFromRGB(0xdadada)
 *
 *  @return UIClolor
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**
 *  是否显示状态栏
 *
 *  @param show
 */
+ (void)showStatusBar:(BOOL)show;
/**
 *  设置状态栏颜色
 *
 *  @param statusBarType
 */
+ (void)setStatusBarType:(UIStatusBarStyle)statusBarType;
/**
 *  获取颜色值
 *
 *  @param UIColor @"32BFAF"
 *
 *  @return color
 */
+ (UIColor *)colorFromHexRGB:(NSString *) inColorString;

//获取网络状态
/**
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域wifi
 */
+ (void)getNetWorkStateBlock:(void (^)(NSInteger index))block;
//获取本地缓存的图片
+ (NSString *)getPicturefromCaches;
//图片压缩处理500*500
+(UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size;
//上传／更换头像 保存图片到Cache
+ (void)postHeadImage:(UIImage *)image;
//加模糊效果，image是图片，blur是模糊度
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
//把从数据库取出来的重复天数（0和1）转换为周几的字符串
+(NSString *)componentStr:(NSString *)str;

//***************************初始默认值****************************

+(void)addDefaultData;

+ (NSString*) valuableCodeInTag:(NSString*)beginMatch andTag:(NSString*)endMatch withString:(NSString *)str;



// 随机数（8~20位长，允许0-9数字和a-zA-Z字母），用于关联所生成的验证码图形信息。
+ (NSString*) randomWithLengh:(int)randomLength;

+ (BOOL) isValidEmail:(NSString *)str;
+ (BOOL) isValidPhoneNumber:(NSString *)str;
+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (BOOL) isValidCapchaNumber:(NSString *)str;
+ (BOOL) isValidPassword:(NSString *)str;
@end
