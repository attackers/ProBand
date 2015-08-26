//
//  DefaultValueManage.h
//  iiTagBluetooth
//
//  Created by shi hu on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  macAddressKey @"macAddress_key"
#define  isOpenANCSKey @"isOpenANCS_key"

#define  SleepType @"SleepType"
#define  StepType @"StepType"
#define  FormatTypeHour  @"FormatTypeHour"
#define  FormatTypeDay @"FormatTypeDay"
#define  FormatTypeMonth @"FormatTypeMonth"
#define  FormatTypeWeek @"FormatTypeWeek"
#define  FormatTypeYear @"FormatTypeYear"

//#import <CoreBluetooth/CoreBluetooth.h>
@interface DefaultValueManage : NSObject
+(NSString *)peripheralIdentiferToString:(NSUUID *)identifier;
+(void)savePeripheralsWithIdentifiers:(NSString *)uuidString;
+(NSString *)getPeripheralsIdentifiers;
+(void)removeAllPeripheral;
+(void)setLostOrComeValue:(NSString *)type;
+(NSString *)getLostOrComeValue;
+(void)setRemindTypeValue:(NSString *)type  theValue:(NSString *)theValue;
+(NSString *)getRemindTypeValue:(NSString *)typeName;
+(void)removePeripheral:(NSString *)address;
+(void)savePeripheral:(NSString *)address;
+(NSArray *)getSavePeripheral;
+(void)setPlayMusic:(NSString *)musicName;
+(NSString *)getMusicName;

+(void)saveEmailConfig:(NSDictionary *)dicEmailConfig;
+(NSDictionary *)getEmailConfig;
+(void)saveSOSMessage:(NSString *)message;
+(NSString *)getSOSMessage;

+(NSDictionary *)getUserMessage;
+(void)saveUserMessage:(NSDictionary *)message;
+(NSString *)getUserId;
+(void)saveUserId:(NSString *)Id;

+(void)savePeripheralUUID:(CFUUIDRef)UUID;
+(CFUUIDRef)getSavePeripheralUUID;
+(void)saveWriteCharacteristicUUID:(NSString *)uuidString;
+(NSString *)getWriteCharacteristicUUID;

+(void)saveValue:(id)Value forKey:(NSString *)key;

+(void)saveArray:(NSArray *)array forKey:(NSString *)key;

+(NSString *)getValueForKey:(NSString *)key;

+(NSDictionary *)getDictionaryForKey:(NSString *)key;

+(NSArray *)getArrayForKey:(NSString *)key;



@end
