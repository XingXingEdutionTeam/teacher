//
//  XXEXingClassRoomTeacherDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingClassRoomTeacherDetailInfoApi : YTKRequest

/*
 【猩课堂--老师个人详情】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xkt_teacher_detail
 
 传参:
	teacher_id		//老师id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id teacher_id:(NSString *)teacher_id;


@end
