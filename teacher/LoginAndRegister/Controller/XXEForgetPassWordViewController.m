//
//  XXEForgetPassWordViewController.m
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEForgetPassWordViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "XXEVertifyTimesApi.h"
#import "XXERegisterCheckApi.h"
#import "XXERegisterSecondViewController.h"
#import "XXELoginViewController.h"
#import "XXENavigationViewController.h"
#import "SystemPopView.h"

@interface XXEForgetPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *registerUerTextField;
@property (nonatomic, strong)UITextField *registerVerificationTextField;
@property (nonatomic, strong)UIButton *button;
/** 用户名 */
@property (nonatomic, copy)NSString *registerUserName;
/** 验证码 */
@property (nonatomic, copy)NSString *registerVerifi;

/** 验证码按钮 */
@property (nonatomic, strong)UIButton *verificationButton;

@property (nonatomic, copy)NSString *phone;

@end

@implementation XXEForgetPassWordViewController
- (UITextField *)registerUerTextField
{
    if (!_registerUerTextField) {
        _registerUerTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入11位手机号"];
        [_registerUerTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        _registerUerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registerUerTextField.delegate = self;
        _registerUerTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _registerUerTextField;
}

- (UITextField *)registerVerificationTextField
{
    if (!_registerVerificationTextField) {
        _registerVerificationTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"输入4位验证码"];
        _registerVerificationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _registerVerificationTextField.delegate = self;
        _registerVerificationTextField.borderStyle = UIKeyboardTypeDefault;
    }
    return _registerVerificationTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;

    self.navigationItem.title = @"忘记密码";
    
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
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
    label.font = [UIFont systemFontOfSize:12 * kScreenRatioWidth];
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
    
    [verificationImageView addSubview:self.registerVerificationTextField];
    
    if (self.loginType == LoginNot) {
        [userImageView addSubview:self.registerUerTextField];
        [self.registerUerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userImageView.mas_centerY);
            make.left.equalTo(userIconImageView.mas_right).offset(10*kScreenRatioWidth);
            make.right.equalTo(userImageView.mas_right).offset(0);
            make.height.mas_equalTo(41*kScreenRatioHeight);
        }];
    }else if (self.loginType == LoginSure) {
        label.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        userImageView.hidden = YES;
        NSRange range;
        range.length = 4;
        range.location = 3;
        
        UILabel *userNameLbl = [[UILabel alloc] init];
        userNameLbl.font = [UIFont systemFontOfSize:15];
        userNameLbl.textColor = UIColorFromHex(000);
        userNameLbl.textAlignment = NSTextAlignmentCenter;
        userNameLbl.text = [[XXEUserInfo user].account stringByReplacingCharactersInRange:range withString:@"****"];;
        [self.view addSubview:userNameLbl];
        [userNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(label.mas_bottom).offset(26*kScreenRatioHeight);
            make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
        }];
        
    }
    
    
    [self.registerVerificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationImageView.mas_centerY);
        make.left.equalTo(passIconImageView.mas_right).offset(10*kScreenRatioWidth);
        make.right.equalTo(verificationImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    
    _verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _verificationButton = verificationButton;
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    [_verificationButton setTitleColor:XXEColorFromRGB(189, 210, 38) forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(setupVerificationNumber:) forControlEvents:UIControlEventTouchUpInside];
//    _verificationButton.userInteractionEnabled = NO;
    [verificationImageView addSubview:_verificationButton];
    [_verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verificationImageView.mas_centerY);
        make.right.equalTo(weakSelf.registerVerificationTextField.mas_right).offset(-10);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [verificationImageView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationImageView.mas_top).offset(0);
        make.right.equalTo(_verificationButton.mas_left).offset(-3);
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
    
    if (self.loginType == LoginSure) {
        
    }else {
        [self setLeftBarBtn];
    }
    
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
    
//    NSLog(@"获取验证码=======");
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

#pragma mark - UItextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
////    if (self.registerUerTextField == textField) {
////        [self.registerUerTextField resignFirstResponder];
////        if (self.registerUserName == nil) {
////            [self showString:@"输入电话号码有误" forSecond:1.f];
////        } else {
////            //验证手机号有没有注册过
//////            [self checkPhoneNumber];
////        }
////    }
//}

#pragma mark - 网络请求

- (void)checkPhoneNumberWithPhone:(NSString *)phone
{
    
    XXERegisterCheckApi *registerCheckApi = [[XXERegisterCheckApi alloc]initWithChechPhoneNumber:phone];
    [registerCheckApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"电话可不可以用%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        NSString *string = [dic objectForKey:@"code"];
        if ([string intValue] == 1) {
            [self showString:@"此号码没有注册过" forSecond:1.f];
//            self.verificationButton.userInteractionEnabled = NO;
            self.registerVerificationTextField.enabled = NO;
        } else if ([string intValue] == 3) {
            [self showString:@"可以更改密码" forSecond:3.f];
            
            self.registerVerificationTextField.enabled = YES;
            [self.verificationButton startWithTime:60 title:@"获取验证码" countDownTile:@"s后重新获取" mColor:XXEColorFromRGB(189, 210, 38) countColor:XXEColorFromRGB(204, 204, 204)];
            
            [self getVerificationNumberWithPhone:phone];
//            self.verificationButton.userInteractionEnabled = YES;
        } else{
            [self showString:@"请重新输入" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"网络不好请重新输入" forSecond:1.f];
    }];
}

-(void)textFieldResignFirstResponder {
    
    [self.registerUerTextField resignFirstResponder];
    [self.registerVerificationTextField resignFirstResponder];
}

-(void)textFieldTextChange:(UITextField*)textField {
    NSString *tmpStr = textField.text;
    if (textField.text.length >= 11) {
        textField.text = [tmpStr substringToIndex:11];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.registerVerificationTextField == textField) {
        [self.registerVerificationTextField becomeFirstResponder];
    }else {
        
    }
}

- (void)setupVerificationNumber:(UIButton *)sender
{
    [self textFieldResignFirstResponder];
    NSString *phone;
    if (self.loginType == LoginNot) {
        if ([self.registerUerTextField.text isEqualToString:@""]) {
            [self showString:@"请输入手机号" forSecond:2];
            return;
        }
        phone = self.registerUerTextField.text;
    }else if (self.loginType == LoginSure) {
        phone = [XXEUserInfo user].account;
    }
    self.phone = phone;
    [self checkPhoneNumberWithPhone:phone];
    
    
}

- (void)nextButtonsClick:(UIButton *)sender
{
    [self textFieldResignFirstResponder];
    
    if (self.loginType == LoginNot) {
        if ([self.registerUerTextField.text isEqualToString:@""]) {
            [self showString:@"请输入手机号" forSecond:2];
            return;
        }
    }else if (self.loginType == LoginSure) {
        
    }
    
    
    if ([self.registerVerificationTextField.text isEqualToString:@""]) {
        [self showString:@"请输入验证码" forSecond:2];
        return;
    }
    //验证验证码对不对
    [self verifyNumberISRight];
    
//    XXERegisterSecondViewController *registerVC = [[XXERegisterSecondViewController alloc]init];
//    registerVC.forgetPassWordPage = @"忘记密码--";
//    registerVC.forgetPhonrNum = self.registerUserName;
//    [self.navigationController pushViewController:registerVC animated:YES];
//
}

#pragma mark - 验证验证码对不对
-(void)verifyNumberISRight
{
    NSLog(@"电话号码%@ 验证码%@",self.registerUerTextField.text,self.registerVerificationTextField.text);
    
    
//    [SMSSDK commitVerificationCode:self.registerVerificationTextField.text phoneNumber:self.phone zone:@"86" result:^(NSError *error) {
//        if (error) {
//            [self showString:@"验证码错误" forSecond:1.f];
//        }else {
//            //标示是不是从忘记页面跳转过去的
//        }
//    }];
    NSString *forgetPass = @"忘记密码--";
    XXERegisterSecondViewController *registerVC = [[XXERegisterSecondViewController alloc]init];
    
    if (self.passwordType == PayPassword) {
        registerVC.passwordType = PayPassword;
    }else if (self.passwordType == LoginPassword) {
        registerVC.passwordType = LoginPassword;
    }
    
    if (self.loginType == LoginSure) {
        registerVC.loginType = LoginSure;
        registerVC.forgetPhonrNum = [XXEUserInfo user].account;
    }else if (self.loginType == LoginNot) {
        registerVC.loginType = LoginNot;
        registerVC.forgetPhonrNum = self.registerUserName;
    }
    
    registerVC.forgetPassWordPage = forgetPass;
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.registerUerTextField resignFirstResponder];
    [self.registerVerificationTextField resignFirstResponder];
}

- (void)getVerificationNumberWithPhone:(NSString*)phone
{
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            
            //记录次数
            [self recordTheVerifyCodeNumWithPhone:phone];
        }else {
            [self showString:@"获取验证码失败" forSecond:1.f];
        }
    }];
}

#pragma mark - 获取验证码次数
- (void)recordTheVerifyCodeNumWithPhone:(NSString*)phone
{
    XXEVertifyTimesApi *timesApi = [[XXEVertifyTimesApi alloc]initWithVertifyTimesActionPage:@"2" PhoneNum:phone];
    [timesApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSInteger code1 = [code integerValue];
        
        if (code1 == 4) {
            [self showString:@"已达今日5条上线" forSecond:1.f];
//            self.verificationButton.userInteractionEnabled = NO;
        }else {
            [self showString:@"获取验证码成功" forSecond:1.f];
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


#pragma mark - 导航栏的返回按钮
- (void)forgetPageBack
{
    XXELoginViewController *registerVC = [[XXELoginViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:registerVC];
    window.rootViewController = navi;
    NSLog(@"-----免费注册-----");
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
