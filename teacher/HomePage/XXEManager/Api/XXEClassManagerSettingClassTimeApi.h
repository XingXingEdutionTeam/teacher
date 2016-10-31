//
//  XXEClassManagerSettingClassTimeApi.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerSettingClassTimeApi : YTKRequest

/*
 【班级管理->设置学校开学时间】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/edit_school_term_tm
 传参:
	school_id	//学校id
	position	//身份	(公立学校的管理和校长才能操作)
	term_start_tm_s //春季开学时间,格式:06-17  (只要月和日)
	term_end_tm_s 	//春季学期结束
	term_start_tm_a //秋季开学时间
	term_end_tm_a   //秋季学期结束时间
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position term_start_tm_s:(NSString *)term_start_tm_s term_end_tm_s:(NSString *)term_end_tm_s term_start_tm_a:(NSString *)term_start_tm_a term_end_tm_a:(NSString *)term_end_tm_a;



@end
