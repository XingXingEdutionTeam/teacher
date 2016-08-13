//
//  XXETabBarControllerConfig.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETabBarControllerConfig.h"
#import "XXENavigationViewController.h"
#import "XXEHomePageViewController.h"
#import "XXEChatPageViewController.h"
#import "XXEFriendCirclePageViewController.h"
#import "XXEMySelfPageViewController.h"

@interface XXETabBarControllerConfig ()


@end

@implementation XXETabBarControllerConfig


+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0/255.f green:170/255.0 blue:42/255.0 alpha:1.0];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc:[[XXEHomePageViewController alloc] init] title:@"首页" image:@"tabbar_homeicon" selectedImage:@"tabbar_homeicon_click"];
    
    [self setupChildVc:[[XXEChatPageViewController alloc] init] title:@"聊天" image:@"tabbar_xclassroom" selectedImage:@"tabbar_xclassroom_click"];
    
    [self setupChildVc:[[XXEFriendCirclePageViewController alloc] init] title:@"猩课堂" image:@"tabbar_circle" selectedImage:@"tabbar_circle_click"];
    
    [self setupChildVc:[[XXEMySelfPageViewController alloc] init] title:@"我" image:@"tabbar_personal" selectedImage:@"tabbar_personal_click"];
    
//    // 更换tabBar
//    [self setValue:[[XMGTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    XXENavigationViewController *nav = [[XXENavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
