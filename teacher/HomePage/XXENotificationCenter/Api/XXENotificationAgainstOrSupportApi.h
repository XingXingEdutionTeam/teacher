//
//  XXENotificationAgainstOrSupportApi.h
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXENotificationAgainstOrSupportApi : YTKRequest

/*
 【校园通知--审核通过和驳回操作】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_notice_action
 
 传参:
	notice_id	//通知id
	action_type	//操作类型  1:审核通过  2:驳回
 */

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id notice_id:(NSString *)notice_id action_type:(NSString *)action_type;


@end
