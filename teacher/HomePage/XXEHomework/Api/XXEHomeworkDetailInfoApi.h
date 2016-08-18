//
//  XXEHomeworkDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEHomeworkDetailInfoApi : YTKRequest

/*
 【班级作业详情】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Parent/class_homework_detail
 
 传参:
	homework_id	//作业id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type homework_id:(NSString *)homework_id;


@end
