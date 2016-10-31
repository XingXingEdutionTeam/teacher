//
//  XXERongCloudDeleteFriendRequestApi.h
//  teacher
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudDeleteFriendRequestApi : YTKRequest

/*
 【聊天--删除请求好友通知】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/friend_request_delete
 传参:
	request_id	//请求好友通知id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id request_id:(NSString *)request_id;

@end
