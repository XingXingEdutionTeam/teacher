//
//  XXECourseManagerDeleteCourseApi.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerDeleteCourseApi : YTKRequest

/*
 【课程管理->删除课程(只允许删除非上线的课程)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/course_delete
 传参:
	school_id	//学校id
	course_id	//课程id
    position	//身份
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id course_id:(NSString *)course_id school_id:(NSString *)school_id position:(NSString *)position;



@end
