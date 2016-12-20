//
// SettingPersonInfoViewController.m
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "SettingPersonInfoViewController.h"
#import "WJCommboxView.h"
#import "CheckIDCard.h"
#import "XXERegisterTeacherViewController.h"
#import "XXERegisterHeadMasterViewController.h"
#import "XXERegisterTeacherOrClassteacherViewController.h"
#import "KTActionSheet.h"
#import "AFNetworking.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SettingPersonInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,KTActionSheetDelegate,UITextFieldDelegate>

{
    
    
    UIImagePickerController *_ipc;
}

@property(nonatomic ,strong)UITextField *parentsName;   //姓名
@property(nonatomic ,strong)UITextField *parentsIDCard;   //身份证号
/** 头像 */
@property (nonatomic, strong) UIImageView *portraitImageView;

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *teacherTypeArr;
@property(nonatomic,strong)WJCommboxView *teacherTypeCombox;
@property(nonatomic,strong)UILabel *teacherTypeLabel;
/** 用户头像 */
@property (nonatomic, strong)UIImage *avatarImage;
/** 用户类型 */
@property (nonatomic, copy)NSString *userType;

/** 用户身份证 */
@property (nonatomic, copy)NSString *userIDCard;
/** 用户护照 */
@property (nonatomic, copy)NSString *userPassPort;

/** 用户年龄 */
@property (nonatomic, copy)NSString *userAge;
/** 用户性别 */
@property (nonatomic, copy)NSString *userSex;
/** 下一步按钮 */
@property (nonatomic, strong)UIButton *nextButton;

@end

@implementation SettingPersonInfoViewController

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.layer.masksToBounds = YES;
        _portraitImageView.layer.cornerRadius = 120*kScreenRatioWidth/2;
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor clearColor];
        _portraitImageView.image = [UIImage imageNamed:@"img"];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.parentsName.delegate == nil) {
        self.parentsName.delegate = self;
    }
    
    if (self.parentsIDCard.delegate == nil) {
        self.parentsIDCard.delegate = self;
    }
    
    self.view.backgroundColor = XXEBackgroundColor;
    if ([self.login_type isEqualToString:@"1"]) {
        self.navigationItem.title = @"3/4注册";
    }else{
        self.navigationItem.title = @"完善资料1/2";
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.parentsName.delegate = nil;
    self.parentsIDCard.delegate = nil;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setLeftBarBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(forgetPageBack) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)forgetPageBack {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.whereFromController isEqualToString:@"loginVC"]) {
        [self setLeftBarBtn];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    [self thirdUserMessage];
    self.userIDCard = @"";
    self.avatarImage = nil;
    self.userPassPort = @"";
    self.userAge = @"";
    self.userSex = @"";
    self.userType = @"";
    if ([self.login_type isEqualToString:@"1"]) {
        self.QQToken = @"";
        self.t_head_img = @"";
        self.weixinToken = @"";
        self.sinaToken = @"";
        self.aliPayToken = @"";
    }
    [self createUI];
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc]init];
    }
    _ipc.delegate = self;
    _ipc.allowsEditing  = YES;
}

#pragma mark - 第三方的信息
- (void)thirdUserMessage
{
    if (self.t_head_img != nil) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.t_head_img]];
        UIImage *image = [UIImage imageWithData:data];
        self.avatarImage = image;
    }
}

-(void)createUI
{
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.portraitImageView];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10*kScreenRatioHeight);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120*kScreenRatioWidth, 120*kScreenRatioWidth));
    }];
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"点击设置头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.portraitImageView.mas_bottom).offset(10*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 40*kScreenRatioHeight));
    }];

   UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.backgroundColor = XXEColorFromRGB(255, 255, 255);
    bgImageView.image = [UIImage imageNamed:@"register_background"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20*kScreenRatioHeight);
        make.left.equalTo(weakSelf.view.mas_left).offset(8);
        make.size.mas_equalTo(CGSizeMake(359*kScreenRatioWidth, 158*kScreenRatioHeight));
    }];
    
    //姓名
    UILabel *parentsNameLabel = [UILabel setupMessageLabel:@"注册姓名:"];
    [bgImageView addSubview:parentsNameLabel];
    [parentsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(bgImageView.mas_top).offset(1);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];
    
//    parentsName = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入您的姓名"];
    self.parentsName = [[UITextField alloc] init];
    self.parentsName.placeholder = @"请输入您的姓名";
    self.parentsName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.parentsName.borderStyle = UITextBorderStyleNone;
    self.parentsName.font = [UIFont systemFontOfSize:15 * kScreenRatioWidth];
    [bgImageView addSubview:self.parentsName];
    [self.parentsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentsNameLabel.mas_right).offset(2);
        make.centerY.equalTo(parentsNameLabel.mas_centerY);
        make.right.equalTo(bgImageView.mas_right).offset(-4);
        make.height.equalTo(@(52*kScreenRatioHeight));
    }];
    
    //身份证号
    UILabel *parentsIDCardLabel = [UILabel setupMessageLabel:@"证件号:"];
    [bgImageView addSubview:parentsIDCardLabel];
    [parentsIDCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(parentsNameLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];

//    parentsIDCard = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入您的身份证号或者护照"];
    self.parentsIDCard = [[UITextField alloc] init];
    self.parentsIDCard.font = [UIFont systemFontOfSize:15 * kScreenRatioWidth];
    self.parentsIDCard.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.parentsIDCard.placeholder = @"请输入您的身份证号或者护照";
    self.parentsIDCard.delegate = self;
    self.parentsIDCard.keyboardType = UITextBorderStyleNone;
    [bgImageView addSubview:self.parentsIDCard];
    [self.parentsIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentsIDCardLabel.mas_right).offset(2);
        make.centerY.equalTo(parentsIDCardLabel.mas_centerY);
        make.right.equalTo(bgImageView.mas_right).offset(-4);
        make.height.equalTo(@(52*kScreenRatioHeight));
    }];
    
    //教职身份
    UILabel *teacherTypeLabel = [UILabel setupMessageLabel:@"教职身份:"];
    [bgImageView addSubview:teacherTypeLabel];
    [teacherTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView.mas_left).offset(5);
        make.top.equalTo(parentsIDCardLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80*kScreenRatioWidth, 52*kScreenRatioHeight));
    }];
    
    self.teacherTypeArr = [[NSArray alloc]initWithObjects:@"授课老师",@"班主任",@"管理员",@"校长",nil];
    
    self.teacherTypeCombox = [[WJCommboxView alloc]initWithFrame:CGRectMake(95*kScreenRatioWidth, 318*kScreenRatioHeight, 260*kScreenRatioWidth, 100*kScreenRatioHeight)];
    self.teacherTypeCombox.textField.placeholder = @"请选择职位";
    self.teacherTypeCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.teacherTypeCombox.textField.borderStyle = UITextBorderStyleNone;
    self.teacherTypeCombox.textField.tag = 102;
    self.teacherTypeCombox.dataArray = self.teacherTypeArr;
    self.teacherTypeCombox.listTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.teacherTypeCombox];
    
    self.nextButton = [[UIButton alloc]init];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(landClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.userInteractionEnabled = NO;
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
}

-(void)landClick:(UIButton *)sender
{
//    //测试
//    XXERegisterHeadMasterViewController *teacherVC = [[XXERegisterHeadMasterViewController alloc]init];
//    teacherVC.userPhoneNum = self.userSettingPhoneNum;
//    teacherVC.userName = parentsName.text;
//    teacherVC.userIDCarNum = parentsIDCard.text;
//    teacherVC.userPassword = self.userSettingPassWord;
//    teacherVC.userIdentifier = @"2";
//    teacherVC.userAvatarImage = self.avatarImage;
//    teacherVC.login_type = self.login_type;
//    teacherVC.userSex = self.userSex;
//    teacherVC.userAge = self.userAge;
//    [self.navigationController pushViewController:teacherVC animated:YES];
    
        if ([self.parentsName.text isEqualToString:@""])
        {
            [self showString:@"请输入姓名" forSecond:1.f];
            return;
        }
        else if (self.parentsName.text.length >5||self.parentsName.text.length <2)
        {
            [self showString:@"请输入正确的姓名" forSecond:1.f];
            return;
        }
        else if ([self.parentsIDCard.text isEqualToString:@""])
        {
            [self showString:@"请输入正确的证件号" forSecond:1.f];
            return;
        }else if ([self.teacherTypeCombox.textField.text isEqualToString:@""])
        {
            [self showString:@"请选择教职身份" forSecond:1.f];
            return;
        }else if ([self.teacherTypeCombox.textField.text isEqualToString:@"校长"] || [self.teacherTypeCombox.textField.text isEqualToString:@"管理员"]){
         if ([self.teacherTypeCombox.textField.text isEqualToString:@"校长"]) {
             self.userType = @"4";
         }else {
             self.userType = @"3";
         }
         
         XXERegisterHeadMasterViewController *headVC = [[XXERegisterHeadMasterViewController alloc]init];
            headVC.userPhoneNum = self.userSettingPhoneNum;
            headVC.userName = self.parentsName.text;
            headVC.userIDCarNum = self.userIDCard;
            headVC.headPassport = self.userPassPort;
            headVC.userPassword = self.userSettingPassWord;
            headVC.userIdentifier = self.userType;
            headVC.userAvatarImage = self.avatarImage;
            headVC.login_type = self.login_type;
            headVC.userSex = self.userSex;
            headVC.userAge = self.userAge;
            headVC.headThirdNickName = self.nickName;
            headVC.headThirdHeadImage = self.t_head_img;
            headVC.headThirdQQToken = self.QQToken;
            headVC.headThirdWeiXinToken = self.weixinToken;
            headVC.headThirdSinaToken = self.sinaToken;
            headVC.headThirdAliPayToken = self.aliPayToken;
            [self.navigationController pushViewController:headVC animated:YES];
        }
      else{
          if ([self.teacherTypeCombox.textField.text isEqualToString:@"授课老师"]) {
              self.userType = @"1";
          }else {
              self.userType = @"2";
          }
//        XXERegisterTeacherViewController *teacherVC = [[XXERegisterTeacherViewController alloc]init];
//          teacherVC.userPhoneNum = self.userSettingPhoneNum;
//          teacherVC.userName = parentsName.text;
//          teacherVC.userIDCarNum = self.userIDCard;
//          teacherVC.teacherPassport = self.userPassPort;
//          teacherVC.userPassword = self.userSettingPassWord;
//          teacherVC.userIdentifier = self.userType;
//          teacherVC.userAvatarImage = self.avatarImage;
//          teacherVC.login_type = self.login_type;
//          teacherVC.userSex = self.userSex;
//          teacherVC.userAge = self.userAge;
//          teacherVC.teacherThirdNickName = self.nickName;
//          teacherVC.teacherThirdHeadImage = self.t_head_img;
//          teacherVC.teacherThirdQQToken = self.QQToken;
//          teacherVC.teacherThirdWeiXinToken = self.weixinToken;
//          teacherVC.teacherThirdSinaToken = self.sinaToken;
//          teacherVC.teacherThirdAliPayToken = self.aliPayToken;
//        [self.navigationController pushViewController:teacherVC animated:YES];
          
          XXERegisterTeacherOrClassteacherViewController *registerTeacherOrClassteacherVC = [[XXERegisterTeacherOrClassteacherViewController alloc] init];
            registerTeacherOrClassteacherVC.userPhoneNum = self.userSettingPhoneNum;
            registerTeacherOrClassteacherVC.userName = self.parentsName.text;
            registerTeacherOrClassteacherVC.userIDCarNum = self.userIDCard;
            registerTeacherOrClassteacherVC.teacherPassport = self.userPassPort;
            registerTeacherOrClassteacherVC.userPassword = self.userSettingPassWord;
            registerTeacherOrClassteacherVC.userIdentifier = self.userType;
            registerTeacherOrClassteacherVC.userAvatarImage = self.avatarImage;
            registerTeacherOrClassteacherVC.login_type = self.login_type;
            registerTeacherOrClassteacherVC.userSex = self.userSex;
            registerTeacherOrClassteacherVC.userAge = self.userAge;
            registerTeacherOrClassteacherVC.teacherThirdNickName = self.nickName;
            registerTeacherOrClassteacherVC.teacherThirdHeadImage = self.t_head_img;
            registerTeacherOrClassteacherVC.teacherThirdQQToken = self.QQToken;
            registerTeacherOrClassteacherVC.teacherThirdWeiXinToken = self.weixinToken;
            registerTeacherOrClassteacherVC.teacherThirdSinaToken = self.sinaToken;
            registerTeacherOrClassteacherVC.teacherThirdAliPayToken = self.aliPayToken;
          [self.navigationController pushViewController:registerTeacherOrClassteacherVC animated:YES];
    }
}


#pragma mark - UItextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.parentsIDCard == textField) {
        if (self.parentsIDCard.text.length==8||self.parentsIDCard.text.length == 7) {
            self.userPassPort = self.parentsIDCard.text;
            [self testIdCardIsRegister];
            return;
        }else {
        if (self.parentsIDCard.text.length <17) {
            [self showString:@"身份证有误" forSecond:1.f];
            return;
        }else if (![CheckIDCard checkIDCard:self.parentsIDCard.text]) {
//            [self showString:@"您输入的家长身份证号码不存在" forSecond:1.f];
            [self showString:@"您输入的身份证号码不存在" forSecond:1.f];
            return;
        } else{
            [self getupUserIDCard:self.parentsIDCard.text];
            self.userIDCard = self.parentsIDCard.text;
        }
    }
        //调用测试身份证有没有注册过
        [self testIdCardIsRegister];
    }
}

- (void)testIdCardIsRegister
{
    
    NSLog(@"身份证%@ 护照%@",self.userIDCard,self.userPassPort );

    NSString *globalUrl = @"http://www.xingxingedu.cn/Global/id_card_verify";
    NSDictionary *dic = @{@"id_card":self.parentsIDCard.text,
                          @"passport":self.userPassPort,
                          @"appkey":APPKEY,
                          @"backtype":BACKTYPE,
                          @"user_type":USER_TYPE
                          };
    
    NSLog(@"身份证%@ 护照%@",self.parentsIDCard.text,self.parentsIDCard.text);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:globalUrl parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        NSString *code = [responseObject objectForKey:@"code"];
        if ([code intValue]== 1) {
            [self showString:@"可以注册" forSecond:2.f];
            self.nextButton.userInteractionEnabled = YES;
        }else if ([code intValue]== 3){
            [self showString:@"证件号已存在" forSecond:2.f];
            self.nextButton.userInteractionEnabled = NO;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
//
    
}

#pragma mark - 根据身份证号判断性别与年龄

- (void)getupUserIDCard:(NSString *)IDCard
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
       NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = (int)[dateComponent year];
    int card = (year-[[IDCard substringWithRange:NSMakeRange(6, 4)]intValue]);
    int sex = [[IDCard substringWithRange:NSMakeRange(16, 1)] intValue];
    if (sex%2 != 0) {
        NSLog(@"男");
        self.userSex = @"男";
    }else {
        self.userSex = @"女";
        NSLog(@"nv");
    }
    self.userAge = [NSString stringWithFormat:@"%d",card];
    NSLog(@"%d",card);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --更换头像
- (void)editPortrait {
    
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"拍照",@"从手机相册选择"]];
    actionSheet.delegate = self;
}

- (void)sheetViewDidSelectIndex:(NSInteger)index title:(NSString *)title sender:(id)sender
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    if (index == 1) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _ipc.sourceType = sourceType;
        _ipc.navigationBar.tintColor = [UIColor whiteColor];

        [self presentViewController:_ipc animated:YES completion:nil];
    }
    if (index == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        _ipc.allowsEditing = YES;//设置可编辑
        _ipc.sourceType = sourceType;
        _ipc.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:_ipc animated:YES completion:nil];//进入照相界面
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageAvatar = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",imageAvatar);
    self.avatarImage = imageAvatar;
//    UIImage *imageBack = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.portraitImageView setImage:imageAvatar];
    //网络请求
//    MGTPhotoPageApi *userMessageApi = [[MGTPhotoPageApi alloc]initWithUserUid:userUid andImage:imageAvatar];
//    [userMessageApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        if ([[request.responseJSONObject objectForKey:@"errorCode"] isEqualToString:@"0"]) {
//            self.productModel.imageUrl = [request.responseJSONObject objectForKey:@"errorMessage"];
//        }else{
//            self.productModel.imageUrl = [MGTUser user].avatar;
//            [self showString:@"上传图片失败，请重试" forSeconds:2];
//        }
//    } failure:^(YTKBaseRequest *request) {
//        self.productModel.imageUrl = [MGTUser user].avatar;
//        [self showString:@"上传图片失败，请重试" forSeconds:2];
//    }];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    // [searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.showsCancelButton = YES;
    [self  allview:searchBar indent:0];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
/*递归*/
//（深度优先算法）
-(void)allview:(UIView *)rootview indent:(NSInteger)indent
{
    //    NSLog(@"[%2d] %@",indent, rootview);
    indent++;
    for (UIView *aview in rootview.subviews)
    {
        /**
         在这里还可以遍历得到 UISearchBarTextField，即搜索输入框，
         */
        
        [self allview:aview indent:indent];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
    [self.view endEditing:YES];
}

@end
