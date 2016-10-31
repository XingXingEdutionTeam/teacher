//
//  XXERongCloudAddFriendRequestApi.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudAddFriendRequestApi : YTKRequest

/*
 【聊天--发起添加好友请求】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/action_friend_request
 传参:
	other_xid	//对方xid  (测试可用xid: 18886390,18886391,18886393(允许任何人通过),18886378(已是好友),18886177(在对方黑名单中))
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;

@end
