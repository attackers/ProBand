//
//  MathTool.h
//  ProBand
//
//  Created by star.zxc on 15/7/25.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathTool : NSObject
SINGLETON

//对一天的480条数据进行整理，分成宽度的比例和每一个柱子的值:dictionary的关键字分别为widthArray,valueArray
- (NSDictionary *)chartDataFromDataArray:(NSArray *)valueArray;
@end
