//
//  XXELoginViewController.m
//  teacher
//
//  Created by codeDing on 16/8/4.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXELoginViewController.h"
#import "HyLoglnButton.h"
#import "XXENavigationViewController.h"
#import "XXETabBarControllerConfig.h"
#import "XXERegisterViewController.h"
#import "XXENavigationViewController.h"
#import "XXELoginApi.h"
#import "XXEUserInfo.h"

@interface XXELoginViewController ()<UITextFieldDelegate>
/** 用户名登录 */
@property (nonatomic, strong) UITextField *userNameTextField;
/** 密码登录 */
@property (nonatomic, strong) UITextField *passWordTextField;
/** 登陆按钮 */
@property (nonatomic, strong) HyLoglnButton *loginButton;

@end

@implementation XXELoginViewController

- (UITextField *)userNameTextField
{
    if (!_userNameTextField) {
        _userNameTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"手机"];
        _userNameTextField.delegate = self;
        _userNameTextField.borderStyle = UIKeyboardTypeNamePhonePad;
    }
    return _userNameTextField;
}

- (UITextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [UITextField createTextFieldWithIsOpen:YES textPlaceholder:@"密码"];
        _passWordTextField.delegate = self;
        _passWordTextField.borderStyle = UIKeyboardTypeDefault;
    }
    return _passWordTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)loadView
{
    [super loadView];
    //创建登录按钮
    [self setUpSubviewLayout];
    //创建免费注册等按钮
    [self setUpRegister];
    //创建第三方登录
    [self setupThirdLoginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
}
/** 创建视图View */
#pragma mark - 创建视图View
- (void)setUpSubviewLayout
{
    __weak typeof(self)weakSelf = self;
    
    UIImageView *loginHeadImageView = [[UIImageView alloc]init];
    loginHeadImageView.image = [UIImage imageNamed:@"xingxing_click"];
    [self.view addSubview:loginHeadImageView];
    [loginHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(70*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 172*kScreenRatioHeight));
    }];
    
    UIImageView *userImageView = [[UIImageView alloc]init];
    userImageView.image = [UIImage imageNamed:@"login_image"];
    [self.view addSubview:userImageView];
    userImageView.userInteractionEnabled = YES;
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(loginHeadImageView.mas_bottom).offset(18*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    UIImageView *passImageView = [[UIImageView alloc]init];
    passImageView.image = [UIImage imageNamed:@"login_image"];
    [self.view addSubview:passImageView];
    passImageView.userInteractionEnabled = YES;
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [passImageView addSubview:passIconImageView];
    [passIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passImageView.mas_left).offset(12);
        make.centerY.equalTo(passImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22*kScreenRatioWidth, 24*kScreenRatioHeight));
    }];
 
    _loginButton = [[HyLoglnButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-40, 40*kScreenRatioHeight)];
    _loginButton.userInteractionEnabled = NO;
    [_loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.backgroundColor = XXEColorFromRGB(153, 153, 153);
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [_loginButton setTintColor:[UIColor whiteColor]];
    _loginButton.layer.cornerRadius = 20.0f*kScreenRatioWidth;
    [self.view addSubview:_loginButton];
    
    [_loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*kScreenRatioWidth);
        make.right.mas_equalTo(-20*kScreenRatioWidth);
        make.top.equalTo(passImageView.mas_bottom).offset(18*kScreenRatioHeight);
        make.height.mas_equalTo(40 * kScreenRatioHeight);
        
    }];
    
    [userImageView addSubview:self.userNameTextField];
    [passImageView addSubview:self.passWordTextField];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userImageView.mas_centerY);
        make.left.equalTo(userIconImageView.mas_right).offset(0);
        make.right.equalTo(userImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImageView.mas_centerY);
        make.left.equalTo(passIconImageView.mas_right).offset(0);
        make.right.equalTo(passImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    UIButton *openPassWordButton = [[UIButton alloc]init];
    [openPassWordButton setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
    [openPassWordButton setImage:[UIImage imageNamed:@"login_password_click"] forState:UIControlStateSelected];
    openPassWordButton.selected = NO;
    [openPassWordButton addTarget:self action:@selector(showThePassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [passImageView addSubview:openPassWordButton];
    [openPassWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImageView.mas_centerY);
        make.right.equalTo(_passWordTextField.mas_right).offset(-10);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
}
#pragma mark - 创建忘记密码 游客登录 免费注册
- (void)setUpRegister
{
     __weak typeof(self)weakSelf = self;
    //免费注册按钮
    UIButton *registerButton = [self creatButtonFrame:CGRectMake(0, 0, 24, 25) title:@"免费注册" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registerButtonClick:)];
    [self.view addSubview:registerButton];
    
    [registerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(52*kScreenRatioWidth);
        make.top.equalTo(self.passWordTextField.mas_bottom).offset(77*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(55, 24));
        
    }];
    
    //游客登录
    UIButton *guestButton = [self creatButtonFrame:CGRectMake(0, 0, 24, 25) title:@"游客登录" titleColor:[UIColor colorWithRed:0/255.f green:170/255.0 blue:42/255.0 alpha:1.0] font:[UIFont systemFontOfSize:13] target:self action:@selector(guestButtonClick:)];
    [self.view addSubview:guestButton];
    
    [guestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(self.passWordTextField.mas_bottom).offset(77*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(55, 24));
        
    }];
    
    //忘记密码
    UIButton *forgetButton = [self creatButtonFrame:CGRectMake(0, 0, 24, 25) title:@"忘记密码" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(forgetPassWordButtonClick:)];
    [self.view addSubview:forgetButton];
    
    [forgetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-52*kScreenRatioWidth);
        make.top.equalTo(self.passWordTextField.mas_bottom).offset(77*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(55, 24));
    }];
}

#pragma mark - 创建第三方登录
- (void)setupThirdLoginView
{
    __weak typeof(self)weakSelf = self;
    //创建UIlabel
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"适用其他账号登录";
    messageLabel.textColor = XXEColorFromRGB(204, 204, 204);
    messageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-121*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    //建立分界线
    UIView * lineLeft = [[UIView alloc]init];
    lineLeft.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:lineLeft];
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20*kScreenRatioWidth);
        make.centerY.equalTo(messageLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 1));
    }];
    
    //建立分界线
    UIView * lineRight = [[UIView alloc]init];
    lineRight.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:lineRight];
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20*kScreenRatioWidth);
        make.centerY.equalTo(messageLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90*kScreenRatioWidth, 1));
    }];
    
    
    //创建第三方登录按钮
    //QQ
    UIButton *QQButton = [[UIButton alloc]init];
    [QQButton setBackgroundImage:[UIImage imageNamed:@"QQ_click"] forState:UIControlStateNormal];
    [QQButton addTarget:self action:@selector(QQButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQButton];
    [QQButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(46*kScreenRatioWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
    
    //微信
    UIButton *WechatButton = [[UIButton alloc]init];
    [WechatButton setBackgroundImage:[UIImage imageNamed:@"wechat_icon"] forState:UIControlStateNormal];
    [WechatButton addTarget:self action:@selector(WechatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WechatButton];
    [WechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(QQButton.mas_right).offset(25*kScreenRatioWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
    //新浪
    UIButton *SinaButton = [[UIButton alloc]init];
    [SinaButton setBackgroundImage:[UIImage imageNamed:@"sina_icon"] forState:UIControlStateNormal];
    [SinaButton addTarget:self action:@selector(SinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SinaButton];
    [SinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(WechatButton.mas_right).offset(25*kScreenRatioWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
    //支付宝
    UIButton *ZhiFuBaoButton = [[UIButton alloc]init];
    [ZhiFuBaoButton setBackgroundImage:[UIImage imageNamed:@"zhifubao_icon"] forState:UIControlStateNormal];
    [ZhiFuBaoButton addTarget:self action:@selector(ZhiFuBaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ZhiFuBaoButton];
    [ZhiFuBaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(SinaButton.mas_right).offset(25*kScreenRatioWidth);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-45*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(52*kScreenRatioWidth, 50*kScreenRatioHeight));
    }];
}

#pragma mark - action - 按钮的点击方法
- (void)loginButtonClick:(HyLoglnButton *)sender
{
    if ([self isChinaMobile:self.userNameTextField.text] && [self detectionPassword:self.passWordTextField.text]) {

        NSLog(@"可以登录");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            XXELoginApi *loginApi = [[XXELoginApi alloc]initLoginWithUserName:self.userNameTextField.text PassWord:self.passWordTextField.text];
            [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                
                NSLog(@"%@",request.responseJSONObject);
                NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
                NSString *login_times = [data objectForKey:@"login_times"];
                NSString *nickname = [data objectForKey:@"nickname"];
                NSString *position = [data objectForKey:@"position"];
                NSString *token = [data objectForKey:@"token"];
                NSString *user_head_img = [data objectForKey:@"user_head_img"];
                NSString *user_id = [data objectForKey:@"user_id"];
                NSString *user_type = [data objectForKey:@"user_type"];
                NSString *xid = [data objectForKey:@"xid"];
                [XXEUserInfo user].login = YES;
                NSDictionary *userInfo = @{@"account":self.userNameTextField.text,
                                           @"login_times":login_times,
                                           @"position":position,
                                           @"nickname":nickname,
                                           @"token":token,
                                           @"user_head_img":user_head_img,
                                           @"user_id":user_id,
                                           @"user_type":user_type,
                                           @"xid":xid,
                                           @"loginStatus":[NSNumber numberWithBool:YES]
                                           };
                [[XXEUserInfo user] setupUserInfoWithUserInfo:userInfo];
                
                [_loginButton ExitAnimationCompletion:^{
                    NSLog(@"---点击登录按钮-------");
                    
                    XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = tabBarControllerConfig;
                    [self.view removeFromSuperview];
                    
                }];
            } failure:^(__kindof YTKBaseRequest *request) {
                
                [_loginButton ErrorRevertAnimationCompletion:^{
                    NSString *stringMsg = [request.responseJSONObject objectForKey:@"msg"];
                    [self showHudWithString:stringMsg forSecond:2.f];
                }];
                
            }];
        });
    } else {
        [self showString:@"用户名或密码不能为空" forSecond:1.f];
    }
}

- (void)showThePassWord:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateSelected];
        self.passWordTextField.secureTextEntry = YES;
         NSLog(@"-----点击不显示密码-----");

    } else {
        
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"login_password_click"] forState:UIControlStateSelected];
        self.passWordTextField.secureTextEntry = NO;
         NSLog(@"-----点击显示密码-----");
    }
}

- (void)registerButtonClick:(UIButton *)sender
{
    XXERegisterViewController *registerVC = [[XXERegisterViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:registerVC];
    window.rootViewController = navi;
     NSLog(@"-----免费注册-----");
}

- (void)guestButtonClick:(UIButton *)sender
{
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}

- (void)forgetPassWordButtonClick:(UIButton *)sender
{
    NSLog(@"-----忘记密码-----");
}

- (void)QQButtonClick:(UIButton *)sender
{
    NSLog(@"------QQ登录------");
}

- (void)WechatButtonClick:(UIButton *)sender
{
    NSLog(@"------微信登录------");
}

- (void)SinaButtonClick:(UIButton *)sender
{
    NSLog(@"------新浪登录------");
}
- (void)ZhiFuBaoButtonClick:(UIButton *)sender
{
    NSLog(@"------支付宝登录------");
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

#pragma mark - 创建按钮
- (UIButton *)creatButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userNameTextField) {
        if ([self isChinaMobile:textField.text]) {
            NSLog(@"正确的用户名");
            self.userNameTextField.text = textField.text;
        } else {
            [self showString:@"用户名不正确" forSecond:1.f];
        }
        
    } else {
        if ([self detectionPassword:textField.text]) {
            self.passWordTextField.text = textField.text;
            
        } else {
            
        }
    }
    
    if (![self.userNameTextField.text isEqual: @""] && ![self.passWordTextField.text  isEqual: @""]) {
        
        _loginButton.userInteractionEnabled = YES;
        _loginButton.backgroundColor = XXEColorFromRGB(0, 170, 42);
    }
    
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

/** 判断密码 */
- (BOOL)detectionPassword:(NSString *)password{
    if (!password || [password isEqualToString:@""]) {
        [self showString:@"请输入密码" forSecond:1.f];
        return NO;
    }else if(password.length <= 16 && password.length >= 6){
        return YES;
    }else{
        [self showString:@"密码仅支持6-16位字符，支持字母、数字" forSecond:1.f];
        return NO;
    }
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
