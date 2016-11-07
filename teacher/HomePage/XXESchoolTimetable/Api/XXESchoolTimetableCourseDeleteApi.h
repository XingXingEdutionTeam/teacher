//
//  XXESchoolTimetableCourseDeleteApi.h
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolTimetableCourseDeleteApi : YTKRequest

/*
 【课程表--课程表删除单条用户自定义数据】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/schedule_teacher_delete
 传参:
	schedule_id	//上个接口中的id
 */

- (id)initWithXid:(NSString *)xid  user_id:(NSString *)user_id schedule_id:(NSString *)schedule_id;

@end
