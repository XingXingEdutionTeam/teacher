//
//  AppDelegate.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#define JPushAppKey @"4246476d42da75a98d9e01f2"
#define kIsProduction NO //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
#define kSystemModelEntity @"SystemModel"

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

//支付
#import "BeeCloud.h"

//极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AudioToolbox/AudioToolbox.h>

#import "FMDBManager.h"

#import <NotificationCenter/NotificationCenter.h>

#import "ServiceManager.h"

#import "UpdatePopView.h"
#import "WithoutCloseUpdatePopView.h"

// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//MARK - 当前系统版本号 规定为三位数整数 如: 1.0.0 为100
static int currentVersion = 100;

@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setRCIMPush];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //初始化应用,appKey appSecret 从后天获取
    [SMSSDK registerApp:FreeSMSAPPKey withSecret:FreeSMSAPPSecret];

    
    //支付
    [BeeCloud initWithAppID:@"a2c64858-7c9c-4fd2-b2f8-2c58f853d47f" andAppSecret:@"fc8fe808-d180-48e7-99ba-54b42d3c725d"];
    [BeeCloud initWeChatPay:@"wxed731a36270b5a4f"];
    
    //初始化 融云
    [self initRongClould];
    
    //初始化APNs
    [self initAPNs];
    
    [self showUpdatePopView];
    //初始化JPush
    [self initJPushWith:launchOptions];
    
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.userInfo = remoteNotification;
    //设置根视图控制器
    [self toMainAPP];
    
    [self loadStarView];
    
    
    return YES;
}

- (void)setUM:(NSString*)appStoreURL {
    //初始化友盟分享 与登录
    [UMSocialData setAppKey:UMSocialAppKey];
    [UMSocialData openLog:YES];
    //微信
    [UMSocialWechatHandler setWXAppId:WeChatAppId appSecret:WeChatAppSecret url:appStoreURL];
    //新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaWebAppKey secret:SinaWebAppSecret RedirectURL:appStoreURL];
    //QQ空间
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:appStoreURL];
    //设置没有客户端的情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //隐藏没有安装的APP图标
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
}

//MARK: - 10.0推送
- (void)setRCIMPush {
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        //if( option != nil )
        //{
        //    NSLog( @"registerForPushWithOptions:" );
        //}
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );  
             }  
         }];  
    }
}

//MARK: - 版本更新提示框
- (void)showUpdatePopView {
    
    [[ServiceManager sharedInstance] requestWithURLString:CheckoutVersionURL parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [GlobalVariable shareInstance].appStoreURL = responseObject[@"data"][@"url"];
            NSString *appStoreURL = responseObject[@"data"][@"url"];
            int nowVersion = [responseObject[@"data"][@"now_version"] intValue];
            int allowVersion = [responseObject[@"data"][@"allow_version"] intValue];// 支持最低版本号
            //设置友盟
            [self setUM:appStoreURL];
            if (currentVersion < nowVersion) {//更新
                if (currentVersion < allowVersion) {//强制更新
                    [self mustJumpToAppStoreWithNowVerson:nowVersion appStoreURL:appStoreURL];
                    return;
                }
                [self jumpToAppStoreWithNowVerson:nowVersion appStoreURL:appStoreURL];
            }else if (currentVersion > nowVersion){ //苹果审核中
                //code...
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//MARK: - 强制跳转AppStore
- (void)mustJumpToAppStoreWithNowVerson:(int)nowVersion appStoreURL:(NSString*)appStoreURL {
    NSString *versionText = [NSString stringWithFormat:@"%d", nowVersion];
    WithoutCloseUpdatePopView *withoutClosePopView = [WithoutCloseUpdatePopView convenicenWithTitle:versionText];
    [self.window addSubview:withoutClosePopView];
    //button点击方法
    //    __weak typeof (UpdatePopView) *weakPopView = popView;
    [withoutClosePopView clickUpdateBtn:^{
        NSURL * url = [NSURL URLWithString:appStoreURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }];
}

//MARK: - 跳转AppStore
- (void)jumpToAppStoreWithNowVerson:(int)nowVersion appStoreURL:(NSString*)appStoreURL {
    NSString *versionText = [NSString stringWithFormat:@"%d", nowVersion];
    UpdatePopView *popView = [UpdatePopView convenicenWithTitle:versionText];
    [self.window addSubview:popView];
    //button点击方法
//    __weak typeof (UpdatePopView) *weakPopView = popView;
    [popView clickUpdateBtn:^{
        NSURL * url = [NSURL URLWithString:appStoreURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }];
}

// 添加初始化APNs代码
- (void)initAPNs {
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
//    else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    

}

// 初始化JPush代码
- (void)initJPushWith:(NSDictionary *)launchOptions {
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:@" " apsForProduction:kIsProduction];
}


- (void) toMainAPP {
    UIViewController *initViewController = [[UIViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
    XXENavigationViewController *navi = [[XXENavigationViewController alloc] initWithRootViewController:loginVC];
    
    if ([XXEUserInfo user].login){
        XXETabBarControllerConfig *tarVC = [[XXETabBarControllerConfig alloc] init];
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
        [first setObject:@"firstEnterApp" forKey:@"isFirst"];
    }
}

- (void)setupControllers
{
    
    XXEStarImageViewController *starImageViewController = [[XXEStarImageViewController alloc]init];
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = starImageViewController;
    [self.window makeKeyAndVisible];

    
//    NSString *key = @"CFBundleShortVersionString";
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
//    //当前软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    NSLog(@"%@",currentVersion);
//    if (![currentVersion isEqualToString:lastVersion]) {//版本号相同:这次打开的和上次为同一个版本
////        XXEStarImageViewController *starImageViewController = [[XXEStarImageViewController alloc]init];
////        self.window = [[UIWindow alloc]init];
////        self.window.frame = [UIScreen mainScreen].bounds;
////        
////        self.window.rootViewController = starImageViewController;
////        
////        [self.window makeKeyAndVisible];
//        //将当前版本号存入沙盒
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else {
//        self.window = [[UIWindow alloc]init];
//        self.window.frame = [UIScreen mainScreen].bounds;
//        XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
//        self.window.rootViewController = tabBarControllerConfig;
//        [self.window makeKeyAndVisible];
//        //将当前版本号存入沙盒
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}


/** 
 这里处理新浪微博SSO授权之后的跳转回来,和微信分享完成后跳转回来
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        NSLog(@"打开支付宝!");
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        
    }
    return YES;

}


//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
        
        NSLog(@"打开支付宝!===== ");
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

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

/*
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    if ([XXEUserInfo user].login){
        [JPUSHService setAlias:[XXEUserInfo user].xid callbackSelector:nil object:nil];
        NSLog(@"%@", [XXEUserInfo user].xid);
    }
    
//    [JPUSHService re];
}

// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        AudioServicesPlayAlertSound(1007);
//        [self saveFMDBWithUserInfo:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //判断是否从后台进入
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isActiveStatus"] isEqualToString:@"NO"]) { //不是从后台进入
            
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isActiveStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        AudioServicesPlayAlertSound(1007);
//        [self saveFMDBWithUserInfo:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    // iOS 10 will handle notifications through other methods
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    NSLog( @"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo );
    
    // custom code to handle notification content
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }

    
    
//    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([userInfo[@"aps"][@"sound"] isEqualToString:@"default"]) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatNotification object:nil userInfo:userInfo];
            AudioServicesPlayAlertSound(1007);
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatRemoteNotification object:nil userInfo:userInfo];
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatNotification object:nil userInfo:userInfo];
        }
    }else {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSystemMessage object:nil userInfo:userInfo];
            AudioServicesPlayAlertSound(1007);
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
        }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSystemMessage object:nil userInfo:userInfo];
        }
    }
//    
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSystemMessage object:nil userInfo:userInfo];
//        AudioServicesPlayAlertSound(1007);
//    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
//    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoteNotification object:nil userInfo:userInfo];
//    }
    
    
    
//    [self saveFMDBWithUserInfo:userInfo];
    
    
    //订阅展示视图消息，将直接打开某个分支视图
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
//    //弹出消息框提示用户有订阅通知消息。主要用于用户在使用应用时，弹出提示框
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification:) name:@"Notification" object:nil];
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
}

- (void)saveFMDBWithUserInfo:(NSDictionary *)userInfo {
    [JPUSHService setBadge:0];
    [[FMDBManager shareDataBase] createSystemMsgListTable];
    
    SysMsgModel *model = [[SysMsgModel alloc] init];
    model.alert = userInfo[@"aps"][@"alert"];
    model.sound = userInfo[@"aps"][@"sound"];
    model.badge = userInfo[@"aps"][@"badge"];
    model.type = userInfo[@"type"];
    model.notice_id = userInfo[@"notice_id"];
    [[FMDBManager shareDataBase] insertWithSysmodel:model];
    
    NSLog(@"%@",[[FMDBManager shareDataBase] selectedSysmodel]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
    }];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


@end
