//
//  CoreDataManager.h
//  teacher
//
//  Created by codeDing on 16/12/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemModel+CoreDataClass.h"
#import "SystemModel+CoreDataProperties.h"
@interface CoreDataManager : NSObject
+(id)sharedManager;

//MARK: - 保存数据
- (void)saveDataWithEntity:(NSString*)entity type:(SystemModel*)type;

//MARK: - 获取数据
-(NSArray<SystemModel*> *)getDataWithEntity:(NSString*)entity;

//MARK: - 查询数据
- (SystemModel*)searchDataWithEntity:(NSString*)entity key:(NSString*)key;

//MARK: - 删除数据
- (void) deleteDataWithEntity:(NSString *)entity key:(NSString*)key;

//MARK: - 删除所有数据
- (void) deleteAllDataWithEntity:(NSString *)entity succeed:(void (^)())succeed fail:(void (^)())fail;

//MARK: - 修改数据
- (void) modifyDataWithEntity:(NSString*)entity ID:(NSString*)ID value:(id)value key:(NSString*)key;
@end
