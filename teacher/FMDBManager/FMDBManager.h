//
//  FMDBManager.h
//  teacher
//
//  Created by codeDing on 16/12/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "SysMsgModel.h"

@interface FMDBManager : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;

//创建单例类
+ (FMDBManager *)shareDataBase;

//打开数据库
- (void)openDataBase;

//关闭数据库
-  (void)closeSqlite;

#pragma mark - 系统消息表的增删改查

//创建系统消息表
- (void)createSystemMsgListTable;

//判断消息是否存在
- (BOOL)isExistSysmodel:(SysMsgModel *)sysMsgModel;

//插入一条数据
- (void)insertWithSysmodel:(SysMsgModel *)sysMsgModel;

//根据 根据notice_id 删除数据
- (void)deleteSysmodel:(SysMsgModel *)sysMsgModel;

//取出所有数据
- (NSMutableArray *)selectedSysmodel;


@end
