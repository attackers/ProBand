//
//  EditThingsController.m
//  ProBand
//
//  Created by Echo on 15/5/20.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "EditThingsController.h"

@interface EditThingsController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIDatePicker *_picker;
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_weekArr;
    UITextField *_tipsTextField;
}

@end

@implementation EditThingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self creatView];
}

- (void)creatView
{
    self.title=@"新建提醒";
    UIButton *saveBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, 32, 32) imageName:nil title:@"保存" clickAction:@selector(save)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    UIButton *leftBtn = [PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, 60, 60) imageName:@"" title:@"" clickAction:@selector(gotoBackBtnClick)];
    [leftBtn setImage:[UIImage imageNamed:@"return"] forState:normal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    _weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    _titleArray=[[NSArray alloc] initWithObjects:@"",@"重复",@"永远",nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    CGFloat headViewH = 236;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewH)];
    
    _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewH-20)];
    _picker.datePickerMode = UIDatePickerModeTime;
    [_picker addTarget:self action:@selector(selectDatePicker:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:_picker];
    NSLog(@"_picker.frame = %@",NSStringFromCGRect(_picker.frame));
    //    _picker.backgroundColor = [UIColor yellowColor];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_picker.frame), SCREEN_WIDTH, 20)];
    separatorView.backgroundColor =COLOR(218, 223, 234);
    [headView addSubview:separatorView];
    
    _tableView.tableHeaderView = headView;
    
}


#pragma mark - TableVIewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else if(indexPath.row == 1){
        return 100;
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
    if (indexPath.row == 0) {
        UILabel *label = [PublicFunction getlabel:CGRectMake(0, 5, SCREEN_WIDTH, 40) text:@"提醒信息" fontSize:19 color:nil align:@"center"];
        [cell.contentView addSubview:label];
        _tipsTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame), SCREEN_WIDTH-20, 30)];
        _tipsTextField.placeholder = @"点击输入简单提示";
        _tipsTextField.delegate = self;
        _tipsTextField.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_tipsTextField];
    }else if (indexPath.row == 1) {
        UILabel *label = [PublicFunction getlabel:CGRectMake(12, 5, 150, 40) text:@"重复" fontSize:19 color:nil align:nil];
        [cell.contentView addSubview:label];
        UIButton *repeatBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 64, 5, 71, 37) normalImageName:@"setting_button.png" selectedImageName:@"setting_button_sel.png" title:nil tag:11 clickAction:@selector(repeatBtnClick:)];
        [cell.contentView addSubview:repeatBtn];
        
        CGFloat btnW = (SCREEN_WIDTH-24)/7;
        for (int i=0; i<7; i++) {
            UIButton *weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            weekBtn.frame = CGRectMake(12+(btnW*i), CGRectGetMaxY(label.frame), btnW-2, btnW-2);
            [weekBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_02"] forState:UIControlStateNormal];
            [weekBtn setBackgroundImage:[UIImage imageNamed:@"setting_electricity_01"] forState:UIControlStateSelected];
            [weekBtn setTitle:_weekArr[i] forState:UIControlStateSelected];
            [weekBtn setTitle:_weekArr[i] forState:UIControlStateNormal];
            [weekBtn setTitleColor:COLOR(153, 153, 153) forState:UIControlStateNormal];
            [weekBtn setTitleColor:COLOR(0, 204, 204) forState:UIControlStateSelected];
            [weekBtn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            weekBtn.tag = i;
            weekBtn.layer.cornerRadius = (btnW-2)/2;
            weekBtn.layer.masksToBounds = YES;
            [cell.contentView addSubview:weekBtn];
        }
    }else if (indexPath.row == 2){
        UILabel *label = [PublicFunction getlabel:CGRectMake(12, 5, 150, 40) text:@"永远" fontSize:19 color:nil align:nil];
        [cell.contentView addSubview:label];
        UIButton *foreverBtn =  [PublicFunction getButtonInControl:self frame:CGRectMake(SCREEN_WIDTH - 64, 7, 71, 37) normalImageName:@"setting_button.png" selectedImageName:@"setting_button_sel.png" title:nil tag:11 clickAction:@selector(foreverBtnClick:)];
        [cell.contentView addSubview:foreverBtn];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark : UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int limit = 20;
    NSLog(@"%@",string);
    return !([textField.text length]>limit && [string length] > range.length);
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidBeginEditing");
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidEndEditing");
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldShouldBeginEditing");
//    return YES;
//}
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    NSLog(@"textFieldShouldClear");
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldShouldEndEditing");
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tipsTextField resignFirstResponder];
    NSLog(@"%@", _tipsTextField.text);
    NSLog(@"textFieldShouldReturn");
    return YES;
}


- (void)setupData
{
    
}

- (void)weekBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"weekBtnClick,tag = %ld",(long)btn.tag);
}

-(void)selectDatePicker:(UIDatePicker *)picker
{
    NSString *time = [DateHandle dateToString:picker.date withType:1];
    NSLog(@"---%@---",time);
}

- (void)save
{
    
}

- (void)repeatBtnClick:(UIButton *)btn
{
    NSLog(@"repeatBtnClick,tag = %ld",(long)btn.tag);
    btn.selected = !btn.selected;
}

- (void)foreverBtnClick:(UIButton *)btn
{
    NSLog(@"foreverBtnClick,tag = %ld",(long)btn.tag);
    btn.selected = !btn.selected;
}

-(void)gotoBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
