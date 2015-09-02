//
//  Contants.m
//  LenovoVB10
//
//  Created by fenda on 14/11/28.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "Contants.h"
#import "UIImageView+WebCache.h"
@implementation Contants
/**
 *  是否显示状态栏
 *
 *  @param show
 */
+ (void)showStatusBar:(BOOL)show{
    [[UIApplication sharedApplication] setStatusBarHidden:show];
}
/**
 *  设置状态栏颜色
 *
 *  @param statusBarType
 */
+ (void)setStatusBarType:(UIStatusBarStyle)statusBarType{
  [[UIApplication sharedApplication] setStatusBarStyle:statusBarType];
}
/**
 *  获取颜色值
 *
 *  @param UIColor @"32BFAF"
 *
 *  @return color
 */
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
//获取网络状态
/**
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域wifi
 */
+ (void)getNetWorkStateBlock:(void (^)(NSInteger index))block;
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //NSLog(@"%d", status);
        if (status<=0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"network_error", nil)];
        }
        block(status);
    }];
}

//获取本地缓存的图片
+ (NSString *)getPicturefromCaches{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Caches文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        NSLog(@"~~~~~%@",path);
        if ([path isEqualToString:[self cachesFolderPath]]) {
            return path;
        }
        
    }
    return nil;
}

+ (NSString *)cachesFolderPath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@image.png",[Singleton getUserID]]];
}
//上传／更换头像 保存图片到Cache
+ (void)postHeadImage:(UIImage *)image{
    
    UIImage *newImage = [self scaleImage:image tosize:CGSizeMake(160, 160)];
    
    NSData *data;
    if (UIImagePNGRepresentation(newImage) == nil) {
        //0.6为压缩系数
        data = UIImageJPEGRepresentation(newImage, 0.6);
    }else{
        data = UIImagePNGRepresentation(newImage);
        
    }
    //如果需要压缩上传则返回该值
    //[data base64Encoding];
    //图片重命名
    [self saveImage:newImage WithName:[NSString stringWithFormat:@"%@image.png",[Singleton getUserID]]];
}
//图片压缩处理500*500
+(UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size{
    UIImage *newImage;
    int h = image.size.height;
    int w = image.size.width;
    if (h <= size.height && w <= size.width) {
        newImage = image;
    }else{//等比缩放
        float newImageWidth = 0.0f;
        float newImageHeight = 0.0f;
        
        float whcare = (float)w/h;
        float hwcare = (float)h/w;
        if (w > h) {
            newImageWidth = (float)size.width;
            newImageHeight = size.width * hwcare;
        }else{
            newImageWidth = size.height*whcare;
            newImageHeight = (float)size.height;
        }
        CGSize newSize = CGSizeMake(newImageHeight, newImageHeight);
        UIGraphicsBeginImageContext(newSize);
        CGRect imageRect = CGRectMake(0.0, 0.0,newImageWidth,newImageHeight);
        [image drawInRect:imageRect];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newImage = newImg;
        
    }
    
    return newImage;
}

+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile  = [cachesDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    
    
}
//加模糊效果，image是图片，blur是模糊度
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

//把从数据库取出来的重复天数（0和1）转换为周几的字符串
+(NSString *)componentStr:(NSString *)str
{
   
    if ([str isEqualToString:@"0000000"]) {
        
        return @"单次";
    }
    NSArray *dayArr = @[NSLocalizedString(@"Sunday", nil),NSLocalizedString(@"Saturday", nil),NSLocalizedString(@"Friday", nil),NSLocalizedString(@"Thursday", nil),NSLocalizedString(@"Wednesday", nil),NSLocalizedString(@"Tuesday", nil),NSLocalizedString(@"Monday", nil)];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableString *dayStr = [NSMutableString string];
    for (int i = 0; i<str.length; i++) {
        NSRange range;
        range.length = 1;
        range.location = i;
        NSString *s =[str substringWithRange:range];
        [arr addObject:s];
    }
    
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i<arr.count; i++) {
        
        if ([arr[i] isEqualToString:@"1"])
        {
            [tempArray addObject:dayArr[i]];
        }
    }
    
    for (int i = 0; i<tempArray.count; i++)
    {
        [dayStr appendString:tempArray[tempArray.count -i-1]];
    }
    
    
    if ([arr isEqualToArray:@[@"0",@"0",@"1",@"1",@"1",@"1",@"1"]]) {
        
        return NSLocalizedString(@"legal_work_days", nil);
    }
    
    if ([arr isEqualToArray:@[@"1",@"1",@"1",@"1",@"1",@"1",@"1"]]) {
        
        return NSLocalizedString(@"everyday", nil);
    }
    return dayStr;
}
//***************************初始默认值****************************
//刚进去时如果没有设置值则会默认给数据库填上数据

+(void)addDefaultData
{

    NSString *sqlAlarm =  @"select * from t_alarm";
    
    NSArray *array = [DBOPERATOR getDataForSQL:sqlAlarm];
    
    if ([array count] <= 0) {
        NSLog(@"插入默认数据");
        NSMutableArray *clockArray = [NSMutableArray new];
        NSArray *arr=[NSArray arrayWithObjects:@"08:00",@"13:30",@"20:00", nil];
        for (int i = 0 ; i< arr.count; i++) {
            NSDictionary *dic = @{@"startTime":[arr objectAtIndex:i],@"name":NSLocalizedString(@"band_alarm_clock", nil),@"repeat":@"0011111",@"interval":@"0",@"userId":[Singleton getUserID],@"AlarmId":[NSString stringWithFormat:@"%d",i+1],@"status":@"0"};
            [clockArray addObject:dic];
        }
        [DBOPERATOR insertToDB:@"t_alarm" withDicNeedAdd:nil withValue:clockArray withkey:@"userId"];
        
        
        NSString *tagetSql = [NSString stringWithFormat:@"select * from t_targetInfo where userid = '%@'",[Singleton getUserID]];
        NSString *insertSql = [NSString stringWithFormat: @"insert into t_targetInfo(userid,stepTarget,startTime,endTime,sleepTarget,botherStart,botherEnd,botherStatus) values('%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],@"10000",@"23:00",@"07:00",@"480",@"23:00",@"07:00",@"0"];
        [DBOPERATOR insertDataToSQL:insertSql withExsitSql:tagetSql];
        //保存默认目标值到单列
        //[UserTargetModel setUserTargetInfo];
        
        
     
        NSString *userInfoStr = [NSString stringWithFormat:@"select * from t_userInfo where userId = '%@'",[Singleton getUserID]];
        NSString *userInsertSql = [NSString stringWithFormat: @"insert into t_userInfo(userId,userName,height,weight,gender,birthDay,weightUnit,heightUnit,imageUrl) values('%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],NSLocalizedString(@"NickName", nil),@"168",@"60",@"1",@"1984-1-7",@"kg",@"cm",@""];
        [DBOPERATOR insertDataToSQL:userInsertSql withExsitSql:userInfoStr];
        //保存默认用户信息值到单列
        //[UserInfoModel setUserInfo];
        [Singleton setValues:@"0" withKey:@"heightFormat"];
        [Singleton setValues:@"0" withKey:@"weightFormat"];
        
        
        NSString *selectStr = [NSString stringWithFormat:@"select * from t_settingInfo where userId = '%@'",[Singleton getUserID]];
        NSString *insertStr = [NSString stringWithFormat:@"insert into t_settingInfo (userId,smsStatus,callState,weatherState,wecatState,WhatsappState,FacebookState,calendarState,TiwitterState,FindPhone,LinkLostPhone,BatteryPowerPush,Address,ColudBackUp,clockDaile,weightFormat,heightFormat,UnlockPhone) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton getUserID],@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"0",@"1",@"0",@"1",@"1",@"0",@"0",@"0"];
        
//        [Singleton setValues:@"1" withKey:@"ColudBackUp"];
        //保存默认手机助理状态列表
        [DBOPERATOR insertDataToSQL:insertStr withExsitSql:selectStr];
        [Singleton setSettingStatus];
        
    }
}

+ (NSString*) valuableCodeInTag:(NSString*)beginMatch andTag:(NSString*)endMatch withString:(NSString *)str
{
    NSRange beginRange = [str rangeOfString:beginMatch];
    NSRange endRange = [str rangeOfString:endMatch];
    
    if (beginRange.location == NSNotFound || endRange.location == NSNotFound)
    {
        return nil;
    }
    NSRange valueRange = {beginRange.location+beginRange.length , 0};
    valueRange.length = endRange.location - valueRange.location;
    return [str substringWithRange:valueRange ];
}


//生成随机数
+ (NSString*) randomWithLengh:(int)randomLength
{
    static char* RANDOM_STR = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //static char* RANDOM_STR = "11111111111111111111111111111111111111111111111111111111111111";
    static int RANDOM_STR_LEN = 62;
    
    NSMutableData* tmpBuf = [NSMutableData dataWithLength:randomLength];
    char* tmpPointer = [tmpBuf mutableBytes];
    for (int i = 0; i < randomLength; i++)
    {
        tmpPointer[i] = RANDOM_STR[arc4random() % RANDOM_STR_LEN];
    }
    NSString* result = [[NSString alloc] initWithData:tmpBuf encoding:NSASCIIStringEncoding];//[NSString stringWithCString:tmpPointer encoding:NSASCIIStringEncoding];
    
    return result;
}

+ (BOOL) isValidEmail:(NSString *)str
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_EMAIL_REGEX];
    return [rexTest evaluateWithObject:str];
}
+ (BOOL) isValidPhoneNumber:(NSString *)str {
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_PHONE_REGEX];
    return [rexTest evaluateWithObject:str];
}

//添加by Star
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) isValidCapchaNumber:(NSString *)str {
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_CAPCHANUM_REGEX];
    return [rexTest evaluateWithObject:str];
}

+ (BOOL) isValidPassword:(NSString *)str {
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_PASSWORD_REGEX];
    return [rexTest evaluateWithObject:str];
}

@end
