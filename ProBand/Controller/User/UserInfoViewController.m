//
//  UserInfoViewController.m
//  ProBand
//
//  Created by zhuzhuxian on 15/5/5.
//  Copyright (c) 2015年 fenda. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CustomAlertview.h"
#import "SingleCamera.h"

#import "CustomPickerView.h"
#import "CustomActionSheetView.h"
#import "TextKeyBoadViewController.h"
#import "AQPhotoPickerView.h"
#import "t_userInfo.h"
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
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CustomAlertviewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CameraDelegate,UIActionSheetDelegate,UITextFieldDelegate,AQPhotoPickerViewDelegate>
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
    
    NSInteger currentAge;
    NSInteger currentHeight;//记录当前的身高
    NSInteger currentWeight;//体重
    UIView *customAlertView;
}
@property (nonatomic, strong)t_userInfo *userInfoObj;
//验证用户信息是否改变的model:保持不变
@property (nonatomic, strong)t_userInfo *fixedInfoObj;
@end

@implementation UserInfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"personal_information", nil);
    self.navigationController.navigationBar.barTintColor = COLOR(0, 31, 57);
    
    NSDictionary *titleAttribute = [NSDictionary dictionaryWithObjects:@[[UIColor whiteColor]] forKeys:@[NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.titleTextAttributes = titleAttribute;
    [self initData];
    [self createView];
    
    // Do any additional setup after loading the view.
}
//需要验证用户信息是否变化
- (void)gotoBackBtnClick
{
    //先转为dictionary再比较
    NSDictionary *infoDic1 = [UserInfoManager dictionaryFromModel:_userInfoObj];
    NSDictionary *infoDic2 = [UserInfoManager dictionaryFromModel:_fixedInfoObj];
    if ([infoDic1 isEqualToDictionary:infoDic2]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        CustomAlertview *alert = [[CustomAlertview alloc]initWithTitle:@"提示" message:@"您要保存修改的信息吗？" delegate:self withContextView:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@[NSLocalizedString(@"confirm", nil)]];
        alert.tag = saveInfoTag;
        [alert show];
    }
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [SingleCamera sharedIntance].delegate = self;
    describeArray = [NSArray arrayWithObjects:NSLocalizedString(@"icon", nil),NSLocalizedString(@"band_id", nil),NSLocalizedString(@"nickname", nil),NSLocalizedString(@"gender", nil),NSLocalizedString(@"age", nil),NSLocalizedString(@"height", nil),NSLocalizedString(@"weight", nil), nil];
    
    if ([UserInfoManager getUserInfoDic] != nil)
    {
        _userInfoObj = [UserInfoManager getUserInfoDic];
        _fixedInfoObj = [UserInfoManager getUserInfoDic];;
    }
    else
    {
        NSDictionary *dic = @{@"age":@"24",
                              @"gender":@"0",
                              @"height":@"170",
                              @"mac":[Singleton getMacSite],
                              @"imageUrl":@"",
                              @"userid":[Singleton getUserID],
                              @"username":@"昵称",
                              @"weight":@"60"
                              };
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
    }
    for (int i = 30; i < 251; i ++) {
        [_weightArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    currentAge = 1;
    currentHeight = 90;
    currentWeight = 30;
}

- (void)createView
{
    personalInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    UIButton *sureBn = [PublicFunction getButtonInControl:self frame:CGRectMake(20, CGRectGetMaxY(personalInfoTable.frame)+10, SCREEN_WIDTH-40, 40) title:NSLocalizedString(@"login", nil) align:@"center" color:[UIColor blackColor] fontsize:14 tag:11 clickAction:@selector(saveUserInfoToLocal)];
    sureBn.layer.cornerRadius = 20;
    sureBn.layer.masksToBounds = YES;
    sureBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sureBn.layer.borderWidth = 1.0;
    [self.view addSubview:sureBn];
    //    CALayer *lineLayer = [[CALayer alloc]init];
    //    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    //    lineLayer.backgroundColor =[UIColor lightGrayColor].CGColor;
    //    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    //    [footView addSubview:sureBn];
    //    [footView.layer addSublayer:lineLayer];
    //    personalInfoTable.tableFooterView = [[UIView alloc]init];
    //personalInfoTable.tableFooterView.backgroundColor = [UIColor yellowColor];
    personalInfoTable.delegate = self;
    personalInfoTable.dataSource = self;
    personalInfoTable.backgroundColor = [UIColor whiteColor];
    personalInfoTable.scrollEnabled = YES;
    [personalInfoTable setTableFooterView:[[UIView alloc]init]];
    [self.view addSubview:personalInfoTable];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return describeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row == 1) {
        return 60;
    }
    if (iPhone4) {
        return 40;
    }
    return 40;
}

//需要避免重影
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //    cell.backgroundColor = [UIColor colorWithRed:223/255.0 green:234/255.0 blue:235/255.0 alpha:1];
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
    //    if (describeArray.count == indexPath.row) {
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        return cell;
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row != 0) {
        if (indexPath.row != 1) {
            cell.textLabel.text = [describeArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else
    {
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 50, 40)];
        headLabel.text = describeArray[0];
        [cell.contentView addSubview:headLabel];
        //
        //        CALayer *probandIDView = [[CALayer alloc]init];
        //        probandIDView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 40);
        //        probandIDView.backgroundColor = CGCOLOR(255, 255, 255);
        //        probandIDView.borderColor = [UIColor grayColor].CGColor;
        //        probandIDView.borderWidth = .5;
        //        [cell.contentView.layer addSublayer:probandIDView];
        //
        //        UILabel *probandID = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 80, 40)];
        //        probandID.text = describeArray[1];
        //        [cell.contentView addSubview:probandID];
        //
        //        CALayer *layer = [[CALayer alloc]init];
        //        layer.frame = CGRectMake(0, 160, SCREEN_WIDTH, 20);
        //        layer.backgroundColor = CGCOLOR(225, 229, 230);
        //        [cell.contentView.layer addSublayer:layer];
        
    }
    
    if (indexPath.row == 1) {
        
        
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = CGRectMake(0, 40, SCREEN_WIDTH, 20);
        layer.backgroundColor = CGCOLOR(225, 229, 230);
        [cell.contentView.layer addSublayer:layer];
        
        UILabel *valueLabel = [PublicFunction getlabel:CGRectMake(120, 0, SCREEN_WIDTH-150, 40) text:@"lenovo_5461" fontSize:16 color:COLOR(0, 194, 194) align:@"right"];
        [cell.contentView addSubview:valueLabel];
        
        UILabel *probandID = [PublicFunction getlabel:CGRectMake(15, 0, 100, 40) text:[describeArray objectAtIndex:indexPath.row] fontSize:16 color:COLOR(1, 1, 1) align:@"left"];
        [cell.contentView addSubview:probandID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    
    //靠右对齐的label
    NSString *labelText = [NSString string];
    //    if (valueArray && valueArray.count > 3) {
    //        labelText = [valueArray objectAtIndex:indexPath.row];
    //    }
    switch (indexPath.row) {
        case 1:
        {
            labelText = @"lenovo_5461";
        }
            break;
        case 2:
        {
            labelText = _userInfoObj.username;
        }
            break;
        case 3:
        {
            if ([_userInfoObj.gender isEqualToString:@"0"]) {
                labelText = @"男";
            }
            else
            {
                labelText = @"女";
            }
        }
            break;
        case 4:
        {
            labelText = _userInfoObj.age;
        }
            break;
        case 5:
        {
            labelText = [NSString stringWithFormat:@"%@厘米",_userInfoObj.height];
        }
            break;
        case 6:
        {
            labelText = [NSString stringWithFormat:@"%@千克",_userInfoObj.weight];
        }
            break;
        default:
            break;
    }
    if (indexPath.row != 0) {
        UILabel *valueLabel = [PublicFunction getlabel:CGRectMake(100, 0, SCREEN_WIDTH-150, 40) text:labelText fontSize:16 color:COLOR(0, 194, 194) align:@"right"];
        [cell.contentView addSubview:valueLabel];
    }
    else
    {
        NSData *headImageData = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_HEADIMAGE_KEY];
        UIImage *headImage = [[UIImage alloc]initWithData:headImageData];
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 20, 80, 80)];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
        if (headImageData) {
            headImageView.image = headImage;
        }
        else
        {
            headImageView.image = [UIImage imageNamed:@"head_portrait"];
        }
        [cell.contentView addSubview:headImageView];
        
    }
    return cell;
}

- (void)setHeaderImage
{
    //    UIActionSheet *headerAction = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    //    headerAction.actionSheetStyle = UIActionSheetStyleAutomatic;
    //    [headerAction showInView:self.view];
    
    CustomActionSheetView *sheet = [CustomActionSheetView sharaActionSheetWithStyle:@"headImage"];
    [sheet customActionSheetSelectedIndexButton:^(UIButton *button) {
        
        switch (button.tag) {
            case 9900:
            {
                [AQPhotoPickerView presentInViewController:self photoSource:@"Camera"];
                
            }
                break;
            case 9901:
            {
                [AQPhotoPickerView presentInViewController:self photoSource:@"Album"];
                
            }
                break;
            default:
                break;
        }
        [sheet removeFromSuperview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    
}

-(void)photoFromImagePickerView:(UIImage *)photo{
    
    NSLog(@"图片拿到了：%@",photo);
    [headImageView setImage:photo];
    
    NSData *imageData = UIImagePNGRepresentation(photo);
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:LOCAL_HEADIMAGE_KEY];
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
            
        }
            break;
        case 2:
        {
            [self confirmNickName];
            
        }
            break;
        case 3:
        {
            [self createGenderView];
            
        }
            break;
        case 4://年龄：改为生日
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_age;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.age = [NSString stringWithFormat:@"%@",values];
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
            
        }
            break;
        case 5://身高
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_height;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.height = values;
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
            
        }
            break;
            
        case 6://体重
        {
            CustomPickerView *vc = [[CustomPickerView alloc]init];
            vc.view.frame = [UIScreen mainScreen].bounds;
            vc.pickerType = pickerType_weight;
            [vc returnSelectRowString:^(NSString *values) {
                _userInfoObj.weight = values;
                [personalInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 自定义的alertview的代理方法

- (void)alertView:(CustomAlertview *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSLog(@"--%ld--",buttonIndex);
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
    //显示一个悬浮框:改为显示键盘上方的VIew
    popView =[[UIView alloc]initWithFrame:CGRectMake(0, 10, 260, 70)];
    nickText = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, 240, 40)];
    [popView addSubview:nickText];
    nickText.tag = 1000;
    nickText.delegate = self;
    nickText.placeholder = @"输入昵称";
    [nickText becomeFirstResponder];
    CALayer *line = [CALayer new];
    line.frame = CGRectMake(20, 100, 240, 1);
    line.backgroundColor = [UIColor blackColor].CGColor;
    [popView.layer addSublayer:line];
    
    UIButton *confirmBn = [PublicFunction getButtonInControl:self frame:CGRectMake(CGRectGetMaxX(nickText.frame), 10, 60, 50) title:@"确定" align:@"center" color:[UIColor lightGrayColor] fontsize:18 tag:20 clickAction:@selector(confirmNickName)];
    confirmBn.layer.masksToBounds = YES;
    confirmBn.layer.cornerRadius = 5.0;
    confirmBn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    confirmBn.layer.borderWidth = 1.0;
    [popView addSubview:confirmBn];
    //    CustomAlertview *alert = [[CustomAlertview alloc]initWithTitle:@"设置昵称" message:nil delegate:self withContextView:popView cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
    //    alert.tag = nameTag;
    //    alert.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 70);
    //    [alert show];
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
-(void)createGenderView
{
    CustomActionSheetView *sheet = [CustomActionSheetView sharaActionSheetWithStyle:@"Gender"];
    [sheet customActionSheetSelectedIndexButton:^(UIButton *button) {
        
        switch (button.tag) {
            case 9900:
            {
                _userInfoObj.gender = @"0";
                
            }
                break;
            case 9901:
            {
                _userInfoObj.gender = @"1";
                
            }
                break;
            default:
                break;
        }
        NSIndexPath *tmpIndexpath = [NSIndexPath indexPathForRow:3 inSection:0];
        [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        [sheet removeFromSuperview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
}

- (void)confirmNickName
{
    TextKeyBoadViewController *info = [[TextKeyBoadViewController alloc]init];
    [info textFieldString:^(NSString *stg) {
        _userInfoObj.username = stg;
        NSIndexPath *tmpIndexpath = [NSIndexPath indexPathForRow:2 inSection:0];
        [personalInfoTable reloadRowsAtIndexPaths:@[tmpIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    info.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self addChildViewController:info];
    [self.view addSubview:info.view];
    
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
    [headBtn setImage:image forState:UIControlStateNormal];
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
    //如果信息未完全填写
    //    for (NSString *string in _us) {
    //        if (string.length <= 0) {
    //            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请填写全部信息"];
    //             return;
    //        }
    //       }
    //[self addAlertView];
    
    
    [UserInfoManager insertDefaultUserInfo:_userInfoObj];
}
- (void)addAlertView
{
    customAlertView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    customAlertView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(customAlertView.frame) - 215, CGRectGetWidth(customAlertView.frame), 215)];
    NSString *string = NSLocalizedString(@"logout", nil);
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(customAlertView.frame), 24)];
    lable.text = string;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    //    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bracelet_line@2x"]];
    //    imageview.frame = CGRectMake(20, CGRectGetMaxY(lable.frame)+ 10, CGRectGetWidth(view.frame) - 40, 1);
    
    string = NSLocalizedString(@"logout_message", nil);
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) + 20, CGRectGetWidth(customAlertView.frame), 24)];
    lable2.text = string;
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
    SubSegmentedControl *seg = [[SubSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"解绑",@"取消", nil]];
    seg.frame = CGRectMake(20, CGRectGetHeight(view.frame) - 57, CGRectGetWidth(view.frame) - 40, 37);
    seg.layer.cornerRadius = CGRectGetHeight(seg.frame)/2;
    [seg segmentSelectedIndex:^(SubSegmentedControl *segmc) {
        NSLog(@"%d",segmc.selectedSegmentIndex);
        
        if (segmc.selectedSegmentIndex == 1) {
            [customAlertView removeFromSuperview];
        }else{
            NSLog(@"解绑");
            [customAlertView removeFromSuperview];
            
        }
        segmc.selectedSegmentIndex = -1;
    }];
    
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:lable];
    //    [view addSubview:imageview];
    [view addSubview:lable2];
    [view addSubview:seg];
    [customAlertView addSubview:view];
    [[UIApplication sharedApplication].keyWindow addSubview:customAlertView];
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
