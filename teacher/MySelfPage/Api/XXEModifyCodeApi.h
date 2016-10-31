//
//  XXEModifyCodeApi.h
//  teacher
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEModifyCodeApi : YTKRequest

/*
 【修改密码,两端通用(登陆密码和支付密码)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/edit_pass
 传参
	user_type	//用户类型 1:家长 2:教师
	old_pass	//老密码
	new_pass	//新密码
	action_type	//1: 修改登录密码   2:修改支付密码
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id old_pass:(NSString *)old_pass new_pass:(NSString *)new_pass action_type:(NSString *)action_type;


@end
