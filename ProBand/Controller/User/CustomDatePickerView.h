//
//  CustomDatePickerView.h
//  CustomPickerView
//
//  Created by attack on 15/7/2.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PickviewType) {
    showDate,
    showKM
};
typedef void(^PickerviewSelectTime) (NSString* hourValues,NSString *minuteValues);
typedef void(^PickerviewSelectMinuteValue) (NSString* MinuteValues);

@interface CustomDatePickerView : UIViewController
@property (nonatomic,copy) PickerviewSelectTime timevalues;
@property (nonatomic,assign)PickviewType modelType;
- (void)returnSelectTime:(PickerviewSelectTime)timeSelectd;
@end
