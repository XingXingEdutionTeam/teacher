//
//  XXERegisterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterViewController.h"
#import "XXERegisterSecondViewController.h"
#import "XXERegisterCheckApi.h"
#import "XXEVerificationApi.h"
#import "XXELoginViewController.h"
#import "XXENavigationViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "XXEVertifyTimesApi.h"

@interface XXERegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *registerUerTextField;
@property (nonatomic, strong)UITextField *registerVerificationTextField;
@property (nonatomic, strong)UIButton *button;
/** 用户名 */
@property (nonatomic, copy)NSString *registerUserName;
/** 验证码 */
@property (nonatomic, copy)NSString *registerVerifi;

/** 验证码按钮 */
@property (nonatomic, strong)UIButton *verificationButton;

@end

@implementation XXERegisterViewController

- (UITextField *)registerUerTextField
{
    if (!_registerUerTextField) {
        _registerUerTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入11位手机号"];
        _registerUerTextField.delegate = self;
        _registerUerTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _registerUerTextField;
}

- (UITextField *)registerVerificationTextField
{
    if (!_registerVerificationTextField) {
        _registerVerificationTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"输入4位验证码"];
        _registerVerificationTextField.delegate = self;
        _registerVerificationTextField.borderStyle = UIKeyboardTypeDefault;
    }
    return _registerVerificationTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"1/4注册";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [super loadView];
    //创建上面的提示
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请输入你的手机号";
    label.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    label.textColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:label];
    
    __weak typeof(self)weakSelf = self;

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(26);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 15));
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = XXEColorFromRGB(204, 204, 204);
    
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 1));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.left.equalTo(label.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 1));
    }];
    
    UIImageView *userImageView = [[UIImageView alloc]init];
    userImageView.image = [UIImage imageNamed:@"login_image"];
    [self.view addSubview:userImageView];
    userImageView.userInteractionEnabled = YES;
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(label.mas_bottom).offset(26*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    UIImageView *verificationImageView = [[UIImageView alloc]init];
    verificationImageView.image = [UIImage imageNamed:@"login_image"];
    [self.view addSubview:verificationImageView];
    verificationImageView.userInteractionEnabled = YES;
    [verificationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(userImageView.mas_bottom).offset(14*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    
    UIImageView *userIconImageView = [[UIImageView alloc]init];
    userIconImageView.image = [UIImage imageNamed:@"account_icon"];
    [userImageView addSubview:userIconImageView];
    [userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImageView.mas_left).offset(12);
        make.centerY.equalTo(userImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22*kScreenRatioWidth, 24*kScreenRatioHeight));
    }];
    
    UIImageView *passIconImageView = [[UIImageView alloc]init];
    passIconImageView.image = [UIImage imageNamed:@"login_icon"];
    [verificationImageView addSubview:passIconImageView];
    [passIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verificationImageView.mas_left).offset(12);
        make.centerY.equalTo(verificationImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22*kScreenRatioWidth, 24*kScreenRatioHeight));
    }];
    
    [userImageView addSubview:self.registerUerTextField];
    [verificationImageView addSubview:self.registerVerificationTextField];
    
    [self.registerUerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userImageView.mas_centerY);
        make.left.equalTo(userIconImageView.mas_right).offset(0);
        make.right.equalTo(userImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    [self.registerVerificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationImageView.mas_centerY);
        make.left.equalTo(passIconImageView.mas_right).offset(0);
        make.right.equalTo(verificationImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];

    
    UIButton *verificationButton = [[UIButton alloc]init];
    [verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verificationButton = verificationButton;
    verificationButton.titleLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    [verificationButton setTitleColor:XXEColorFromRGB(189, 210, 38) forState:UIControlStateNormal];
    [verificationButton addTarget:self action:@selector(setupVerificationNumber:) forControlEvents:UIControlEventTouchUpInside];
    verificationButton.userInteractionEnabled = NO;
    [verificationImageView addSubview:verificationButton];
    [verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationImageView.mas_centerY);
        make.right.equalTo(weakSelf.registerVerificationTextField.mas_right).offset(-10);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [verificationImageView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationImageView.mas_top).offset(0);
        make.right.equalTo(verificationButton.mas_left).offset(-3);
        make.size.mas_equalTo(CGSizeMake(2, 41*kScreenRatioHeight));
    }];
    
    //下一步
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(verificationImageView.mas_bottom).offset(14*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    button.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [[self.registerUerTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return [self isChinaMobile:text];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        self.registerUserName = x;
    } ];
    
    [[self.registerVerificationTextField.rac_textSignal filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        self.registerVerifi = x;
    }];
}

#pragma mark - UItextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.registerUerTextField == textField) {
        [self.registerUerTextField resignFirstResponder];
        if (self.registerUserName == nil) {
            [self showString:@"输入电话号码有误" forSecond:1.f];
        } else {
            //验证手机号有没有注册过
            [self checkPhoneNumber];
        }
    }
}


#pragma mark - 点击相应方法actionClick

- (void)back
{
    XXELoginViewController *registerVC = [[XXELoginViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:registerVC];
    window.rootViewController = navi;
    NSLog(@"-----免费注册-----");
    
}

- (void)setupVerificationNumber:(UIButton *)sender
{
    NSLog(@"----获取验证码----");
    [sender startWithTime:5 title:@"获取验证码" countDownTile:@"s后重新获取" mColor:XXEColorFromRGB(189, 210, 38) countColor:XXEColorFromRGB(204, 204, 204)];
    [self showString:@"验证码已发送" forSecond:1.f];
    [self getVerificationNumber];
}

- (void)nextButtonsClick:(UIButton *)sender
{
    //验证验证码对不对
//    [self verifyNumberISRight];
//
    //测试环境
    [self showString:@"测试" forSecond:1.f];
    XXERegisterSecondViewController *registerSecondVC = [[XXERegisterSecondViewController alloc]init];
    registerSecondVC.userPhoneNum = @"00000999999";
    registerSecondVC.login_type = @"1";
    [self.navigationController pushViewController:registerSecondVC animated:YES];
}

#pragma mark - 验证验证码对不对
-(void)verifyNumberISRight
{
    NSLog(@"电话号码%@ 验证码%@",self.registerUserName,self.registerVerifi);
    [SMSSDK commitVerificationCode:self.registerVerifi phoneNumber:self.registerUserName zone:@"86" result:^(NSError *error) {
        if (error) {
            [self showString:@"验证码错误" forSecond:1.f];
        }else {
            XXERegisterSecondViewController *registerSecondVC = [[XXERegisterSecondViewController alloc]init];
            registerSecondVC.userPhoneNum = self.registerUserName;
            registerSecondVC.login_type = @"1";
            [self.navigationController pushViewController:registerSecondVC animated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.registerUerTextField resignFirstResponder];
    [self.registerVerificationTextField resignFirstResponder];
}


#pragma mark - 网络请求

- (void)checkPhoneNumber
{
    XXERegisterCheckApi *registerCheckApi = [[XXERegisterCheckApi alloc]initWithChechPhoneNumber:self.registerUserName];
    [registerCheckApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"电话可不可以用%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        NSString *string = [dic objectForKey:@"code"];
        if ([string intValue] == 1) {
            [self showString:@"此号码可以注册" forSecond:1.f];
            self.verificationButton.userInteractionEnabled = YES;
        } else if ([string intValue] == 3) {
            [self showString:@"手机号码已存在" forSecond:2.f];
            self.verificationButton.userInteractionEnabled = NO;
        } else{
            [self showString:@"请重新注册" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"网络不好请重新注册" forSecond:1.f];
    }];
}

- (void)getVerificationNumber
{
   //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.registerUserName zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self showString:@"获取验证码成功" forSecond:1.f];
            //记录次数
            [self recordTheVerifyCodeNum];
        }
    }];
}

#pragma mark - 获取验证码次数
- (void)recordTheVerifyCodeNum
{
    XXEVertifyTimesApi *timesApi = [[XXEVertifyTimesApi alloc]initWithVertifyTimesActionPage:@"1" PhoneNum:self.registerUserName];
    [timesApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSInteger code1 = [code integerValue];
        
        if (code1 == 4) {
            [self showString:@"已达今日5条上线" forSecond:1.f];
           self.verificationButton.userInteractionEnabled = NO;
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

/** 判断用户名 */
- (BOOL)isChinaMobile:(NSString *)phoneNum{
    BOOL isChinaMobile = NO;
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if([regextestcm evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国移动");
    }
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if([regextestcu evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国联通");
    }
    
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if([regextestct evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国电信");
    }
    return isChinaMobile;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
