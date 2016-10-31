//
//  XXERongCloudFriendRequestListApi.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudFriendRequestListApi : YTKRequest

/*
 【聊天--请求好友列表】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/friend_request_list
 传参:
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id;



@end
