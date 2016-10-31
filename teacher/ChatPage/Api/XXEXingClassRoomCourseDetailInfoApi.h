//
//  XXEXingClassRoomCourseDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingClassRoomCourseDetailInfoApi : YTKRequest

/*
 【猩课堂--课程详情】
 接口类型:1
 ★注:虽然猩课堂是全局性的,但是教师端没有支付按钮
 接口:
 http://www.xingxingedu.cn/Global/xkt_course_detail
 传参:
	course_id		//课程id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id course_id:(NSString *)course_id;

@end
