//
//  XXERongCloudDeleteFriendApi.h
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudDeleteFriendApi : YTKRequest

/*
 【聊天--删除好友】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/delete_friend
 传参:
	other_xid	//好友xid
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;

@end
