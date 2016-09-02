//
//  XXEManagerAndHeadmasterStudentSignInApi.h
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEManagerAndHeadmasterStudentSignInApi : YTKRequest

/*
 【学生签到->整个学校的签到数和未签到数】(学校班级前面已经做过接口)
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/sign_in_school_count
 传参:
 
	school_id	//学校id
	date_tm		//日期,格式必须是: 2016-08-03 (如果不传参,默认今天)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type date_tm:(NSString *)date_tm school_id:(NSString *)school_id ;


@end
