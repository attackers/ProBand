//
//  FitApplication_Model.h
//  ProBand
//
//  Created by Echo on 15/7/2.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitApplication_Model : NSObject
@property (nonatomic, copy) NSString *appKey;//联想提供，固定值@"SG1505105378"
@property (nonatomic, copy) NSString *detailUrl;//可随意填写
@property (nonatomic, copy) NSString *name;//app名字，此处为name=@"ProBand";
@property (nonatomic, copy) NSString *packageName;//包名，即@"com.fendateam.ProBand"
@property (nonatomic, copy) NSString *version;//版本，@"1.0.0"
@end
