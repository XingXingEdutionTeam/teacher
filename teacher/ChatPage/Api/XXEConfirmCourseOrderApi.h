//
//  XXEConfirmCourseOrderApi.h
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEConfirmCourseOrderApi : YTKRequest

/*
 【猩课堂--购买课程确认订单页】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xkt_confirm_course_order
 
 传参:
	course_id		//课程id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id course_id:(NSString *)course_id;

@end
