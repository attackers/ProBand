//
//  ExerciseDayView.m
//  ProBand
//
//  Created by star.zxc on 15/8/5.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ExerciseDayView.h"

@implementation ExerciseDayView
{
    NSArray *timeArray;
    NSArray *stepArray;
    NSArray *mileArray;
    NSArray *caloryArray;
    NSArray *avSpeedArray;
     NSArray *upArray;
}
- (id)initWithFrame:(CGRect)frame exerciseModel:(ExerciseSectionModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        upArray = [NSArray arrayWithObjects:@"步数/步",@"里程/千米",@"卡路里/千卡",@"平均速度/小时", nil];
        
        if (model.startArray == nil || model.startArray.count<=0)
        {
            timeArray = [NSArray arrayWithObject:@"00:00-24:00"];
            stepArray = @[@0];
            mileArray = @[@0.0];
            caloryArray = @[@0.0];
            avSpeedArray = @[@0.0];
        }
        else
        {
        timeArray = [NSArray arrayWithArray:model.timeArray];
        stepArray = [NSArray arrayWithArray:model.valueArray];
        mileArray = [NSArray arrayWithArray:model.mileArray];
        caloryArray = [NSArray arrayWithArray:model.caloryArray];
        avSpeedArray = [NSArray arrayWithArray:model.speedArray];
        }
        UITableView *tableView1 = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView1.delegate = self;
        tableView1.dataSource = self;
        tableView1.backgroundColor = [UIColor clearColor];
        tableView1.tableFooterView = [[UIView alloc]init];
        tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView1];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    
    //添加左侧的线条
    UIImageView *pointView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 10, 10)];
    pointView.image = [UIImage imageNamed:@"volume_point"];
    [cell.contentView addSubview:pointView];
    CALayer *leftLine = [CALayer layer];
    leftLine.frame = CGRectMake(14.5, 10, 0.5, 75);
    leftLine.backgroundColor = CGCOLOR(0, 215, 137);
    leftLine.opacity = 0.5;
    [cell.contentView.layer addSublayer:leftLine];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 160, 20)];
    timeLab.text = timeArray[row];
    timeLab.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:timeLab];
    
    //添加一个背景的View
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(timeLab.frame), CGRectGetMaxY(timeLab.frame), SCREEN_WIDTH-CGRectGetMinX(timeLab.frame)-20, 60)];
    bgView.backgroundColor = COLOR(11, 45, 75);
    //bgView.alpha = 0.03;
    [cell.contentView addSubview:bgView];
    //添加下方的label
    CGFloat width = bgView.frame.size.width;
    for (int i = 0; i < 4; i ++)
    {
        UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*i/4, 7, width/4, 15)];
        upLabel.text = upArray[i];
        upLabel.textColor = COLOR(229, 229, 229);
        upLabel.textAlignment = NSTextAlignmentCenter;
        upLabel.alpha = 0.4;
        upLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:upLabel];
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*i/4, 30, width/4, 30)];
        downLabel.textColor = COLOR(229, 229, 229);
        downLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:downLabel];
        switch (i)
        {
            case 0:
                downLabel.text = [NSString stringWithFormat:@"%d",[stepArray[row] intValue]];
                break;
            case 1:
                downLabel.text = [NSString stringWithFormat:@"%.1f",[mileArray[row] floatValue]];
                break;
            case 2:
                downLabel.text = [NSString stringWithFormat:@"%.1f",[caloryArray[row] floatValue]];
                break;
            case 3:
                downLabel.text = [NSString stringWithFormat:@"%.1f",[avSpeedArray[row] floatValue]];
                break;
            default:
                break;
        }
    }
    return cell;
}
@end
