//  BaseModel.h
//  LenovoVB10
//
//  Created by jacy on 14/12/13.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+(id)convertDataToModel:(NSDictionary *)data;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
@end
