//
//  XXEAuditorApi.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEAuditorApi : YTKRequest

/*
 【校园通知--审核人(发布时需要)】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_notice
 
 传参:
	school_id	//学校id
	class_id	//班级id
	position	//身份 1,2,3,4 (校长和管理身份不需要传class_id)
	notice_type	//1:班级通知  2:学校通知
 */

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id position:(NSString *)position notice_type:(NSString *)notice_type;


@end
