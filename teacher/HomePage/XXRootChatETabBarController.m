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
#import <RongIMKit/RongIMKit.h>

@interface XXRootChatETabBarController ()

@end

@implementation XXRootChatETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
//    [self setupChildVc:[[XXERootFriendListController alloc] init] title:@"朋友列表" image:@"rcim2.png" selectedImage:@"rcim2.png"];
//    
//    // 添加子控制器
//    [self setupChildVc:[[XXERootReplyListController alloc] init] title:@"回话列表" image:@"rcim1.png" selectedImage:@"rcim1.png"];
    [[RCIM sharedRCIM]initWithAppKey:MyRongCloudAppKey];
    
    [self setContent];
    [self setRongCloud];
    
    
}

- (void)setContent{
    
    XXERootFriendListController *wmConversationListVC = [[XXERootFriendListController alloc]init];
    wmConversationListVC.title = @"好友列表";
    UINavigationController *converNav = [[UINavigationController alloc]initWithRootViewController:wmConversationListVC];
    UITabBarItem *converListItem = [[UITabBarItem alloc]initWithTitle:@"好友列表" image:[UIImage imageNamed:@"rcim2"] selectedImage:[[UIImage imageNamed:@"rcim2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    wmConversationListVC.tabBarItem = converListItem;

    XXERootReplyListController *FriendsListVC = [[XXERootReplyListController alloc]init];
    FriendsListVC.title = @"会话列表";
    
    UITabBarItem *friendsListItem = [[UITabBarItem alloc]initWithTitle:@"会话列表" image:[UIImage imageNamed:@"rcim1"] selectedImage:[[UIImage imageNamed:@"rcim1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FriendsListVC.tabBarItem = friendsListItem;
    
    self.viewControllers = @[wmConversationListVC,FriendsListVC];
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
    NSString *token = [XXEUserInfo user].token;
    NSString *userId = [XXEUserInfo user].user_id;
    NSString *userNickName = [XXEUserInfo user].nickname;
    NSString *userImage = [XXEUserInfo user].user_head_img;
    RCUserInfo *currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:userNickName portrait:userImage];
    [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
