//
//  XXEClassManagerDeleteClassInfoApi.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerDeleteClassInfoApi : YTKRequest

/*
 【班级管理->删除班级】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/delete_class
 传参:
	school_id	//学校id
	class_id	//班级id
	position	//身份	(公立学校的管理和校长才能操作)
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position;

@end
