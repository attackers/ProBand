//
//  ProbandListTableViewController.h
//  ProBand
//
//  Created by attack on 15/6/17.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectProband) (BOOL begin);
typedef void(^ProbandlistIndex) (NSInteger index);
@interface ProbandListTableViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray *probandlistArray;
@property (nonatomic,copy) SelectProband begin;
@property (nonatomic,copy) ProbandlistIndex listIndex;
- (void)selectProBandAndBeginConnect:(SelectProband)beginconnect;
- (void)probandlistIndex:(ProbandlistIndex)index;
@end
