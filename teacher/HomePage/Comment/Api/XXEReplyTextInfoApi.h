//
//  XXEReplyTextInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEReplyTextInfoApi : YTKRequest

/*
 【点评->处理家长请求的点评】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/request_comment_action
 
 
 传参:
	class_id	//班级id
	comment_id	//评论id
	com_con		//评论内容
	url_group	//图片url集合(字符串,多个逗号隔开)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id comment_id:(NSString *)comment_id com_con:(NSString *)com_con url_group:(NSString *)url_group;


@end
