//
//  XXERongCloudJudgePositionApi.h
//  teacher
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudJudgePositionApi : YTKRequest

/*
 【聊天--发起聊天(获取双方token)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/chat_token
 传参:
	other_xid	//对方xid
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;


@end
