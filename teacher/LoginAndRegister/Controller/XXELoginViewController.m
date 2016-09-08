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
#import "XXEChangeRoleViewController.h"
#import "UMSocial.h"
#import "SettingPersonInfoViewController.h"
#import "XXEForgetPassWordViewController.h"
#import "XXEPerfectInfoViewController.h"

@interface XXELoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
/** 登陆的首页头像 */
@property (nonatomic, strong)UIImageView *loginHeadImageView;
/** 用户名登录 */
@property (nonatomic, strong) UITextField *userNameTextField;
/** 密码登录 */
@property (nonatomic, strong) UITextField *passWordTextField;
/** 登陆按钮 */
@property (nonatomic, strong) HyLoglnButton *loginButton;
/** 经度 */
@property (nonatomic, copy)NSString *longitudeString;
/** 纬度 */
@property (nonatomic, copy)NSString *latitudeString;

@property (nonatomic, strong)CLLocationManager *locationManager;

/** 第三方昵称 */
@property (nonatomic, copy)NSString *thirdNickName;
/** 第三放头像 */
@property (nonatomic, copy)NSString *thirdHeadImage;
/** QQToken */
@property (nonatomic, copy)NSString *qqLoginToken;
/** 微信Token */
@property (nonatomic, copy)NSString *weixinLoginToken;
/** 新浪Token */
@property (nonatomic, copy)NSString *sinaLoginToken;
/** 支付宝Token */
@property (nonatomic, copy)NSString *aliPayLoginToken;
/** 登录类型 1为手机 2为qq 3为微信 4为微博 5为 支付宝  10为访客模式(访客模式只要此参数)*/
@property (nonatomic, copy)NSString *login_type;
/** 访客模式 */
@end

@implementation XXELoginViewController


- (UIImageView *)loginHeadImageView {
    if (!_loginHeadImageView) {
        _loginHeadImageView = [[UIImageView alloc] init];
        _loginHeadImageView.layer.masksToBounds = YES;
        _loginHeadImageView.layer.cornerRadius = 100*kScreenRatioWidth/2;
        [_loginHeadImageView setContentMode:UIViewContentModeScaleAspectFill];
        _loginHeadImageView.userInteractionEnabled = YES;
        _loginHeadImageView.backgroundColor = [UIColor clearColor];
    }
    return _loginHeadImageView;
}

- (UITextField *)userNameTextField
{
    if (!_userNameTextField) {
        _userNameTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"手机"];
        _userNameTextField.delegate = self;
        _userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _userNameTextField;
}

- (UITextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [UITextField createTextFieldWithIsOpen:YES textPlaceholder:@"密码"];
        _passWordTextField.delegate = self;
        _passWordTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _passWordTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
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
    //初始化所有的参数
    [self TheInitializationParameter];
    //定位手机
    [self startLocationManager];
}
#pragma mark - 初始化参数
- (void)TheInitializationParameter
{
    NSString *str = [XXEUserInfo user].user_head_img;
    NSLog(@"%@",str);
    if ([str isEqualToString:@""] || str == nil ) {
        self.loginHeadImageView.image = [UIImage imageNamed:@"img"];
    }else{
    [self.loginHeadImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    }
    self.longitudeString = @"";
    self.latitudeString = @"";
    self.qqLoginToken = @"";
    self.weixinLoginToken = @"";
    self.sinaLoginToken = @"";
    self.aliPayLoginToken = @"";
    self.login_type = @"";
    self.thirdNickName = @"";
    self.thirdHeadImage = @"";
}

#pragma mark - 定位
- (void)startLocationManager
{
    //    判断定位操作是否允许
    if ([CLLocationManager locationServicesEnabled])
    {
        //定位初始化
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000;//横向移动距离更新
        [_locationManager requestWhenInUseAuthorization];
        //定位开始
        [_locationManager startUpdatingLocation];
    }else{
        //提示用户无法定位操作
        [self initAlertWithTitle:@"温馨提醒" Message:@"您尚未开启定位是否开启" ActionTitle:@"开启" CancelTitle:@"取消" URLS:@"prefs:root=LOCATION_SERVICES"];
    }
}

- (void)initAlertWithTitle:(NSString *)title Message:(NSString *)message ActionTitle:(NSString *)actionTitle CancelTitle:(NSString *)cancelTitle URLS:(NSString *)urls
{
    //提示用户无法定位操作
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定操作");
        NSURL*url=[NSURL URLWithString:urls];
        [[UIApplication sharedApplication] openURL:url];
    }];
    if (cancelTitle==nil) {
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消操作");
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - CoreLocationdelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    //获取当前所在城市的名字
    NSLog(@"经度%f",currentLocation.coordinate.longitude);
    NSLog(@"纬度%f",currentLocation.coordinate.latitude);
    self.longitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    self.latitudeString = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSLog(@"Token%@ loginType%@",self.loginThirdWeiXinToken,self.loginThirdType);
    if (self.loginThirdWeiXinToken.length > 12) {
        [self loginInterFaceApiSnsAccount:self.loginThirdWeiXinToken LoginTYpe:self.loginThirdType];
    }
    [manager stopUpdatingLocation];
}

/** 创建视图View */
#pragma mark - 创建视图View
- (void)setUpSubviewLayout
{
    __weak typeof(self)weakSelf = self;
    
    [self.view addSubview:self.loginHeadImageView];
    [self.loginHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(100*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 100*kScreenRatioHeight));
    }];
    
    UIImageView *userImageView = [[UIImageView alloc]init];
    userImageView.image = [UIImage imageNamed:@"login_image"];
    [self.view addSubview:userImageView];
    userImageView.userInteractionEnabled = YES;
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_loginHeadImageView.mas_bottom).offset(18*kScreenRatioHeight);
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
    _loginButton.backgroundColor = XXEGreenColor;
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
        make.left.equalTo(userIconImageView.mas_right).offset(10*kScreenRatioWidth);
        make.right.equalTo(userImageView.mas_right).offset(0);
        make.height.mas_equalTo(41*kScreenRatioHeight);
    }];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passImageView.mas_centerY);
        make.left.equalTo(passIconImageView.mas_right).offset(10*kScreenRatioWidth);
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

#pragma mark - action - 按钮的点击方法非第三方登录
- (void)loginButtonClick:(HyLoglnButton *)sender
{
    if ([self isChinaMobile:self.userNameTextField.text] && [self detectionPassword:self.passWordTextField.text]) {
        NSLog(@"可以登录");
        self.login_type = @"1";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            XXELoginApi *loginApi = [[XXELoginApi alloc]initLoginWithUserName:self.userNameTextField.text PassWord:self.passWordTextField.text LoginType:self.login_type Lng:self.longitudeString Lat:self.latitudeString];
            [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                
                NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
                NSString *code = [request.responseJSONObject objectForKey:@"code"];
                NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
                if ([code intValue]==1) {
                    [self LoginSetupUserInfoDict:data SnsAccessToken:@"" LoginType:self.login_type];
                    NSString *login_times = [data objectForKey:@"login_times"];
                    
                    if ([login_times intValue]==1) {
                        NSLog(@"进入信息补全");
                        XXEPerfectInfoViewController *perfecVC = [[XXEPerfectInfoViewController alloc]init];
                        XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:perfecVC];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        window.rootViewController = navi;
                        [self.view removeFromSuperview];

                        
                    }else{
                    
                    [_loginButton ExitAnimationCompletion:^{
                        NSLog(@"---点击登录按钮-------");
                        
                        XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                        window.rootViewController = tabBarControllerConfig;
                        [self.view removeFromSuperview];
                        
                    }];
                    }
                }else if([code intValue]==3)
                {
                    [self showString:@"账号或密码错误" forSecond:1.f];
                    [_loginButton ErrorRevertAnimationCompletion:^{
                        NSString *stringMsg = [request.responseJSONObject objectForKey:@"msg"];
                        [self showHudWithString:stringMsg forSecond:2.f];
                    }];
                }else{
                    
                    [self showString:@"登录失败" forSecond:1.f];
                }
                
            } failure:^(__kindof YTKBaseRequest *request) {
                
                [_loginButton ErrorRevertAnimationCompletion:^{
                    
                    [self showHudWithString:@"网络请求失败" forSecond:2.f];
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
    XXELoginApi *loginApi = [[XXELoginApi alloc]initLoginWithUserName:@"" PassWord:@"" LoginType:@"10" Lng:@"" Lat:@""];
    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSString *msg = [request.responseJSONObject objectForKey:@"msg"];
        NSLog(@"%@",msg);
        if ([code intValue]==1) {
            [self LoginSetupUserInfoDict:data SnsAccessToken:@"" LoginType:@"10"];
            XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = tabBarControllerConfig;
            [self.view removeFromSuperview];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)forgetPassWordButtonClick:(UIButton *)sender
{
    XXEForgetPassWordViewController *forgetVC = [[XXEForgetPassWordViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:forgetVC];
    window.rootViewController = navi;
    NSLog(@"-----忘记密码-----");
}

- (void)QQButtonClick:(UIButton *)sender
{
    NSLog(@"------QQ登录------");
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取QQ用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"2";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            self.qqLoginToken = snsAccount.unionId;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
//            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
            [self loginInterFaceApiSnsAccount:snsAccount.usid LoginTYpe:self.login_type];
        }});
}

- (void)WechatButtonClick:(UIButton *)sender
{
    NSLog(@"------微信登录------");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"3";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:snsPlatform.platformName];
            self.weixinLoginToken = snsAccount.unionId;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
            
            NSLog(@"iD微信:---%@",snsAccount.unionId);
            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
        }
    });
    
}

- (void)SinaButtonClick:(UIButton *)sender
{
    NSLog(@"------新浪登录------");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.login_type = @"4";
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"%@",snsAccount);
             NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            self.sinaLoginToken = snsAccount.usid ;
            self.thirdNickName = snsAccount.userName;
            self.thirdHeadImage = snsAccount.iconURL;
//            
//            [self getAddInfomationMessage:snsAccount LoginType:self.login_type];
            [self loginInterFaceApiSnsAccount:snsAccount.usid LoginTYpe:self.login_type];
            
        }});
    
    
}
- (void)ZhiFuBaoButtonClick:(UIButton *)sender
{
    NSLog(@"------支付宝登录------");
//    self.qqLoginToken = snsAccount.accessToken;
//    self.thirdNickName = snsAccount.userName;
//    self.thirdHeadImage = snsAccount.iconURL;
    
    self.login_type = @"5";
}

#pragma mark - 给数据库添加信息
- (void)getAddInfomationMessage:(UMSocialAccountEntity *)snsAccount LoginType:(NSString *)loginType
{
    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId);
//    token = 2.00dhfvICzOGjWE6c1874530acQJx6B
//            2.00dhfvICzOGjWE6c1874530acQJx6B
    //调用登录接口
    [self loginInterFaceApiSnsAccount:snsAccount.unionId LoginTYpe:loginType];
}

#pragma mark - 登录接口
- (void)loginInterFaceApiSnsAccount:(NSString *)accessToken LoginTYpe:(NSString *)logintype
{
    //微博第三方蹦是因为没有审核通过没有unionId 为空
    NSLog(@"Token%@ 类型%@ 经度%@ 纬度%@",accessToken,logintype,self.longitudeString,self.latitudeString);
    XXELoginApi *loginApi = [[XXELoginApi alloc]initLoginWithUserName:accessToken PassWord:@"" LoginType:logintype Lng:self.longitudeString Lat:self.latitudeString];
    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue] == 1) {
            //存储数据直接进入首页
            [self showHudWithString:@"正在登录" forSecond:2.f];            
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            NSString * logintimes = [data objectForKey:@"login_times"];
            [self LoginSetupUserInfoDict:data SnsAccessToken:accessToken LoginType:logintype];
            NSLog(@"%@",logintimes);
            if ([logintimes integerValue]==1 ) {
                XXEPerfectInfoViewController *perfecVC = [[XXEPerfectInfoViewController alloc]init];
                XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:perfecVC];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = navi;
                [self.view removeFromSuperview];
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    window.rootViewController = tabBarControllerConfig;
                    [self.view removeFromSuperview];
                    
                });
            }
            
        }else{
            //进入注册的第三个
            SettingPersonInfoViewController *settingVC = [[SettingPersonInfoViewController alloc]init];
            settingVC.userSettingPhoneNum = @"";
            settingVC.userSettingPassWord = @"";
            settingVC.nickName = self.thirdNickName;
            settingVC.t_head_img = self.thirdHeadImage;
            settingVC.login_type = logintype;
            settingVC.QQToken = self.qqLoginToken;
            settingVC.weixinToken = self.weixinLoginToken;
            settingVC.sinaToken = self.sinaLoginToken;
            settingVC.aliPayToken = self.aliPayLoginToken;
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
    
}

#pragma mark - 保存数据信息
- (void)LoginSetupUserInfoDict:(NSDictionary *)data SnsAccessToken:(NSString *)accessToken LoginType:(NSString *)logintype
{
    NSString *login_times = [data objectForKey:@"login_times"];
    NSString *nickname = [data objectForKey:@"nickname"];
    NSString *token = [data objectForKey:@"token"];
    NSString *user_head_img = [data objectForKey:@"user_head_img"];
    NSString *user_id = [data objectForKey:@"user_id"];
    NSString *user_type = [data objectForKey:@"user_type"];
    NSString *xid = [data objectForKey:@"xid"];
    NSString *login_type = logintype;
    
    NSLog(@"登录次数%@ 昵称%@ token%@ 用头像%@ 用户Id%@ 用户类型%@ XID%@ ",login_times,nickname,token,user_head_img, user_id, user_type,xid);
    
    if ([logintype  isEqualToString: @"1"]) {

    }else if ([logintype isEqualToString:@"2"]){
        self.qqLoginToken = accessToken;
    }else if ([logintype isEqualToString:@"3"]){
        self.weixinLoginToken = accessToken;
    }else if ([logintype isEqualToString:@"4"]){
        self.sinaLoginToken = accessToken;
    }else if ([logintype isEqualToString:@"5"]){
        self.aliPayLoginToken = accessToken;
    }else if ([logintype isEqualToString:@"10"]){
    }
    
    [XXEUserInfo user].login = YES;
    NSDictionary *userInfo = @{
                               @"login_times":login_times,
                               @"nickname":nickname,
                               @"token":token,
                               @"qqNumberToken":self.qqLoginToken,
                               @"weixinToken":self.weixinLoginToken,
                               @"sinaNumberToken":self.sinaLoginToken,
                               @"zhifubaoToken":self.aliPayLoginToken,
                               @"login_type":login_type,
                               @"user_head_img":user_head_img,
                               @"user_id":user_id,
                               @"user_type":user_type,
                               @"xid":xid,
                               @"loginStatus":[NSNumber numberWithBool:YES]
                               };
    NSLog(@"%@",userInfo);
    [[XXEUserInfo user] setupUserInfoWithUserInfo:userInfo];
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
