//
//  Base64.h
//  LenovoVB10
//
//  Created by admin on 15/4/10.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {
    
}
+ (void) initialize;
+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;
@end

/*
 NSString *authString = [[NSString stringWithFormat:@"OD0EK819OJFIFT6OJZZXT09Y1YUT1EJ2"]
 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 
 NSData *inputData = [authString dataUsingEncoding:NSUTF8StringEncoding];
 
 NSString *finalAuth =[Base64 encode:inputData];
 NSLog(@"Encoded string =%@", finalAuth);
 
 */