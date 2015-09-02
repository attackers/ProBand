//
//  GetCityDataModel.h
//  LenovoVB10
//
//  Created by jacy on 15/1/24.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseModel.h"

@interface GetCityDataModel : BaseModel
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *weathType;
@property(nonatomic,strong)NSString *fahrenheit;//华氏温度
@property(nonatomic,strong)NSString *centigrad;//摄氏温度
@property(nonatomic,strong)NSString *pm25;

+(GetCityDataModel *)convertDataToModel:(NSDictionary *)aDictionary;
+(void)saveWeather:(NSDictionary *)weathInfoDic;
+ (GetCityDataModel*)getDataModel;
@end
