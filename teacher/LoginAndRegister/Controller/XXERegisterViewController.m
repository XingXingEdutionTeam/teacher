//
//  XXERegisterViewController.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterViewController.h"
#import "XXERegisterSecondViewController.h"

@interface XXERegisterViewController ()

@property (nonatomic, strong)UITextField *registerUerTextField;
@property (nonatomic, strong)UITextField *registerVerificationTextField;
@property (nonatomic, strong)UIButton *button;

@end

@implementation XXERegisterViewController

- (UITextField *)registerUerTextField
{
    if (!_registerUerTextField) {
        _registerUerTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入11位手机号"];
        _registerUerTextField.borderStyle = UIKeyboardTypeNamePhonePad;
    }
    return _registerUerTextField;
}

- (UITextField *)registerVerificationTextField
{
    if (!_registerVerificationTextField) {
        _registerVerificationTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"输入4位验证码"];
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
    verificationButton.titleLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    [verificationButton setTitleColor:XXEColorFromRGB(189, 210, 38) forState:UIControlStateNormal];
    [verificationButton addTarget:self action:@selector(setupVerificationNumber:) forControlEvents:UIControlEventTouchUpInside];
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
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    
}


#pragma mark - 点击相应方法actionClick

- (void)setupVerificationNumber:(UIButton *)sender
{
    NSLog(@"----获取验证码----");
    [sender startWithTime:59 title:@"获取验证码" countDownTile:@"s后重新获取" mColor:XXEColorFromRGB(189, 210, 38) countColor:XXEColorFromRGB(204, 204, 204)];
}

- (void)nextButtonClick:(UIButton *)sender
{
    NSLog(@"-----下一步-----");
    XXERegisterSecondViewController *registerSecondVC = [[XXERegisterSecondViewController alloc]init];
    [self.navigationController pushViewController:registerSecondVC animated:YES];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.registerUerTextField resignFirstResponder];
    [self.registerVerificationTextField resignFirstResponder];
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
