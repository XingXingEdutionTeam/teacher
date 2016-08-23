//
//  XXERecipeDeleteApi.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipeDeleteApi : YTKRequest

/*
 【食谱->删除食谱】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_cookbook_delete
 
 
 传参:
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	cookbook_id	//食谱id
	school_id	//学校id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position cookbook_id:(NSString *)cookbook_id;


@end
