//
//  XXEPerfectInfoViewController.m
//  teacher
//
//  Created by codeDing on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEPerfectInfoViewController.h"
#import "XXETabBarControllerConfig.h"
#import "WZYSearchSchoolViewController.h"

@interface XXEPerfectInfoViewController ()<XXESearchSchoolMessageDelegate>

@property (nonatomic, strong)WZYSearchSchoolViewController *searchVC;
@property (nonatomic, strong)NSMutableArray *perfectInfoDatasource;

@end

@implementation XXEPerfectInfoViewController

- (NSMutableArray *)perfectInfoDatasource
{
    if (!_perfectInfoDatasource) {
        _perfectInfoDatasource = [NSMutableArray array];
    }
    return _perfectInfoDatasource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"完善信息";
    self.navigationController.navigationBarHidden = NO;
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否完善信息赚取200猩币" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"完善" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"跳过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = tabBarControllerConfig;
        [self.view removeFromSuperview];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark - 搜索的按钮点击事件
- (void)searchButtonClick:(UIButton *)sender
{  NSLog(@"点击搜搜");
        
        WZYSearchSchoolViewController *searchVC = [[WZYSearchSchoolViewController alloc]init];
        self.searchVC = searchVC;
        
        [searchVC returnArray:^(NSMutableArray *mArr) {
            
            self.perfectInfoDatasource = mArr;
            self.searchVC.delegate = self;
        }];
        [self.navigationController pushViewController:searchVC animated:YES];
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
