//
//  XXEAuditAndReleaseApi.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEAuditAndReleaseApi : YTKRequest

/*
 【校园通知--我发布的通知和我要审核的通知】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_notice_me
 传参:
	school_id	//学校id
	class_id	//班级id (校长和管理身份不需要传class_id)
	request_type	//查询类型,1:我要审核的通知   2:我发布的通知
	page		//页码,起始页1,不传值默认1
 */
- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id request_type:(NSString *)request_type page:(NSString *)page;

@end
