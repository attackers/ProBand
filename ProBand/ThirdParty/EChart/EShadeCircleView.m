//
//  EShadeCircleView.m
//  MultifunctionApp
//
//  Created by jacy on 14/12/4.
//  Copyright (c) 2014年 李健. All rights reserved.
//

#import "EShadeCircleView.h"
#import "UICountingLabel.h"

#define lineWidthNumber 125


@interface EShadeCircleView()
@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
//进度
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,strong) UIImage *backGroundImage;
@property (nonatomic,strong) UIImage *showImage;
@property (nonatomic,strong)UIImageView *arrorwImage;
@property (nonatomic,strong)  UICountingLabel *budgetLabel;
@end

@implementation EShadeCircleView
-(id)initWithFrame:(CGRect)frame andDataModel:(EShadeChartDataModel*)data withLineWid:(CGFloat)lineWidth isShow:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isShowAnimotion = show;
        [self setBasicData:data];
        if (data.typeImage) {//标记图片
            if (data.currentValue>=data.targetValue && data.reachTargerTypeImage) {
               // [self setupImageview:data.reachTargerTypeImage];
            }else{
               [self setupImageview:data.typeImage];
            }
            
        }
        _arrorwImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _arrorwImage.image = [UIImage imageNamed:@"daily_dashboard_light"];
        [self addSubview:_arrorwImage];
        //遮罩里面添加说明文字
        [self setTileAndIntroduce:data];
        //显示动态变化的当前值
        [self setupCurrent:data.currentValue];
        _lineWidth = fmaxf(lineWidth, 1.f);
        _progressBackgroundLayer.lineWidth = _lineWidth;
        _progressLayer.lineWidth = _lineWidth;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andDataModel:(EShadeChartDataModel *)data withLineWid:(CGFloat)lineWidth isShow:(BOOL)show withBgImageView:(NSString *)bgImageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isShowAnimotion = show;
        [self setBasicData:data];
        if (data.typeImage) {//标记图片
            if (data.currentValue>=data.targetValue && data.reachTargerTypeImage) {
                // [self setupImageview:data.reachTargerTypeImage];
            }else{
                [self setupImageview:data.typeImage];
            }
            
        }
        //遮罩里面添加说明文字
        [self setTileAndValues:data];
        //显示动态变化的当前值
      // [self setupCurrentValues:data.currentValue];
        [self setupCurrent:data.currentValue];
        
        _lineWidth = fmaxf(lineWidthNumber, 1.f);
        _progressBackgroundLayer.lineWidth = _lineWidth;
        _progressLayer.lineWidth = _lineWidth;
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_bgImageView];
        _bgImageView.image = [UIImage imageNamed:bgImageName];
        
        
        UIImageView *smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        smallImageView.image = [UIImage imageNamed:@"exercise_dashboard_round"];
        [self addSubview:smallImageView];
        
    }
    return self;
}

//添加by STar
- (id)initWithFrame:(CGRect)frame andDataModel:(EShadeChartDataModel *)data withLineWid:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBasicData:data];
        if (data.typeImage) {//标记图片
            if (data.currentValue>=data.targetValue && data.reachTargerTypeImage) {
                // [self setupImageview:data.reachTargerTypeImage];
            }else{
                [self setupImageview:data.typeImage];
            }
            
        }
//        _arrorwImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//        _arrorwImage.image = [UIImage imageNamed:@"daily_dashboard_light"];
//        [self addSubview:_arrorwImage];
        //显示动态变化的当前值
        [self setupCurrent:data.currentValue];
        _lineWidth = fmaxf(lineWidth, 1.f);
        _progressBackgroundLayer.lineWidth = _lineWidth;
        _progressLayer.lineWidth = _lineWidth;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    
    [_backGroundImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    UIImage *frontMaskImage = [self maskImage:self.showImage withMask:[self getMaskImage:_lineWidth]];
    [frontMaskImage drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}

- (void)setBasicData:(EShadeChartDataModel *)data
{
    self.backGroundImage = data.backGroundImage;
    self.showImage = data.showImage;
    self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:6/255.0 green:46/255.0 blue:74/255.0 alpha:1];
    
    _lineWidth = fmaxf(self.frame.size.width * 0.025, 1.f);
    _progressTintColor = [UIColor clearColor];
    _backgroundTintColor = [UIColor clearColor];
    
    self.progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressBackgroundLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_progressLayer];
    _percent = 0.0;
    if (data.currentValue<data.targetValue) {
        _percent = data.currentValue/data.targetValue;
    }else{
        _percent = 1.0;
    }
    
    [self showProgress:_percent];
}

//类型标记图片（此项目中没用）
-(void)setupImageview:(UIImage *)typeImage
{
    CGFloat x = CGRectGetMidX(self.bounds) - typeImage.size.width/2;
    CGFloat y = 10;
    CGRect rect = {x,y,typeImage.size};
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = typeImage;
    [self addSubview:imageView];
    
}

//遮罩里面添加说明文字
-(void)setTileAndIntroduce:(EShadeChartDataModel *)data
{
    UILabel *title = [[UILabel alloc] initWithFrame:self.frame];
    title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.45);
    title.text = @"完成度";[NSString stringWithFormat:@"%.1f",data.targetValue];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textColor = [UIColor colorWithRed:30/255.0 green:180/255.0 blue:189/255.0 alpha:1];
   
    [self addSubview:title];
    
    UILabel *intruduce = [[UILabel alloc] initWithFrame:self.frame];
    intruduce.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)*1.5);
    intruduce.text = data.labelTitle;
    intruduce.textAlignment = NSTextAlignmentCenter;
    intruduce.font = [UIFont fontWithName:@"Menlo-Bold" size:17];
    intruduce.textColor = [UIColor colorWithRed:30/255.0 green:180/255.0 blue:189/255.0 alpha:1];
    [self addSubview:intruduce];
}
-(void)setupCurrent:(CGFloat)current
{
    _budgetLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
    _budgetLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _budgetLabel.textAlignment = NSTextAlignmentCenter;
    _budgetLabel.method = UILabelCountingMethodEaseInOut;
    _budgetLabel.font = [UIFont boldSystemFontOfSize:25];
    _budgetLabel.textColor = [UIColor whiteColor];
    _budgetLabel.format = @"%.0f";
    //[_budgetLabel countFrom:0 to:current withDuration:0.8f];
    [self addSubview:_budgetLabel];
    
}

//锻炼界面里的标题
-(void)setTileAndValues:(EShadeChartDataModel*)data
{
    UILabel *intruduce = [[UILabel alloc] initWithFrame:self.frame];
    intruduce.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)*1.5);
    intruduce.text = data.labelTitle;
    intruduce.textAlignment = NSTextAlignmentCenter;
    intruduce.font = [UIFont fontWithName:@"Menlo-Bold" size:17];
    intruduce.textColor = [UIColor colorWithRed:30/255.0 green:180/255.0 blue:189/255.0 alpha:1];
    [self addSubview:intruduce];
    intruduce.center = CGPointMake(intruduce.center.x, intruduce.center.y - 15);
 
}
-(void)setupCurrentValues:(CGFloat)current
{
    UICountingLabel *budgetLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
    budgetLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    budgetLabel.textAlignment = NSTextAlignmentCenter;
    budgetLabel.method = UILabelCountingMethodEaseInOut;
    budgetLabel.font = [UIFont boldSystemFontOfSize:20];
    budgetLabel.textColor = [UIColor whiteColor];
    budgetLabel.format = @"%.0f";
    //[budgetLabel countFrom:0 to:<#(float)#>];
    //[budgetLabel countFrom:0 to:current withDuration:0.8f];
    [self addSubview:budgetLabel];
    budgetLabel.center = CGPointMake(budgetLabel.center.x, budgetLabel.center.y - 15);
}

- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}
-(UIImage *)getMaskImage:(CGFloat)width
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width-_lineWidth)/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height),NO,1.0);
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = width;
    
    
    CGFloat startAngle =2* M_PI - M_PI_2;//起始点
    CGFloat endAngle = startAngle + 2 * M_PI * self.progress;//结束点
    
    
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    
    //遮罩层
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    UIRectFill(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    [processPath stroke];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (_bgImageView) {
        CGAffineTransform transform= CGAffineTransformMakeRotation(2 * M_PI * self.progress);
        _bgImageView.transform = transform;

    }
    if (_arrorwImage) {
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(2*M_PI*self.progress);
        _arrorwImage.transform = transform;
    }
    return image;
}
-(void)showProgress:(CGFloat)percent
{
    [self setProgress:percent];
    static float oldPress;
    if (_isShowAnimotion) {
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            for (float i=0; i<percent; i+=0.03f)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [_budgetLabel countFrom:oldPress*100 to:i*100];
                                   [self setProgress:i];
                                    oldPress = i;
                               });
                usleep(10000);
            }
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFinish" object:nil];
            NSLog(@"刷新完");
        });
        
    }
    
}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}
#pragma mark Setters

//- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor
//{
//    _backgroundTintColor = backgroundTintColor;
//    _progressBackgroundLayer.strokeColor = _backgroundTintColor.CGColor;
//}
//
//- (void)setProgressTintColor:(UIColor *)progressTintColor {
//    _progressTintColor = progressTintColor;
//    _progressLayer.strokeColor = _progressTintColor.CGColor;
//    _progressLayer.fillColor = [UIColor clearColor].CGColor;
//}
@end
