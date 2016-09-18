//
//  XXENotificationReleaseApi.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXENotificationReleaseApi : YTKRequest

/*
 【校园通知--发布】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/publish_school_notice
 
 传参:
	school_id	//学校id
	class_id	//班级id
	position	//身份 1,2,3,4 (校长和管理身份不需要传class_id)
	notice_type	//1:班级通知  2:学校通知
	examine_tid	//审核人id
	title		//主题
	con		//内容
 */
- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id position:(NSString *)position notice_type:(NSString *)notice_type examine_tid:(NSString *)examine_tid title:(NSString *)title con:(NSString *)con;


@end
