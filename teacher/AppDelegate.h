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
#import "SystemModel+CoreDataClass.h"
#import "SystemModel+CoreDataProperties.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain)XXRootChatETabBarController *tabbarVC;

@property(nonatomic,retain) NSMutableArray *friendsArray;
@property(nonatomic,retain) NSMutableArray *groupsArray;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/// func
+ (AppDelegate* )shareAppDelegate;

@end

