//
//  XXEChangeRoleViewController.m
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChangeRoleViewController.h"
#import "XXETabBarControllerConfig.h"

@interface XXEChangeRoleViewController ()

@end

@implementation XXEChangeRoleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"选择身份";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)loadView
{
    [super loadView];
    __weak typeof(self)weakSelf = self;
    //教师(公立)
    UIButton *teacherButton = [[UIButton alloc]init];
    [teacherButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [teacherButton setTitle:@"教师" forState:UIControlStateNormal];
    [teacherButton addTarget:self action:@selector(teacherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:teacherButton];
    [teacherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.top.equalTo(weakSelf.view.mas_top).offset(20*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    
    
    
    //管理员(私立)
    UIButton *privateAdminButton = [[UIButton alloc]init];
    [privateAdminButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [privateAdminButton setTitle:@"管理员(私立)" forState:UIControlStateNormal];
    [privateAdminButton addTarget:self action:@selector(privateAdminButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateAdminButton];
    [privateAdminButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(teacherButton.mas_leading);
        make.top.equalTo(teacherButton.mas_bottom).offset(20*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    //管理员(公立)
    UIButton *publicAdminButton = [[UIButton alloc]init];
    [publicAdminButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [publicAdminButton setTitle:@"管理员(公立)" forState:UIControlStateNormal];
    [publicAdminButton addTarget:self action:@selector(publicAdminButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicAdminButton];
    [publicAdminButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(privateAdminButton.mas_leading);
        make.top.equalTo(privateAdminButton.mas_bottom).offset(20*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    //校长(私立)
    UIButton *privateHeadButton = [[UIButton alloc]init];
    [privateHeadButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [privateHeadButton setTitle:@"校长(私立)" forState:UIControlStateNormal];
    [privateHeadButton addTarget:self action:@selector(privateHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateHeadButton];
    [privateHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(publicAdminButton.mas_leading);
        make.top.equalTo(publicAdminButton.mas_bottom).offset(20*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    

    //校长(公立)
    UIButton *publicHeadButton = [[UIButton alloc]init];
    [publicHeadButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [publicHeadButton setTitle:@"校长(公立)" forState:UIControlStateNormal];
    [publicHeadButton addTarget:self action:@selector(publicHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicHeadButton];
    [publicHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(privateHeadButton.mas_bottom).offset(20*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
}

#pragma mark - 点击事件

- (void)teacherButtonClick:(UIButton *)sender
{
    NSLog(@"教师身份");
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}
- (void)privateAdminButtonClick:(UIButton *)sender
{
    NSLog(@"私立管理员");
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}

- (void)publicAdminButtonClick:(UIButton *)sender
{
    NSLog(@"公立管理员");
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}

- (void)privateHeadButtonClick:(UIButton *)sender
{
    NSLog(@"私立校长");
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}

- (void)publicHeadButtonClick:(UIButton *)sender
{
    NSLog(@"公立校长");
    XXETabBarControllerConfig *tabBarConfig = [[XXETabBarControllerConfig alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarConfig;
    NSLog(@"-----游客登录-----");
}


-(void)dealloc
{
    NSLog(@"");
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
