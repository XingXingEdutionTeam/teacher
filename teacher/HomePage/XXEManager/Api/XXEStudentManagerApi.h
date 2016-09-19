//
//  XXEStudentManagerApi.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentManagerApi : YTKRequest

/*
 【学生管理->学生列表】
  接口类型:1
  接口:
 http://www.xingxingedu.cn/Teacher/manage_baby_list
  传参:
 
	school_id	//学校id
	school_type	//学校类型
	class_id	//班级id (只有身份时1和2时才有class_id)
	position	//身份
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id  school_type:(NSString *)school_type class_id:(NSString *)class_id position:(NSString *)position;


@end
