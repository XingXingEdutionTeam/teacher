//
//  XXEModifyEmailApi.h
//  teacher
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEModifyEmailApi : YTKRequest


/*
 【修改学校信息】
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_edit
 
 传参:
 
	school_id		//学校id(必须传参)
	position		//身份 (必须传参),只允许管理和校长才可以修改学校信息
    email			//邮箱
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position email:(NSString *)email;


@end
