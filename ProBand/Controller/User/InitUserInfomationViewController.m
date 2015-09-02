//
//  InitUserInfomationViewController.m
//  ProBand
//
//  Created by attack on 15/7/6.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "InitUserInfomationViewController.h"
#import "CustomAlertview.h"
#import "SingleCamera.h"
#import "CustomPickerView.h"
#import "TextKeyBoadViewController.h"
#import "UIView+Toast.h"
#import "UserSportTargetController.h"
#import "CustomActionSheetView.h"
#import "SendCommandToPeripheral.h"
#import "UserInfoManager.h"
#define HeadView_Height 140
#define LOCAL_INFO_KEY @"userInfoLocalKey"
#define LOCAL_HEADIMAGE_KEY @"userHeadImageLocalKey"
typedef enum : NSUInteger {
    genderTag = 120,
    ageTag,
    heightTag,
    weightTag,
    tagetTag,
    nameTag,
    eixtLogin,
    saveInfoTag
} userInfoTag;

@interface InitUserInfomationViewController ()<UITableViewDataSource,UITableViewDelegate,CustomAlertviewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CameraDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    NSArray *describeArray;//比如年龄，性别
    //NSMutableArray *valueArray;//比如男，25岁等
    //NSMutableArray *_ageArray;//年龄的数组:1-100
    NSMutableArray *_heigthArr;//显示身高的数组:目前只需要年龄
    NSMutableArray *_weightArr;
    NSMutableArray *_yearArr;
    NSMutableArray *_monthArr;
    NSMutableArray *_dayArr;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger oneCompoent;
    NSInteger twoCompoent;
    NSInteger threeCompoent;
    
    UITableView *personalInfoTable;
    UIButton *headBtn;//头像按钮:imageView
    UIImageView *headImageView;
    UIView *popView;//编辑昵称的view
    UITextField *nickText;
    
    NSInteger currentAge;//当前选择的年龄
    NSInteger currentHeight;//记录当前的身高
    NSInteger currentWeight;//体重
    
    UInt8 ageUIntArray[150];
    UInt8 heighUIntArray[200];
    UInt8 weightUIntArray[250];
    
    UInt8 ageUInt;
    UInt8 heighUInt;
    UInt8 weightUInt;
    UInt8 genderUInt;
    NSString *nameStg;
}
@property (nonatomic, strong)t_userInfo *userInfoObj;
//验证用户信息是否改变的model:保持不变
@property (nonatomic, strong)t_userInfo *fixedInfoObj;
@end
@implementation InitUserInfomationViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self syncDateAndWeather];
}
- (void)syncDateAndWeather
{
    
    [[[DateAndWeatherInformation alloc]init]timeSync];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[DateAndWeatherInformation alloc]init]weatherSync];
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftBtn.hidden = YES;
    self.titleLabel.text = @"个人信息";
    self.navigationController.navigationBar.barTintColor = COLOR(0, 31, 57);
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjects:@[[UIColor whiteColor]] forKeys:@[NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.titleTextAttributes = titleAttribute;
    [self initData];
    [self createView];
}
//需要验证用户信息是否变化
- (void)backToLastController
{
    //先转为dictionary再比较
    NSDictionary *infoDic1 = [UserInfoManager dictionaryFromModel:_userInfoObj];
    NSDictionary *infoDic2 = [UserInfoManager dictionaryFromModel:_fixedInfoObj];
    if ([infoDic1 isEqualToDictionary:infoDic2])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        CustomAlertview *alert = [[CustomAlertview alloc]initWithTitle:@"提示" message:@"您要保存修改的信息吗？" delegate:self withContextView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
        alert.tag = saveInfoTag;
        [alert show];
    }
}
- (void)initData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [SingleCamera sharedIntance].delegate = self;
    describeArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"年龄",@"身高",@"体重", nil];
        //从数据库取出数据
    
        
    if ([UserInfoManager getUserInfoDic] != nil)
    {
        _userInfoObj = [UserInfoManager getUserInfoDic];
        _fixedInfoObj = [UserInfoManager getUserInfoDic];
    }
    else
    {
        NSDictionary *dic = @{@"age":@"25",
                              @"gender":@"0",
                              @"height":@"170",
                              @"mac":[Singleton getMacSite],
                              @"imageUrl":@"",
                              @"userid":[Singleton getUserID],
                              @"username":@"昵称",
                              @"weight":@"60"};
        _userInfoObj = [t_userInfo convertDataToModel:dic];
        _fixedInfoObj = [t_userInfo convertDataToModel:dic];
    }
    
    
    _yearArr = [NSMutableArray array];
    _monthArr = [NSMutableArray array];
    _dayArr = [NSMutableArray array];
    _heigthArr = [NSMutableArray arrayWithCapacity:0];
    _weightArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1900; i<=[DateHandle getCurrentDateorTimeWithIndex:0]; i++)
    {
        [_yearArr addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 1; i<=12; i++)
    {
        [_monthArr addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 90; i < 251; i ++) {
        [_heigthArr addObject:[NSString stringWithFormat:@"%d",i]];
        heighUIntArray[i - 90] = i;
    }
    for (int i = 30; i < 251; i ++) {
        [_weightArr addObject:[NSString stringWithFormat:@"%d",i]];
        weightUIntArray[i - 30] = i;
    }
    for (UInt8 i = 0; i< 150; i++) {
        
        ageUIntArray[i] = i+3;
    }
    currentAge = 1;
    currentHeight = 90;
    currentWeight = 30;
    
    ageUInt = 3;
    heighUInt = 90;
    weightUInt = 30;
    genderUInt = 1;
}

- (void)createView
{
    personalInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    UIButton *sureBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, CGRectGetMaxY(personalInfoTable.frame)+10, SCREEN_WIDTH-40, 40) title:NSLocalizedString(@"confirm", nil) align:@"center" color:[UIColor blackColor] fontsize:14 tag:11 clickAction:@selector(saveUserInfoToLocal)];
    sureBn.layer.cornerRadius = 20;
    sureBn.layer.masksToBounds = YES;
    sureBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sureBn.layer.borderWidth = 1.0;
    [self.view addSubview:sureBn];
    
    personalInfoTable.delegate = self;
    personalInfoTable.dataSource = self;
    personalInfoTable.backgroundColor = [UIColor whiteColor];
    personalInfoTable.scrollEnabled = YES;
    [self.view addSubview:personalInfoTable];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return describeArray.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor clearColor];
    [self addTableFootView:tableView];
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 140;
    }
    if (iPhone4) {
        return 55;
    }
    return 60;
}

//需要避免重影
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    else
    {
        while ([cell.contentView.subviews lastObject]) {
            [(UIView *)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    if (indexPath.row != 0) {
        cell.textLabel.text = [describeArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = CGRectMake(0, 120, SCREEN_WIDTH, 20);
        layer.backgroundColor = CGCOLOR(225, 229, 230);
        [cell.contentView.layer addSublayer:layer];
    }
    //靠右对齐的label
    NSString *labelText = [NSString string];
    
    switch (indexPath.row) {
        case 1:
        {
            labelText = _userInfoObj.username;
        }
            break;
        case 2:
        {
            //labelText = _userInfoObj.gender;
            if ([_userInfoObj.gender isEqualToString:@"0"]) {
                labelText = @"男";
            }
            else
            {
                labelText = @"女";
            }
        }
            break;
        case 3:
        {
            labelText = _userInfoObj.age;
            
        }
            break;
        case 4:
        {
            labelText = [NSString stringWithFormat:@"%@厘米",_userInfoObj.height];
            
        }
            break;
        case 5:
        {
            labelText = [NSString stringWithFormat:@"%@千克",_userInfoObj.weight];
            
        }
            break;
        case 6:
        {
        }
            break;
        default:
            break;
    }
    if (indexPath.row != 0) {
        UILabel *valueLabel = [PublicFunction getlabel:CGRectMake(100, 10, SCREEN_WIDTH-150, 40) text:labelText fontSize:16 color:COLOR(0, 194, 194) align:@"right"];
        [cell.contentView addSubview:valueLabel];
    }
    else
    {
        NSData *headImageData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_HEADIMAGE_KEY];
        UIImage *headImage = [[UIImage alloc]initWithData:headImageData];
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 20, 80, 80)];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
        if (headImageData) {
//            headImageView.image = headImage;

            headImageView.image = [UIImage imageNamed:@"head_portrait"];}
        else
        {
            headImageView.image = [UIImage imageNamed:@"head_portrait"];
        }
        [cell.contentView addSubview:headImageView];
    }
    cell.backgroundColor = ColorRGB(223, 224, 225);
    return cell;
}

- (void)setHeaderImage
{
    UIActionSheet *headerAction = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    headerAction.actionSheetStyle = UIActionSheetStyleAutomatic;
    [headerAction showInView:self.view];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            [self setHeaderImage];
        }
            break;
        case 1:
        {
            [self createNickNameView];
            
        }
            break;
        case 2:
        {
            [self createGenderView];
            
        }
            break;
        case 3://年龄：改为生日
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_age;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.age = [NSString stringWithFormat:@"%@",values];
                ageUInt = ageUIntArray[[values integerValue] - 3];
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
        }
            break;
        case 4://身高
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_height;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.height = values;
                heighUInt = heighUIntArray[[values integerValue] - 90];
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
            
        }
            break;
        case 5://体重
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_weight;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.weight = values;
                weightUInt = weightUIntArray[[values integerValue] - 30];
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
            
            
        }
            break;
            
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)addTableFootView:(UITableView*)ta
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    view.backgroundColor = [UIColor clearColor];
    [ta setTableFooterView:view];
    
}
#pragma mark - 自定义的alertview的代理方法

- (void)alertView:(CustomAlertview *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSLog(@"--%ld--",(long)buttonIndex);
    switch (alertView.tag) {
        case nameTag:
        {
            if(buttonIndex == 1)//确定按钮:保存用户昵称
            {
                UITextField *textField = (UITextField *)[alertView viewWithTag:1000];
                _userInfoObj.username = textField.text;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
        case genderTag:
        {
            if (buttonIndex == 1) {
                UISwitch *genderswitch = (UISwitch *)[alertView viewWithTag:12];
                
                if (!genderswitch.on) {
                    //[valueArray replaceObjectAtIndex:0 withObject:@"男"];
                    _userInfoObj.gender = @"男";
                }
                else
                {
                    //[valueArray replaceObjectAtIndex:0 withObject:@"女"];
                    _userInfoObj.gender = @"女";
                }
                NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:2 inSection:0];
                [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            break;
        }
        case ageTag:
        {
            if (buttonIndex==1) {
                //                NSString *nowAge = _ageArray[currentAge];
                //                [valueArray replaceObjectAtIndex:1 withObject:nowAge];
                //                NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:1 inSection:0];
                //                [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
                NSString *birthday = [NSString stringWithFormat:@"%@年%@月%@日",_yearArr[year],_monthArr[month],_dayArr[day]];
                //[valueArray replaceObjectAtIndex:1 withObject:birthday];
                _userInfoObj.age = birthday;
                NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:3 inSection:0];
                [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            break;
        }
        case heightTag:
        {
            if (buttonIndex == 1) {
                
                NSString *unitStr =@"cm";
                NSString *height = [NSString stringWithFormat:@"%@",_heigthArr[oneCompoent]];
                
                if (twoCompoent == 1)
                {
                    height = [NSString stringWithFormat:@"%.2f",[_heigthArr[oneCompoent] integerValue]*0.0328084];
                    unitStr = @"ft";
                    
                }
                
                //NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:2 inSection:0];
                _userInfoObj.height = height;
                [personalInfoTable reloadData];
            }
            
            
            break;
        }
        case weightTag:
        {
            if (buttonIndex==1) {
                
                NSString *unitStr =@"kg";
                NSString *weight = [NSString stringWithFormat:@"%@",_weightArr[oneCompoent]];
                if (twoCompoent == 1)
                {
                    unitStr = @"lbs";
                    weight = [NSString stringWithFormat:@"%.0f",[_weightArr[oneCompoent] integerValue]*2.2046226];
                    
                }
                _userInfoObj.weight = weight;
                [personalInfoTable reloadData];
            }
            
            break;
        }
        case tagetTag:
        {
            if (buttonIndex==1)
            {
                
            }
            
            break;
        }
        case eixtLogin:
        {
            if (buttonIndex==1) {
                
            }
            break;
        }
        case saveInfoTag:
        {
            if (buttonIndex == 1)//保存信息并退到主页面
            {
                [self saveUserInfoToLocal];
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma - mark:PickView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //有多少列:设置年龄时为3列,身高和体重为两列
    if (pickerView.tag == 1) {
        return 3;
    }
    else
        return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1://年龄
        {
            if (component == 0 ) {
                
                return _yearArr.count;
                
            }
            else if (component == 1){
                return 12;
            }
            else{
                //                if (year == 0 && month == 0) {
                //
                //                    NSString *date = _userInfoObj.birthDay;
                //                    [_dayArr addObjectsFromArray:[DateHandle getdaysArrayByTheDate:date withType:@"yyyy-MM-dd"]];
                //                    NSLog(@"%@",_dayArr);
                //                    return _dayArr.count;
                //                }
                //                else{
                
                NSString *date = [NSString stringWithFormat:@"%d-%d-%@",[_yearArr[year] intValue],[_monthArr[month] intValue],@"01"];
                [_dayArr removeAllObjects];
                [_dayArr addObjectsFromArray:[DateHandle getdaysArrayByTheDate:date withType:@"yyyy-MM-dd"]];
                return _dayArr.count;
                //}
                
            }
        }
            break;
        case 2://身高
        {
            if (component == 0) {
                return _heigthArr.count;
            }
            else{
                return 2;
            }
        }
            break;
        case 3://体重
        {
            if (component == 0) {
                return _weightArr.count;
            }
            else{
                return 2;
            }
        }
            break;
        default:
            break;
    }
    return 1;
}
//pickView上显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1://年龄
        {
            if (component == 0) {
                return [NSString stringWithFormat:@"%@",_yearArr[row]];
            }
            else if (component == 1){
                
                return [NSString stringWithFormat:@"%@",_monthArr[row]];
            }
            else{
                
                return [NSString stringWithFormat:@"%@",_dayArr[row]];
            }
        }
            break;
        case 2://身高
        {
            if (component == 0) {
                
                if (twoCompoent == 0) {
                    return _heigthArr[row];
                }
                else{
                    double heigh = [_heigthArr[row] integerValue]*0.0328084;
                    // NSLog(@"%d,--------%@",heigh,_heigthArr[row]);
                    return [NSString stringWithFormat:@"%.2f",heigh];
                }
            }
            else{
                
                if (row == 0) {
                    
                    return @"cm";
                }
                else{
                    return @"ft";
                }
            }
            
        }
            break;
        case 3://体重
        {
            if (component == 0) {
                
                if (twoCompoent == 0) {
                    return _weightArr[row];
                }
                else{
                    double weight = [_weightArr[row] integerValue]*2.2046226;
                    
                    return [NSString stringWithFormat:@"%.0f",weight];
                }
                
            }
            else{
                
                if (row == 0) {
                    
                    return @"kg";
                }
                else{
                    return @"lbs";
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    return @"你好";
}
//选中某一行后
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1://年龄
        {
            if (component == 0) {
                //year = 0;
                year = row;
            }
            else if (component == 1){
                month = 0;
                month = row;
            }
            else
            {
                day = 0;
                day = row;
            }
            [pickerView reloadComponent:2];
        }
            break;
        case 2://身高
        {
            currentHeight = row;
            if (component == 0) {
                oneCompoent = row;
            }
            else if(component ==1){
                twoCompoent = row;
                [pickerView reloadComponent:0];
            }
        }
            break;
        case 3://体重
        {
            currentWeight = row;
            if (component == 0) {
                oneCompoent = row;
            }
            else if(component ==1){
                twoCompoent = row;
                [pickerView reloadComponent:0];
            }
        }
            break;
        default:
            break;
    }
}
//创建昵称的View
- (void)createNickNameView
{
    TextKeyBoadViewController *info = [[TextKeyBoadViewController alloc]init];
    [info textFieldString:^(NSString *stg) {
        _userInfoObj.username = stg;
        nameStg = stg;
        NSIndexPath *tmpIndexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    info.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self addChildViewController:info];
    [self.view addSubview:info.view];
}
- (void)keyboardWillShown:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [aValue CGRectValue];
    CGFloat keyBoardEndY = rect.origin.y;
    //CGFloat width = rect.size.width;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGPoint center = CGPointMake(screenWidth/2, screenHeight+15);
    popView.center = center;
    
    [UIView animateWithDuration:duration.doubleValue    animations:^{
        popView.center = CGPointMake(center.x, keyBoardEndY-25);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)keyBoardWillHide:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info = [notification userInfo];
    //CGFloat width = rect.size.width;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGPoint center = CGPointMake(screenWidth/2, screenHeight+25);
    [UIView animateWithDuration:duration.doubleValue animations:^{
        popView.center = center;
    }];
}

//创建性别的VIew：换一种方式
-(void)createGenderView{
    
    CustomActionSheetView *sheet = [CustomActionSheetView sharaActionSheetWithStyle:@"Gender"];
    [sheet customActionSheetSelectedIndexButton:^(UIButton *button) {
        
        switch (button.tag) {
            case 9900:
            {
                _userInfoObj.gender = @"0";
                genderUInt = 0;
            }
                break;
            case 9901:
            {
                _userInfoObj.gender = @"1";
                genderUInt = 1;
            }
                break;
            default:
                break;
        }
        NSIndexPath *tmpIndexpath = [NSIndexPath indexPathForRow:2 inSection:0];
        [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        [sheet removeFromSuperview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
}

- (void)confirmNickName
{
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [[SingleCamera sharedIntance]cameraFromControl:self.view cameraType:camera];//camera
        }
            break;
        case 1:
        {
            [[SingleCamera sharedIntance]cameraFromControl:self.view cameraType:photosAlbum];
        }
            break;
        default:
            break;
    }
    
}
#pragma - Mark:Camera 的delegate,需要对图片命名
- (void)useImageFromCamera:(UIImage *)image
{
    headImageView.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:LOCAL_HEADIMAGE_KEY];
    //同时上传头像到服务器
    //[NetworkManager uploadUserHeadImage:<#(NSString *)#> imageName:<#(NSString *)#> image:<#(UIImage *)#>]
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveUserInfoToLocal
{
    /**
     发送用户信息 2015-08-11添加
     */
//    [[[UserInfoMation alloc]init]sendUserInfoMation:ageUInt Gender:genderUInt High:heighUInt Weight:weightUInt Name:nameStg];
//    BOOL exist = [[DBOperator shared]checkTheDataExistOnDB:@"t_userInfo" withKey:@"userId" withValue:[Singleton getUserID]];
//    if (exist) {
//        BOOL success = [userInfoManage updateUserId:[Singleton getUserID] userName:_userInfoObj.userName height:_userInfoObj.height weight:_userInfoObj.weight gender:_userInfoObj.gender birthDay:_userInfoObj.birthDay imageUrl:nil weightUnit:_userInfoObj.weightUnit heightUnit:_userInfoObj.heightUnit];
//        if (success) {
//            NSLog(@"更新数据库成功");
//        }
//    }
//    else
//    {
//        NSLog(@"该数据不存在");
//        int success = [userInfoManage adduserId:[Singleton getUserID] userName:_userInfoObj.userName height:_userInfoObj.height weight:_userInfoObj.weight gender:_userInfoObj.gender birthDay:_userInfoObj.birthDay imageUrl:nil weightUnit:_userInfoObj.weightUnit heightUnit:_userInfoObj.heightUnit];
//        NSLog(@"添加数据为%d",success);
//    }
    
//    NSUserDefaults *userDefailt =  [NSUserDefaults standardUserDefaults];
//    [userDefailt setObject:[Singleton getUserID] forKey:@"getUserID"];
//    [userDefailt setObject:_userInfoObj.username forKey:@"userName"];
//    [userDefailt setObject:_userInfoObj.height forKey:@"height"];
//    [userDefailt setObject:_userInfoObj.weight forKey:@"weight"];
//    [userDefailt setObject:_userInfoObj.gender forKey:@"gender"];
//    [userDefailt setObject:_userInfoObj.age forKey:@"birthDay"];
//    [userDefailt setObject:_userInfoObj.imageUrl forKey:@"imageUrl"];
//    [userDefailt setObject:UIImagePNGRepresentation(headImageView.image) forKey:@"headImage"];
//    [userDefailt synchronize];
    
    [UserInfoManager insertDefaultUserInfo:_userInfoObj];
    [self.view makeToastActivity];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view hideToastActivity];
        UserSportTargetController *u = [UserSportTargetController new];
        u.showSegment = NO;
        [self.navigationController pushViewController:u animated:YES];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end