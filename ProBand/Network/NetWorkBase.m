//
//  NetWorkBase.m
//  LenovoVB10
//
//  Created by fenda on 14/12/23.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "NetWorkBase.h"

static void *ProgressObserverContext = &ProgressObserverContext;

@implementation NetWorkBase

/**
   要使用常规的AFN网络访问
 
   1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   所有的网络请求,均有manager发起
 
   2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
   1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
   2> 如果返回格式不是JSON的,
 
   3. 请求格式
   AFHTTPRequestSerializer            二进制格式
   AFJSONRequestSerializer            JSON
   AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
   4. 返回格式
 
    AFHTTPResponseSerializer           二进制格式
    AFJSONResponseSerializer           JSON
    AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    AFXMLDocumentResponseSerializer (Mac OS X)
    AFPropertyListResponseSerializer   PList
    AFImageResponseSerializer          Image
    AFCompoundResponseSerializer       组合
 */
#pragma mark - 检测网络连接
- (void)reachNetWorkWithBlock:(void (^)(BOOL blean))block;
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域wifi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //NSLog(@"%d", status);
        BOOL isconnect = NO;
        if (status >0) {
            isconnect = YES;
        }
        block(isconnect);
    }];
}
/**
 *  基础请求
 *
 *  @param url    请求地址
 *  @param type   请求类型如post、get、put、head、patch......
 *  @param params 请求参数
 *  @param files  需要上传的文件，如：图片等
 *  @param key    节点字段名，可为nil
 */
- (void)getMethod:(NSString *)url
      requestType:(NSString *)type
           params:(NSDictionary *)params
        fileArray:(NSArray *)files
          dataKey:(NSString *)key{

    [self reachNetWorkWithBlock:^(BOOL blean) {
        if (blean) {//有网络
            [self startRequest:params fileArray:files withUrl:url httpMethod:type dataKey:key];
        }else{
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"network_error", nil)];
            
        }
    }];
}
//核心请求,AF
- (void)startRequest:(NSDictionary *)params
           fileArray:(NSArray *)files
             withUrl:(NSString *)url
          httpMethod:(NSString *)method
             dataKey:(NSString *)key{
    
    NSLog(@"%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request;
    if (files && files.count>0) {//上传文件
        request = [manager.requestSerializer multipartFormRequestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:manager.baseURL] absoluteString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 将本地的文件上传至服务器
            NSURL *filePath = [NSURL fileURLWithPath:[files[0] objectForKey:@"path"]];
            
            NSLog(@"%@",filePath.path);
            NSError *error;
            if ( [formData appendPartWithFileURL:filePath name:@"file" fileName:@"image.png" mimeType:@"image/jpeg" error:&error] == NO)
            {
                NSLog(@"Append part failed with error: %@", error);
                [[Loading shareInstance] stopLoading];
            }
            
        } error:nil];
    }else{
        //NSLog(@"~~~params:~######~~~~%@",params);
        
        request = [manager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:url relativeToURL:manager.baseURL] absoluteString] parameters:params error:nil];
    }
    //请求时间为5秒，超过5秒为超时
//    request.timeoutInterval = 5.0;
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:nil];
        
        if (!jsonObject) {
            
            NSString *str = operation.responseString;
            //NSLog(@"非JSON格式：%@",str);
            if (self.completion) {
                self.completion(operation.responseData);
            }

        } else {
            NSLog(@"返回数据：%@",jsonObject);
            id callbackData = key ? jsonObject [key] : jsonObject;
            if (self.completion) {
                self.completion(callbackData);
            }
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：\n%@ 错误信息：\n%@",error.description,error.userInfo [NSLocalizedDescriptionKey]);
        
        [[Loading shareInstance] stopLoading];
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];

}

#pragma mark - Session 下载
/**
 *  核心文件下载请求
 *
 *  @param urlstr 文件下载地址 如 @"http://localhost/itcast/videos/01.mp4"
 *  @param unzip 是否需要解压@.zip等压缩文件则需要解压
 */
- (void)downloadFilewithURL:(NSString *)downloadUrl withUnzip:(BOOL)unzip;
{
    [self reachNetWorkWithBlock:^(BOOL blean) {
        if (blean) {//有网络
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
            NSString *urlString = downloadUrl;
            
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:urlString];
            //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
            //请求时间为5秒，超过5秒为超时
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
            
            // 指定下载文件保存的路径
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSURL* (^destinationBlock) (NSURL *targetPath, NSURLResponse *response) = ^NSURL* (NSURL *targetPath, NSURLResponse *response){
                
                //response.suggestedFilename下载文件名字，可自定义
                NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                
                NSURL *fileURL = [NSURL fileURLWithPath:path];//本地路径
                NSLog(@"本地保存路径 %@",fileURL);
                return fileURL;
                
            };
            // filePath即上面那个block的返回值
            void (^completionBlock) (NSURLResponse *response, NSURL *filePath, NSError *error) = ^void (NSURLResponse *response, NSURL *filePath, NSError *error){
                NSLog(@"download success, file written to: %@", [filePath path]);
                if(unzip){//需要解压
                    
                    // 下载完成之后，解压缩文件
                    /*
                     参数1:要解结压缩的文件名及路径 [filePath path] - > response.suggestedFilename
                     参数2:要解压缩到的位置，目录    - > document目录
                     */
                    //[SSZipArchive unzipFileAtPath:[filePath path] toDestination:cacheDir];
                    
                    // 解压缩之后，将原始的压缩包删除
                    // NSFileManager专门用于文件管理操作，可以删除，复制，移动文件等操作
                    // 也可以检查文件是否存在
                    // [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
                }
                
                [[Loading shareInstance] stopLoading];
            };
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:destinationBlock completionHandler:completionBlock];
            [downloadTask resume];
            
            //下载写入进度，test
            [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                // 设置进度条的百分比
                CGFloat precent = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
                NSLog(@"%f", precent);
            }];

        }else{
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"network_error", nil)];
            
        }
    }];

   
    
}





@end
