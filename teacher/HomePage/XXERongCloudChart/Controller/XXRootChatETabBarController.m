//
//  XXRootChatETabBarController.m
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXRootChatETabBarController.h"
#import "XXENavigationViewController.h"
#import "XXERootFriendListController.h"
#import "XXERootReplyListController.h"
#import "RCUserInfo+XXEAddition.h"
#import <RongIMKit/RongIMKit.h>
#import "XXERCDataManager.h"

@interface XXRootChatETabBarController ()

@end

@implementation XXRootChatETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContent];
    [self setRongCloud];
    
    
}

- (void)setContent{
    
    XXERootFriendListController *rootFriendListVC = [[XXERootFriendListController alloc]init];
    rootFriendListVC.title = @"好友列表";
    
    UITabBarItem *converListItem = [[UITabBarItem alloc]initWithTitle:@"好友列表" image:[UIImage imageNamed:@"rcim2"] selectedImage:[[UIImage imageNamed:@"rcim2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    rootFriendListVC.tabBarItem = converListItem;

    XXERootReplyListController *rootReplyListVC = [[XXERootReplyListController alloc]init];
    rootReplyListVC.title = @"会话列表";
    
    UITabBarItem *friendsListItem = [[UITabBarItem alloc]initWithTitle:@"会话列表" image:[UIImage imageNamed:@"rcim1"] selectedImage:[[UIImage imageNamed:@"rcim1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    rootReplyListVC.tabBarItem = friendsListItem;
    
    self.viewControllers = @[rootFriendListVC,rootReplyListVC];
    self.tabBar.backgroundColor =[UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        [[UITabBarItem appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIColorFromRGB(0, 170, 42), NSForegroundColorAttributeName, nil]
                                                 forState:UIControlStateHighlighted];
    }else
    {
        [self.tabBar setTintColor:UIColorFromRGB(0, 170, 42)]; 
    }
}


#pragma mark - 融云
- (void)setRongCloud
{
    
    [[RCIM sharedRCIM]initWithAppKey:MyRongCloudAppKey];
    NSString *userId = [XXEUserInfo user].user_id;
    NSString *userNickName = [XXEUserInfo user].nickname;
    NSString *userImage = [XXEUserInfo user].user_head_img;
    RCUserInfo *currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:userNickName portrait:userImage];

    [RCIM sharedRCIM].currentUserInfo = currentUserInfo;

}



- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
