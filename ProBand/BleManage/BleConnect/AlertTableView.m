//
//  AlertTableView.m
//  Heart Rate
//
//  Created by Richard Cardoe on 04/11/2011.
//  Copyright (c) 2011 CSR Work. All rights reserved.
//

#import "AlertTableView.h"

@implementation AlertTableView

@synthesize  caller, context, data;

-(void)addListItem:(NSString*)newItem
{
    
    if (![self.data containsObject:newItem])
    {
        [self.data addObject:newItem];
        [myTableView reloadData];
        [myTableView setNeedsDisplay];
    }
   
}

-(id)initWithCaller:(id)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context
{
    self.data=[[NSMutableArray alloc] init];
    
    NSMutableString *messageString = nil;
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    

  if ([[vComp objectAtIndex:0] intValue] <7)
  {
        messageString = [NSMutableString stringWithString:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"];
        
    }
    else
    {
    messageString = [NSMutableString stringWithString:@""];
    }
    tableHeight = 307;
   
    if (iPhone6plus||iPhone6)
    {
         tableHeight = 307;
    }
    if(self = [super initWithTitle:_title message:messageString delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil]){
        self.caller = _caller;
        self.context = _context;
        if (_data!=nil) {
            [data addObjectsFromArray:_data];
        }
       
        [self prepare];
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.caller didSelectRowAtIndex:-1 withContext:self.context];
}

-(void)show{
    self.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer:) userInfo:nil repeats:NO];
    [super show];
}

-(void)myTimer:(NSTimer*)_timer{
    self.hidden = NO;
    [myTableView flashScrollIndicators];
}


-(void)prepare{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 50, 261, tableHeight) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[vComp objectAtIndex:0] intValue] <7) {
        [self addSubview:myTableView];
        
    }
    else
    {
     [self setValue:myTableView forKey:@"accessoryView"];
    }
    
 
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 50, 261, 4)];
    imgView.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:imgView];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, tableHeight+46, 261, 4)];
    imgView.image = [UIImage imageNamed:@"bottom.png"];
    [self addSubview:imgView];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 10);
    [self setTransform:myTransform];
}
// to set the alertView frame size.
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    
    //[alertView setFrame:CGRectMake((SCREEN_WIDTH-300)/2, (SCREEN_HEIGHT-420)/2, 300, 420)];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ABC"];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ABC"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    NSLog(@"cell text=%@",[self.data objectAtIndex:indexPath.row]);
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.caller didSelectRowAtIndex:indexPath.row withContext:self.context];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSLog(@"numberOfRowsInSection called rows:%d", [data count]);
    return [data count];
}

-(void)dealloc{
    [data removeAllObjects];
    
    self.data = nil;
    self.caller = nil;
    self.context = nil;
}

@end
