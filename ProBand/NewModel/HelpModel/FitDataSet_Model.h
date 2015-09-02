//
//  FitDataSet_Model.h
//  ProBand
//
//  Created by Echo on 15/7/3.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitDataPoint_Model.h"
@interface FitDataSet_Model : NSObject

@property (nonatomic, assign) long minStartTime;    //上传FitDataPoints时的开始时间
@property (nonatomic, assign) long maxEntTime;      //上传FitDataPoints时的结束时间
@property (nonatomic, assign) int fitDataSourceId;  //fitDataSourceId，在第一步时有存储在本地
@property (nonatomic, copy) NSString *fitDataTypeName;//构建自定义Type时的名字，此处应为@"com.lenovo.settings.heartbeat"
@property (nonatomic, strong) NSMutableArray *FitDataPoints;//向服务器请求数据时可不赋值，获取成功需要时可对其赋值
@property (nonatomic, copy) NSString *nextPageIndex;//请求页码，填0

@end
