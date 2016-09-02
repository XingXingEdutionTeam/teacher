//
//  XXEStudentSignInApi.h
//  teacher
//
//  Created by Mac on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentSignInApi : YTKRequest

/*
 【学生签到->签到列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/sign_in_list
 
 
 传参:
	class_id	//班级id
	school_id	//学校id
	date_tm		//日期,格式必须是: 2016-08-03 (如果不传参,默认今天)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id school_id:(NSString *)school_id date_tm:(NSString *)date_tm;



@end
