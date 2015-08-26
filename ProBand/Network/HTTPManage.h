//
//  HTTPManage.h
//  LenovoVB10
//
//  Created by admin on 15/4/10.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpBase.h"
@class FitDevice_Model;
@class FitDataSource_Model;
@class FitDataType_Model;
@class FitDataPoint_Model;
@class FitDataSet_Model;

@protocol HttpManageDelegate
@required

- (void)didRequestFinish:(NSString *)receiveString;
- (void)didRequestFail:(NSError *)error;

@end
@interface HTTPManage : NSObject
{
    
}

@property (nonatomic, assign) id delegate;

/**
 *  创建createFitDataSource
 *
 *  @param model FitDataSource_Model
 *  @param block 结果通过block返回
 */
+ (void)createFitDataSourceWithFitDataSourceModel:(FitDataSource_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

/**
 *  通过FitDataSourceId获取FitDataSource
 *
 *  @param fitDataSourceId fitDataSourceId
 *  @param block           结果通过block返回
 */
+ (void)getFitDataSourceBySourceId:(int)fitDataSourceId  Withblock:(void (^)(NSData *,NSError *))block;

/**
 * 通过FitDeviceModel获取FitDataSource
 *
 *  @param fitDeviceModel fitDeviceModel
 *  @param block          结果通过block返回
 */
+ (void)getFitDataSourceByFitDeviceModel:(FitDevice_Model *)fitDeviceModel Withblock:(void (^)(NSData *,NSError *))block;

/**
 * 获取FitDataSourceList
 *
 *  @param block 结果通过block返回
 */
+ (void)getFitDataSourceListWithblock:(void (^)(NSData *,NSError *))block;

/**
 *  创建自定义FitDataType
 *
 *  @param model FitDataType_Model
 *  @param block 结果通过block返回
 */
+ (void)createCustomFitDataTypeWithFitDataTypeModel:(FitDataType_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

/**
 *  上传FitDataPoint
 *
 *  @param model FitDataPoint_Model
 *  @param block 结果通过block返回
 */
+ (void)uploadFitDataPointWithFitDataPointModel:(FitDataPoint_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

/**
 *  获取FitDataSet
 *
 *  @param model FitDataSet_Model
 *  @param block 结果通过block返回
 */
+ (void)getFitDataSetWithFitDataSetModel:(FitDataSet_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

/**
 *  上传FitDataSet
 *
 *  @param model FitDataSet_Model
 *  @param block 结果通过block返回
 */
+ (void)uploadFitDataSetWithFitDataSetModel:(FitDataSet_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

//+ (void)uploadFitDataSetWithFitDataSet_Model:(FitDataSet_Model *)model Withblock:(void (^)(NSData *,NSError *))block;

-(void)registerUsername:(NSString *)Username password:(NSString *)password Nickname:(NSString *)Nickname  block:(void (^)(NSData *,NSError *))block;

+(void)getTokenWithblock:(void (^)(NSData *,NSError *))block;

+(void)uploadImageWithUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName  block:(void (^)(NSData *,NSError *))block;
@end
