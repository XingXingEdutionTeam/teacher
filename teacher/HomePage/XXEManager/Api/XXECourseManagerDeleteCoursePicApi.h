//
//  XXECourseManagerDeleteCoursePicApi.h
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerDeleteCoursePicApi : YTKRequest

/*
 【课程管理->删除课程图片(在修改课程时)】 注释请参考发布课程接口
  接口类型:2
  接口:
 http://www.xingxingedu.cn/Teacher/course_pic_delete
 传参:
 	course_id	//课程id
	pic_id		//图片id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id course_id:(NSString *)course_id pic_id:(NSString *)pic_id;


@end
