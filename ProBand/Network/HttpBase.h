//
//  HttpBase.h
//  LenovoVB10
//
//  Created by zhuzhuxian on 15/5/4.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBase : NSObject

typedef void (^RequestBlock)(NSData *,NSError *);
@property (nonatomic, copy) RequestBlock requestBlock;

-(void)getWithPath:(NSString *)Path  ParaDic:(NSDictionary *)ParaDic;
-(void)postToPath:(NSString *)Path  ParaDic:(NSDictionary *)ParaDic;
-(NSString*)dictToJson:(NSDictionary *)dic;
-(void)uploadImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName;

@end
