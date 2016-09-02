//
//  XXEStudentAllSignApi.h
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentAllSignApi : YTKRequest

/*
 【学生签到->一键签到】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/sign_in_all_action
 
 
 传参:
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	class_id	//班级id
	school_id	//学校id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position;


@end
