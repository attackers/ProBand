//
//  WebViewController.h
//  MyB2C
//
//  Created by zzx on 12-12-4.
//
//



#import "MBProgressHUD.h"
@interface WebViewController :BaseViewController<UIWebViewDelegate>
{
    NSString  *userId;
    BOOL isLoading;
   
    MBProgressHUD *HUD;
    UIWebView *myWebView;
    NSString *requestUrl;
    NSString *titleText;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) NSString *showReturn;
@property (nonatomic,retain)  NSString *titleText;
@property (nonatomic,retain) NSString  *userId;
@property (nonatomic,retain) NSString  *requestUrl;
@end
