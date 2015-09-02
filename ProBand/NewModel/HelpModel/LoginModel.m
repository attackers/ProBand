//
//  LoginModel.m
//  LenovoVB10
//
//  Created by yumiao on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "LoginModel.h"
#import "NSString+MD5Addition.h"
#import "DBOperator.h"
#import "Singleton.h"
#import "DateHandle.h"
@implementation LoginModel

- (id) init
{
    if (! (self = [super init]))
    {
        return nil;
    }
    self.userTypeName = @"msisdn" ;
    self.userNameValue  = @"" ;
    self.password  = @"" ;
    self.t  = @"" ;
    self.c  = @"" ;
    self.getcode  = @"y" ;
    self.source  = [self requestSource] ;
    self.deviceidtype  = @"sn" ;
    self.deviceid  = @"" ;
    self.devicecategory  = @"unknown" ;
    self.devicevendor  = @"apple" ;
    self.devicefamily  = @"unknown" ;
    self.devicemodel  = [[UIDevice currentDevice] model] ;
    self.osversion  = @"" ;
    self.productiondate  = [DateHandle stringOfCurrentTime];
    self.unpackdate  = _productiondate;
    self.extrainfo  = @"" ;
    self.imsi  = @"" ;
    self.lang = @"zh-CN";
    self.realm = @"contact.cloud.lps.lenovo.com";
    return self;
}

- (NSString* ) requestSource
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *retVal = @"ios:ios.lesync-1.6";
    //NSString* retVal = [NSString stringWithFormat:@"ios:ios.lesync-%@", [infoDict objectForKey:@"CFBundleVersion"]];
    return retVal;
}


- (NSString *)toTgtPostBodyParam:(LoginModel *)obj
{
    NSString* usrInfo = [NSString stringWithFormat:
                         @"password=%@&t=%@&c=%@&getcode=%@&source=%@",
                         obj.password , obj.t , obj.c ,obj.getcode , obj.source ];
    
    NSString* deviceInfo = [NSString stringWithFormat:
                            @"&deviceidtype=%@&deviceid=%@&devicecategory=%@&devicevendor=%@&devicefamily=%@&devicemodel=%@",
                            obj.deviceidtype, [[UIDevice currentDevice] uniqueDeviceIdentifier] ,obj.devicecategory,obj.devicevendor,obj.devicefamily,obj.devicemodel];
    
    NSString* producInfo = [NSString stringWithFormat:
                            @"&osversion=%@&productiondate=%@&unpackdate=%@",
                            obj.osversion , obj.productiondate, obj.unpackdate];
    
    NSString* extInfo = [NSString stringWithFormat:
                         @"&extrainfo=%@&imsi=%@&lang=%@",
                         obj.extrainfo, obj.imsi,obj.lang ];
    
    NSString* result = [NSString stringWithFormat:@"%@%@%@%@",
                        usrInfo, deviceInfo, producInfo, extInfo];
    
    NSLog(@"tgt body :%@",result);
    return result;
}


@end
