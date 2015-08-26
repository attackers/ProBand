//
//  XlabTools.h
//  ColorBand
//
//  Created by fly on 15/5/12.
//  Copyright (c) 2015年 com.fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface XlabTools : NSObject
{
    MBProgressHUD *_loadingView;
    NSUInteger _loadingCount;
}

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



#define SINGLETON + (id)sharedInstance;

SINGLETON


- (void)startLoadingInView:(UIView *)view;
- (void)startLoadingInView:(UIView *)view withmessage:(NSString *)message;
- (void)stopLoading;


//检测是否有网络
+(BOOL)isNetConnect;

//判断当前时间的制式
+(BOOL)getTimeSys;
//判断当前是上下午
+(NSString *)getAmOrPm;
//持久化数据
+(void)setStringValue:(id)value defaultKey:(NSString *)defaultKey;
//获取持久化的数据
+(id)getStringValueFromKey:(NSString *)defaultKey;
//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey;
+(BOOL)getBoolState:(NSString *)defaultKey;
//按首字母排序并拼接成字符串
+ (NSString *)getStrFromDic:(NSDictionary *)dic;
// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否3G
+ (BOOL) IsEnable3G;

+ (void)setStatusBarBlack:(UIViewController *)viewController;
+(void)pullView:(UIView *)view;
+(BOOL)isIOS7;
+(BOOL)isRetinaDisplay;
+(int)getSystemMainVersion;
+(NSString *)getHumanString:(int)index;

+(BOOL)isChinese;
+(NSString*)currentLanguage;
+(NSString *)deviceName;

+(NSUUID*)uuid;
+(NSString*)UUIDString;

+(NSData*)hexStringToNSData:(NSString *)command;
+(NSData*) bytesFromHexString:(NSString *)aString;

+ (NSString *)getPicturefromCaches;

/*************************************************By Fly*********************************************************/
/**
 *  处理字符串 type为1表示把hourStr处理成X时X分，type为0处理成两个的,type为1处理单个。
 *
 *  @param SourceStr 需要处理de字符串
 *  @param unitArray 单位数组
 *  @param attriArry 参数信息
 *  @param type      处理数据的格式
 *
 *  @return 返回处理好的数据
 */
+ (NSAttributedString *)getModifyGoodFrom:(NSString *)SourceStr withUnit:(NSArray *)unitArray withAttributArr:(NSArray *)attriArry type:(int)type;

//图片等比压缩处理500*500
+(UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size;

//获取字段长度
+ (CGSize)getSizeFromString:(NSString *)string withFont:(CGFloat)floatNumber wid:(CGFloat)wid;

+ (NSMutableString *)getArrayToString:(NSMutableArray *)array;
+ (NSMutableArray *)getArrayFromString:(NSString *)string;
//获取url链接字符串中的参数
+(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress;
/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype;
//获取当前手机系统语言
+(NSString *)getCurrentLanguage;
+ (NSString *)getMonthStringWith:(NSString *)str;


//将十进制转化为二进制,设置返回NSString长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length;

/**
 *  by Star:将XX小时xx分钟还原到数值
 *
 *  @param dateString 表示当天时间的字符串：xx小时xx分钟
 *  @param type       为0时返回小时，为1时返回分钟
 *
 *  @return 各时间分量的数值
 */
+ (int)timeFromDateString:(NSString *)dateString withType:(int)type;


//计算CRC值（128）
+ (uint16_t)creatCRCWith:(NSData *)data withLenth:(NSInteger)lenth;

@end
