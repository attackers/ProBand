//
//  NSString+MD5.h
//  LenovoVB10
//
//  Created by jacy on 14/12/10.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5Encrypt;

@end
