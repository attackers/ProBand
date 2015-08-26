//
//  TopAler.h
//  TopAler
//
//  Created by attack on 15/7/8.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopAler : UIView
+ (TopAler*)shareTopAler;
- (void)startShow;
@property (nonatomic,assign)NSString *showText;
@end
