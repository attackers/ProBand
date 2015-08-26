//
//  SpeexController.h
//  BLEManager
//
//  Created by attack on 15/7/29.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeexController : UIViewController
@property (nonatomic,strong) NSMutableData *voiceData;
+ (SpeexController*)shareSpeexController;
- (void)writeDataToFile:(NSData *)data;
- (void)speexManageinfomation;
@end
