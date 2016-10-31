//
//  XXEClassManagerApi.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerApi : YTKRequest

/*
 【班级管理->班级列表】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_grade_list
 传参:
	school_id	//学校id
	school_type	//学校类型
	position	//身份	(公立学校的管理和校长才有这个班级管理这个模块)
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_type:(NSString *)school_type school_id:(NSString *)school_id position:(NSString *)position;

@end
