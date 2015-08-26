//
//  ScheduleTableViewCell.m
//  ProBand
//
//  Created by attack on 15/7/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)openAndOff:(UIButton*)sender {
    
    sender.selected = !sender.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
