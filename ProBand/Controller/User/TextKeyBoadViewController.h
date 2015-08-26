//
//  TextKeyBoadViewController.h
//  keyboard
//
//  Created by attack on 15/7/6.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnStringValue) (NSString *stg);
@interface TextKeyBoadViewController : UIViewController
@property (nonatomic,strong) UITextField *textView;
@property (nonatomic,copy) ReturnStringValue rStg;
- (void)textFieldString:(ReturnStringValue)tStg;
@end
