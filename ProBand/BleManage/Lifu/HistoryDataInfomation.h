//
//  HistoryDataInfomation.h
//  ProBand
//
//  Created by attack on 15/7/31.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BandHistoryData) (NSData *data);
typedef void(^HistorySyncDataEnd) (BOOL historySyncEnd);

@class HistoryDataInfomation;
@protocol HistoryDataInfomationDelegate <NSObject>
- (void)historyDataSyncEnd:(BOOL)end;
@end


@interface HistoryDataInfomation : NSObject
+ (HistoryDataInfomation*)shareHistoryDataInfomation;
@property (nonatomic,copy) BandHistoryData bandHistoryData;
@property (nonatomic,copy) HistorySyncDataEnd syncDataEnd;
@property (nonatomic,assign)id<HistoryDataInfomationDelegate>delegate;
- (void)historySyncDataEnd:(HistorySyncDataEnd)isEnd;
@end
