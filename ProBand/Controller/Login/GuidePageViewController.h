//
//  GuidePageViewController.h
//  GuidePageView
//
//  Created by attack on 15/7/2.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController
@property (nonatomic,retain) NSArray *imageArray;
+ (instancetype)shareGuidePageViewController:(NSArray*)ImageArray;
@end
