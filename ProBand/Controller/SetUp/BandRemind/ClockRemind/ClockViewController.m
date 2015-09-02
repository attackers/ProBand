//
//  ClockViewController.m
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "ClockViewController.h"
#import "EditClockController.h"
#import "SubSegmentedControl.h"
#import "t_alarmModel.h"
#import "AlarmManager.h"
#import "SendCommandToPeripheral.h"
#import "GetDataForPeriphera.h"
@interface ClockViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSIndexPath *touchPath;
    NSMutableArray *alarmArr;
}
@end

@implementation ClockViewController
- (void)addTestData
{
    t_alarmModel *model = [[t_alarmModel alloc] init];
    NSString *open_id = [Singleton getValueWithKey:@"open_id"];
    if (open_id == nil) return;
    model.userid = open_id;
    model.interval_switch = @"0";
    model.repeat_switch = @"0";
    model.mac = @"6a:4a:ac:a5:33:63";
    model.from_device = @"1";
    model.startTimeMinute = @"420";
    model.days_of_week = @"126";
    model.interval_time = @"30";
    model.notification = @"222!!!";
    model.alarm_switch = @"1";
    
    [AlarmManager insertOrUpdateAlarmData:model];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[[AlermInformation alloc]init] alermList];
    NSMutableArray *alerS = [NSMutableArray array];
    [[GetDataForPeriphera alloc]returnMyAlarmList:^(NSMutableArray *alermArray) {
        [alerS addObject:alermArray];
    }];
    alarmArr = [NSMutableArray arrayWithArray:alerS];

    NSArray *arr = [AlarmManager getAlarmDicFromDB];
    
    
    alarmArr = [NSMutableArray arrayWithArray:arr];
    [_tableView reloadData];
    
    //再次出现时要检测
    UILabel *label = (UILabel *)[self.view viewWithTag:8888];
    if (alarmArr.count>0 && label)
    {
        label.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self addTestData];
    
    self.titleLabel.text = NSLocalizedString(@"alarm", nil);
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:nil forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"remind_add"] forState:UIControlStateNormal];
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    //    _tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    longPress.minimumPressDuration = 1;
    [_tableView addGestureRecognizer:longPress];
    
    //添加by Star
    UILabel *relabel  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-60, 200, 30)];
    relabel.text = @"没有闹钟,请添加闹钟";
    relabel.textColor = [UIColor lightGrayColor];
    relabel.textAlignment = NSTextAlignmentCenter;
    relabel.tag = 8888;
    [self.view addSubview:relabel];
    if (alarmArr.count>0) {
        relabel.hidden = YES;
    }else
    {
        relabel.hidden = NO;
    }
}

#pragma mark - TableVIewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return alarmArr.count;
    //    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    cell.backgroundColor = [UIColor clearColor];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        for (UIView *vi in cell.contentView.subviews) {
            [vi removeFromSuperview];
        }
    }
    NSDictionary *dic =  alarmArr[indexPath.row];
    NSString *timeStr = dic[@"startTimeMinute"];
    NSString *time = [AlarmManager minuteToTime:timeStr];
    NSString *text = dic[@"notification"];

    UILabel *timeLabel = [PublicFunction getlabel:CGRectMake(13, 0, 60, 50) text:time fontSize:22 color:COLOR(90, 90, 90)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.tag = 1001;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *textLabel = [PublicFunction getlabel:CGRectMake(80, 0, 100, 50) text:text fontSize:14 color:COLOR(90, 90, 90)];
    textLabel.tag = 1002;
    textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:textLabel];
    
    UIButton *switchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 66, 7, 71, 37) normalImageName:@"setting_button_sel.png" selectedImageName:@"setting_button.png" title:nil tag:1 clickAction:@selector(switchBtnClick:)];
    [cell.contentView addSubview:switchBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditClockController *edit = [EditClockController new];
    edit.isEditType = YES;
    int index = indexPath.row;
    NSLog(@"%d",index);
    NSLog(@"%@",alarmArr);
    NSDictionary *alarmDic = alarmArr[index];
    edit.currentModel = [t_alarmModel convertDataToModel:alarmDic];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)switchBtnClick:(UIButton *)btn
{
    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1001];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1002];
    btn.selected = !btn.selected;
    if (!btn.selected) {
        textLabel.textColor = COLOR(90, 90, 90);
        timeLabel.textColor = COLOR(90, 90, 90);
    }else{
        textLabel.textColor = [UIColor grayColor];
        timeLabel.textColor = [UIColor grayColor];
    }
}

-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton*)sender
{
    EditClockController *edit = [[EditClockController alloc]init];
    edit.isEditType = NO;
    edit.alarmArray = [alarmArr copy];
    [self.navigationController pushViewController:edit animated:YES];
    
}

- (void)longPressClick:(UILongPressGestureRecognizer*)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if (alarmArr.count == 0) {
            return;
        }
        
        CGPoint touchPoint =  [sender locationInView:_tableView];
        touchPath = [_tableView indexPathForRowAtPoint:touchPoint];
        
        UIView *backGrunpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        backGrunpView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
        UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(backGrunpView.frame), CGRectGetWidth(backGrunpView.frame), 190)];
        bottomview.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *deletLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, CGRectGetWidth(backGrunpView.frame)-20, 24)];
        deletLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        deletLabel.text = NSLocalizedString(@"delete_alarm", nil);
        deletLabel.font = [UIFont boldSystemFontOfSize:19];
        
        int row = touchPath.row;
       id model = alarmArr[row];

        UILabel *alarmTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(deletLabel.frame) + 5, CGRectGetWidth(backGrunpView.frame), 24)];
        NSDictionary* mSMDic = [NSDictionary dictionaryWithDictionary:(NSDictionary*)model];
        NSString *sT = [AlarmManager minuteToTime:[mSMDic objectForKey:@"startTimeMinute"]];
        alarmTimeLabel.text = sT;
        alarmTimeLabel.textColor = [UIColor orangeColor];
        alarmTimeLabel.font = [UIFont systemFontOfSize:23];
        alarmTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(alarmTimeLabel.frame)+5, CGRectGetWidth(backGrunpView.frame), 24)];
        titleLabel.text = [mSMDic objectForKey:@"notification"];
        titleLabel.textColor = [UIColor redColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat y = CGRectGetHeight(backGrunpView.frame) - 190;
        [UIView animateWithDuration:0.5f animations:^{
            
            CGRect rect = bottomview.frame;
            rect.origin.y = y;
            bottomview.frame = rect;
            
        }];
        
        
        SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"confirm", nil),NSLocalizedString(@"cancel", nil), nil]];
        seg.frame = CGRectMake(20, CGRectGetHeight(bottomview.frame) - 47, CGRectGetWidth(bottomview.frame) - 40, 37);
        [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
            CGFloat y = CGRectGetHeight(backGrunpView.frame);
            [UIView animateWithDuration:0.5f animations:^{
                
                CGRect rect = bottomview.frame;
                rect.origin.y = y;
                bottomview.frame = rect;
                
            } completion:^(BOOL finished) {
                
                [backGrunpView removeFromSuperview];
                
            }];
            
            if (segmc.selectedSegmentIndex == 0) {
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:touchPath];
                NSLog(@"row:%d section:%d %@",touchPath.row,touchPath.section,cell.textLabel.text);
                [_tableView beginUpdates];
                [alarmArr removeObjectAtIndex:touchPath.row];
                int row = touchPath.row;
                //row = row+1;
                
                //这里移除的id不正确，需要重新获取:by Star
                NSArray *array = [AlarmManager getAlarmDicFromDB];
                NSDictionary *model = [array objectAtIndex:row];
                
                [AlarmManager removeAlarm:[model objectForKey:@"alarmId"]];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:touchPath] withRowAnimation:UITableViewRowAnimationMiddle];
                [_tableView endUpdates];
                
                if (alarmArr.count<=0)
                {
                    UILabel *label = (UILabel *)[self.view viewWithTag:8888];
                    label.hidden = NO;
                }
            }
            segmc.selectedSegmentIndex = -1;
        }];
        [seg.layer setCornerRadius:CGRectGetHeight(seg.frame)/2];
        seg.clipsToBounds = YES;
        [bottomview addSubview:seg];
        [bottomview addSubview:deletLabel];
        [bottomview addSubview:alarmTimeLabel];
        [bottomview addSubview:titleLabel];
        [bottomview addSubview:seg];
        [backGrunpView addSubview:bottomview];
        [[UIApplication sharedApplication].keyWindow addSubview:backGrunpView];
    }
}
@end
