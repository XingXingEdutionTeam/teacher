//
//  XXEHomeworkGetCourseApi.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEHomeworkGetCourseApi : YTKRequest

/*
 【班级作业->老师授课】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/class_teacher_teach
 
 
 传参:
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type;


@end
