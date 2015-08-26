//
//  LoginNetUnit.m
//  LenovoVB10
//
//  Created by yumiao on 15/1/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "LoginNetUnit.h"
#import "LoginModel.h"



@implementation LoginNetUnit

SINGLETON_SYNTHE
- (void)requestComplete:(id)result{
    
    [[Loading shareInstance] stopLoading];
    //NSLog(@"~~result~~%@",result);
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //NSLog(@"~~result~~%@",str);
    NSString *value = [Contants valuableCodeInTag:@"<Value>" andTag:@"</Value>"withString:str];
    if (self.completion) {
        self.completion(value,YES);
    }
}

- (void)getDataWithName:(NSString *)nameStr withvalue:(NSString *)value withBlock:(void (^)(BOOL,NSString *,NSString *))block{
    
    __block  NSDictionary *body = @{
                                    @"rdm":@"d",
                                    nameStr:value,
                                    @"source":@"ios:ios.lesync-1.6",
                                    @"lang":@"",
                                    @"realm":@"photo.cloud.lps.lenovo.com"
                                    };
    [NetWorkManage loginInwithGetData:body block:^(BOOL succ, id result) {
        NSLog(@"!~~~~~%@",result);
        NSString *photoStValue = result;
        if (photoStValue) {
            body = @{
                     @"rdm":@"d",
                     nameStr:value,
                     @"source":@"ios:ios.lesync-1.6",
                     @"lang":@"",
                     @"realm":@"contact.cloud.lps.lenovo.com"
                     };
            [NetWorkManage loginInwithGetData:body block:^(BOOL succ, id results) {
                NSLog(@"!~~~~~%@",results);
                NSString* pimStValue = results;
                if (pimStValue) {
                    block(YES,photoStValue,pimStValue);
                }else{
                    block(NO,photoStValue,nil);
                }
            }];
        }else{
             block(NO,nil,nil);
        }
        
    }];
}

/*
- (BOOL) loginWithName:(NSString*)loginName
                andPsw:(NSString*)loginPsw
              userType:(LeUserType)loginType
          outErrorCode:(NSString**)errCode
{
    
    *errCode = nil;
    @synchronized(self)
    {
        //NSLog(@"--===%@",loginName);
            LoginModel* info = [LoginModel new];
            switch (loginType) {
                case LeUserEMAIL:
                    info.userTypeName = @"email";
                    break;
                case LeUserMSISDN:
                    info.userTypeName = @"msisdn";
                    break;
                default:
                    
                    NSLog(@"loginWithName: The userType is wrong:%d", loginType);
                    break;
            }
                    //break;
        
            info.password = loginPsw;
            info.userNameValue = loginName;
             NSString *tgtName, *tgtValue;
        
            BOOL b = [self fetchTGTof:info outLpsName:&tgtName outLpsUserTgt:&tgtValue outErrorCode:errCode];
        
            if (b)
            {
                NSString*  photoStValue= [self fetchSTof:info lpsName:tgtName lpsUserTgt:tgtValue lpsStRealm:@"photo.cloud.lps.lenovo.com" outErrorCode:nil];
                //get pim lpsust
                NSString* pimStValue = [self fetchSTof:info lpsName:tgtName lpsUserTgt:tgtValue lpsStRealm:@"contact.cloud.lps.lenovo.com" outErrorCode:nil];

                if (nil != pimStValue && nil != photoStValue)
                {
//                    userType = loginType;
                    info.userNameValue = loginName;
                    info.password = loginPsw;
//                    info.lpsPimST = pimStValue;
//                    self.lpsPhotoST = photoStValue;
//                    self.lastLoginTime = [NSDate date];
//                    self.loginAlready = YES;
                    return YES;
                    //[self persistUser];
                }
                
                
                
            }
    }
    
    return NO;
 
}


- (BOOL) fetchTGTof:(LoginModel*)reginfo
         outLpsName:(NSString**)outName
      outLpsUserTgt:(NSString**)outValue
       outErrorCode:(NSString**)errorCode
{
   // __block BOOL retVal = NO;
    *errorCode = nil;
    NSString* urlForUss  = [NSString stringWithFormat:@"https://uss.lenovomm.com/authen/1.2/tgt/user/get?%@=%@",reginfo.userTypeName,reginfo.userNameValue];
    //NSLog(@"==>>>111---%@",urlForUss);
    if (nil != urlForUss && nil != reginfo)
    {
        NSString *time = [DateHandle dateToString:[NSDate date] withType:2];
        
//        NSDictionary *dic = @{@"password":reginfo.password,@"t":@"",@"c":@"",@"getcode":@"y",@"source":@"ios:ios.lesync-1.6",@"deviceidtype":@"sn",@"deviceid":[[UIDevice currentDevice] uniqueDeviceIdentifier],@"devicecategory":@"unknown",@"devicevendor":@"apple",@"devicefamily":@"unknown",@"devicemodel":@"iPhone",@"osversion":@"",@"productiondate":time,@"unpackdate":time,@"extrainfo":@"",@"imsi":@"",@"lang":@"zh-CN"};
//        
//        [self startPost:urlForUss params:dic dataKey:nil];
        
        NSString *bodyStr = [NSString stringWithFormat:@"password=%@&t=&c=&getcode=y&source=ios:ios.lesync-1.6&deviceidtype=sn&deviceid=%@&devicecategory=unknown&devicevendor=apple&devicefamily=unknown&devicemodel=iPhone&osversion=&productiondate=%@&unpackdate=%@&extrainfo=&imsi=&lang=zh-CN",reginfo.password,[[UIDevice currentDevice] uniqueDeviceIdentifier],time,time];        
        NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlForUss]];
        [request setHTTPMethod:@"post"];
        [request setHTTPBody:data];
        NSURLResponse *response = nil;
        NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString *fetchedStr = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",fetchedStr);
        reginfo.userId = [Contants valuableCodeInTag:@"<Userid>" andTag:@"</Userid>" withString:fetchedStr];
        [Singleton setValues:reginfo.userId withKey:@"userID"];
         *outName = [Contants valuableCodeInTag:@"<Name>" andTag:@"</Name>"withString:fetchedStr];
         *outValue = [Contants valuableCodeInTag:@"<Value>" andTag:@"</Value>"withString:fetchedStr];
        
        if (outValue&&outName) {
            
            return YES;
        }

        
       
    }
     return NO;
}

- (NSString*) fetchSTof:(LoginModel*)reginfo
                lpsName:(NSString*)lpsName
             lpsUserTgt:(NSString*)lpsUtgt
             lpsStRealm:(NSString*)theRealm
           outErrorCode:(NSString**)errorCode
{
    NSString *newStr = [NSString stringWithFormat:@"https://uss.lenovomm.com/authen/1.2/st/get?rdm=%d&%@=%@&source=ios:ios.lesync-1.6&lang=&realm=%@",arc4random(),lpsName,lpsUtgt,theRealm];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newStr]];
    [request1 setHTTPMethod:@"get"];
    NSData *data2 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    NSString *str3 = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSString *strNameValues = [Contants valuableCodeInTag:@"<Value>" andTag:@"</Value>"withString:str3];
    return strNameValues;
}

*/
@end
