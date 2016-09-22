//
//  XXECourseManagerSchoolTeacherListApi.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerSchoolTeacherListApi : YTKRequest

/*
 【课程管理->获取某个学校老师】(用于发布)
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/get_school_teacher
 传参:
	school_id	//学校id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id;

@end
