//
//  XXEClassAddressHeadermasterAndManagerApi.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEClassAddressHeadermasterAndManagerApi : YTKRequest

/*
 【某个学校所有班级名称列表(当身份时校长和管理员时用到)】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_all_class
 
 传参:
	school_id	//学校id
	school_type	//学校类型
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id school_type:(NSString *)school_type;


@end
