//
//  XXEModifySchoolNameApi.h
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEModifySchoolNameApi : YTKRequest

/*
 【修改学校信息】
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_edit
 传参:
	school_id		//学校id(必须传参)
	position		//身份 (必须传参),只允许管理和校长才可以修改学校信息
    name			//学校名称
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position name:(NSString *)name;


@end
