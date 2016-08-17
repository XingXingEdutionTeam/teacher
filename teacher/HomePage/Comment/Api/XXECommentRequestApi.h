//
//  XXECommentRequestApi.h
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECommentRequestApi : YTKRequest

/*
 【点评->点评列表(含请求和历史)】 ★注:详情页没有接口,从这里的数据传递
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/teacher_com_msg
 
 
 传参:
	class_id	//班级id
	require_con	//请求数据内容 1:点评历史,2:请求点评
	page		//页码默认1 (加载更多)
 */


- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id require_con:(NSString *)require_con page:(NSString *)page;


@end
