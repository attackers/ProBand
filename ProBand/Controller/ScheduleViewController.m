//
//  ScheduleViewController.m
//  ProBand
//
//  Created by attack on 15/7/30.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleTableViewCell.h"
#define myCell @"defaultCell"
@interface ScheduleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *array;
}
@end

@implementation ScheduleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *scheArray = scheduleDefaults;
    array = [NSMutableArray arrayWithArray:scheArray];
    self.titleLabel.text = NSLocalizedString(@"schedule", nil);
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:NSLocalizedString(@"schedule_delete", nil) forState:UIControlStateNormal];
    self.rightBtn.transform = CGAffineTransformMakeScale(1,1);
    [self.rightBtn addTarget:self action:@selector(deleteSchedule:) forControlEvents:UIControlEventTouchUpInside];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ScheduleTableViewCell" bundle:nil] forCellReuseIdentifier:myCell];
    
}
- (void)deleteSchedule:(UIButton*)sender
{
    _tableView.editing =! _tableView.editing;
    for (int i = 0; i<array.count; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        ScheduleTableViewCell *cell = (ScheduleTableViewCell*)[_tableView cellForRowAtIndexPath:indexpath];
        cell.openButton.hidden = _tableView.editing;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self settableFootView];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell == nil) {
        cell = [[ScheduleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }
    NSDictionary *dic = array[indexPath.row];
    NSString *timeSt = [dic objectForKey:@"time"];
    cell.timeLabel.text = [timeSt substringWithRange:NSMakeRange(0, 5)];
    cell.calendarLabel.text = [dic objectForKey:@"content"];
    if ([dic objectForKey:@"dateOrig"]) {
        cell.dateLabel.text = [[dic objectForKey:@"dateOrig"]stringByAppendingFormat:@" %@",[dic objectForKey:@"date"]];
    }else{
     cell.dateLabel.text = [dic objectForKey:@"date"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [array removeObjectAtIndex:indexPath.row];
        saveScheduleDefaults(array);
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
    }

}
- (void)settableFootView
{
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
