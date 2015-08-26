//
//  DetailBaseController.m
//  ProBand
//
//  Created by star.zxc on 15/6/1.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "DetailBaseController.h"

@interface DetailBaseController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *dateLabel;
    
    NSArray *sleepArray1;
    NSArray *sleepTimeArr1;
    NSArray *sleepArray2;
    NSArray *sleepTimeArr2;
}
@property (nonatomic, strong)UISegmentedControl *segment;
@end

@implementation DetailBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setControllerWithTitle:(NSString *)title UpDescribeArray:(NSArray *)array1 downDescribeArray:(NSArray *)array2 upValueArray:(NSArray *)valueArray1 downValueArray:(NSArray *)valueArray2
{
    UIButton *btnLeft=[PublicFunction getButtonInControl:self frame:CGRectMake(0, 4, 32, 32) imageName:@"return" title:@"" clickAction:@selector(goBack:)];
    UIButton *btnRight=[PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH-40, 0, 32, 32) imageName:@"share_invalid.png" title:@"" clickAction:@selector(share:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    //self.navigationController.navigationBar.alpha = 0;
    UILabel *titleLabel=[PublicFunction getlabel:CGRectMake((SCREEN_WIDTH-80)/2, 0,80, 32) text:@"睡眠详情"  BGColor:[UIColor clearColor] textColor:[UIColor whiteColor] size:16];
    self.navigationItem.titleView=titleLabel;
    
    sleepArray1 = [NSArray arrayWithArray:array1];
    sleepArray2 = [NSArray arrayWithArray:array2];
    sleepTimeArr1 = [NSArray arrayWithArray:valueArray1];
    sleepTimeArr2 = [NSArray arrayWithArray:valueArray2];
    [self createView];
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)share:(UIButton *)sender
{
    
}

- (void)createView
{
    UIImageView *backImageVIew = [PublicFunction getImageView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20) imageName:@"volume_bg.png"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, SCREEN_HEIGHT+80) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.bounces = NO;
    //tableView.backgroundView = backImageVIew;
    tableView.allowsSelection = NO;
    [tableView addSubview:backImageVIew];
    [tableView sendSubviewToBack:backImageVIew];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 400)];
    headView.backgroundColor = [UIColor clearColor];
    
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"日",@"周",@"月"]];
    //_segment.tintColor = [UIColor blueColor];
    _segment.backgroundColor = COLOR(12, 70, 123);
    _segment.selectedSegmentIndex = 0;
    _segment.frame = CGRectMake(SCREEN_WIDTH/2-75, 100, 150, 25);
    _segment.layer.masksToBounds = YES;
    _segment.layer.cornerRadius = 12.5;
    [headView addSubview:_segment];
    
    dateLabel = [PublicFunction getlabel:CGRectMake(0, CGRectGetMaxY(_segment.frame), SCREEN_WIDTH, 30) text:@"2015-5-20" fontSize:16 color:[UIColor whiteColor] align:@"center"];
    [headView addSubview:dateLabel];
    
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
    
    switch (indexPath.row) {
        case 0:
        {
            for (int i = 1; i < sleepTimeArr1.count; i ++)
            {
                CALayer *lineLayer = [[CALayer alloc]init];
                lineLayer.frame = CGRectMake(SCREEN_WIDTH*i/sleepTimeArr1.count, 20, 0.5, 60);
                lineLayer.backgroundColor = [UIColor blackColor].CGColor;
                [cell.contentView.layer addSublayer:lineLayer];
            }
            for (int i = 0; i < sleepTimeArr1.count; i ++) {
                UILabel *describeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepTimeArr1.count+5, 10, SCREEN_WIDTH/sleepTimeArr1.count-10, 30) text:sleepArray1[i] fontSize:14 color:COLOR(80, 96, 114) align:@"center"];
                [cell.contentView addSubview:describeLabel];
                
                UILabel *timeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/3+5, CGRectGetMaxY(describeLabel.frame)+5, SCREEN_WIDTH/3-10, 30) text:sleepTimeArr1[i] fontSize:18 color:COLOR(225, 228, 229) align:@"center"];
                [cell. contentView addSubview:timeLabel];
            }
        }
            break;
        case 1:
        {
            for (int i = 1; i < sleepTimeArr2.count; i ++)
            {
                CALayer *lineLayer = [[CALayer alloc]init];
                lineLayer.frame = CGRectMake(SCREEN_WIDTH*i/sleepTimeArr2.count, 20, 0.5, 60);
                lineLayer.backgroundColor = [UIColor blackColor].CGColor;
                [cell.contentView.layer addSublayer:lineLayer];
            }
            //绘制顶部的线条
            CALayer *lineLayer = [[CALayer alloc]init];
            lineLayer.frame = CGRectMake(60, 0, SCREEN_WIDTH-120, 0.5);
            lineLayer.backgroundColor = [UIColor blackColor].CGColor;
            [cell.contentView.layer addSublayer:lineLayer];
            
            for (int i = 0; i < sleepArray2.count; i ++) {
                UILabel *describeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepArray2.count+5, 10, SCREEN_WIDTH/sleepArray2.count-10, 30) text:sleepArray2[i] fontSize:14 color:COLOR(80, 96, 114) align:@"center"];
                [cell.contentView addSubview:describeLabel];
                
                UILabel *timeLabel = [PublicFunction getlabel:CGRectMake(SCREEN_WIDTH*i/sleepArray2.count+5, CGRectGetMaxY(describeLabel.frame)+5, SCREEN_WIDTH/sleepArray2.count-10, 30) text:sleepTimeArr2[i] textSize:18 textColor:COLOR(225, 228, 229) textBgColor:[UIColor clearColor] textAlign:@"center"];
                [cell. contentView addSubview:timeLabel];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
