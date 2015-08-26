//
//  FMDBDataDispose.m
//  FMDBManage
//
//  Created by attack on 15/6/24.
//  Copyright (c) 2015年 attack. All rights reserved.
//

#import "FMDBDataDispose.h"

@implementation FMDBDataDispose
{
    FMDBManage *manage;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initFMDBManage];
    }
    return self;
}
- (void)initFMDBManage
{
    manage = [FMDBManage shareFMDBManage];
    manage.delegate = self;
    [manage selectDataFromtable:@"twoTables"];

}
-(void)requestDelegateData:(NSMutableArray *)fSetArray
{

}
@end
