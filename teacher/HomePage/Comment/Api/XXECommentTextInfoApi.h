//
//  XXECommentTextInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECommentTextInfoApi : YTKRequest

/*
 【点评->主动点评】(授课老师,主任和管理,校长不参与点评)
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/teacher_comment_action
 
 
 传参:
	school_id	//学校id
	class_id	//班级id
	baby_id		//孩子id,多个逗号隔开
	com_con		//评论内容
	url_group	//图片url集合(字符串,多个逗号隔开)
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id com_con:(NSString *)com_con url_group:(NSString  *)url_group;



@end
