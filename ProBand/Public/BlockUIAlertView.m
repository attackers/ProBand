//
//  BlockUIAlertView.m
//  InvoicingManage
//
//  Created by zzx on 13-10-24.
//
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitles
        clickButton:(AlertBlock)_block
  {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    if (self) {
        self.block = _block;
    }
    
    return self;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.block(buttonIndex);
}


@end