//
//  AppDelegate.h
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RongIMKit/RongIMKit.h>
#import "XXRootChatETabBarController.h"
#import "XXERCDataManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)XXRootChatETabBarController *tabbarVC;

@property(nonatomic,retain) NSMutableArray *friendsArray;
@property(nonatomic,retain) NSMutableArray *groupsArray;
@property (nonatomic,assign) BOOL isLaunchedByNotification;
@property (nonatomic, copy) NSDictionary *userInfo;

/// func
+ (AppDelegate* )shareAppDelegate;

@end

