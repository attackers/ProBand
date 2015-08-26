//
//  PublicFunction.h
//  houseManage
//
//  Created by zhu xian on 12-3-3.
//  Copyright 2012 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"
//#import "ABAddressBook.h"
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

@interface PublicFunction : NSObject
{
    
}
+ (MBProgressHUD *)showLoading:(NSString *)message hiddenAfterDelay:(int)second;
+ (MBProgressHUD *)showNoHiddenLoading:(NSString *)title;
+(UIImageView *)getImageView:(CGRect)frame imageName:(NSString *)imageName;
+(NSData*)hexStringToNSData:(NSString *)command;
+(NSData*) bytesFromHexString:(NSString *)aString;
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+(UISearchBar *)getSearchBarInControl:(id)control frame:(CGRect)frame placeholder:(NSString *)placeholder tag:(int)tag;
+(UISegmentedControl *)getSegmentedControlIn:(id)control frame:(CGRect)frame buttonNames:(NSArray *)buttonNames  action:(SEL)action;
+(BOOL)addDontBackUpCaches;
+(NSString *)getStr:(id)str;
+(NSString *)getIntId:(id)str;
+(NSString *)getHoursMinutes;
+(NSString *)getHoursMinutesSeconds;
+(NSString *)getSeconds;
+(UITextView *)getTextView:(CGRect)frame   text:(NSString *)text size:(int)size;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text textSize:(int)size  textColor:(UIColor *)textColor textBgColor:(UIColor *)bgcolor  textAlign:(NSString *)align;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text  size:(int)size align:(NSString *)align;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text size:(int)size;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color align:(NSString *)align;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text align:(NSString *)align;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text fontSize:(int)fontSize color:(UIColor *)color;
+(UITextField *)getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag  returnType:(NSString *)returnType text:(NSString *)text placeholder:(NSString *)placeholder;
+(void)showError:(NSString *)error;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction;
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title  tag:(int)tag clickAction:(SEL)clickAction;
+(NSString *)getOrderNum;
+(BOOL)getPowerByType:(NSString *)type andAddEditDel:(NSString *)addEditDel;
+(BOOL)canDelete;
+(NSString *)getUserRole;
+(void)saveUserRole:(NSString *)userRole;
+(NSString *)getNameByDateTime;
+(BOOL)isBuyPro;
+(NSString *)getDatabasePath;
+(BOOL)dateCompare:(NSString *)from to:(NSString *)to;
+(NSString *)getMonthFromNow:(int)month;
+(NSString *)getUserName;
+(NSString *)getUserid;
+ (UIImage *) getImage:(UIImage *)image width:(int)width height:(int)height;
+(BOOL)isLoginServer;
+(UITextField *)addTextField:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title clickAction:(SEL)clickAction;
//检测IP格式
+(BOOL) isIp:(NSString *)checkString;
+(BOOL)isConnect;
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *)align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction;
+(UITextView *)getTextViewInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;
+(UITextField *)getTextFieldInControl:(id)control frame:(CGRect)frame  tag:(NSInteger)tag returnType:(NSString *)returnType;
+(NSString *)getCurYear;
+(UIColor *)getColorByImage:(NSString *)imageName;
+(UIImage *)getImage:(NSString *)imageName;
+(NSString *)getCurDateTime;
+(NSString *)getCurMonth;
+(void)saveUserId:(NSString *)UserId;
+(UIButton *)getButtonInControl:(id)control frame:(CGRect)frame  title:(NSString *)title align:(NSString *)align  color:(UIColor *)color fontsize:(int)fontsize tag:(int)tag clickAction:(SEL)clickAction imageName:(NSString *)imageName;
+ (UIImage *) getThumbnailImage:(UIImage *)image width:(int)width height:(int)height;
+(BOOL) isDate:(NSString *)checkString;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text BGColor:(UIColor *)BGColor textColor:(UIColor *)textColor size:(NSInteger)size;
+(UILabel *)getlabel:(CGRect)frame text:(NSString *)text color:(UIColor *)color size:(NSInteger)size;
+(BOOL) isAlphaNumeric:(NSString *)checkString;
+(NSArray *)getDayOfWeek:(NSString *)dateTime;
+(BOOL) isEmail:(NSString *)checkString;

+(BOOL)isValidInput:(NSString *)checkString;

+(BOOL) isIdCarNumber:(NSString *)checkString;
+(BOOL) isFloat:(NSString *)checkString;
+(BOOL) isNumber:(NSString *)checkString;
+(void)showMessage:(NSString *)mes;
+(NSString *)getCurDay;
+(NSString *)getDateTime:(NSString *)format;
+(void)addTextField:(UITextField *)textField;
+(NSString *)replaceString:(NSString *)str;

+(NSString *)stringcnFromHexString:(NSString *)hexString;
+(NSString *)stringFromHexString:(NSString *)hexString;
+(NSString*)intToHexString:(NSInteger)value;
+(NSString*)hexToString:(NSInteger)value;
+ (NSString *) stringFromHex:(NSString *)str;
+ (NSString *) stringToHex:(NSString *)str;
+ (NSData *) HexStringToData:(NSString *)command;//将16进制字符原封不动转nsdata
+(NSString*)hexRepresentationWithSpaces_AS:(NSData *)data;

+(NSString *)getLastMonth;


+ (MBProgressHUD *)showLoading:(NSString *)title;
+ (void)hiddenHUD;
+(BOOL)appHasNewVersion;

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


@end
