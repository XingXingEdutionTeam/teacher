//
//  XXEGlobalPermissionListApi.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEGlobalPermissionListApi : YTKRequest

/*
 【权限设置---权限设置列表】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/right_set_list
 
 传参:
	other_xid 	//被访问者xid
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;


@end
