//
//  NetWorkBase.h
//  LenovoVB10
//
//  Created by fenda on 14/12/23.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NetWorkBase : NSObject
@property (nonatomic, strong) void (^completion) (id result);

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
          dataKey:(NSString *)key;

/**
 *  核心文件下载请求
 *
 *  @param urlstr 文件下载地址 如 @"http://localhost/itcast/videos/01.mp4"
 *  @param unzip 是否需要解压
 */
- (void)downloadFilewithURL:(NSString *)downloadUrl withUnzip:(BOOL)unzip;
@end
