//
//  XlabTools.m
//  ColorBand
//
//  Created by fly on 15/5/12.
//  Copyright (c) 2015年 com.fenda. All rights reserved.
//

#import "XlabTools.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@implementation XlabTools

SINGLETON_SYNTHE

#pragma mark Loading
// webservice开始
- (void)startLoadingInView:(UIView *)view
{
    _loadingCount = 1;
    
    if (_loadingCount == 1) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
        }
        _loadingView = [[MBProgressHUD alloc] initWithView:view];
        _loadingView.labelText = NSLocalizedString(@"settings_policy_toast", nil);
        [_loadingView show:YES];
    }
    [view addSubview:_loadingView];
}

// webservice结束
- (void)stopLoading
{
    _loadingCount--;
    
    // 当没有请求web的时候才移除loading
    if (_loadingCount == 0) {
        [_loadingView hide:YES];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        
        // 网络加载标志停止转动
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


- (void)startLoadingInView:(UIView *)view withmessage:(NSString *)message
{
    _loadingCount = 1;
    
    if (_loadingCount == 1) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
        }
        _loadingView = [[MBProgressHUD alloc] initWithView:view];
        _loadingView.labelText = message;
        [_loadingView show:YES];
    }
    [view addSubview:_loadingView];
}




+(BOOL)isNetConnect
{
    Reachability *r=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL ret=TRUE;
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            return FALSE;
            break;
        default:
            break;
    }
    
    return ret;
}

+(BOOL)getTimeSys
{
    //TURE为12小时制，否则为24小时制。
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
}

+(NSString *)getAmOrPm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"a"];
    NSString *AMPMtext = [dateFormatter stringFromDate:[NSDate date]];
    if ([AMPMtext isEqualToString:@"AM"])
    {
        AMPMtext = @"上午";
    }
    else
    {
        AMPMtext = @"下午";
    }
    
    return AMPMtext;
}


//持久化NSString类型
+(void)setStringValue:(id)value defaultKey:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getStringValueFromKey:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultKey];
}

//持久化BOOL状态值
+(void)setBoolState:(BOOL)loginState defaultKey:(NSString *)defaultKey
{
    [[NSUserDefaults standardUserDefaults] setBool:loginState forKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolState:(NSString *)defaultKey
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultKey];
}

//按首字母排序并拼接成字符串
+ (NSString *)getStrFromDic:(NSDictionary *)dic
{
    
    NSArray *kArrSort = [dic allKeys]; //这里是字母数组:,g,a,b.y,m……
    NSArray *resultkArrSort = [kArrSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSLog(@"按字母排序后%@",resultkArrSort);
    
    NSString* signStr = @"";
    for (int i = 0; i<resultkArrSort.count; i++) {
        signStr = [NSString stringWithFormat:@"%@%@%@",signStr,resultkArrSort[i],[dic objectForKey:resultkArrSort[i]]];
    }
    
    return signStr;
}

// 是否wifi
+ (BOOL) IsEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+(void)pullView:(UIView *)view
{
    view.hidden = NO;
    CGRect rect = view.frame;
    rect.origin.x = [UIScreen mainScreen].bounds.size.width;
    view.frame = rect;
    [UIView beginAnimations:@"pull" context:nil];
    [UIView setAnimationDuration:0.3];
    rect = view.frame;
    rect.origin.x = 0;
    view.frame = rect;
    [UIView commitAnimations];
}

+(BOOL)isIOS7
{
    if(iOS7)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
+(BOOL)isRetinaDisplay
{
    int scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if([screen respondsToSelector:@selector(scale)])
        scale = screen.scale;
    
    if(scale == 2.0f) return YES;
    else return NO;
}

+(int)getSystemMainVersion
{
    //NSLog(@"%@",[[UIDevice currentDevice] systemVersion] );
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSArray *array = [version componentsSeparatedByString:@"."];
    //TODO: for iphone 4  ios 5
    return [[array objectAtIndex:0]intValue];
}

//星期转成文字
+(NSString *)getHumanString:(int)index
{
    switch (index)
    {
        case 0:
            return NSLocalizedString(@"Monday",@"周一");
            break;
        case 1:
            return NSLocalizedString(@"Tuesday",@"周二");
            break;
        case 2:
            return NSLocalizedString(@"Wednesday",@"周三");
            break;
        case 3:
            return NSLocalizedString(@"Thursday",@"周四");
            break;
        case 4:
            return NSLocalizedString(@"Friday",@"周五");
            break;
        case 5:
            return NSLocalizedString(@"Saturday",@"周六");
            break;
        case 6:
            return NSLocalizedString(@"Sunday",@"周日");
            break;
        default:
            return nil;
            break;
    }
}



//是否是中文.包括繁体
+(BOOL)isChinese
{
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
}


+(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}


+(NSString *)deviceName
{
    UIDevice *device = [UIDevice currentDevice];
    return [device name];
}

+(NSUUID*)uuid
{
    UIDevice *device = [UIDevice currentDevice];
    return [device identifierForVendor];
}

+(NSString*)UUIDString
{
    return [[self uuid]UUIDString];
}

//hex 装换成Nsdata
+(NSData*)hexStringToNSData:(NSString *)command
{
    //NSString *command = @"72ff63cea198b3edba8f7e0c23acc345050187a0cde5a9872cbab091ab73e553";
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"%@", commandToSend);
    return commandToSend;
}


+(NSData*) bytesFromHexString:(NSString *)aString
{
    NSString *theString = [[aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:nil];
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= theString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [theString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        if ([scanner scanHexInt:&intValue])
            [data appendBytes:&intValue length:1];
    }
    return data;
}

#pragma mark 从文档目录下获取路径(locator模块)
+ (NSString *)cachesFolderPath
{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@image.png",[Singleton getUserID]]];
}

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

+ (NSAttributedString *)getModifyGoodFrom:(NSString *)SourceStr withUnit:(NSArray *)unitArray withAttributArr:(NSArray *)attriArry type:(int)type
{
    
    if (type==0)
    {
        NSMutableAttributedString *strhour = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",[SourceStr intValue]/60] attributes:attriArry[0]];
        
        NSMutableAttributedString *strMinute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",[SourceStr intValue]%60] attributes:attriArry[0]];
        
        [strhour appendAttributedString:[[NSAttributedString alloc] initWithString:unitArray[0] attributes:attriArry[1]]];
        [strMinute appendAttributedString:[[NSAttributedString alloc] initWithString:unitArray[1] attributes:attriArry[1]]];
        [strhour appendAttributedString:strMinute];
        return strhour;
    }
    else if(type == 1)
    {
        if (SourceStr == nil)
        {
            SourceStr = @"0";
        }
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:SourceStr attributes:attriArry[0]];
        [str2 appendAttributedString:[[NSAttributedString alloc] initWithString:unitArray[0] attributes:attriArry[1]]];
        return str2;
    }
    return nil;
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


+ (void)setStatusBarBlack:(UIViewController *)viewController
{
    if (iOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

//获取字段长度
+ (CGSize)getSizeFromString:(NSString *)string withFont:(CGFloat)floatNumber wid:(CGFloat)wid
{
    CGSize size;
    if (iOS7) {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:floatNumber],NSFontAttributeName,nil];
        size = [string boundingRectWithSize:CGSizeMake(wid,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    }else{
        //              size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH-80.0,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}


+ (NSMutableString *)getArrayToString:(NSMutableArray *)array
{
    NSMutableString *str = [NSMutableString new];
    if ([array count]>0)
    {
        for (int i = 0; i<[array count]; i++)
        {
            [str appendFormat:@"%@,",array[i]];
        }
        str = (NSMutableString *)[str substringWithRange:NSMakeRange(0, [str length]-1)];
    }
    
    return str;
}

+ (NSMutableArray *)getArrayFromString:(NSString *)string
{
    NSMutableArray *arrWriterPos;
    if ([string length] > 0)
    {
        arrWriterPos = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
    }
    return arrWriterPos;
}


//获取url链接字符串中的参数
+(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?|://)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

/**
 *  int类型的数据转换成NSData
 *
 *  @param operatetype 需要转换的int类型
 *
 *  @return 返回转换好的NSData类型
 */
+(NSData *)intTochar:(int)operatetype
{
    NSNumber *data = [NSNumber numberWithChar:operatetype];
    char value = [data charValue];
    NSMutableData *charData = [NSMutableData dataWithBytes:&value length:sizeof(char)];
    
    return charData;
}

//获取当前手机系统语言
+(NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"languages~~~~%@" , languages);//简体汉字zh-Hans,英文en
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]||[currentLanguage isEqualToString:@"zh-HK"])
    {
        [XlabTools setBoolState:YES defaultKey:SIMPLECHINESE];
    }
    else
    {
        [XlabTools setBoolState:NO defaultKey:SIMPLECHINESE];
    }
    
    return currentLanguage;
}


+ (NSString *)getMonthStringWith:(NSString *)str
{
    NSString *result = [NSString new];
    switch ([str intValue])
    {

        case 1:
            result = NSLocalizedString(@"January", nil);
            break;
        case 2:
            result = NSLocalizedString(@"February", nil);
            break;
        case 3:
            result = NSLocalizedString(@"March", nil);
            break;
        case 4:
            result = NSLocalizedString(@"April", nil);
            break;
        case 5:
            result = NSLocalizedString(@"May", nil);
            break;
        case 6:
            result = NSLocalizedString(@"June", nil);
            break;
        case 7:
            result = NSLocalizedString(@"July", nil);
            break;
        case 8:
            result = NSLocalizedString(@"August", nil);
            break;
        case 9:
            result = NSLocalizedString(@"September", nil);
            break;
        case 10:
            result = NSLocalizedString(@"October", nil);
            break;
        case 11:
            result = NSLocalizedString(@"November", nil);
            break;
        case 12:
            result = NSLocalizedString(@"December", nil);
            break;
            
        default:
            break;
    }
    return result;
    
    
}


//将十进制转化为二进制,设置返回NSString长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        a = [b stringByAppendingString:a];
    }
    return a;
    
}

+ (int)timeFromDateString:(NSString *)dateString withType:(int)type
{
    if (dateString && dateString.length > 0)
    {
        NSArray *array = [dateString componentsSeparatedByString:@"小时"];
        NSString *hourStr = array[0];
        int hour = [hourStr intValue];
        
        NSString *minuteStr = array[1];
        NSArray *minArr = [minuteStr componentsSeparatedByString:@"分"];
        NSString *minStr = [minArr objectAtIndex:0];
        int minute = [minStr intValue];
        switch (type) {
            case 0:
                return hour;
                break;
            case 1:
                return minute;
                break;
            default:
                return 0;
                break;
        }
    }
    else
    {
        return 0;
    }
}

//计算CRC值（128）
+ (uint16_t)creatCRCWith:(NSData *)data withLenth:(NSInteger)lenth
{
    uint16_t crc = 0xffff;
    Byte *testByte = (Byte *)[data bytes];
    for (int i = 0; i<lenth; i++)
    {
        crc = (unsigned char)(crc>>8)| (crc<<8);
        crc ^= testByte[i];
        crc ^= (unsigned char)(crc & 0xff)>>4;
        crc ^= (crc << 8)<<4;
        crc ^= ((crc & 0xff)<<4)<<1;
    }
    return crc;
}




@end
