//
//  XXEClassManagerClassDefaultTimeApi.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerClassDefaultTimeApi : YTKRequest

/*
 【班级管理->获取学校开学时间】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_term_tm
 传参:
	school_id	//学校id
	position	//身份	(公立学校的管理和校长才能操作)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position;

@end
