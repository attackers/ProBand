//
//  CustomPickerView.m
//  CustomPickerView
//
//  Created by attack on 15/7/1.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerV;
    UILabel *timeLabel;
    NSMutableArray *ageArray;
    NSMutableArray *heightArray;
    NSMutableArray *weightArray;
//    NSMutableArray *timeArrayHour;
//    NSMutableArray *timeArrayminute;
    
}
@end

@implementation CustomPickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.3f];
    pickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-215, CGRectGetWidth(self.view.frame), 150)];
    pickerV.delegate = self;
    pickerV.dataSource = self;
    ageArray = [NSMutableArray array];
    heightArray = [NSMutableArray array];
    weightArray = [NSMutableArray array];
    for (int i = 3; i< 150; i++) {
        [ageArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 90; i < 251; i++) {
        [heightArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 30; i < 251; i++) {
        [weightArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
//    for (int i = 0; i < 48; i++) {
//        if (i>23) {
//            
//            [timeArrayHour addObject:[NSString stringWithFormat:@"%d",abs(i-24)]];
//
//        }else{
//            
//            [timeArrayHour addObject:[NSString stringWithFormat:@"%d",i]];
//        
//        }
//    }
//    for (int i = 0; i < 60; i++) {
//        
//        [timeArrayminute addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 215, CGRectGetWidth(self.view.frame), 215)];
    SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObject:@"确定"]];
    seg.frame = CGRectMake(20, CGRectGetHeight(view.frame) - 57, CGRectGetWidth(view.frame) - 40 , 37);
    seg.layer.cornerRadius = CGRectGetHeight(seg.frame)/2;
    [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    }];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:seg];
    [self.view addSubview:view];
    [self.view addSubview:pickerV];
    [pickerV selectRow:2 inComponent:0 animated:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.frame;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button atIndex:0];
//    [self ]
    
}
- (void)removeSelf
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerType_age:
            return ageArray.count;
        case pickerType_height:
            return heightArray.count;
        case pickerType_weight:
            return weightArray.count;
        default:
            break;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (_pickerType) {
        case pickerType_age:
            return ageArray[row];
        case pickerType_height:
            return heightArray[row];
        case pickerType_weight:
            return weightArray[row];
        default:
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *cellview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pickerV.frame), 30)];
    cellview.backgroundColor = [UIColor whiteColor];
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cellview.frame), CGRectGetHeight(cellview.frame))];
    timeLabel.textAlignment = NSTextAlignmentCenter;

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:24],NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName, nil];
        
    switch (_pickerType) {
        case pickerType_age:
        {
          NSAttributedString *string = [[NSAttributedString alloc]initWithString:ageArray[row] attributes:dic];
            timeLabel.attributedText = string;

        }
            break;
        case pickerType_height:
        {
            NSAttributedString *string = [[NSAttributedString alloc]initWithString:heightArray[row] attributes:dic];
            timeLabel.attributedText = string;
        }
            break;
        case pickerType_weight:
        {
            NSAttributedString *string = [[NSAttributedString alloc]initWithString:weightArray[row] attributes:dic];
            timeLabel.attributedText = string;
        }
            break;
        default:
            break;
    }

    [cellview addSubview:timeLabel];
    return cellview;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView *view = [pickerView viewForRow:row forComponent:component];
    NSArray *array = [view subviews];
    for (id lable in array) {
        if ([lable isKindOfClass:[UILabel class]]) {
            UILabel *lableAttr = (UILabel*)lable;
            
            switch (_pickerType) {
                case pickerType_age:
                {
                    lableAttr.attributedText =  [self returnAttributedStringFromString:ageArray[row]];
                    if (_rowStg) {
                        
                        _rowStg(ageArray[row]);

                    }
                }
                    break;

                case pickerType_height:
                {
                    lableAttr.attributedText =  [self returnAttributedStringFromString:heightArray[row]];
                    if (_rowStg) {
                        
                        _rowStg(heightArray[row]);

                    }

                }
                    break;

                case pickerType_weight:
                {
                    lableAttr.attributedText =  [self returnAttributedStringFromString:weightArray[row]];
                    if (_rowStg) {
                        _rowStg(weightArray[row]);
                    }

                }
                    break;

                default:
                    break;
            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableAttributedString*)returnAttributedStringFromString:(NSString*)stg
{
    
    switch (_pickerType) {
        case pickerType_age:
           // stg = [stg stringByAppendingString:@" 岁"];
            stg = [NSString stringWithFormat:@"   %@ 岁",stg];
            break;
        case pickerType_height:
 
            stg = [NSString stringWithFormat:@"   %@ cm",stg];
            break;
        case pickerType_weight:

            stg = [NSString stringWithFormat:@"   %@ kg",stg];
            break;
        default:
            break;
    }
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
     NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:34],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
        
    NSMutableAttributedString *muAttStg = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    NSDictionary *EditAttStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
    switch (_pickerType) {
        case pickerType_age:
            [muAttStg setAttributes:EditAttStringDic range:NSMakeRange(stg.length - 1, 1)];
            break;
        case pickerType_height:
        case pickerType_weight:
            [muAttStg setAttributes:EditAttStringDic range:NSMakeRange(stg.length - 2, 2)];
            break;
        default:
            break;
    }
    return muAttStg;
}
- (NSAttributedString*)returnTimeString:(NSString*)stg
{
    UIColor *stringColor = [UIColor colorWithRed:24.0/255.0f green:179.0/255.0f blue:176.0/255.0f alpha:1];
    NSDictionary *EditStringDic = [NSDictionary dictionaryWithObjectsAndKeys:stringColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:34],NSFontAttributeName, nil];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:stg attributes:EditStringDic];
    return string;
}
- (void)addHourAndminuteLable:(UIView*)superview hourString:(NSAttributedString*)hourString minuteString:(NSAttributedString*)minuteString
{

    UILabel *hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(superview.frame)/2 - 10, CGRectGetHeight(superview.frame))];
    hourLabel.attributedText = hourString;
    hourLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 20)];

    [imageview setHighlightedImage:[UIImage imageNamed:@"setting_point"]];
    UILabel *minuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame), 0, CGRectGetWidth(superview.frame)/2 - 10, CGRectGetHeight(superview.frame))];
    minuteLabel.attributedText = minuteString;
    
    [superview addSubview:hourLabel];
    [superview addSubview:imageview];
//    [superview addSubview:minuteLabel];

}
- (void)returnSelectRowString:(PickerviewSelectValue)stg
{
    _rowStg = ^(NSString *rowstring){
    
        stg(rowstring);
    
    };
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
