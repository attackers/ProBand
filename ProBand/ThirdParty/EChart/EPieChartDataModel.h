//
//  EPieChartDataModel.h
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPieChartDataModel : NSObject
@property (nonatomic) CGFloat budget;
@property (nonatomic) CGFloat current;
@property (nonatomic) CGFloat estimate;
@property (nonatomic,strong)NSString *bgImageNameOne;
@property (nonatomic,strong)NSString *bgImageNameTwo;
@property (nonatomic,strong)NSString *bgImageNameThree;

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate bgimageOne:(NSString *)str1 bgimageTwo:(NSString *)str2 bgimageThree:(NSString *)str3;
@end
