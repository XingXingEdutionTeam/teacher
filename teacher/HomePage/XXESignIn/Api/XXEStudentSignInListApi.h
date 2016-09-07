//
//  XXEStudentSignInListApi.h
//  teacher
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEStudentSignInListApi : YTKRequest

/*
 【学生签到->已签到和未签到列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/sign_part_list
 
 传参:
	class_id	//班级id
	school_id	//学校id
	sign_type	//1:已签到  2:未签到
	date_tm		//日期,格式必须是: 2016-08-03 (如果不传参,默认今天)
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id  class_id:(NSString *)class_id school_id:(NSString *)school_id date_tm:(NSString *)date_tm sign_type:(NSString *)sign_type;

@end
