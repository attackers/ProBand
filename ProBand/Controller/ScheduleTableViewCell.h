//
//  ScheduleTableViewCell.h
//  ProBand
//
//  Created by attack on 15/7/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end
