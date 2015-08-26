//
//  HomeNetUnit.m
//  LenovoVB10
//
//  Created by fenda on 14/12/25.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "HomeNetUnit.h"

@implementation HomeNetUnit

SINGLETON_SYNTHE

//回调方法重写 ，由于每个接口retCode值不同，故这里由各子类去实现,test
- (void)requestComplete:(id)result{
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary *)result;
        NSArray *allKeys = [dic allKeys];
        //根据接口返回字段相印的修改retCode
        if ([allKeys containsObject:@"retCode"]) {
            NSString *code = [dic objectForKey:@"retCode"];
            if ([code intValue] == 0  && code) {
                flag = YES;
            }
        }
    }
    
    if (self.completion) {
        self.completion(result,flag);
    }
}
@end
