//
//  XXESchoolTimetableCourseAddApi.h
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolTimetableCourseAddApi : YTKRequest

/*
 【课程表--新增内容】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_teacher_add
 传参:
	date			//指定日期,格式必须是:2016-07-27
	lesson_start_tm		//上课时间,请限制用户格式:09:15
	lesson_end_tm		//下课时间
	course_name		//课程名
	teacher_name		//老师名
	classroom		//教室
	notes			//备注
	copy_week_num		//复制几周
 */

- (id)initWithXid:(NSString *)xid  user_id:(NSString *)user_id date:(NSString *)date lesson_start_tm:(NSString *)lesson_start_tm lesson_end_tm:(NSString *)lesson_end_tm course_name:(NSString *)course_name teacher_name:(NSString *)teacher_name classroom:(NSString *)classroom notes:(NSString *)notes copy_week_num:(NSString *)copy_week_num;



@end
