//
//  CoreDataManager.m
//  teacher
//
//  Created by codeDing on 16/12/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"



@implementation CoreDataManager
+(id)sharedManager {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
    });
    
    return sharedInstance;
}

//MARK: - 保存数据
- (void)saveDataWithEntity:(NSString*)entity type:(SystemModel*)type {
    //1
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    //2
    NSEntityDescription *entit = [NSEntityDescription entityForName:entity inManagedObjectContext:managedContext];
    NSManagedObject *attributes = [[NSManagedObject alloc] initWithEntity:entit insertIntoManagedObjectContext:managedContext];
    //3
    [attributes setValue:type.alert forKey:@"alert"];
    [attributes setValue:type.sound forKey:@"sound"];
    [attributes setValue:type.badge forKey:@"badge"];
    [attributes setValue:type.type forKey:@"type"];
    [attributes setValue:type.notice_id forKey:@"notice_id"];
    
    NSError *error;
    [managedContext save:&error];
}

//MARK: - 获取数据
-(NSArray<SystemModel*> *)getDataWithEntity:(NSString*)entity {
    NSMutableArray<SystemModel*> *systemModels = [NSMutableArray array];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    
    NSError *error;
    NSArray *datas = [managedContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < datas.count; i+=1) {
        SystemModel *model = [[SystemModel alloc] init];
        model.alert = [datas[i] valueForKey:@"alert"];
        model.sound = [datas[i] valueForKey:@"sound"];
        model.badge = [datas[i] valueForKey:@"badge"];
        model.type = [datas[i] valueForKey:@"type"];
        model.notice_id = [datas[i] valueForKey:@"notice_id"];
        [systemModels addObject:model];
    }
    
    return systemModels;
}

//MARK: - 查询数据
- (SystemModel*)searchDataWithEntity:(NSString*)entity key:(NSString*)key {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSError *error;
    NSArray *datas = [managedContext executeFetchRequest:fetchRequest error:&error];
    
    for (SystemModel *model in datas) {
        if ([model.notice_id isEqualToString:key]) {
            return model;
        }
    };
    
    return nil;
    
}

//MARK: - 删除数据
- (void) deleteDataWithEntity:(NSString *)entity key:(NSString*)key {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    
    SystemModel *model = [self searchDataWithEntity:entity key:key];
    if (model != nil) {
        [managedContext deleteObject:(NSManagedObject*)model];
    }else {
        return;
    }
    
    NSError *error;
    [managedContext save:&error];
    
}
//MARK: - 删除所有数据
- (void) deleteAllDataWithEntity:(NSString *)entity succeed:(void (^)())succeed fail:(void (^)())fail {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSError *error;
    [managedContext executeFetchRequest:fetchRequest error:&error];
    [managedContext save:&error];
}

//MARK: - 修改数据
- (void) modifyDataWithEntity:(NSString*)entity ID:(NSString*)ID value:(id)value key:(NSString*)key {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = appdelegate.managedObjectContext;
    SystemModel *model = [self searchDataWithEntity:entity key:key];
    [model setValue:value forKey:key];
    NSError *error;
    [managedContext save:&error];
}


@end
