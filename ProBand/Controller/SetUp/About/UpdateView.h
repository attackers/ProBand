//
//  UpdateView.h
//  ProBand
//
//  Created by star.zxc on 15/5/29.
//  Copyright (c) 2015年 fenda. All rights reserved.
//
/**
 *  用于显示app更新过程的View
 */
#import <UIKit/UIKit.h>

@interface UpdateView : UIView
@property (nonatomic, copy)void (^updateFinished)();
@property (nonatomic, copy)void (^updateFailed)();//更新失败

@end
