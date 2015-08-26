//
//  ProbandListTableViewCell.m
//  ProBand
//
//  Created by attack on 15/6/17.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ProbandListTableViewCell.h"
@interface ProbandListTableViewCell()
{

}
@end
@implementation ProbandListTableViewCell
- (void)awakeFromNib {
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeContentView];
    }
    return self;
}
- (void)makeContentView
{

    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bracelet_uncheck"] highlightedImage:[UIImage imageNamed:@"search_bracelet_selected"]];
    imageview.frame = CGRectMake(105, 20, 10, 10);
    [self.contentView addSubview:imageview];
    
    
    _namelabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame) + 8, 3, CGRectGetWidth(self.frame) - CGRectGetMaxX(imageview.frame), CGRectGetHeight(self.frame))];
    _namelabel.text = @"联想手机";
    _namelabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_namelabel];
    
    UIImageView *topImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.frame), 1)];
    topImageview.image = [UIImage imageNamed:@"search_bracelet_line"];
    [self.contentView addSubview:topImageview];
    UIView *view = [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = ColorRGB(9, 65, 98);
    self.selectedBackgroundView = view;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
