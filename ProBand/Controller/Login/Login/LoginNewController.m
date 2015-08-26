//
//  LoginNewController.m
//  ProBand
//
//  Created by star.zxc on 15/7/10.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "LoginNewController.h"
#import "BlueToothTestViewController.h"
#import "ThirdPartyLoginManager.h"
#import "LoginModel.h"
#import "NSString+MD5Addition.h"
#import "UIView+Extension.h"
@interface LoginNewController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    
    UITextField *accountField;
    UITextField *psdField;
    
    ThirdPartyLoginManager *loginManager;
}
@property (nonatomic, strong)NSTimer *timer;//超时限制
@property (nonatomic,strong)LoginModel *loginObj;
@end

@implementation LoginNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBarTitle:NSLocalizedString(@"login", nil) leftImage:@"return.png"];
    
    loginManager = [ThirdPartyLoginManager sharedInstance];
    _loginObj = [LoginModel new];
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:scrollView];
    if (iPhone4) {
        //scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
    }
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 20)];
    thirdLabel.text = NSLocalizedString(@"3th_account_login", nil);
    thirdLabel.textColor = [UIColor lightGrayColor];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:thirdLabel];
    
    
    UIButton *qqBn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-10, CGRectGetMaxY(thirdLabel.frame)+40, 40, 40)];
    [qqBn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    qqBn.imageEdgeInsets =UIEdgeInsetsMake(4, 4, 4, 4);
    [qqBn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:qqBn];
    UIButton *wechartBn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-CGRectGetMaxX(qqBn.frame), CGRectGetMinY(qqBn.frame), qqBn.frame.size.width, qqBn.frame.size.height)];
    [wechartBn setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    wechartBn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    [wechartBn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:wechartBn];
    UIButton *qqLogin = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(qqBn.frame)-40, CGRectGetMaxY(qqBn.frame), 80, 25)];
    [qqLogin setTitle:NSLocalizedString(@"qq_login", nil) forState:UIControlStateNormal];
    [qqLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [qqLogin addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:qqLogin];
    UIButton *wechatLogin = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(wechartBn.frame)-40, CGRectGetMaxY(qqBn.frame), 80, 25)];
    [wechatLogin setTitle:NSLocalizedString(@"wechat_login", nil) forState:UIControlStateNormal];
    [wechatLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [wechatLogin addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:wechatLogin];
    
    
    UIButton *skipBn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-70, scrollView.frame.size.height-50, 140, 30)];
    [skipBn setTitle:NSLocalizedString(@"direct_use", nil) forState:UIControlStateNormal];
    [skipBn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    skipBn.titleLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:skipBn];
    [skipBn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *testBn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(skipBn.frame), CGRectGetMinX(skipBn.frame), 30)];
    [testBn setTitle:@"数据测试页面" forState:UIControlStateNormal];
    [testBn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    testBn.titleLabel.font = [UIFont systemFontOfSize:10];
    [scrollView addSubview:testBn];
    [testBn addTarget:self action:@selector(pushHomeView:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)threadActionlogin {
    [PublicFunction showLoading:@""];
    
    NSLog(@"---userTypeName:%@",_loginObj.userTypeName);
    NSString *time = [DateHandle dateToString:[NSDate date] withType:2];
    NSDictionary *body = @{
                           @"password":_loginObj.password,
                           @"t":@"",
                           @"c":@"",
                           @"getcode":@"y",
                           @"source":@"ios:ios.lesync-1.6",
                           @"deviceidtype":@"sn",
                           @"deviceid":[[UIDevice currentDevice] uniqueDeviceIdentifier],
                           @"devicecategory":@"unknown",
                           @"devicevendor":@"apple",
                           @"devicefamily":@"unknown",
                           @"devicemodel":@"iPhone",
                           @"osversion":@"",
                           @"productiondate":time,
                           @"unpackdate":time,
                           @"extrainfo":@"",
                           @"imsi":@"",
                           @"lang":@"zh-CN"};
    
    
    [NetWorkManage loginIN:body withModel:_loginObj block:^(BOOL succ, id result) {
        NSLog(@"~~登录成功~~%@",result);
        NSString *codeStr = [Contants valuableCodeInTag:@"<Code>" andTag:@"</Code>" withString:result];
        
        if ([codeStr isEqualToString:@"USS-0103"]) {
            [PublicFunction hiddenHUD];
            [[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"wrong_account", nil)];
            return ;
        }
        else if ([codeStr isEqualToString:@"USS-0101"]) {
            [PublicFunction hiddenHUD];
            [[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"wrong_psd_msg", nil)];
            return ;
        }
        
        _loginObj.userId = [Contants valuableCodeInTag:@"<Userid>" andTag:@"</Userid>" withString:result];
        
        //NSLog(@"userId:%@",_loginObj.userId);
        [Singleton setValues:_loginObj.userId withKey:@"userID"];
        NSLog(@"---Levono userID---%@",_loginObj.userId);
        NSString  *isON=[DefaultValueManage getValueForKey:savePassword_key];
        if ([isON isEqualToString:@"YES"])
        {
            [DefaultValueManage saveValue:accountField.text forKey:username_key];
            [DefaultValueManage saveValue:psdField.text forKey:password_key];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:40.0 target:self selector:@selector(loginAboveTime) userInfo:nil repeats:NO];
        if([_loginObj.userId integerValue]>0)
        {
            __block LoginNewController *blockSelf = self;
            [NetWorkManage threadActionlogin:_loginObj.userId withBlock:^(BOOL b , id result) {
                [blockSelf.timer invalidate];
                blockSelf.timer = nil;
                NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                [Singleton setValues:dic[@"postkey"] withKey:@"postkey"];
                [Singleton setValues:dic[@"token"] withKey:@"token"];
                NSLog(@"--result dic----%@----",dic);
                if (dic == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [PublicFunction hiddenHUD];
                        [[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"login_failed", nil)];
                    });
                    
                }
                NSString *retcode=dic[@"retcode"]; //返回1000才算登陆成功
                if ([retcode isEqualToString:@"10000"])
                {
                    [PublicFunction hiddenHUD];
                    [DBOPERATOR checkUserDatabase];
                    [Contants addDefaultData];
                    
                    BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
                    [self.navigationController pushViewController:ble animated:YES];
                }
                
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PublicFunction hiddenHUD];
                [[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"login_failed_msg", nil)];
            });
        }
        
    }];
    
    
}

- (void)pushHomeView:(UIButton *)sender
{
    [[AppDelegate getAPPDelegate]pushHomeViewController];
}
- (void)skip:(UIButton *)sender
{
    NSLog(@"跳过");
    BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
    [self.navigationController pushViewController:ble animated:YES];
    //    [[AppDelegate getAPPDelegate]pushHomeViewController];
}

-(void)loginAboveTime
{
    [PublicFunction hiddenHUD];
    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登录超时，请重试 "];
}
#pragma mark QQ Login
- (void)qqLogin
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loginAboveTime) userInfo:nil repeats:NO];
    __block LoginNewController *blockSelf = self;
    
    
    if ([QQApi isQQInstalled]) {
        [PublicFunction showLoading:@""];
    }else
    {
        NSLog(@"未安装QQ，提醒用户！！！");
        UIAlertView *tipsAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        tipsAlertView.centerX = SCREEN_WIDTH/2;
        tipsAlertView.centerY = SCREEN_HEIGHT/2;
        tipsAlertView.width = SCREEN_WIDTH - 150;
        tipsAlertView.height = 180;
        [tipsAlertView show];
        return;
    }
    [loginManager loginQQSpaceWithBlock:^(NSDictionary *dic, BOOL success) {
        if (success) {
            NSLog(@"QQ登录成功 %@", dic);
            NSString *open_id = dic[@"userId"];
            [Singleton setValues:open_id withKey:@"open_id"];
            [Singleton setValues:@"QQ" withKey:@"user_type"];
            NSLog(@"open_id = %@, user_type = %@",[Singleton getValueWithKey:@"open_id"],[Singleton getValueWithKey:@"user_type"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [PublicFunction hiddenHUD];
                BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
                [self.navigationController pushViewController:ble animated:YES];
            });
        }
        [blockSelf.timer invalidate];
        blockSelf.timer = nil;
        //
        //        NSDictionary *modelDic = [NSDictionary dictionaryWithDictionary:dic];
        //        NSString *qqAccount = modelDic[@"userId"];//nil？
        //将数据提交到服务器
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            [NetWorkManage threadActionlogin:qqAccount withBlock:^(BOOL hasSubmit, id result) {
        //                if (hasSubmit)
        //                {
        //                    NSLog(@"向服务器提交第三方账号成功");
        //                    NSLog(@"返回数据：%@",result);
        //                    NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        //
        //                    [Singleton setValues:dic[@"postkey"] withKey:@"postkey"];
        //                    [Singleton setValues:dic[@"token"] withKey:@"token"];
        //
        //                    [[NSUserDefaults standardUserDefaults]setObject:qqAccount forKey:@"userID"];
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //                        [PublicFunction hiddenHUD];
        //                        BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
        //                        [self.navigationController pushViewController:ble animated:YES];
        //                    });
        //                }
        //                else
        //                {
        //                    NSLog(@"向服务器提交数据失败");
        //                    NSLog(@"返回数据：%@",result);
        //                }
        //            }];
        //
        //        });
        
    }];
}

#pragma mark WeChat Login
- (void)wechatLogin
{
    if ([WXApi isWXAppInstalled]) {
        [PublicFunction showLoading:@""];
    }else
    {
        NSLog(@"未安装微信，提醒用户！！！");
        UIAlertView *tipsAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        tipsAlertView.centerX = SCREEN_WIDTH/2;
        tipsAlertView.centerY = SCREEN_HEIGHT/2;
        tipsAlertView.width = SCREEN_WIDTH - 150;
        tipsAlertView.height = 180;
        //[self.view addSubview:tipsAlertView];
        [tipsAlertView show];
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loginAboveTime) userInfo:nil repeats:NO];
    __block LoginNewController *blockSelf = self;
    
    [loginManager loginWeixinWithBlock:^(NSDictionary *dic, BOOL success) {
        if (success) {
            NSLog(@"微信登录成功 %@", dic);
            NSString *open_id = dic[@"userId"];
            [Singleton setValues:open_id withKey:@"open_id"];
            [Singleton setValues:@"Wechat" withKey:@"user_type"];
            NSLog(@"open_id = %@, user_type = %@",[Singleton getValueWithKey:@"open_id"],[Singleton getValueWithKey:@"user_type"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [PublicFunction hiddenHUD];
                BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
                [self.navigationController pushViewController:ble animated:YES];
            });
        }
        [blockSelf.timer invalidate];
        blockSelf.timer = nil;
        
        //        NSDictionary *modelDic = [NSDictionary dictionaryWithDictionary:dic];
        //        NSString *qqAccount = modelDic[@"userId"];//nil？
        //将数据提交到服务器
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            [NetWorkManage threadActionlogin:qqAccount withBlock:^(BOOL hasSubmit, id result) {
        //                if (hasSubmit)
        //                {
        //                    NSLog(@"向服务器提交第三方账号成功");
        //                    NSLog(@"返回数据：%@",result);
        //                    //[Singleton setValues:model.userId withKey:@"userID"];
        //                    NSDictionary *dic=  [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        //
        //                    [Singleton setValues:dic[@"postkey"] withKey:@"postkey"];
        //                    [Singleton setValues:dic[@"token"] withKey:@"token"];
        //
        //                    [[NSUserDefaults standardUserDefaults]setObject:qqAccount forKey:@"userID"];
        //                    dispatch_async(dispatch_get_main_queue(), ^{
        //                        [PublicFunction hiddenHUD];
        //                        BlueToothTestViewController *ble = [[BlueToothTestViewController alloc]init];
        //                        [self.navigationController pushViewController:ble animated:YES];
        //                    });
        //                }
        //                else
        //                {
        //                    NSLog(@"向服务器提交数据失败");
        //                    NSLog(@"返回数据：%@",result);
        //                }
        //            }];
        //
        //        });
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
