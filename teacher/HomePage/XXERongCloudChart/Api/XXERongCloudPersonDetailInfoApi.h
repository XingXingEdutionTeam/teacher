//
//  XXERongCloudPersonDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudPersonDetailInfoApi : YTKRequest

/*
 【聊天--好友资料(也用于,陌生人资料)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/friend_info
 传参:
	other_xid	//对方xid
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;

@end
