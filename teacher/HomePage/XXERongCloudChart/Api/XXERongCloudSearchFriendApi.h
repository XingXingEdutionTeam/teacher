//
//  XXERongCloudSearchFriendApi.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudSearchFriendApi : YTKRequest

/*
 【聊天--通过手机或猩猩ID搜索用户】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/search_user
 传参:
	search_con	//搜索内容
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id search_con:(NSString *)search_con;


@end
