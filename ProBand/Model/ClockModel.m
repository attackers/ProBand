//
//  ClockModel.m
//  LenovoVB10
//
//  Created by fenda-newtech on 14/12/16.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "ClockModel.h"

@implementation ClockModel


+(NSMutableArray *)getResultArr:(NSArray *)arr{
    
    NSMutableArray *clockObjArr = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++)
    {
        
        NSDictionary *clockDic = arr[i];
        ClockModel *obj = [ClockModel convertDataToModel:clockDic];
        [clockObjArr addObject:obj];
    }
    return clockObjArr;
    
}

+(ClockModel *)convertDataToModel:(NSDictionary *)aDictionary
{
    ClockModel *instance = [[ClockModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}



//将星期转化为从高到低的零一（从星期日到星期一）
+(NSArray *)sortWeek:(NSString *)str
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i<str.length; i++) {
        
        NSString *s = [NSString stringWithFormat:@"%c",[str characterAtIndex:i]];
        [arr addObject:s];
    }

    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:arr[0], nil];
    for (int i = (int)(arr.count - 1); i>=1; i--) {
        [tempArray addObject:arr[i]];
    }
    [arr removeAllObjects];
    arr = [NSMutableArray array];
    for (int i = 0; i <tempArray.count; i++) {
        
        if ([[tempArray objectAtIndex:i] isEqualToString:@"1"]) {
            [arr addObject:@YES];
        }
        else
        {
            [arr addObject:@NO];
        }
    }
    
   // NSLog(@"---星期转换---%@",arr);
    return arr;
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"id: %@,AlarmId: %@,startTime: %@,repeat:%@,name: %@,interval: %@,status: %@",_userId,_AlarmId,_startTime,_repeat,_name,_interval,_status];
}
@end
