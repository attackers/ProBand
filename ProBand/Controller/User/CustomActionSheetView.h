//
//  CustomActionSheetView.h
//  ActionSheet
//
//  Created by attack on 15/7/9.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectIndexButton) (UIButton *button);
@interface CustomActionSheetView : UIView
@property (nonatomic,copy) SelectIndexButton selectIndexButton;
+ (CustomActionSheetView*)sharaActionSheetWithStyle:(NSString *)styleName;
- (void)buttonClick:(UIButton*)sender;
- (void)customActionSheetSelectedIndexButton:(SelectIndexButton)indexButton;
@end

