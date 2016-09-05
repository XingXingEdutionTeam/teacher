//
//  XXEDiffentIdentityViewController.m
//  teacher
//
//  Created by codeDing on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDiffentIdentityViewController.h"
#import "XXERegisterHeadMasterViewController.h"
#import "XXERegisterTeacherViewController.h"
#import "XXEIdentityAddHeadViewController.h"
#import "XXEIdentityAddTeacherViewController.h"

@interface XXEDiffentIdentityViewController ()

/** 教师选择的身份 1为教师 2为班主任 3为管理员 4为校长 */
@property (nonatomic, copy)NSString *diffPosition;

@end

@implementation XXEDiffentIdentityViewController

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

- (void)loadView
{
    [super loadView];
    __weak typeof(self)weakSelf = self;
    //教师(公立)
    UIButton *teacherButton = [[UIButton alloc]init];
    [teacherButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [teacherButton setTitle:@"授课教师" forState:UIControlStateNormal];
    [teacherButton addTarget:self action:@selector(teacherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:teacherButton];
    [teacherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.top.equalTo(weakSelf.view.mas_top).offset(80*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    //班主任
    UIButton *privateAdminButton = [[UIButton alloc]init];
    [privateAdminButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [privateAdminButton setTitle:@"班主任" forState:UIControlStateNormal];
    [privateAdminButton addTarget:self action:@selector(privateAdminButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateAdminButton];
    [privateAdminButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(teacherButton.mas_leading);
        make.top.equalTo(teacherButton.mas_bottom).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    //管理员
    UIButton *publicAdminButton = [[UIButton alloc]init];
    [publicAdminButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [publicAdminButton setTitle:@"管理员" forState:UIControlStateNormal];
    [publicAdminButton addTarget:self action:@selector(publicAdminButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicAdminButton];
    [publicAdminButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(privateAdminButton.mas_leading);
        make.top.equalTo(privateAdminButton.mas_bottom).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
    
    //校长
    UIButton *privateHeadButton = [[UIButton alloc]init];
    [privateHeadButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [privateHeadButton setTitle:@"校长" forState:UIControlStateNormal];
    [privateHeadButton addTarget:self action:@selector(privateHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateHeadButton];
    [privateHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(publicAdminButton.mas_leading);
        make.top.equalTo(publicAdminButton.mas_bottom).offset(40*kScreenRatioHeight);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
}


#pragma mark - 点击选择身份
- (void)teacherButtonClick:(UIButton *)sender
{
    NSLog(@"选择授课老师");
    XXEIdentityAddTeacherViewController *teacherVC = [[XXEIdentityAddTeacherViewController alloc]init];
    self.diffPosition = @"1";
    teacherVC.teacherPosition = self.diffPosition;
    [self.navigationController pushViewController:teacherVC animated:YES];
}


- (void)privateAdminButtonClick:(UIButton *)sender
{
    NSLog(@"选择班主任身份");
    self.diffPosition = @"2";
    
    XXEIdentityAddTeacherViewController *teacherVC = [[XXEIdentityAddTeacherViewController alloc]init];
    teacherVC.teacherPosition = self.diffPosition;
    [self.navigationController pushViewController:teacherVC animated:YES];
}

- (void)publicAdminButtonClick:(UIButton *)sender
{
    NSLog(@"选择管理员身份");
    self.diffPosition = @"3";
    
    XXEIdentityAddHeadViewController *headVC = [[XXEIdentityAddHeadViewController alloc]init];
    headVC.headPosition = self.diffPosition;
    [self.navigationController pushViewController:headVC animated:YES];
}

- (void)privateHeadButtonClick:(UIButton *)sender
{
    NSLog(@"选择校长身份");
    self.diffPosition = @"4";
    XXEIdentityAddHeadViewController *headVC = [[XXEIdentityAddHeadViewController alloc]init];
    headVC.headPosition = self.diffPosition;
    [self.navigationController pushViewController:headVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
