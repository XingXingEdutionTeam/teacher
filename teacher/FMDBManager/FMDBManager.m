//
//  FMDBManager.m
//  teacher
//
//  Created by codeDing on 16/12/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "FMDBManager.h"
#define kDataBaseName @"FunnyTimeDataBase.sqlite"
#define kDataBasePath [self sqlitePathsWithSqliteName:kDataBaseName]
#define kSystemMsgListTableName @"SystemMsgList"

static FMDBManager *shareIntance = nil;

@implementation FMDBManager
//创建单例类
+ (FMDBManager *)shareDataBase {
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        if (shareIntance == nil) {
            shareIntance = [[FMDBManager alloc] init];
        }
    });
    return shareIntance;
}

- (FMDatabase *)dataBase
{
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:kDataBasePath];
    }
    return _dataBase;
}

//指定数据库路径
- (NSString *)sqlitePathsWithSqliteName:(NSString *)sqliteName
{
    NSString *str = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *path = [str stringByAppendingPathComponent:sqliteName];
    return path;
}


//打开数据库
- (void)openDataBase {
    self.dataBase = [FMDatabase databaseWithPath:kDataBasePath];
    //    NSLog(@"数据库路径:%@",kDataBasePath);
}

//关闭数据库
-  (void)closeSqlite {
    [self.dataBase close];
}

//根据表名判断表是否存在
- (BOOL)isExistCollectionTableWithTableName:(NSString *)tableName
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    
    FMResultSet *rs = [_dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?", tableName];
    
    while ([rs next]) {
        if ([rs intForColumn:@"count"]) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return NO;
}

//判断表中是否有数据
- (BOOL)isContainDataInTable:(NSString *)tableName
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"select count(*) as 'count' from %@",tableName]];
        while ([rs next]) {
            
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
        
    }
    
    return NO;
}

#pragma mark - 系统消息表的增删改查

//创建系统消息表
- (void)createSystemMsgListTable {
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    //打开数据库
    if ([self.dataBase open]) {
        
        if ([self isExistCollectionTableWithTableName:kSystemMsgListTableName]) { //表已存在,直接返回
            return;
        }else{  //表不存在,建表
            
            BOOL isCreateTable = [self.dataBase executeUpdate:@"create table if not exists SystemMsgList(alert text, sound text, badge text, type text, notice_id text)"];
            
            if (isCreateTable) {
                NSLog(@"建表成功");
            }else{
                NSLog(@"建表失败");
            }
        }
        
        
    }
    
}

//判断消息是否存在
- (BOOL)isExistSysmodel:(SysMsgModel *)sysMsgModel {
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from SystemMsgList where notice_id = ?",sysMsgModel.notice_id];
        while ([rs next]) {
            
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

//插入一条数据
- (void)insertWithSysmodel:(SysMsgModel *)sysMsgModel {
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    
    if (!sysMsgModel) {
        NSLog(@"insert faile");
        return;
    }
    
    if ([self.dataBase open]) {
        
        if (![self isExistSysmodel:sysMsgModel]) {
            
            NSString *sqlStmt = @"insert into SystemMsgList(alert, sound, badge, type, notice_id) values (?,?,?,?,?) ";
            
            BOOL isInserted = [_dataBase executeUpdate:sqlStmt,sysMsgModel.alert,sysMsgModel.sound, sysMsgModel.badge, sysMsgModel.type, sysMsgModel.notice_id];
            
            if (isInserted) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
        }else{
            NSLog(@"图片已经存在");
        }
    }
}

//根据 notice_id 删除数据
- (void)deleteSysmodel:(SysMsgModel *)sysMsgModel {
    if (!_dataBase) {
        [self openDataBase];
    }
    
    if (!sysMsgModel) {
        return;
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistSysmodel:sysMsgModel]) {  //数据存在才删除
            
            BOOL isDelete = [_dataBase executeUpdate:@"delete from SystemMsgList where notice_id = ?",sysMsgModel.notice_id];
            
            if (isDelete) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }
    }
    
}

//取出所有数据
- (NSMutableArray *)selectedSysmodel {
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openDataBase];
    }
    
    NSMutableArray *mArray = nil;
    
    if ([self.dataBase open]) {
        
        if ([self isContainDataInTable:kSystemMsgListTableName]) {
            
            mArray = [[NSMutableArray alloc] init];
            
            FMResultSet *rs = [_dataBase executeQuery:@"select * from SystemMsgList"];
            
            while ([rs next]) {
                SysMsgModel *sysModel = [[SysMsgModel alloc] init];
                sysModel.alert = [rs stringForColumn:@"alert"];
                sysModel.badge = [rs stringForColumn:@"badge"];
                sysModel.sound = [rs stringForColumn:@"sound"];
                sysModel.type = [rs stringForColumn:@"type"];
                sysModel.notice_id = [rs stringForColumn:@"notice_id"];
                [mArray addObject:sysModel];
            }
        }
    }
    
    return mArray;
    
}


@end
