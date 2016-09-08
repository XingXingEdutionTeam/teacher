//
//  XXEGlobalPermissionSettingApi.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEGlobalPermissionSettingApi : YTKRequest

/*
 【权限设置---权限设置操作】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/right_set_action
 
 传参:
	other_xid 	//被访问者xid
	action_name	//要执行的事件名,允许的事件名有: dt_look_at_him,dt_let_him_see,refuse_chat,black_user  每次只能写一个,注释见上一个接口
	action_num	//执行内容,传数字  1:关闭  2:开启
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid action_name:(NSString *)action_name action_num:(NSString *)action_num;



@end
