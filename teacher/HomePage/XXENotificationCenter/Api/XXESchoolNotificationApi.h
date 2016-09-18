//
//  XXESchoolNotificationApi.h
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolNotificationApi : YTKRequest

/*
 【通知--校园通知】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_notice
 
 传参:
	school_id	//学校id (测试值:1)
	class_id	//班级id (测试值:1)
	position	//身份 1,2,3,4 (校长和管理身份不需要传class_id)
	page		//页码,不传值默认1
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position page:(NSString *)page;

@end
