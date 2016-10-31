//
//  XXECourseManagerCourseDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerCourseDetailInfoApi : YTKRequest

/*
 【课程管理->单个课程数据(修改课程用)】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/edit_course_detail
 
 
 传参:
	school_id	//学校id
	course_id	//课程id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id course_id:(NSString *)course_id;

@end
