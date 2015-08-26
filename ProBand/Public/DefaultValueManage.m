//
//  DefaultValueManage.m
//  iiTagBluetooth
//
//  Created by shi hu on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

#import "DefaultValueManage.h"
@implementation DefaultValueManage

//设置是离开提醒还是靠近提醒

+(void)setLostOrComeValue:(NSString *)type
{
    [[NSUserDefaults standardUserDefaults] setValue:type forKey:@"isLostOrCome"];   
	[[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"setLostOrComeValue=%@",type);
    
    NSString *getType=[self getLostOrComeValue];
    NSLog(@"getType=%@",getType);
    
}
+(NSString *)getLostOrComeValue
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLostOrCome= [SaveDefaults stringForKey:@"isLostOrCome"];
    if (isLostOrCome!=nil) 
    {
        return isLostOrCome;
    }
    return @"";
    
}

//iitag提醒类型 震动 声音 低电量
+(void)setRemindTypeValue:(NSString *)type  theValue:(NSString *)theValue
{
    NSLog(@"tag=%@ theValue=%@",type,theValue);
    if ([type isEqualToString:@"0"]) 
    {
         [[NSUserDefaults standardUserDefaults] setValue:theValue forKey:@"isSound"];  
    }
    else if ([type isEqualToString:@"1"]){
         [[NSUserDefaults standardUserDefaults] setValue:theValue forKey:@"isShock"];  
    } 
    else if ([type isEqualToString:@"2"]){
        [[NSUserDefaults standardUserDefaults] setValue:theValue forKey:@"isBattery"];  
    }
    
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSString *)getRemindTypeValue:(NSString *)typeName
{
    NSLog(@"getRemindTypeName=%@",typeName);
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *theValue= [SaveDefaults stringForKey:typeName];
        
    if (theValue!=nil) 
    {
        return theValue;
    }
    return @"";
    
}
// 保存连接到的设备
+(void)savePeripheral:(NSString  *)address
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
   //NSArray *arr= [SaveDefaults objectForKey:@"Periphera"];
    NSArray *oldSavedArray= [SaveDefaults objectForKey:@"PeripheraArray"];
    NSMutableArray *objectArray=[[NSMutableArray alloc] init];

    NSLog(@"oldSavedArray=%@",oldSavedArray);
    
        if (oldSavedArray != nil)
        { 
            //objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
       
        
        NSLog(@"the  objectArray=%@", objectArray);
    if (![objectArray containsObject:address]) 
    {
        [objectArray addObject:address];
        NSLog(@"savePeripheral arr=%@",objectArray);
        
        NSArray *arrr=[NSArray arrayWithArray:objectArray];
        [[NSUserDefaults standardUserDefaults] setObject:arrr forKey:@"PeripheraArray"];   
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    
}
//获取连接过的设备
+(NSArray *)getSavePeripheral
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrPeriphera= [SaveDefaults objectForKey:@"PeripheraArray"];
    
    return arrPeriphera;
    
}

+(void)removePeripheral:(NSString *)address
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrPeriphera= [[NSMutableArray alloc] init];
    [arrPeriphera addObjectsFromArray:[SaveDefaults objectForKey:@"PeripheraArray"]];
    
    
    if ([arrPeriphera containsObject:address])
    {
        [arrPeriphera removeObject:address];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:arrPeriphera] forKey:@"PeripheraArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)removeAllPeripheral
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PeripheraArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)savePeripheralUUID:(CFUUIDRef)UUID
{
    CFStringRef uuidString = NULL;
    uuidString = CFUUIDCreateString(NULL, UUID);
    
    if (uuidString)
    {
        [[NSUserDefaults standardUserDefaults] setObject:(__bridge id)(uuidString) forKey:@"PeripheraUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CFRelease(uuidString);
}
+(CFUUIDRef)getSavePeripheralUUID
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    CFStringRef uuidString = (__bridge CFStringRef)([SaveDefaults objectForKey:@"PeripheraUUID"]);
    CFUUIDRef UUID = CFUUIDCreateFromString(NULL, (CFStringRef)uuidString);
    return UUID;
}
+(void)saveWriteCharacteristicUUID:(NSString *)uuidString
{
    [[NSUserDefaults standardUserDefaults] setObject:uuidString  forKey:@"WriteCharacteristicUUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getWriteCharacteristicUUID
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *WriteCharacteristicUUID= [SaveDefaults stringForKey:@"WriteCharacteristicUUID"];
    if (WriteCharacteristicUUID!=nil)
    {
        return WriteCharacteristicUUID;
    }
    return @"";
}
+(NSString *)peripheralIdentiferToString:(NSUUID *)identifier
{
    
    NSString *identifierString = [identifier UUIDString];
    return identifierString;
}
+(void)savePeripheralsWithIdentifiers:(NSString *)uuidString
{
    [[NSUserDefaults standardUserDefaults] setObject:uuidString  forKey:@"PeripheralsWithIdentifiers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getPeripheralsIdentifiers
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *WriteCharacteristicUUID= [SaveDefaults objectForKey:@"PeripheralsWithIdentifiers"];
    if (WriteCharacteristicUUID!=nil)
    {
        return WriteCharacteristicUUID;
    }
    return @"";
}

+(void)setPlayMusic:(NSString *)musicName
{
    [[NSUserDefaults standardUserDefaults] setValue:musicName forKey:@"musicName"];   
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getMusicName
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLostOrCome= [SaveDefaults stringForKey:@"musicName"];
    if (isLostOrCome!=nil) 
    {
        return [isLostOrCome stringByReplacingOccurrencesOfString:@".MP3" withString:@""];
    }
    return @"";
}

+(void)saveEmailConfig:(NSDictionary *)dicEmailConfig
{
    [[NSUserDefaults standardUserDefaults] setValue:dicEmailConfig forKey:@"EmailConfig"];   
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)getEmailConfig
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
   return [SaveDefaults objectForKey:@"EmailConfig"];
}

+(void)saveSOSMessage:(NSString *)message
{
    [[NSUserDefaults standardUserDefaults] setValue:message forKey:@"message"];   
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getSOSMessage
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults objectForKey:@"message"];
}

+(NSDictionary *)getUserMessage
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults objectForKey:@"usermessage"];
}
+(void)saveUserMessage:(NSDictionary *)message
{
    [[NSUserDefaults standardUserDefaults] setObject:message  forKey:@"usermessage"];   
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getUserId
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults objectForKey:@"userid"];
}
+(void)saveUserId:(NSString*)Id
{
    [[NSUserDefaults standardUserDefaults] setObject:Id  forKey:@"userid"];   
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)saveValue:(id)Value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:Value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)saveArray:(NSArray *)array forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getValueForKey:(NSString *)key
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults objectForKey:key];
}
+(NSDictionary *)getDictionaryForKey:(NSString *)key
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults dictionaryForKey:key];
}
+(NSArray *)getArrayForKey:(NSString *)key
{
    NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
    return [SaveDefaults arrayForKey:key];
}


@end
