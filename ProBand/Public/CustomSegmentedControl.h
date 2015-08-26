//
//  TabVIew.h
//  tabView
//
//  Created by Simon on 15/8/18.
//  Copyright (c) 2015年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentedDelegate <NSObject>

-(void)selectTabItemIndex:(int)index;

@end

@interface CustomSegmentedControl : UIView{
    
    UIImageView *selectImage;
    NSArray *images;
    NSMutableArray *arrarSections;
    float itemRadius;
    float itemDiameter;
    
}

@property (nonatomic,readonly) int currentIndex;
@property (nonatomic,assign) id<CustomSegmentedDelegate> delegate;

/*
 *  imageItem 图片数组
 *  frame view 的大小
 */
-(id)initWithItems:(NSArray *)imageItem frame:(CGRect)rect;

/*
 *  选中目标选项卡
 *  item 目标选项卡的下标 下标从0开始
 */

-(void)selectTabItem:(int)item;

@end
