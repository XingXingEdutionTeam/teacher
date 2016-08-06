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

//测试------
#import "XXELoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    //测试界面 --------------------------
    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
//    XXEStarImageViewController *startVC = [[XXEStarImageViewController alloc]init];
    self.window.rootViewController = loginVC;
    
    
//    XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
//    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
    
    //加入启动图
//    [self setupControllers];
    
    return YES;
}

#pragma mark - 加入启动图片
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
