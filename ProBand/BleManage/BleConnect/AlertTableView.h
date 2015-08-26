//
//  AlertTableView.h
//  Heart Rate
//
//  Created by Richard Cardoe on 04/11/2011.
//  Copyright (c) 2011 CSR Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTableViewDelegate

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context;

@end

@interface AlertTableView : UIAlertView <UITableViewDelegate, UITableViewDataSource>{
    UITableView *myTableView;
    id<AlertTableViewDelegate> caller;
    id context;
    NSMutableArray *data;
    int tableHeight;
}

-(id)initWithCaller:(id<AlertTableViewDelegate>)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context;
-(void)addListItem:(NSString*)newItem;

@property(nonatomic, retain) id<AlertTableViewDelegate> caller;
@property(nonatomic, retain) id context;
@property(nonatomic, retain) NSMutableArray *data;
@property(nonatomic, assign) int RSSI;
@end

@interface AlertTableView(HIDDEN)

-(void)prepare;

@end
