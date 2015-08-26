//
//  WebViewController.m
//  MyB2C
//
//  Created by zzx on 12-12-4.
//
//

#import "WebViewController.h"
#import "PublicFunction.h"
@interface WebViewController ()

@end

@implementation WebViewController
@synthesize userId;
@synthesize requestUrl;
@synthesize titleText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"remove";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"Tab";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){ self.edgesForExtendedLayout = UIRectEdgeNone; }
#endif
    self.view.backgroundColor=[UIColor whiteColor];
    //    if ([PublicFunction getUserid]==nil)
    //    {
    //        [PublicFunction showMessage:NSLocalizedString(@"Please login or register",nil)];
    //        return;
    //    }
    // [self setCookies];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
         self.navigationController.navigationBar.barTintColor = navigationColor;
    }
    else
    {
        self.navigationController.navigationBar.tintColor=navigationColor;
    }
	// Do any additional setup after loading the view.
    if ([self.showReturn isEqualToString:@"no"])
    {
        
          self.navigationItem.leftBarButtonItem=nil;
        
    }
    else
    {
         self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[self getButton:CGRectMake(0, 0, 32, 32) imageName:@"return" title:@"" clickAction:@selector(goback)]];
   
    }
  
    
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[self getButton:CGRectMake(0, 0, 32, 32) imageName:@"refresh.png" title:@"" clickAction:@selector(loadWebview)]];
    // NSString *url=[NSString stringWithFormat:@"%@AjaxFunction/getWebViewControllerList.ashx?appname=%@&userid=%@",weburl,Appname,self.userId];
    // [self performSelectorOnMainThread:@selector(httpRequest:) withObject:url waitUntilDone:NO];
    if (self.titleText!=nil)
    {
        self.title=self.titleText;
    }
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-30, screenWidth, 30)];
	footView.backgroundColor=[UIColor whiteColor];
    [footView addSubview:[PublicFunction getButtonInControl:self frame:CGRectMake(0, 0, 30, 30) imageName:@"return" title:@"" clickAction:@selector(goback)]];
    [self.view addSubview:footView];
    
    [self loadWebview];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    //    NSString *url=[NSString stringWithFormat:@"http://www.iosbuy.com/customer/orderlist.aspx"];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
-(void)loadWebview
{
    NSString *strUserRole=[PublicFunction getUserRole];
    if ([strUserRole isEqualToString:@"2"])
    {
        [PublicFunction showMessage:NSLocalizedString(@"you have no power to use this function", nil)];
        return;
    }
    if(![PublicFunction isConnect])
    {
        
        [PublicFunction showMessage:NSLocalizedString(@"Can not connect to network", nil)];
        return;
    }
    
    if (myWebView) {
        [myWebView stopLoading];
        [myWebView removeFromSuperview];
      
        myWebView=nil;
    }
  
     myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight-44)];
    
   
    myWebView.userInteractionEnabled = YES;
    myWebView.scalesPageToFit=YES;
    myWebView.layer.cornerRadius=1.0f;
    myWebView.layer.masksToBounds=YES;
    myWebView.layer.borderColor=[[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1.0] CGColor];
    myWebView.layer.borderWidth= 1.0f;
    myWebView.delegate=self;
    [self.view addSubview:myWebView];
    
    
    NSLog(@"self.requestUrl=%@",self.requestUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    
    NSDictionary *subkey= [NSDictionary dictionaryWithObjectsAndKeys:
                           
                           @"userid", NSHTTPCookieName,
                           [PublicFunction getUserid], NSHTTPCookieValue,
                           @"username", NSHTTPCookieName,
                           [PublicFunction getUserName], NSHTTPCookieValue,
                           nil];
    
    //NSLog(@"username=%@",[PublicFunction getUserName]);
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"fenda.com", NSHTTPCookieDomain,
                                @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                @"iosbuy", NSHTTPCookieName,
                                subkey, NSHTTPCookieValue,   //带子键的cookies
                                nil];
    
    NSDictionary *properties2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"fenda.com", NSHTTPCookieDomain,
                                 @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                 @"userid", NSHTTPCookieName,
                                 [PublicFunction getUserid], NSHTTPCookieValue,
                                 nil];
    
    
    // NSLog(@"properties=%@",properties);
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:properties2];
    
    NSArray* cookies = [NSArray arrayWithObjects: cookie,cookie2, nil];
    
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    [myWebView loadRequest:request];
}

-(void)setCookies
{
    if ([PublicFunction getUserid]!=nil)
    {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"userid" forKey:NSHTTPCookieName];
        [cookieProperties setObject:[PublicFunction getUserid] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@"www.fenda.com" forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"www.fenda.com" forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:@"//" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        
        // set expiration to one month from now or any NSDate of your choosing
        // this makes the cookie sessionless and it will persist across web sessions and app launches
        /// if you want the cookie to be destroyed when your app exits, don't set this
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        
        
        
    }
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showWaiting];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self hideWaitng];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideWaitng];
}

-(void)showLoadingUI:(NSString *)message
{
	
	if (HUD) {
		[HUD removeFromSuperview];
	
		HUD = nil;
	}
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
	HUD.labelText=message;
	[HUD hide:YES afterDelay:10];
}
-(UIButton *)getButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title clickAction:(SEL)clickAction
{
	UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
	if (imageName.length>0)
    {
		[btnCamera setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	if (title.length>0)
    {
		[btnCamera setTitle:title forState:UIControlStateNormal];
        [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	btnCamera.frame = frame ;
    
	[btnCamera addTarget:self action:clickAction forControlEvents:UIControlEventTouchUpInside];
	return btnCamera;
}
-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)dismissView
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//开始滚动轮指示器
- (void)showWaiting
{
    [self hideWaitng];
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth/2, 90, 26, 26)];
    spinner.backgroundColor = [UIColor clearColor];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
}
//消除滚动轮指示器
-(void)hideWaitng
{
	if (spinner) {
		[spinner stopAnimating];
		[spinner removeFromSuperview];
      
		spinner=nil;
		
	}
}

- (void)showLoading:(NSString *)title
{
    if (HUD)
    {
        [HUD removeFromSuperview];
       
        HUD = nil;
    }
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:HUD];
	//HUD.delegate = self;
	if (title.length>0){ HUD.labelText = title;}
	[HUD show:YES];
	//[HUD showWhileExecuting:@selector(httpRequest:) onTarget:self withObject:nil animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillDisappear:(BOOL)animated
{
      //[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillDisappear:animated];
}
- (void) viewWillAppear:(BOOL)animated
{
     //[self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)dealloc {
	NSLog(@"selectCity dealloc8");
    if (myWebView) {
        [myWebView stopLoading];
        [myWebView removeFromSuperview];
        
        myWebView=nil;
    }
    
    [self hideWaitng];
  
}
@end
