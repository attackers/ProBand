//
//  SubSegmentedControl.h
//  segment
//
//  Created by attack on 15/7/1.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubSegmentedControl;
typedef void(^SegmentBlock) (SubSegmentedControl *segmc);
@interface SubSegmentedControl : UISegmentedControl
@property (nonatomic,copy)SegmentBlock segBlock;
@property (nonatomic,assign)NSInteger type;
- (void)segmentSelectedIndex:(SegmentBlock)selfBlock;
@end
