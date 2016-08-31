//
//  XXESchoolRegisterTeacherInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolRegisterTeacherInfoApi : YTKRequest
/*
 【猩课堂--某个学校的所有老师列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/school_teacher_list
 
 传参:
	school_id	//学校id
	page		//页码(加载更多),不传参默认1
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id page:(NSString *)page;

@end
