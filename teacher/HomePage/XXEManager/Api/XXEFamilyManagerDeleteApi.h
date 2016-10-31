//
//  XXEFamilyManagerDeleteApi.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFamilyManagerDeleteApi : YTKRequest
/*
 【家长管理->删除家长】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/manage_parent_delete
 传参:
	school_id 	//学校id
	class_id 	//班级id
	parent_id 	//家长id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id  class_id:(NSString *)class_id parent_id:(NSString *)parent_id;


@end
