//
//  AppDelegate.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "AppDelegate.h"
#import "XXETabBarControllerConfig.h"
#import "XXEStarImageViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

//测试------
#import "XXELoginViewController.h"
#import "XXENavigationViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

//测试远程库能不能用

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化应用,appKey appSecret 从后天获取
    [SMSSDK registerApp:FreeSMSAPPKey withSecret:FreeSMSAPPSecret];
    //初始化友盟分享 与登录
    [UMSocialData setAppKey:UMSocialAppKey];
    [UMSocialData openLog:YES];
    //微信
    [UMSocialWechatHandler setWXAppId:WeChatAppId appSecret:WeChatAppSecret url:@"http://www.umeng.com/social"];
    //新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaWebAppKey secret:SinaWebAppSecret RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    //QQ空间
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:@"http://www.umeng.com/social"];
    //设置没有客户端的情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //隐藏没有安装的APP图标
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    
    
//    self.window = [[UIWindow alloc]init];
//    self.window.frame = [UIScreen mainScreen].bounds;
//    //测试界面 --------------------------
//    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
////    XXEStarImageViewController *startVC = [[XXEStarImageViewController alloc]init];
//    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:loginVC];
//    
//    self.window.rootViewController = navi;
//    
//    
////    XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
////    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
//    [self.window makeKeyAndVisible];
    
    //加入启动图
//    [self setupControllers];
    
    
    //初始化 融云
    [self initRongClould];
    
    [self toMainAPP];
    
    [self loadStarView];
    
    
    
    return YES;
}

- (void) toMainAPP {
    UIViewController *initViewController = [[UIViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
    XXENavigationViewController *navi = [[XXENavigationViewController alloc] initWithRootViewController:loginVC];
    XXETabBarControllerConfig *tarVC = [[XXETabBarControllerConfig alloc] init];
    
    if ([XXEUserInfo user].login){
        initViewController = tarVC;
    }else{
        initViewController = navi;
    }
    
    self.window.rootViewController = initViewController;
    
    
}

#pragma mark - 加入启动图片
- (void)loadStarView {
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [first objectForKey:@"isFirst"];
    if (!isFirst) {
        [self setupControllers];
    }
    isFirst = @"NO";
    [first setObject:isFirst  forKey:@"isFirst"];
    [first synchronize];
}

- (void)setupControllers
{
    
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    //当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    NSLog(@"%@",currentVersion);
    if (![currentVersion isEqualToString:lastVersion]) {//版本号相同:这次打开的和上次为同一个版本
        XXEStarImageViewController *starImageViewController = [[XXEStarImageViewController alloc]init];
        self.window = [[UIWindow alloc]init];
        self.window.frame = [UIScreen mainScreen].bounds;
        
        self.window.rootViewController = starImageViewController;
        
        [self.window makeKeyAndVisible];
        //将当前版本号存入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.window = [[UIWindow alloc]init];
        self.window.frame = [UIScreen mainScreen].bounds;
        XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
        self.window.rootViewController = tabBarControllerConfig;
        [self.window makeKeyAndVisible];
        //将当前版本号存入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


/** 
 这里处理新浪微博SSO授权之后的跳转回来,和微信分享完成后跳转回来
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/** 
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台,再返回来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initRongClould{
    // 初始化 SDK，传入 AppKey
    self.friendsArray = [[NSMutableArray alloc]init];
    self.groupsArray = [[NSMutableArray alloc]init];
    [[RCIM sharedRCIM] initWithAppKey:MyRongCloudAppKey];
    //设置用户信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].userInfoDataSource = [XXERCDataManager shareManager];
    //设置群组信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].groupInfoDataSource = [XXERCDataManager shareManager];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
