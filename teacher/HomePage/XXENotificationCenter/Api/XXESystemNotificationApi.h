//
//  XXESystemNotificationApi.h
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESystemNotificationApi : YTKRequest

/*
 【系统消息】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/official_notice
 
 传参:
	app_type	//1:家长端, 2:教师端
	page		//页码,加载更多, 默认1
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id app_type:(NSString *)app_type page:(NSString *)page;


@end
