//
//  SyncAlertView.h
//  ProBand
//
//  Created by attack on 15/7/14.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncAlertView : UIView
+(SyncAlertView*)shareSyncAlerview:(BOOL)SyncOk;
@property (nonatomic,assign)BOOL isok;
- (void)removeSelf;
@end
