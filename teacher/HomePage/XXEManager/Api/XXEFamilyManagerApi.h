//
//  XXEFamilyManagerApi.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFamilyManagerApi : YTKRequest

/*
 【家长管理->家长列表】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/manage_parent_list
 传参:
	school_id	//学校id
	school_type	//学校类型
	class_id	//班级id
	position	//身份
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id  school_type:(NSString *)school_type class_id:(NSString *)class_id position:(NSString *)position;


@end
