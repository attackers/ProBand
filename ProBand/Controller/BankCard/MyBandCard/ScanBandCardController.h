//
//  ScanBandCardController.h
//  ProBand
//
//  Created by star.zxc on 15/6/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanBandCardController : BaseViewController

@property (nonatomic, copy)void (^postCardNumber)(NSString *number);
@end
