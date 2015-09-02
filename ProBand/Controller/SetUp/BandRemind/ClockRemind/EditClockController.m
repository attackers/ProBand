//
//  EditClockController.m
//  ProBand
//
//  Created by Echo on 15/5/19.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "EditClockController.h"
#import "ClockViewController.h"
#import "SendCommandToPeripheral.h"
#import "AlarmManager.h"
#import "XlabTools.h"
#import "FitDataSet_Model.h"
#import "FitDataType_Model.h"
#import "FitDataPoint_Model.h"
#import "SSOTest.h"


typedef void(^PickerviewSelectValue) (NSString* values);
@interface EditClockController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *pickView;
    UInt8 hourArr[24];
    UInt8 minArr[60];
    
    UITableView *_tableView;
    NSArray *_weekArr;
    NSArray *_intervalArr;
    UITextField *_tipsTextField;
    
    //重复按钮
    UIView *repeatBgView;
    UIButton *repeatSwitchBtn;
    NSString *repeatBtnStatus;
    
    //间隔按钮
    UIView *intervalBgView;
    UIButton *intervalSwitchBtn;
    NSString *intervalBtnStatus;
    
    NSMutableArray *weekBtnArrM;
    UInt8 hour;
    UInt8 min;
    NSMutableArray *repeat;
    NSString *intervalValue;
    //day of week
    NSMutableArray *weekBtnArr;
    //intervalBtn
    NSMutableArray *intervalBtnArr;
    
    UInt8 dayofweek;
    
    int alarmId;
    
}
@property (nonatomic,copy) PickerviewSelectValue rowStg;
@end

@implementation EditClockController


@synthesize currentModel,alarmArray;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    currentModel = [[alarm_Model alloc] init];
    weekBtnArr = [NSMutableArray array];
    intervalBtnArr = [NSMutableArray array];
    NSArray *arr = @[@0,@0,@0,@0,@0,@0,@0];
    repeat = [NSMutableArray arrayWithArray:arr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (![Singleton getValueWithKey:@"fitDataSourceId"]) {
        [[SSOTest alloc]initNet];
    }
    [self setupData];
    [self creatView];
    
}
- (void)creatView
{
    if (self.isEditType) {
        self.titleLabel.text=NSLocalizedString(@"edit_alarm", nil);
    }else {
        self.titleLabel.text=NSLocalizedString(@"add_alarm", nil);
    }
    
    UIButton *saveBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, 32, 32) imageName:@"picture_editing_confirm.png" title:nil clickAction:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    _weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",NSLocalizedString(@"select_all", nil)];
    _intervalArr = @[@"10\n分钟",@"20\n分钟",@"30\n分钟",@"45\n分钟",@"60\n分钟",@"90\n分钟",@"120\n分钟"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    CGFloat headViewH = 236;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewH)];
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewH-20)];
    
    //    pickView.backgroundColor = [UIColor grayColor];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, pickView.frame.size.height/2-5, 4, 13.5)];
    imageview.image = [UIImage imageNamed:@"setting_point"];
    [pickView addSubview:imageview];
    
    pickView.delegate = self;
    pickView.dataSource = self;
    [headView addSubview:pickView];
    
//    hourArr = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
//        [hourArr addObject:[NSString stringWithFormat:@"%.2d",i]];
        hourArr[i] = i;
    }
    
//    minArr = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        minArr[i] = i;
//        [minArr addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    [pickView selectRow:[self.currentModel.startTimeMinute intValue]/60 inComponent:0 animated:YES];
    [pickView selectRow:[self.currentModel.startTimeMinute intValue]%60 inComponent:1 animated:YES];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickView.frame), SCREEN_WIDTH, 20)];
    separatorView.backgroundColor =COLOR(218, 223, 234);
    [headView addSubview:separatorView];
    
    _tableView.tableHeaderView = headView;
    
    repeatBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
    repeatBgView.tag = 9999;
    CGFloat btnW = (SCREEN_WIDTH-24)/8;
    for (int i=0; i<=7; i++) {
        UIButton *weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weekBtn.frame = CGRectMake(12+(btnW*i), 3, btnW-2, btnW-2);
        [weekBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_02"] forState:UIControlStateNormal];
        [weekBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_01"] forState:UIControlStateSelected];
        [weekBtn setTitle:_weekArr[i] forState:UIControlStateSelected];
        [weekBtn setTitle:_weekArr[i] forState:UIControlStateNormal];
        weekBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [weekBtn setTitleColor:COLOR(153, 153, 153) forState:UIControlStateNormal];
        [weekBtn setTitleColor:COLOR(0, 204, 204) forState:UIControlStateSelected];
        [weekBtn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        weekBtn.tag = i;
        weekBtn.layer.cornerRadius = (btnW-2)/2;
        weekBtn.layer.masksToBounds = YES;
        [repeatBgView addSubview:weekBtn];
        [weekBtnArr addObject:weekBtn];
    }
    [self setupWeekBtnStatus:weekBtnArr];
    intervalBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
    intervalBgView.tag = 8888;
    CGFloat btnW1 = (SCREEN_WIDTH-24)/7;
    for (int i=0; i<7; i++) {
        UIButton *intervalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        intervalBtn.frame = CGRectMake(12+(btnW1*i), 3, btnW-2, btnW-2);
        [intervalBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_02"] forState:UIControlStateNormal];
        [intervalBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_01"] forState:UIControlStateSelected];
        [intervalBtn setTitle:_intervalArr[i] forState:UIControlStateSelected];
        [intervalBtn setTitle:_intervalArr[i] forState:UIControlStateNormal];
        intervalBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        intervalBtn.titleLabel.numberOfLines = 2;
        intervalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [intervalBtn setTitleColor:COLOR(153, 153, 153) forState:UIControlStateNormal];
        [intervalBtn setTitleColor:COLOR(0, 204, 204) forState:UIControlStateSelected];
        [intervalBtn addTarget:self action:@selector(intervalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        intervalBtn.tag = 100+i;
        intervalBtn.layer.cornerRadius = (btnW-2)/2;
        intervalBtn.layer.masksToBounds = YES;
        [intervalBgView addSubview:intervalBtn];
        [intervalBtnArr addObject:intervalBtn];
    }
    [self intervalBtnStatus:intervalBtnArr];
    
}

- (void)intervalBtnStatus:(NSMutableArray*)arr
{
    int interval_time = [self.currentModel.interval_time intValue];
    
    UIButton *btn;
    switch (interval_time) {
        case 10:
            btn = arr[0];
            btn.selected = YES;
            break;
        case 20:
            btn = arr[1];
            btn.selected = YES;
            break;
        case 30:
            btn = arr[2];
            btn.selected = YES;
            break;
        case 45:
            btn = arr[3];
            btn.selected = YES;
            break;
        case 60:
            btn = arr[4];
            btn.selected = YES;
            break;
        case 90:
            btn = arr[5];
            btn.selected = YES;
            break;
        case 120:
            btn = arr[6];
            btn.selected = YES;
            break;
        default:
            break;
    }
}

#pragma mark 设置day_of_week按钮的状态
- (void)setupWeekBtnStatus:(NSMutableArray *)btnArr
{
    int statusValue = [self.currentModel.days_of_week intValue];
    NSString *str = [XlabTools decimalTOBinary:statusValue backLength:7];
    //010101
    if (!repeat) {
        repeat = [[NSMutableArray alloc]init];
    }
    NSLog(@"%@ %d",str, str.length);

    for (int i = 0; i < str.length; i++) {

        UIButton *btn = btnArr[i];
        if (statusValue == 127) {
            btn.selected = YES;
            [btnArr[7] setSelected:YES];
            
        }
        if (statusValue == 0) {
            btn.selected = NO;
            [btnArr[7] setSelected:NO];

        }
        unichar c = [str characterAtIndex:i];
        
        if (c == 49) {
            btn.selected = YES;
            [repeat replaceObjectAtIndex:btn.tag withObject:[NSString stringWithFormat:@"%i",btn.isSelected?1:0]];
        }else{
            btn.selected = NO;
            [repeat replaceObjectAtIndex:btn.tag withObject:[NSString stringWithFormat:@"%i",btn.isSelected?1:0]];
        }
        
    }
    
}

#pragma mark - TableVIewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    if(indexPath.row == 1 ){
        if ([repeatBtnStatus isEqual:@"1"]){
            return 100;
        }
    }
    if (indexPath.row == 2)
    {
        if ([intervalBtnStatus isEqual:@"1"]) {
            return 100;
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        for (UIView *vi in cell.contentView.subviews) {
            [vi removeFromSuperview];
        }
    }
    if (indexPath.row == 0){
        
        UILabel *label = [PublicFunction getlabel:CGRectMake(0, 5, SCREEN_WIDTH, 40) text:NSLocalizedString(@"remind_tips", nil) fontSize:19 color:nil align:@"center"];
        [cell.contentView addSubview:label];
        _tipsTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame), SCREEN_WIDTH-20, 30)];
        _tipsTextField.placeholder = NSLocalizedString(@"input_simple_tips", nil);
        _tipsTextField.delegate = self;
        _tipsTextField.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_tipsTextField];
        _tipsTextField.text = currentModel.notification;
    }else if (indexPath.row == 1) {
        UILabel *label = [PublicFunction getlabel:CGRectMake(12, 5, 150, 40) text:NSLocalizedString(@"repeat", nil) fontSize:19 color:nil align:nil];
        [cell.contentView addSubview:label];
        repeatSwitchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 64, 5, 71, 37) normalImageName:@"setting_button.png" selectedImageName:@"setting_button_sel.png" title:nil tag:222 clickAction:@selector(repeatBtnSwitchClick:)];
        
        [cell.contentView addSubview:repeatSwitchBtn];
        
        if ([repeatBtnStatus isEqual:@"1"])
        {
            repeatSwitchBtn.selected = [repeatBtnStatus boolValue];
            repeatBgView.hidden = NO;
        }else
        {
            repeatBgView.hidden = YES;
        }
        [cell.contentView addSubview:repeatBgView];
    }else if (indexPath.row == 2){
        UILabel *label = [PublicFunction getlabel:CGRectMake(12, 5, 150, 40) text:NSLocalizedString(@"wake_up_interval", nil) fontSize:19 color:nil align:nil];
        [cell.contentView addSubview:label];
        intervalSwitchBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 64, 5, 71, 37) normalImageName:@"setting_button.png" selectedImageName:@"setting_button_sel.png" title:nil tag:333 clickAction:@selector(intervalBtnSwitchClick:)];
        [cell.contentView addSubview:intervalSwitchBtn];
        
        if ([intervalBtnStatus isEqual:@"1"]) {
            intervalSwitchBtn.selected = [intervalBtnStatus boolValue];
            intervalBgView.hidden = NO;
        }else
        {
            if (intervalBgView) {
                intervalBgView.hidden = YES;
            }
        }
        [cell.contentView addSubview:intervalBgView];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return sizeof(hourArr);
    }
    return sizeof(minArr);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%hhu",hourArr[row]];
    }
    return [NSString stringWithFormat:@"%hhu",minArr[row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *cellview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pickView.frame)-60, 30)];
    cellview.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:24],NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName, nil];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cellview.frame), CGRectGetHeight(cellview.frame))];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%hhu",hourArr[row]] attributes:dic];
        timeLabel.attributedText = string;
    }else
    {
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%hhu",minArr[row]] attributes:dic];
        timeLabel.attributedText = string;
    }
    
    [cellview addSubview:timeLabel];
    return cellview;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView *view = [pickerView viewForRow:row forComponent:component];
    NSArray *array = [view subviews];
    
    for (id lable in array)
    {
        if ([lable isKindOfClass:[UILabel class]]) {
            UILabel *lableAttr = (UILabel*)lable;
            if (component == 0) {
                lableAttr.attributedText = [self returnAttributedStringFromString:[NSString stringWithFormat:@"%hhu",hourArr[row]]];
                if (_rowStg) {
                    _rowStg([NSString stringWithFormat:@"%hhu",hourArr[row]]);
                }
                hour = hourArr[row];
                
            }else
            {
                lableAttr.attributedText = [self returnAttributedStringFromString:[NSString stringWithFormat:@"%hhu",minArr[row]]];
                if (_rowStg) {
                    _rowStg([NSString stringWithFormat:@"%hhu",minArr[row]]);
                }
                min = minArr[row];
            }
            currentModel.startTimeMinute = [NSString stringWithFormat:@"%d", hour*60+min];
            NSLog(@"------------  hour:min = %d:%d %@",hour,min,currentModel.startTimeMinute);
        }
    }
}
- (NSMutableAttributedString*)returnAttributedStringFromString:(NSString*)stg
{
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
    NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:34],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
    
    NSMutableAttributedString *muAttStg = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    return muAttStg;
}

#pragma mark : UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int limit = 20;
    NSLog(@"%@",string);
    return !([textField.text length]>limit && [string length] > range.length);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tipsTextField resignFirstResponder];
    NSLog(@"%@", _tipsTextField.text);
    NSLog(@"textFieldShouldReturn");
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    currentModel.notification = _tipsTextField.text;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    currentModel.notification = _tipsTextField.text;
    return YES;
}

#pragma mark weekBtnClick
- (void)weekBtnClick:(UIButton *)btn
{
//    btn.selected = !btn.selected;
//    
//    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
//    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
//    NSArray *array = [cell subviews];
//    UIView *view = (UIView*)array[0];
//    NSArray *viewCell = [view subviews];
//    for (UIView* view in viewCell) {
//        if ([view isKindOfClass:[UIView class]]) {
//            if (view.tag == 9999) {
//                NSArray *subArray = [view subviews];
//                for (UIButton *button in subArray) {
//                    if (btn.tag == 7) {
//                        if (btn.selected) {
//                            button.selected = YES;
//                        }else{
//                            button.selected = NO;
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    //UIButton *button = [weekBtnArr objectAtIndex:btn.tag];
    

    if (btn.tag == 7) {
        if (btn.isSelected) {
            NSArray *arr = @[@1,@1,@1,@1,@1,@1,@1];
            repeat = [NSMutableArray arrayWithArray:arr];
        }else{
            NSArray *arr = @[@0,@0,@0,@0,@0,@0,@0];
            repeat = [NSMutableArray arrayWithArray:arr];
        }
        NSString *string = [repeat componentsJoinedByString:@""];
        dayofweek = btd([string UTF8String]);
        currentModel.days_of_week = [NSString stringWithFormat:@"%d", dayofweek];
        return;
    }
    [btn setSelected:btn.isSelected?NO:YES];
    [repeat replaceObjectAtIndex:btn.tag withObject:[NSString stringWithFormat:@"%i",btn.isSelected?1:0]];
    NSString *string = [repeat componentsJoinedByString:@""];
    dayofweek = btd([string UTF8String]);
    currentModel.days_of_week = [NSString stringWithFormat:@"%d", dayofweek];
    
//    if (btn.selected) {
//        if (btn.tag == 7) {
//            NSArray *arr = @[@1,@1,@1,@1,@1,@1,@1];
//            repeat = [NSMutableArray arrayWithArray:arr];
//        }else{
//            [repeat replaceObjectAtIndex:btn.tag withObject:@1];
//        }
//    }else
//    {
//        if (btn.tag == 7) {
//            NSArray *arr = @[@0,@0,@0,@0,@0,@0,@0];
//            repeat = [NSMutableArray arrayWithArray:arr];
//        }else{
//            [repeat replaceObjectAtIndex:btn.tag withObject:@0];
//        }
//    }


}

#pragma mark intervalBtnClick
- (void)intervalBtnClick:(UIButton *)btn
{
    NSIndexPath *path = [_tableView indexPathForRowAtPoint:[_tableView convertPoint:CGPointZero fromView:btn]];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
    NSArray *array = [cell subviews];
    UIView *view = (UIView*)array[0];
    NSArray *viewCell = [view subviews];
    for (UIView* view in viewCell) {
        if ([view isKindOfClass:[UIView class]]) {
            if (view.tag == 8888) {
                NSArray *subArray = [view subviews];
                for (UIButton *button in subArray)
                {
                    button.selected = NO;
                }
            }
        }
    }
    btn.selected = YES;
    switch (btn.tag) {
        case 100:
            intervalValue =  @"10";
            break;
        case 101:
            intervalValue =  @"20";
            break;
        case 102:
            intervalValue =  @"30";
            break;
        case 103:
            intervalValue =  @"45";
            break;
        case 104:
            intervalValue =  @"60";
            break;
        case 105:
            intervalValue =  @"90";
            break;
        case 106:
            intervalValue =  @"120";
            break;
        default:
            break;
    }
    NSLog(@"btn.tag = %d", btn.tag);
}

#pragma mark saveBtnClick
- (void)saveBtnClick
{
    AlermInformation *alermInformation = [[AlermInformation alloc] init];
    
    /**
     *  闹钟提醒
     *
     *  @param alarmhour          提示时间小时
     *  @param alarmin            提示时间分钟
     *  @param rep                重复周期，1为当天，最高位为0，参数为1-7
     *  @param openCMD            是否开启
     *  @param alerInstervalValue 提示间隔时间，单位为分，为0则响铃一次；
     *  @param capacityOpen       开启智能提醒
     *  @param alerTitle          提醒事项
     */
    
    if (self.isEditType)
    {//编辑闹钟
        currentModel.startTimeMinute = [NSString stringWithFormat:@"%i",hour*60 + min];
        currentModel.days_of_week = [NSString stringWithFormat:@"%i",dayofweek];
        currentModel.interval_time = intervalValue;
        currentModel.from_device = @"0";
        [AlarmManager insertOrUpdateAlarmData:currentModel];
        
    }
    else//添加闹钟
    {
        alarmId = [AlarmManager getMaxAlarmId];
        alarmId++;
        
#warning modeify WD
//修改by Star
//        alarmId = [alarmManage getLastAlarmId];
//        alarmId++;
        currentModel.alarmId = [NSString stringWithFormat:@"%d",alarmId];
        currentModel.userid = [Singleton getUserID];
        currentModel.mac = [Singleton getMacSite];
        currentModel.from_device = @"0";
        currentModel.repeat_switch = repeatBtnStatus;
        currentModel.interval_switch = [NSString stringWithFormat:@"%d",[intervalSwitchBtn isSelected]];
        if (intervalValue) {
             currentModel.interval_time = intervalValue;
        }
        else
        {
            currentModel.interval_time = @"0";
        }
        currentModel.alarm_switch = @"1";
        [AlarmManager insertNewAlarm:currentModel];
        [alermInformation alermRemind:hour alarmMin:min repeat:[self.currentModel.days_of_week integerValue] isopen:1 interval:[intervalValue intValue] capacityAlarm:1 title:currentModel.notification];
    }
    
    NSArray *arrayControllers = self.navigationController.viewControllers;
    BOOL hasPushed = NO;
    for (UIViewController *viewController in arrayControllers)
    {
        if ([viewController isKindOfClass:[ClockViewController class]])
        {
            hasPushed = YES;
            [self.navigationController popToViewController:viewController animated:NO];
        }
    }
    if (!hasPushed)
    {
        [self.navigationController pushViewController:[ClockViewController new] animated:NO];
    }
    
}



-(void)uploadFitDataSet
    {
    FitDataSet_Model *setModel = [[FitDataSet_Model alloc]init];
    setModel.nextPageIndex = @"1";
    setModel.minStartTime = 1436151478;
    setModel.maxEntTime = 1436151500;
    setModel.fitDataTypeName = @"com.lenovo.appdemo.userAlarm";
    setModel.fitDataSourceId = [[Singleton getValueWithKey:@"fitDataSourceId"]intValue];
    setModel.FitDataPoints = [self a];
    
    [HTTPManage uploadFitDataSetWithFitDataSetModel:setModel Withblock:^(NSData *result, NSError *error) {
        
        if (result.length ) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"上傳成功：%@",dict);
        }
    }];
}

-(NSMutableArray *)a {

    FitDataPoint_Model *point1 = [[FitDataPoint_Model alloc]init];
    point1.fitDataSourceId = [[Singleton getValueWithKey:@"fitDataSourceId"]intValue];
    point1.fitDataTypeName = @"com.lenovo.appdemo.userAlarm";
    point1.startTime = 1436151478;
    point1.entTime = 1436151500;
    
    
    FitValue_Model *fitValue1 = [[FitValue_Model alloc]init];
    fitValue1.value = [NSString stringWithFormat:@"%i",alarmId];
    fitValue1.format = 2;
    
    FitValue_Model *fitValue2 = [[FitValue_Model alloc]init];
    fitValue2.value = [NSString stringWithFormat:@"%i",hour];
    fitValue2.format = 2;
    
    FitValue_Model *fitValue3 = [[FitValue_Model alloc]init];
    fitValue3.value = [NSString stringWithFormat:@"%i",min];
    fitValue3.format =2;
    
    FitValue_Model *fitValue4 = [[FitValue_Model alloc]init];
    fitValue4.value = [NSString stringWithFormat:@"%i",dayofweek];;
    fitValue4.format =2;
    
    FitValue_Model *fitValue5 = [[FitValue_Model alloc]init];
    fitValue5.value = intervalValue;
    fitValue5.format =2;
    
    FitValue_Model *fitValue6 = [[FitValue_Model alloc]init];
    fitValue6.value = _tipsTextField.text;
    fitValue6.format =2;
    
    FitValue_Model *fitValue7 = [[FitValue_Model alloc]init];
    fitValue7.value = @"0";
    fitValue7.format =2;
    
    FitValue_Model *fitValue8 = [[FitValue_Model alloc]init];
    fitValue8.value = @"1";
    fitValue8.format =2;
    
    FitValue_Model *fitValue9 = [[FitValue_Model alloc]init];
    fitValue9.value = @"0";
    fitValue9.format =2;
    
    point1.values = [@[fitValue1,fitValue2,fitValue3,fitValue4,fitValue5,fitValue6,fitValue7,fitValue8,fitValue9]mutableCopy];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:point1];
    
    for (t_alarmModel *alarm in alarmArray) {
     
        FitDataPoint_Model *point2 = [[FitDataPoint_Model alloc]init];
        point2.fitDataSourceId = [[Singleton getValueWithKey:@"fitDataSourceId"]intValue];
        point2.fitDataTypeName = @"com.lenovo.appdemo.userAlarm";
        point2.startTime = 1436151478;
        point2.entTime = 1436151500;
        
        FitValue_Model *fit1 = [[FitValue_Model alloc]init];
        fit1.value = alarm.alarmId;
        fit1.format = 2;
        
        FitValue_Model *fit2 = [[FitValue_Model alloc]init];
        fit2.value = [NSString stringWithFormat:@"%i",[alarm.startTimeMinute intValue]/60];
        fit2.format = 2;
        
        FitValue_Model *fit3 = [[FitValue_Model alloc]init];
        fit3.value = [NSString stringWithFormat:@"%i",[alarm.startTimeMinute intValue]%60];
        fit3.format =2;
        
        FitValue_Model *fit4 = [[FitValue_Model alloc]init];
        fit4.value = alarm.days_of_week;
        fit4.format =2;
        
        FitValue_Model *fit5 = [[FitValue_Model alloc]init];
        fit5.value = alarm.interval_time;
        fit5.format =2;
        
        FitValue_Model *fit6 = [[FitValue_Model alloc]init];
        fit6.value = alarm.notification;
        fit6.format =2;
        
        FitValue_Model *fit7 = [[FitValue_Model alloc]init];
        fit7.value = alarm.from_device;
        fit7.format =2;
        
        FitValue_Model *fit8 = [[FitValue_Model alloc]init];
        fit8.value = alarm.alarm_switch;
        fit8.format =2;
        
        FitValue_Model *fit9 = [[FitValue_Model alloc]init];
        fit9.value = @"0";
        fit9.format =2;
        
        point2.values = [@[fit1,fit2,fit3,fit4,fit5,fit6,fit7,fit8,fit9]mutableCopy];
        [array addObject:point2];
    }
    

    
    return array;
}


#pragma mark repeatBtnSwitchClick
- (void)repeatBtnSwitchClick:(UIButton *)btn
{
    NSLog(@"repeatBtnSwitchClick,tag = %ld",(long)btn.tag);
    btn.selected = !btn.selected;
    [_tipsTextField resignFirstResponder];
    repeatBtnStatus = [NSString stringWithFormat:@"%d",repeatSwitchBtn.selected];
    [_tableView reloadData];
    
}

#pragma mark intervalBtnSwitchClick
- (void)intervalBtnSwitchClick:(UIButton *)btn
{
    NSLog(@"intervalBtnSwitchClick,tag = %ld",(long)btn.tag);
    btn.selected = !btn.selected;
    [_tipsTextField resignFirstResponder];
    intervalBtnStatus = [NSString stringWithFormat:@"%d",intervalSwitchBtn.selected];
    currentModel.interval_switch = intervalBtnStatus;
    [_tableView reloadData];
    
}

-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma keyboard notification
- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSLog(@"键盘即将弹出");
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //获取键盘高度
    [UIView beginAnimations:nil context:nil];
    _tableView.contentOffset = CGPointMake(0, height);
    [UIView setAnimationDuration:0.35];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"键盘即将消失");
    
    NSDictionary *useInfo = [notification userInfo];
    
    [UIView beginAnimations:nil context:nil];
    _tableView.contentOffset = CGPointZero;
    [UIView setAnimationDuration:0.35];
    [UIView commitAnimations];
}

- (void)setupData
{
    //首先初始化一个和UI一致的model
    NSDictionary *initDic = @{@"userid":[Singleton getUserID],
                              @"mac":[Singleton getMacSite],
                              @"alarmId":[NSString stringWithFormat:@"%d",[AlarmManager getMaxAlarmId]],
                              @"from_device":@"0",
                              @"startTimeMinute":@"0",
                              @"days_of_week":@"0",
                              @"interval_time":@"0",
                              @"notification":@"",
                              @"repeat_switch":@"0",
                              @"interval_switch":@"0",
                              @"alarm_switch":@"0"};
    if (self.currentModel) {
        currentModel = self.currentModel;
    }
    else if (currentModel == nil)
    {
        currentModel = [t_alarmModel convertDataToModel:initDic];
    }
    repeatBtnStatus = self.currentModel.repeat_switch;
    intervalBtnStatus = self.currentModel.interval_switch;
    
    int intHour = [currentModel.startTimeMinute intValue]/60;
    int intMin = [currentModel.startTimeMinute intValue]%60;
    hour = intHour;
    min =intMin;
    
    //    intervalValue =  @"120";
}

/*将以字符串形式存储在s地址中的二进制数字转换为对应的十进制数字*/
int btd(const char *s)
{
    if (s == NULL) return 0;
    int rt=0;
    int i,n=0;
    
    while (s[n]) n++;
    
    for (--n,i=n; i>=0; i--)
        rt|=(s[i]-48)<<(n-i);
    
    return rt;
}
@end


