//
//  XXEBabyFamilyInfoDetailApi.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEBabyFamilyInfoDetailApi : YTKRequest

/*
 【家人详情页】
 
 接口类型:1
 
 用于:
 1.首页长按孩子出现的家长,查看家长详情
 2.班级通讯录孩子名下的家长,查看家长详情
 
 接口:
 http://www.xingxingedu.cn/Parent/parent_detail
 
 传参:
	baby_id		//孩子id
	parent_id	//家人id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type baby_id:(NSString *)baby_id parent_id:(NSString *)parent_id;

@end
