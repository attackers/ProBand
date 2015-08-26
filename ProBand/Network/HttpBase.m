//
//  HttpBase.m
//  LenovoVB10
//
//  Created by zhuzhuxian on 15/5/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "HttpBase.h"

@implementation HttpBase
#define weburl @"http://192.168.2.231:8169/"

-(NSMutableURLRequest *)getRequest:(NSString *)url
{
    url=[NSString stringWithFormat:@"%@",url];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"get url=%@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:12];
    [request setHTTPMethod:@"GET"];
    
    return request;
}
-(NSMutableURLRequest *)getPostRequest:(NSString *)urlString paras:(NSString *)paras
{

    NSString *post =[paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
     //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

-(NSMutableURLRequest *)getRequestPostImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName
{
    NSLog(@"postToUrl:%@ Form:%@ imageKey:%@",urlString,ParaDic,imageName);
    NSString *boundary = @"iOS_fenda_zhuzhuxian_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageName,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(img)]];
    
    
    
    for (NSString*key in [ParaDic allKeys]) {
        NSLog(@"%@ - %@",key,[ParaDic objectForKey:key]);
        NSString *value = [ParaDic objectForKey:key];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    //Now all we need to do is make a connection to the server and send the request:
    [request setHTTPBody:body];
    return request;//[NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}


-(void)getWithPath:(NSString *)Path  ParaDic:(NSDictionary *)ParaDic
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++) {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0) {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
        }else{
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
        }
    }
    
    NSMutableURLRequest *request=[self getRequest:[NSString stringWithFormat:@"%@?%@",Path,ParaString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && responseCode == 200)
        {
            
            //NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
            //NSLog(@"responseData: %@",responseString);
            if (self.requestBlock)
            {
                self.requestBlock(data,error);
            }
        }
        else
        {
            if (self.requestBlock)
            {
                self.requestBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],error);
            }
        }
    }];
    
}
-(void)postToPath:(NSString *)Path ParaDic:(NSDictionary *)ParaDic
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++) {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0) {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
//            ParaString = [NSString stringWithFormat:@"%@=%@",key,[self URLEncodeStringFromString:ParaDic[key]]];
        }else{
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
//            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,[self URLEncodeStringFromString:ParaDic[key]]];
        }
    }
    

    NSMutableURLRequest *request=[self getPostRequest:Path paras:ParaString];

    NSLog(@"url=%@",Path);
    NSLog(@"paras=%@",ParaString);

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            
            NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
            
            NSLog(@"responseData: %@",responseString);
          
            if (self.requestBlock)
            {
                self.requestBlock(data,error);
            }
        }
        else
        {
            NSLog(@"error=%@",error.description);
          
            if (self.requestBlock)
            {
                self.requestBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],error);
            }
        }
 
    }];  
}


-(void)uploadImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName
{

    NSMutableURLRequest *request=[self getRequestPostImageToUrl:urlString ParaDic:ParaDic andImage:img imageName:imageName];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            
            NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
            
            NSLog(@"responseData: %@",[NSString stringWithUTF8String:[data bytes]]);
            
            if (self.requestBlock)
            {
                self.requestBlock(data,error);
            }
        }
        else
        {
            NSLog(@"error=%@",error.description);
            
            if (self.requestBlock)
            {
                self.requestBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],error);
            }
        }
        
    }];  
}


- (NSString*)dicToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
