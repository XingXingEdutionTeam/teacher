//
//  XXERCDataManager.h
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface XXERCDataManager : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
+(XXERCDataManager *) shareManager;
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion;

-(BOOL)hasTheFriendWithUserId:(NSString *)userId;
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token;
/**
 *  从服务器同步好友列表
 */

-(void) syncFriendList:(void (^)(NSMutableArray * friends,BOOL isSuccess))completion;

/**
 *  从服务器同步群组列表
 */

-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion;


-(void) refreshBadgeValue;
-(NSString *)currentNameWithUserId:(NSString *)userId;
/**
 *  userId 参数用户的id
 获取RCUserInfo
 */
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId;
#pragma mark
#pragma mark 根据userId获取RCGroup


/**
 *  groupId 群组id
 获取RCGroup
 */
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId;


@end
