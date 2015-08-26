//
//  DetailBaseViewController.h
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "BaseViewController.h"
#import "SubBaseViewcontroller.h"
@interface DetailBaseViewController : SubBaseViewcontroller
@property (nonatomic, strong)UIView *headView;
- (void)setControllerWithTitle:(NSString *)title UpDescribeArray:(NSArray *)array1 downDescribeArray:(NSArray *)array2 upValueArray:(NSArray *)valueArray1 downValueArray:(NSArray *)valueArray2 withIndex:(NSInteger)index;
//更新原有视图:能否成功
- (void)updateControllerWithUpDescribeArray:(NSArray *)array1 downDescribeArray:(NSArray *)array2 upValueArray:(NSArray *)valueArray1 downValueArray:(NSArray *)valueArray2;

- (void)hiddenDownView;

- (void)showDownView;
@end
