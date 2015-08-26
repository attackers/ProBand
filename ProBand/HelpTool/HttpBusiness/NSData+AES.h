//
//  NSData+AES.h
//  LenovoVB10
//
//  Created by admin on 15/4/10.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

@interface NSData (AES)

- (NSData *)AES128EncryptedDataWithKey:(NSString *)key;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key;
- (NSData *)AES128EncryptedDataWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptedDataWithKey:(NSString *)key iv:(NSString *)iv;

@end
