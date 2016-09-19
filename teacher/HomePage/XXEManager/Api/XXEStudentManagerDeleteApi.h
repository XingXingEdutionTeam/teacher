//
//  XXEStudentManagerDeleteApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentManagerDeleteApi : YTKRequest

/*
 【学生管理->删除学生】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/manage_baby_delete
 传参:
	school_id	//学校id
	class_id	//班级id
	baby_id		//孩子id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id;


@end
