//
//  XXERongCloudAgreeFriendRequestApi.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudAgreeFriendRequestApi : YTKRequest

/*
 【聊天--同意添加好友请求】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/agree_friend_request
 传参:
	request_id	//请求id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id request_id:(NSString *)request_id;

@end
