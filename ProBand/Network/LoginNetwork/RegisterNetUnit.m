//
//  RegisterNetUnit.m
//  LenovoVB10
//
//  Created by yumiao on 15/1/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "RegisterNetUnit.h"
#import "NSString+MD5Addition.h"

#define LEHTTP_OK (200)
static NSString* LDS_SID_4_USS = @"russ001";
static NSString* USS_NEW_USER = @"accounts/1.2/user/new/alldevice?";
static NSString* LDS_ADDR_PREFIX = @"http://lds.lenovomm.com/addr/1.0/query?didt=sn&sid=";

@implementation RegisterNetUnit

SINGLETON_SYNTHE
- (void)requestComplete:(id)result{
    
    [[Loading shareInstance] stopLoading];
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary *)result;
        NSArray *allKeys = [dic allKeys];
        //根据接口返回字段相印的修改retCode
        if ([allKeys containsObject:@"retCode"]) {
            NSString *code = [dic objectForKey:@"retCode"];
            if ([code intValue] == 0  && code) {
                flag = YES;
            }
        }
    }
   
    if (self.completion) {
        self.completion(result,flag);
    }
}

- (BOOL) registerUser:(LoginModel*)reginfo outErrorCode:(NSString**)errorCode
{
    
    BOOL retVal = NO;
    *errorCode = nil;
    NSString* urlForUss  = [self getUssUrl];
    NSLog(@"----%@---",urlForUss);
    if (nil != urlForUss && nil != reginfo)
    {
        NSString* registerUrl = [NSString stringWithFormat:@"%@%@%@=%@",
                                 urlForUss, USS_NEW_USER,reginfo.userTypeName, reginfo.userNameValue];
        
        NSMutableURLRequest* request = [self newRequestTo:registerUrl];
        NSData* body = [[reginfo toTgtPostBodyParam:reginfo] dataUsingEncoding:NSUTF8StringEncoding];
        
        int statusCode;
        NSLog(@"--body---%@-----%@--",body,registerUrl);
        NSData* fetchedData = [self sendRequest:request withBody:body forMethod:1 outResponseStatus:&statusCode];
        NSLog(@"----statusCode---%d--",statusCode);
        if (LEHTTP_OK == statusCode)
        {
            retVal = YES;
        }
        else if (nil != fetchedData)
        {
            NSString* result = [[NSString alloc] initWithData:fetchedData encoding:NSUTF8StringEncoding];
            *errorCode = [Contants valuableCodeInTag:@"<Code>" andTag:@"</Code>"withString:result];
            
            NSLog(@"Register user error:%@", *errorCode);
            
        }
        
    }
    return retVal;
}

- (NSString*)getUssUrl {
   
   NSString * ussServiceUrl = [[self fetchUrlBySid:LDS_SID_4_USS] copy];
  
    return ussServiceUrl;
}
- (NSString*) fetchUrlBySid:(NSString*) sid
{
    NSString* result = nil;
    NSString* resp = nil;
    
    NSString* ldsUrl = [NSString stringWithFormat:@"%@%@", LDS_ADDR_PREFIX , sid];
    
    int statusCode;
    NSMutableURLRequest* request = [self newRequestTo: ldsUrl];
    NSData* fetchedData = nil;
    int tryCount = 2;
    
    while (nil == fetchedData && tryCount-- > 0) {
        fetchedData = [self sendRequest:request withBody:nil forMethod:0 outResponseStatus:&statusCode];
        if (statusCode == LEHTTP_OK && nil != fetchedData)
        {
            //resp = [NSString stringWithCString:[fetchedData bytes] encoding:NSUTF8StringEncoding];
            resp = [[NSString alloc]initWithData:fetchedData encoding:NSUTF8StringEncoding];
        }
    }
    
    if (nil != resp)
    {
        result = [Contants valuableCodeInTag:@"<Address>" andTag:@"</Address>"withString:resp];
        if (nil == result)
        {
            
            NSLog(@"lds url: %@ , for sid:%@", result, sid);
            
        }
        
        /*
         if (StringUtils.isNotBlank(ldsUrl)) {
         String urlPort = addPort(ldsUrl);
         return urlPort;
         }
         */
    }
    return result;
}

//没有自动管理返回值，注意释放
- (NSMutableURLRequest*) newRequestTo:(NSString*)urlString
{
    //2012.9.6添加使用stringWithString方法时参数是否为nil.
    if (nil == urlString) {
        NSLog(@"calling newRequestTo function error by null parameter");
        return nil;
    }
    //@todo: this is a hack to prevent the request to cache.
    NSRange questionMark = [urlString rangeOfString:@"?"];
    NSMutableString* randomUrl = [NSMutableString stringWithString:urlString];
    NSRange tgtRange = [urlString rangeOfString:@"tgt/user/get"];
    NSRange regRange = [urlString rangeOfString:@"user/new/alldevice"];
    NSRange modifyRange = [urlString rangeOfString:@"passwd/modify"];
    NSRange resetPassRange = [urlString rangeOfString:@"passwd/forgot"];
    NSRange smsVerifyRange = [urlString rangeOfString:@"passwd/forgot_smsverify"];
    
    //it's not get tgt && not registration
    if (tgtRange.location == NSNotFound
        && regRange.location == NSNotFound
        && modifyRange.location == NSNotFound
        && resetPassRange.location == NSNotFound
        && smsVerifyRange.location == NSNotFound) {
        if (questionMark.location != NSNotFound) {
            [randomUrl insertString:[NSString stringWithFormat:@"rdm=%d&", arc4random()] atIndex:questionMark.location+1];
        }
        else {
            [randomUrl appendFormat:@"?rdm=%d", arc4random()];
        }
    }
    
    NSURL *url = [NSURL URLWithString:randomUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:url
                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                    timeoutInterval:60.0 ];
    //[request setHTTPMethod:@"POST"];
    [NSURLProtocol setProperty:@"application/x-www-form-urlencoded" forKey:@"Content-type" inRequest:request];
    [NSURLProtocol setProperty:@"en-US" forKey:@"Content-Language" inRequest:request];
    [NSURLProtocol setProperty:@"application/octet-stream" forKey:@"Accept" inRequest:request];
    [NSURLProtocol setProperty:@"close" forKey:@"Connection" inRequest:request];
    
    return request;
}
- (NSData*) sendRequest:(NSMutableURLRequest*)request
               withBody:(NSData*)body
              forMethod:(int)reqMethod
      outResponseStatus:(int*)respStatus
{
    if (nil != respStatus) *respStatus = -1;
    
    NSData* fetchedData = nil;
    if (nil != request)
    {
        NSURLResponse* response = nil;
        NSError* error = nil;
        
        switch (reqMethod)
        {
            case 0:
                [request setHTTPMethod:@"GET"];
                break;
            case 1:
                [request setHTTPMethod:@"POST"];
                break;
        }
        if (nil != body)
        {
            [NSURLProtocol setProperty:[NSNumber numberWithInt:[body length]] forKey:@"Content-Length" inRequest:request];
            [request setHTTPBody:body];
        }
        
        fetchedData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
        
        //NSLog(@"status code: %d", [response statusCode]);
        int status = [(NSHTTPURLResponse *)response statusCode] ;
        if (nil != respStatus) *respStatus = status;
        if(status != 200) {
            NSLog(@"httpstatus:%d, message:%@, requestUrl:%@",
                  status,
                  [NSHTTPURLResponse localizedStringForStatusCode:status],
                  [request URL]);
        }
        if (error != nil) {
            NSLog(@"%@", [error description]);
        }
        
    }
    
    return fetchedData;
}

@end
