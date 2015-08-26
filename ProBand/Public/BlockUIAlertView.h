//
//  BlockUIAlertView.h
//  InvoicingManage
//
//  Created by zzx on 13-10-24.
//
//
#import <UIKit/UIKit.h>
typedef void(^AlertBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)AlertBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        clickButton:(AlertBlock)_block;

@end