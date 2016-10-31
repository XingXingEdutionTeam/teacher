//
//  XXEClassManagerAddClassInfoApi.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassManagerAddClassInfoApi : YTKRequest

/*
 【班级管理->添加班级】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/add_class

 传参:
	school_id	//学校id
	school_type	//学校类型
	position	//身份	(公立学校的管理和校长才有这个班级管理这个模块)
	grade 		//年级,传数字
	class 		//班级,传数字
	num_up 		//班级人数上限
	teacher_boss 	//班主任
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_type:(NSString *)school_type school_id:(NSString *)school_id position:(NSString *)position grade:(NSString *)grade class:(NSString *)classNum num_up:(NSString *)num_up teacher_boss:(NSString *)teacher_boss;



@end
