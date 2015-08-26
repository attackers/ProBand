//
//  CustomPickerView.h
//  CustomPickerView
//
//  Created by attack on 15/7/1.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubSegmentedControl.h"
typedef void(^PickerviewSelectValue) (NSString* values);
typedef NS_ENUM(NSInteger, PickerType) {
    pickerType_age,
    pickerType_height,
    pickerType_weight,
};
@interface CustomPickerView : UIViewController
@property (nonatomic,assign) PickerType pickerType;
@property (nonatomic,copy) PickerviewSelectValue rowStg;
- (void)returnSelectRowString:(PickerviewSelectValue)stg;
@end
