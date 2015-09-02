//
//  BaseModel.m
//  LenovoVB10
//
//  Created by jacy on 14/12/13.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+(id)convertDataToModel:(NSDictionary *)data
{
    
    return self;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
    
}
@end
