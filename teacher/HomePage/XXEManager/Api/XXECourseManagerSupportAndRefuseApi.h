//
//  XXECourseManagerSupportAndRefuseApi.h
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerSupportAndRefuseApi : YTKRequest

/*
 【课程管理->通过和驳回(校长处理管理员发布的)】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/course_examine_action
 
 
 传参:
 
	position 	//身份
	school_id 	//学校id
	course_id 	//课程id
	action_type 	//执行类型, 1:处理通过  2:处理驳回
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id position:(NSString *)position school_id:(NSString *)school_id course_id:(NSString *)course_id action_type:(NSString *)action_type;

@end
