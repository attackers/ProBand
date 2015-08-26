//
//  TabVIew.m
//  tabView
//
//  Created by Simon on 15/8/18.
//  Copyright (c) 2015年 Simon. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl
@synthesize delegate,currentIndex;

-(id)initWithItems:(NSArray *)imageItem frame:(CGRect)rect{
    
    if (self = [super init]) {
        
        self.frame = rect;
        images = imageItem;
        [self.layer setCornerRadius:20.0f];
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[images objectAtIndex:0]];
        [backgroundImage.layer setCornerRadius:20.0f];
        backgroundImage.userInteractionEnabled = YES;
//        backgroundImage.backgroundColor = [UIColor blackColor];
        backgroundImage.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        [self addSubview:backgroundImage];
        
        selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 , rect.size.width/(images.count - 1), rect.size.height)];
        
        [selectImage.layer setCornerRadius:20];

        [selectImage setImage:[images objectAtIndex:1]];
        [backgroundImage addSubview:selectImage];
        
        [self getCenter];
    }
    return self;
}
-(void)getCenter{
    arrarSections = [[NSMutableArray alloc]init];
    itemDiameter = self.frame.size.width / (images.count - 1);
    itemRadius = itemDiameter / 2;
    for (int i = 1 ; i < [images count]; i++) {
       
        float temp = itemDiameter * i - itemRadius;
        
        [arrarSections addObject:[NSString stringWithFormat:@"%f",temp]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    for (int i = 0; i < [arrarSections count]; i++) {
        NSString *str = [arrarSections objectAtIndex:i];
        float temp = [str floatValue];
        if (temp - itemRadius < p.x && temp + itemRadius > p.x) {
            [self selectTabItem:i ];
        }
    }
    
}

-(void)selectTabItem:(int)item{
    if (item == currentIndex) {
        return;
    }
    [UIView animateWithDuration:.25 animations:^{
        
        selectImage.frame = CGRectMake(selectImage.frame.origin.x, selectImage.frame.origin.y, selectImage.frame.size.width, self.frame.size.height);
        selectImage.center = CGPointMake([[arrarSections objectAtIndex:item] floatValue], selectImage.frame.size.height/2);
        [selectImage setImage:[images objectAtIndex:item+1]];

        
    } completion:^(BOOL finished) {
        currentIndex = item;
        if ([delegate respondsToSelector:@selector(selectTabItemIndex:)]) {
            [delegate selectTabItemIndex:item];
        }
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
