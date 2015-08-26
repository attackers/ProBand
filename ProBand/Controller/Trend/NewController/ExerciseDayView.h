//
//  ExerciseDayView.h
//  ProBand
//
//  Created by star.zxc on 15/8/5.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseSectionModel.h"
@interface ExerciseDayView : UIView<UITableViewDelegate,UITableViewDataSource>
- (id)initWithFrame:(CGRect)frame exerciseModel:(ExerciseSectionModel *)model;
@end
