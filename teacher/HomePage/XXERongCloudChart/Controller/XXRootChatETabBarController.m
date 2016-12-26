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
#import "XXERootFriendListApi.h"
#import "AppDelegate.h"

@interface XXRootChatETabBarController (){
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXRootChatETabBarController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self rootFriendListServerDataPageNumber];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    [self setContent];
//    [self setRongCloud];
    
    [self rootFriendListServerDataPageNumber];
}

- (void)rootFriendListServerDataPageNumber
{
    
    XXERootFriendListApi *rootFriendListApi = [[XXERootFriendListApi alloc]initWithRootFriendListUserXid:parameterXid UserId:parameterUser_Id];
    [rootFriendListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@",request.responseJSONObject);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code integerValue]== 1) {
            NSArray *data = [request.responseJSONObject objectForKey:@"data"];
            for (NSDictionary *dic in data) {
                //                0 :表示 自己 头像 ，需要添加 前缀
                //                1 :表示 第三方 头像 ，不需要 添加 前缀
                //判断是否是第三方头像
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[kXXEPicURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:dic[@"xid"] name:dic[@"nickname"] portrait:head_img];
                [[AppDelegate shareAppDelegate].friendsArray addObject:aUserInfo];
                
            }
        }
        [self setContent];
        [self setRongCloud];
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self setContent];
        [self setRongCloud];
    }];
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
    
    self.viewControllers = @[rootReplyListVC,rootFriendListVC];
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
