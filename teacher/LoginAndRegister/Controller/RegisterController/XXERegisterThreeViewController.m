//
//  XXERegisterThreeViewController.m
//  teacher
//
//  Created by codeDing on 16/8/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterThreeViewController.h"
#import "XXERegisterFourViewController.h"

@interface XXERegisterThreeViewController ()
/** 用户头像 */
@property (nonatomic, strong)UIImageView *userImageView;
/** 用户姓名 */
@property (nonatomic, strong)UITextField *userNameTextField;
/** 用户身份证 */
@property (nonatomic, strong)UITextField *userIDCardTextField;

@end

@implementation XXERegisterThreeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"3/4注册";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.userInteractionEnabled = YES;
        _userImageView.image = [UIImage imageNamed:@"register_user_icon"];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 98*kScreenRatioWidth/2;
    }
    return _userImageView;
}

- (UITextField *)userNameTextField
{
    if (!_userNameTextField) {
        _userNameTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入姓名"];
    }
    return _userNameTextField;
}

- (UITextField *)userIDCardTextField
{
    if (!_userIDCardTextField) {
        _userIDCardTextField = [UITextField createTextFieldWithIsOpen:NO textPlaceholder:@"请输入身份证"];
        _userIDCardTextField.borderStyle = UIKeyboardTypeDefault;
    }
    return _userIDCardTextField;
}

- (void)loadView
{
    [super loadView];
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.userImageView];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(18);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(98*kScreenRatioWidth, 98*kScreenRatioWidth));
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.userImageView.mas_centerY);
        make.right.equalTo(weakSelf.userImageView.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 0.5));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = XXEColorFromRGB(204, 204, 204);
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.userImageView.mas_centerY);
        make.left.equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(100*kScreenRatioWidth, 0.5));
    }];
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"点击设置头像";
    messageLabel.textColor = XXEColorFromRGB(204, 204, 204);
    messageLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.userImageView.mas_bottom).offset(10);
    }];
    //设置输入框的视图
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"register_background"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(_userImageView.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(359*kScreenRatioWidth, 158*kScreenRatioHeight));
    }];
    
    UILabel *nameLabel = [UILabel setupMessageLabel:@"姓      名"];
    [imageView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(5);
        make.top.equalTo(imageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(70*kScreenRatioWidth, 49*kScreenRatioHeight));
    }];
    
    [imageView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(2);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.right.equalTo(imageView.mas_right).offset(0);
        make.height.mas_equalTo(49*kScreenRatioHeight);
    }];
    
    
    UILabel *IDCardLabel = [UILabel setupMessageLabel:@"身份证号"];
    [imageView addSubview:IDCardLabel];
    [IDCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(5);
        make.top.equalTo(nameLabel.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(70*kScreenRatioWidth, 49*kScreenRatioHeight));
    }];
    
    [imageView addSubview:self.userIDCardTextField];
    [self.userIDCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(IDCardLabel.mas_right).offset(2);
        make.centerY.equalTo(IDCardLabel.mas_centerY);
        make.right.equalTo(imageView.mas_right).offset(0);
        make.height.mas_equalTo(49*kScreenRatioHeight);
    }];
    
    
    UILabel *IDLabel = [UILabel setupMessageLabel:@"教职身份"];
    [imageView addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(5);
        make.top.equalTo(IDCardLabel.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(70*kScreenRatioWidth, 49*kScreenRatioHeight));
    }];
    
    //下一步
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setupUserAvatar)];
    [self.userImageView addGestureRecognizer:tapgesture];
}


#pragma mark - action点击相应事件
- (void)nextButtonClick:(UIButton *)sender
{
    NSLog(@"---点击进入下一页----");
    XXERegisterFourViewController *fourVC = [[XXERegisterFourViewController alloc]init];
    [self.navigationController pushViewController:fourVC animated:YES];
}

- (void)setupUserAvatar
{
    NSLog(@"---获取用户头像----");
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"" itemTitles:@[@"拍照",@"从手机相册选择"]];
    actionSheet.delegate = self;
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
