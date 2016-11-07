//
//  XXESchoolTimetableCourseModifyApi.h
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolTimetableCourseModifyApi : YTKRequest

/*
 【课程表--修改自定义内容】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_teacher_edit
 
 条件传参:
	week_date	//周(时间戳)
	schedule_id	//上个接口中的id
 
 修改的数据传参 (以下字段传空不修改)
	wd			//星期几(英文)
	lesson_start_tm		//上课时间,请限制用户格式:09:15
	lesson_end_tm		//下课时间
	course_name		//课程名
	teacher_name		//老师名
	classroom		//教室
	notes			//备注
 */

- (id)initWithXid:(NSString *)xid  user_id:(NSString *)user_id week_date:(NSString *)week_date schedule_id:(NSString *)schedule_id wd:(NSString *)wd lesson_start_tm:(NSString *)lesson_start_tm lesson_end_tm:(NSString *)lesson_end_tm course_name:(NSString *)course_name teacher_name:(NSString *)teacher_name classroom:(NSString *)classroom notes:(NSString *)notes;



@end
