//
//  XXECourseManagerApi.h
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerApi : YTKRequest

/*
 【课程管理->课程列表(含草稿箱列表)】
  接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/edit_course_list
  传参:
	school_id	//学校id
	condit 		//要求需要返回的数据   0:待完善(草稿)   10:返回全部课程
    page
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id condit:(NSString *)condit page:(NSString *)page;


@end
