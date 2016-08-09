//
//  XXEHomePageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageViewController.h"
#import "XXEHomePageHeaderView.h"
#import "XXEHomePageMiddleView.h"
#import "XXEHomePageBottomView.h"

@interface XXEHomePageViewController ()<XXEHomePageHeaderViewDelegate,XXEHomePageMiddleViewDelegate,XXEHomePageBottomViewDelegate>

@end

@implementation XXEHomePageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = YES;
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"首页控制器");
    
    XXEHomePageHeaderView *view = [[XXEHomePageHeaderView alloc]init];
    view.frame = CGRectMake(0, 0, KScreenWidth, 276*kScreenRatioHeight);
    view.delegate = self;
    XXEHomePageMiddleView *view1 = [[XXEHomePageMiddleView alloc]initWithFrame:CGRectMake(0, 276*kScreenRatioHeight, KScreenWidth, 43*kScreenRatioHeight)];
    view1.delegate = self;
    
    XXEHomePageBottomView *view2 = [[XXEHomePageBottomView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y+43*kScreenRatioHeight, KScreenWidth, 290*kScreenRatioHeight)];
    view2.delegate = self;
    [self.view addSubview:view2];
    
    [self.view addSubview:view1];
    
    [self.view addSubview:view];
    
}

#pragma mark - 点击代理方法 Delegate
//顶部视图
- (void)homePageLeftButtonClick
{
    NSLog(@"---跳转到学校的详情页----");
}

- (void)homePageRightButtonClick
{
    NSLog(@"----跳转到登录页面----");
}
//中部视图
- (void)homeMiddleFirstButtonClick
{
    NSLog(@"----花篮点击事件----");
}

- (void)homeMiddleTwoButtonClick
{
    NSLog(@"---小红花点击事件----");
}

- (void)homeMiddleThreeButtonClick
{
    NSLog(@"----猩币点击事件---");
}

//下部视图点击相应的方法
- (void)homeClassOneButtonClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            NSLog(@"----实时监控----");
            break;
        case 1:
            NSLog(@"---相册----");
            break;
        case 2:
            NSLog(@"----课程表----");
            break;
        case 3:
            NSLog(@"---通讯录----");
            break;
        case 4:
            NSLog(@"----聊天----");
            break;
        case 5:
            NSLog(@"---点评----");
            break;
        case 6:
            NSLog(@"----作业----");
            break;
        case 7:
            NSLog(@"---食谱----");
            break;
        case 8:
            NSLog(@"----签到----");
            break;
        case 9:
            NSLog(@"---签到----");
            break;
        case 10:
            NSLog(@"----星天地----");
            break;
        case 11:
            NSLog(@"---猩猩商城----");
            break;
            
        default:
            break;
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
