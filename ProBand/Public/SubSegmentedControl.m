//
//  SubSegmentedControl.m
//  segment
//
//  Created by attack on 15/7/1.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "SubSegmentedControl.h"

@implementation SubSegmentedControl
-(instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        self.tintColor = [UIColor grayColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.5;
        self.layer.masksToBounds = YES;
        NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
        [self setTitleTextAttributes:titleDic forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selfclick) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}
- (void)setType:(NSInteger)type
{
    switch (type) {
        case 0:
        {
            self.tintColor = [UIColor grayColor];
            self.layer.borderColor = [UIColor grayColor].CGColor;
            self.layer.borderWidth = 1.5;
            self.layer.masksToBounds = YES;
            NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
            [self setTitleTextAttributes:titleDic forState:UIControlStateNormal];
            [self addTarget:self action:@selector(selfclick) forControlEvents:UIControlEventValueChanged];
        
        }
            break;
        case 1:
        {
            self.tintColor = [UIColor whiteColor];
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 2;
            self.layer.masksToBounds = YES;
            NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
            [self setTitleTextAttributes:titleDic forState:UIControlStateNormal];
            [self addTarget:self action:@selector(selfclick) forControlEvents:UIControlEventValueChanged];

        }
            break;
        default:
            break;
    }

}
- (void)selfclick
{
    if (_segBlock) {
        _segBlock(self);

    }
}

- (void)segmentSelectedIndex:(SegmentBlock)selfBlock
{
    _segBlock = ^(SubSegmentedControl *s){
    
        selfBlock(s);
    };

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
