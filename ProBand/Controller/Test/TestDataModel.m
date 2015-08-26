//
//  TestDataModel.m
//  DrawChartView
//
//  Created by jacy on 14/12/27.
//  Copyright (c) 2014年 fenda. All rights reserved.
//

#import "TestDataModel.h"

@implementation TestDataModel

+(NSArray *)getArrayFromDataModelwithChartIndex:(NSInteger)index withNum:(int)num{
    NSMutableArray *dataArray = [NSMutableArray new];
    switch (index) {
        case 0:
        {
            for (int i = 0; i<num; i++) {
                int value = arc4random() % 100;
                [dataArray addObject:[NSNumber numberWithInt:value]];
            }
        }
            break;
        case 1:
        {
            int a = 0,b = 0,c= 0;
            for (int j = 0; j<num; j++) {
                a = arc4random() % 60;
                b = arc4random() % 60;
                c = arc4random() % 60;
                [dataArray addObject:@[[NSNumber numberWithInteger:a],[NSNumber numberWithInteger:b],[NSNumber numberWithInteger:c]]];
            }
        }
            break;
        case 2:
        {
            for (int i = 0; i<num; i++) {
                int value = arc4random() % 100;
                [dataArray addObject:[NSNumber numberWithInt:value]];
            }
        }
            break;
        default:
            break;
    }
    
    return dataArray;
}
//线型图
+(NSArray *)getArrayFromDataModelwithLineChartwithNum:(int)num{
    NSMutableArray *dataArray = [NSMutableArray new];
    
    for (int i = 0; i<num; i++) {
        int value = arc4random() % 100;
        [dataArray addObject:[NSNumber numberWithInt:value]];
    }
    return dataArray;
}
//遮罩图
+(EShadeChartDataModel *)getModelDataForShadeChart{
    EShadeChartDataModel *data = [EShadeChartDataModel new];
    data.backGroundImage = [UIImage imageNamed: @"daily_dashboard_01"];
    data.showImage = [UIImage imageNamed:@"daily_dashboard_02"];
//    data.typeImage = [UIImage imageNamed:@"ico_program_step"];
//    data.reachTargerTypeImage = [UIImage imageNamed:@"ico_program_step_sel"];
    data.labelTitle = @"0小时0分钟";
    data.currentValue = 0;//arc4random() % 100
    data.targetValue = 100;
    return data;
}
////饼状图
+(EPieChartDataModel *)getModelDataForPieChart{
    
    int a = arc4random()%100;
    int b = arc4random()%100;
    int c = arc4random()%100;
    if (a==0&&b==0&&c==0)
    {
        a=arc4random()%100;
        b = arc4random()%100;
        c = arc4random()%100;
    }
    //Budget:深睡current:浅睡estimate:清醒
      EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:a current:b estimate:c bgimageOne:@"sleep_dashboard_pointer" bgimageTwo:@"sleep_dashboard_sober" bgimageThree:@"sleep_dashboard_round"];
    return ePieChartDataModel;
}
//遮罩图
+(EShadeChartDataModel *)getExerciseModelDataForShadeChart{
    EShadeChartDataModel *data = [EShadeChartDataModel new];
    data.backGroundImage = [UIImage imageNamed: @"exercise_dashboard"];
    data.showImage = [UIImage imageNamed:@"exercise_dashboard_start"];
    data.labelTitle = @"运动完成度";
    data.currentValue = arc4random() % 100;
    data.targetValue = 100;
    return data;
}
+(EShadeChartDataModel *)getExerciseDataForShadeChart{
    EShadeChartDataModel *data = [EShadeChartDataModel new];
    data.backGroundImage = [UIImage imageNamed: @"daily_dashboard_01"];
    data.showImage = [UIImage imageNamed:@"daily_dashboard_02"];
    //    data.typeImage = [UIImage imageNamed:@"ico_program_step"];
    //    data.reachTargerTypeImage = [UIImage imageNamed:@"ico_program_step_sel"];
    data.labelTitle = @"3小时23分钟";
    data.currentValue = arc4random() % 100;
    data.targetValue = 100;
    return data;
}
@end
