//
//  XXERegisterSecondViewController.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterSecondViewController.h"
#import "SettingPersonInfoViewController.h"
#import "XXEForgetPassApi.h"
#import "XXELoginViewController.h"

@interface XXERegisterSecondViewController ()
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UITextField *confirmPassWordTextField;
@end

@implementation XXERegisterSecondViewController

- (UITextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField.borderStyle = UIKeyboardTypeNamePhonePad;
        _passWordTextField = [UITextField createTextFieldWithIsOpen:YES textPlaceholder:@"6--20位字母或数字"];
    }
    return _passWordTextField;
}

- (UITextField *)confirmPassWordTextField
{
    if (!_confirmPassWordTextField) {
        _confirmPassWordTextField = [UITextField createTextFieldWithIsOpen:YES textPlaceholder:@"6--20位字母或数字"];
        _confirmPassWordTextField.borderStyle = UIKeyboardTypeDefault;
    }
    return _confirmPassWordTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    if ([self.forgetPassWordPage isEqualToString:@"忘记密码--"]) {

    self.navigationItem.title = @"2/2 找回密码";

    }else{
        self.navigationItem.title = @"2/4注册";
    }
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
    label.text = @"请设置您的密码";
    label.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:label];
    
    __weak typeof(self)weakSelf = self;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(26);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 15));
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
    
    UIImageView *passWordImageView = [[UIImageView alloc]init];
    passWordImageView.image = [UIImage imageNamed:@"login_image"];
    passWordImageView.userInteractionEnabled = YES;
    [self.view addSubview:passWordImageView];
    passWordImageView.userInteractionEnabled = YES;
    [passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(label.mas_bottom).offset(26*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    UIImageView *confirmPassWordImageView = [[UIImageView alloc]init];
    confirmPassWordImageView.image = [UIImage imageNamed:@"login_image"];
    confirmPassWordImageView.userInteractionEnabled = YES;
    [self.view addSubview:confirmPassWordImageView];
    confirmPassWordImageView.userInteractionEnabled = YES;
    [confirmPassWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(passWordImageView.mas_bottom).offset(14*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"输入密码";
    label3.font = [UIFont systemWithIphone6P:17 Iphone6:15 Iphone5:12 Iphone4:11];
    label3.tintColor = XXEColorFromRGB(51, 51, 51);
    label3.textAlignment = NSTextAlignmentLeft;
    [passWordImageView addSubview:label3];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passWordImageView.mas_left).offset(15);
        make.top.equalTo(passWordImageView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(60*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"确认密码";
    label4.font = [UIFont systemWithIphone6P:17 Iphone6:15 Iphone5:12 Iphone4:11];
    label4.tintColor = XXEColorFromRGB(51, 51, 51);
    label4.textAlignment = NSTextAlignmentLeft;
    [confirmPassWordImageView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmPassWordImageView.mas_left).offset(15);
        make.top.equalTo(confirmPassWordImageView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(60*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    [passWordImageView addSubview:self.passWordTextField];
    [confirmPassWordImageView addSubview:self.confirmPassWordTextField];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passWordImageView.mas_centerY);
        make.left.equalTo(label3.mas_right).offset(5);
        make.right.equalTo(passWordImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    [self.confirmPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmPassWordImageView.mas_centerY);
        make.left.equalTo(label4.mas_right).offset(5);
        make.right.equalTo(confirmPassWordImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    UIButton *openButton = [[UIButton alloc]init];
    [openButton setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
    [openButton setImage:[UIImage imageNamed:@"login_password_click"] forState:UIControlStateSelected];
    openButton.selected = NO;
    [openButton addTarget:self action:@selector(showThePassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [passWordImageView addSubview:openButton];
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passWordImageView.mas_centerY);
        make.right.equalTo(_passWordTextField.mas_right).offset(-10);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];

    //下一步
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(confirmPassWordImageView.mas_bottom).offset(14*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.passWordTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 6;
    }] subscribeNext:^(id x) {
        NSLog(@"电话号码:%@",x);
        self.passWordTextField.text = x;
    } ];
    
    [[self.confirmPassWordTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        
        return [text isEqualToString:self.passWordTextField.text];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
            self.confirmPassWordTextField.text = x;
    }];
}

#pragma mark - action点击相应方法
- (void)showThePassWord:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateSelected];
        self.passWordTextField.secureTextEntry = YES;
        self.confirmPassWordTextField.secureTextEntry = YES;
        NSLog(@"-----点击不显示密码-----");
        
    } else {
        
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"login_password_click"] forState:UIControlStateSelected];
        self.passWordTextField.secureTextEntry = NO;
        self.confirmPassWordTextField.secureTextEntry = NO;
        NSLog(@"-----点击显示密码-----");
    }

}

- (void)nextButtonClick:(UIButton *)sender
{
    NSLog(@"----点击进入下一个个注册----");
    [self.passWordTextField resignFirstResponder];
    [self.confirmPassWordTextField resignFirstResponder];
    NSLog(@"000:%@ 999:%@",self.confirmPassWordTextField.text,self.passWordTextField.text);
    if ([self.confirmPassWordTextField.text isEqualToString:@""] || [self.passWordTextField.text isEqualToString:@""]) {
        [self showString:@"不能为空" forSecond:1.f];
    }else if ([self.confirmPassWordTextField.text isEqualToString: self.passWordTextField.text]) {
        if ([self.forgetPassWordPage isEqualToString:@"忘记密码--"]) {
            [self setupAgainForgetPassWord];
            
        }else {
            SettingPersonInfoViewController *settingVC = [[SettingPersonInfoViewController alloc]init];
            settingVC.userSettingPhoneNum = self.userPhoneNum;
            settingVC.userSettingPassWord = self.confirmPassWordTextField.text;
            settingVC.login_type = self.login_type;
            [self.navigationController pushViewController:settingVC animated:YES];
        }
        
    } else {
        [self showString:@"两次输的密码不一样" forSecond:1.f];
    }
}

#pragma mark - 重新设置密码的网路请求
- (void)setupAgainForgetPassWord
{
    XXEForgetPassApi *forgetPassApi = [[XXEForgetPassApi alloc]initWithForgetPassWordUserType:@"2" Phone:self.forgetPhonrNum NewPass:self.confirmPassWordTextField.text];
    [forgetPassApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue]==1) {
            [self showString:@"密码更改成功" forSecond:2.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = loginVC;
                [self.view removeFromSuperview];
            });
            
        }else{
            [self showString:@"密码更改失败" forSecond:2.f];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"密码更改失败" forSecond:2.f];
    }];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.passWordTextField resignFirstResponder];
    [self.confirmPassWordTextField resignFirstResponder];
    NSLog(@"%@ %@",self.passWordTextField.text,self.confirmPassWordTextField.text);
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
