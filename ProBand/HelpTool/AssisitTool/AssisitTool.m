//
//  AssisitTool.m
//  ProBand
//
//  Created by star.zxc on 15/6/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "AssisitTool.h"

@implementation AssisitTool

+ (instancetype)shareInstance{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BOOL)checkCardNo:(NSString *)cardNo
{
    if (cardNo == nil || cardNo.length <= 0) {
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"您输入账号为空，请重新输入"];
        return NO;
    }
    int oddsum = 0;//奇数求和
    int evensum = 0; //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+ (BOOL) isValidEmail:(NSString *)str
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_EMAIL_REGEX];
    return [rexTest evaluateWithObject:str];
}
+ (BOOL) isValidPhoneNumber:(NSString *)str
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VALIDATE_PHONE_REGEX];
    return [rexTest evaluateWithObject:str];
}

+ (BOOL)isFirstEnterApp
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:IsFirstIntoApp];
    if (number == nil) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
