//
//  StepdownModel.m
//  LenovoVB10
//
//  Created by jacy on 14/12/19.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "StepdownModel.h"

@implementation StepdownModel

+(StepdownModel *)convertDataToModel:(NSDictionary *)aDictionary;
{
    StepdownModel *instance = [[StepdownModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}


- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
    
}

@end
