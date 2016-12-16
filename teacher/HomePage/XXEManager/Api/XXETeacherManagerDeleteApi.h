//
//  XXETeacherManagerDeleteApi.h
//  teacher
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXETeacherManagerDeleteApi : YTKRequest

/*
 【老师管理->删除老师】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/manage_teacher_delete
 传参:
	school_id 	//学校id
	class_id 	//班级id
	examine_id 	//老师id
 
 return_param_all = 1		//要求返回所有传参,测试用
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id examine_id:(NSString *)examine_id ;

@end
