//
//  SettingStatus.h
//  LenovoVB10
//
//  Created by yumiao on 15/1/21.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SettingStatus : BaseModel

@property (nonatomic, copy)NSString *clockDaile;
@property (nonatomic, copy)NSString *WeightUnits;
@property (nonatomic, copy)NSString *LenthUnits;
@property (nonatomic, copy)NSString *ColudBackUp;
@property (nonatomic, copy)NSString *Address;
@property (nonatomic,strong)NSString *smsStatus;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic, strong)NSString *Id;
@property (nonatomic,strong)NSString *callState;
@property (nonatomic,strong)NSString *weatherState;
@property (nonatomic,strong)NSString *wecatState;
@property (nonatomic,strong)NSString *WhatsappState;
@property (nonatomic,strong)NSString *FaceBookState;
@property (nonatomic,strong)NSString *TwitterState;
@property (nonatomic,strong)NSString *calendarState;
@property (nonatomic,strong)NSString *FindPhone;
@property (nonatomic, copy)NSString *UnlockPhone;
@property (nonatomic,strong)NSString *LinkLostPhone;
@property (nonatomic,strong)NSString *BatteryPowerPush;

+ (SettingStatus *)instancesFromDictionary:(NSDictionary *)userinfoDic;
//解析从服务器上面拉下来的数据针对不同界面分不同类型
+(SettingStatus *)parserSetStatus:(id)reslut;
@end
