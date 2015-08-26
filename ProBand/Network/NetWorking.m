//
//  NetWorking.m
//  LenovoVB10
//
//  Created by fenda on 14/12/23.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking

/**
 *  get 获取数据
 *
 *  @param url    下载地址
 *  @param params 请求参数字典
 *  @param key    节点字段名，可为nil
 */
- (void) startGet:(NSString *)url
           params:(NSDictionary *)params
          dataKey:(NSString *)key{
    
  
    NetWorkBase *network = [[NetWorkBase alloc] init];
    network.completion = ^(id result){
        
       // NSLog(@"~~~~1111222~~~~~~~~%@",result);
        
        [self requestComplete:result];
    };
    [network getMethod:url
           requestType:@"GET"
                params:params
             fileArray:nil
               dataKey:key];
}

/**
 *  post 获取数据
 *
 *  @param url    下载地址
 *  @param params 请求参数字典
 *  @param key    节点字段名，可为nil
 */
- (void)startPost:(NSString *)url
           params:(NSDictionary *)params
          dataKey:(NSString *)key{
    
    NetWorkBase *network = [[NetWorkBase alloc] init];
    network.completion = ^(id result){
        [self requestComplete:result];
    };
    
    [network getMethod:url
           requestType:@"POST"
                params:params
             fileArray:nil
               dataKey:key];
}

/**
 *  post 上传数据
 *
 *  @param url    上传地址
 *  @param params 需要上传的参数名
 *  @param files  需要上传的文件
 *  @param key    节点字段名，可为nil
 */
- (void)startPost:(NSString *)url
           params:(NSDictionary *)params
            files:(NSArray *)files
          dataKey:(NSString *)key{
    NetWorkBase *network = [[NetWorkBase alloc] init];
    network.completion = ^(id result){
        [self requestComplete:result];
    };
    
    //图片处理
    NSMutableArray *fileArray;
    if (files && files.count>0) {
        fileArray = [NSMutableArray array];
        for (int i = 0; i<files.count; i++) {
            NSDictionary *dic = files[i];
            //上传的图片在数组字典中对应的关键字是image
            UIImage *image = [self scaleImage:dic[@"image"] tosize:CGSizeMake(80, 80)];
            
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil) {
                //0.6为压缩系数
                data = UIImageJPEGRepresentation(image, 0.6);
            }else{
                data = UIImagePNGRepresentation(image);
                
            }
            
            //图片重命名
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [paths objectAtIndex:0];
            NSString *filePath = [cachePath stringByAppendingFormat:@"/showImage-%d.png",i];
            
            //图片保存路径
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filePath contents:data attributes:nil];
            
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newDic setObject:filePath forKey:@"path"];
            [fileArray addObject:newDic];
            
            
        }
    }

    [network getMethod:url
           requestType:@"POST"
                params:params
             fileArray:fileArray
               dataKey:key];
    
}

/**
 * 文件下载请求
 *
 *  @param urlstr 文件下载地址 如 @"http://localhost/itcast/videos/01.mp4"
 *  @param unzip 是否需要解压
 */
- (void)downloadfilewithURL:(NSString *)downloadUrl withUnzip:(BOOL)unzip{
      NetWorkBase *network = [[NetWorkBase alloc] init];
     [network downloadFilewithURL:downloadUrl withUnzip:unzip];
}

//虚函数
- (void)startRequest{
    //子类做其它操作
}


//图片压缩处理500*500
- (UIImage *)scaleImage:(UIImage *)image tosize:(CGSize)size{
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


/**
 *  在vb10中登陆、注册、找回密码等接口为特列，故添加此接口
 *
 *  @param type 请求类型
 *  @param url  请求地址
 *  @param dic  需要拼接的参数
 */
- (void)startRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic  isUrlEncode:(BOOL)isUrlEncode
{
   
    NSLog(@"url=%@ dic=%@",url,dic);
    NSString *dataString = nil;
    if (isUrlEncode) {
        for (int i = 0; i <[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            if (i == 0) {
                dataString = [NSString stringWithFormat:@"%@=%@",key,[self URLEncodeStringFromString:dic[key]]];
            }else{
                dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,[self URLEncodeStringFromString:dic[key]]];
            }
        }
    }
    else
    {
        for (int i = 0; i <[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            if (i == 0) {
                dataString = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
            }else{
                dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,dic[key]];
            }
        }
    }
    
 
    //dataString=[self URLEncodeStringFromString:dataString];
     NSLog(@"patas=%@",dataString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:type];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLProtocol setProperty:[NSNumber numberWithInt:(int)data.length] forKey:@"Content-Length" inRequest:request];
    [request setHTTPBody:data];
   // NSHTTPURLResponse *responceStr = nil;
    
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
                           ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                               
//                                NSLog(@"---->resultStr>>>>>-----%@",resultStr);
                               if (self.completion) {
                                   self.completion(resultStr,YES);
                               }
                               //[error code] is NSURLErrorTimedOut
                           }];
   // NSData *resultData = [NSURLConnection sendaSynchronousRequest:request returningResponse:&responceStr error:nil];
    
  
    

}

- (BOOL)sendSyncRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic isUrlEncode:(BOOL)isUrlEncode
{
    NSString *dataString = nil;
    if (isUrlEncode) {
        for (int i = 0; i <[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            if (i == 0) {
                dataString = [NSString stringWithFormat:@"%@=%@",key,[self URLEncodeStringFromString:dic[key]]];
            }else{
                dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,[self URLEncodeStringFromString:dic[key]]];
            }
        }
    }
    else
    {
        for (int i = 0; i <[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            if (i == 0) {
                dataString = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
            }else{
                dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,dic[key]];
            }
        }
    }
    
    
    //dataString=[self URLEncodeStringFromString:dataString];
    //NSLog(@"patas=%@",dataString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:type];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLProtocol setProperty:[NSNumber numberWithInt:(int)data.length] forKey:@"Content-Length" inRequest:request];
    [request setHTTPBody:data];
    request.timeoutInterval = 5;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (result == nil) {
        NSLog(@"send request failed: %@", error);
        return NO;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    NSString *retcode=[NSString stringWithFormat:@"%@",dict[@"retcode"]];
    if ([retcode isEqualToString:@"10000"])
        return YES;
    else
        return NO;
}

- (void)startRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic
{
    NSString *dataString = nil;
        for (int i = 0; i <[dic allKeys].count; i++) {
            NSString *key = [dic allKeys][i];
            if (i == 0) {
                dataString = [NSString stringWithFormat:@"%@=%@",key,[self URLEncodeStringFromString:dic[key]]];
            }else{
                dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,[self URLEncodeStringFromString:dic[key]]];
            }
        }
    //dataString=[self URLEncodeStringFromString:dataString];
    //NSLog(@"patas=%@",dataString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:type];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLProtocol setProperty:[NSNumber numberWithInt:(int)data.length] forKey:@"Content-Length" inRequest:request];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error)
    {
         //异步请求返回的result为10001
         NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"---resultStr:%@",resultStr);
         // NSLog(@"---->statusCode>>>>>-----%d",response.);
         if (self.completion) {
             self.completion(resultStr,YES);
         }
         //[error code] is NSURLErrorTimedOut
     }];
 
}

/*
- (void)startRequestWithType:(NSString *)type withUrl:(NSString *)url  withInfo:(NSDictionary *)dic{
    
    NSString *dataString = nil;
    for (int i = 0; i <[dic allKeys].count; i++) {
        NSString *key = [dic allKeys][i];
        if (i == 0) {
            dataString = [NSString stringWithFormat:@"%@=%@",key,[self URLEncodeStringFromString:dic[key]]];
        }else{
            dataString = [NSString stringWithFormat:@"%@&%@=%@",dataString,key,[self URLEncodeStringFromString:dic[key]]];
        }
    }
    
    //dataString=[self URLEncodeStringFromString:dataString];
    //NSLog(@"patas=%@",dataString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:type];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLProtocol setProperty:[NSNumber numberWithInt:(int)data.length] forKey:@"Content-Length" inRequest:request];
    [request setHTTPBody:data];
    NSHTTPURLResponse *responceStr = nil;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responceStr error:nil];
    
    NSString *resultStr = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    
    // NSLog(@"---->statusCode>>>>>-----%d",responceStr.statusCode);
    if (self.completion) {
        self.completion(resultStr,YES);
    }
    
}
*/
//需要替换一些特殊字符
- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}
//回调，由于每个接口returnCode值不同，故这里由各子类去实现
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

@end
