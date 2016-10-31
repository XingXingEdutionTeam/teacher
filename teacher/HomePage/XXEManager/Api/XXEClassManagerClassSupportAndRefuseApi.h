//
//  XXEClassManagerClassSupportAndRefuseApi.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerClassSupportAndRefuseApi : YTKRequest

/*
 【班级管理->班级通过和驳回】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/class_examine_action
 传参:
	school_id	//学校id
	class_id	//班级id
	position	//身份	(公立学校的管理和校长才能操作)
	action_type	//执行类型  1:通过  2:驳回
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position action_type:(NSString *)action_type;


@end
