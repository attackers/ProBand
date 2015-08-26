//
//  CustomDatePickerView.m
//  CustomPickerView
//
//  Created by attack on 15/7/2.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "CustomDatePickerView.h"
#import "SubSegmentedControl.h"
#import "UIView+Toast.h"
@interface CustomDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *timeArrayHour;
    NSMutableArray *timeArrayminute;
    
    NSMutableArray * kValueArray;
    NSMutableArray * mValueArray;
    
    UIPickerView *timePickerview;
    
    NSString *hourStg;
    NSString *minStg;
}
@end

@implementation CustomDatePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4f];
    [self initArray];
    timePickerview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-215, CGRectGetWidth(self.view.frame), 150)];
    timePickerview.delegate = self;
    timePickerview.dataSource = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 215, CGRectGetWidth(self.view.frame), 215)];
    SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObject:@"确定"]];
    seg.frame = CGRectMake(20, CGRectGetHeight(view.frame) - 57, CGRectGetWidth(view.frame) - 40 , 37);
    seg.layer.cornerRadius = CGRectGetHeight(seg.frame)/2;
    [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
        if (hourStg == nil || minStg == nil) {
            
            [self.view makeToast:@"请选择小时或分钟" duration:2.0 position:@"center"];
            
        }else{
            
            if (_timevalues) {
                _timevalues(hourStg,minStg);
            }
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
        segmc.selectedSegmentIndex = -1;
    }];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:seg];
    [self.view addSubview:view];
    [self.view addSubview:timePickerview];
    [timePickerview selectRow:24 inComponent:0 animated:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.frame;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button atIndex:0];

}
- (void)removeSelf
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (void)initArray
{
    timeArrayHour = [NSMutableArray array];
    timeArrayminute = [NSMutableArray array];
    kValueArray = [NSMutableArray array];
    mValueArray = [NSMutableArray array];
    for (int i = 0; i < 48; i++) {
        if (i>23) {
            
            [timeArrayHour addObject:[NSString stringWithFormat:@"%d",abs(i-24)]];
            
        }else{
            
            [timeArrayHour addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
    }
    for (int i = 0; i < 60; i++) {
        
        [timeArrayminute addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0; i < 100; i++) {
        
        [kValueArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0; i < 10; i++) {
        
        [mValueArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    switch (component) {
        case 0:
            return _modelType == showDate?timeArrayHour.count:kValueArray.count;
            break;
        case 1:
            return _modelType == showDate?timeArrayminute.count:mValueArray.count;
        default:
            break;
    }

    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return _modelType == showDate?timeArrayHour[row]:kValueArray[row];
            break;
         case 1:
            return _modelType == showDate?timeArrayminute[row]:mValueArray[row];
        default:
            break;
    }
    return nil;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    switch (component) {
        case 0:
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2, 50)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame) - 40, CGRectGetHeight(view.frame))];
            label.text = _modelType == showDate?timeArrayHour[row]:kValueArray[row];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:24];
            
            int y =  _modelType == showDate?18:30;
            int h =  _modelType == showDate?16:6;
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame) - 13, y, 6, h)];
            [view addSubview:imageview];
            [view addSubview:label];
            return view;
        }
            break;
        case 1:
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 0, CGRectGetWidth(self.view.frame)/2 - 40, 50)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
            label.text = _modelType == showDate?timeArrayminute[row]:mValueArray[row];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:24];

            [view addSubview:label];
            return view;
        }
            break;
        default:
            break;
    }

    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView *view = [pickerView viewForRow:row forComponent:component];
    NSArray *array = [view subviews];
    for (UIView *subv in array) {//for
        if ([subv isKindOfClass:[UILabel class]]) {//类型
            UILabel *lable = (UILabel*)subv;
            switch (component) {//列
                case 0:
                {
                    lable.attributedText = [self returnTimeString:_modelType == showDate?timeArrayHour[row]:kValueArray[row]];
                    hourStg = _modelType == showDate?timeArrayHour[row]:kValueArray[row];
                }
                    break;
                case 1:
                {
                    lable.attributedText =_modelType == showDate?[self returnTimeString:timeArrayminute[row]]:[self returnKMString:mValueArray[row]];
                    
                    
                    minStg = _modelType == showDate?timeArrayminute[row]:mValueArray[row];
                }
                    break;
                default:
                    break;
            }//列
            
        }else if ([subv isKindOfClass:[UIImageView class]]){//类型
        
            UIImageView *imageview = (UIImageView *)subv;
            NSString *ImageName = _modelType == showDate?@"setting_point":@"volume_point";
            imageview.image = [UIImage imageNamed:ImageName];
            
        }//类型
    }//for

}
- (NSAttributedString*)returnTimeString:(NSString*)stg
{
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
    NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:34],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
    return string;
}
- (NSAttributedString*)returnKMString:(NSString*)stg
{
  stg = [stg stringByAppendingString:@"km"];
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
    NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:34],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithAttributedString:string];
       NSDictionary *mStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil];
    [mString setAttributes:mStringDic range:NSMakeRange(stg.length - 2, 2)];
    return mString;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (void)returnSelectTime:(PickerviewSelectTime)timeSelectd;
{
    _timevalues = ^(NSString* hour,NSString* minu){
        
        timeSelectd(hour,minu);
    };

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
