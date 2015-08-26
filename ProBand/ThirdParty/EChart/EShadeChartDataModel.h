//
//  EShadeChartDataModel.h
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EShadeChartDataModel : NSObject

@property(nonatomic,strong) UIImage *backGroundImage;
@property(nonatomic,strong) UIImage *showImage;
@property(nonatomic,strong) UIImage *typeImage;
@property(nonatomic,strong) UIImage *reachTargerTypeImage;
@property(nonatomic,strong) NSString *labelTitle;
@property(nonatomic,assign) CGFloat currentValue;
@property(nonatomic,assign) CGFloat targetValue;
@end
