//
//  XXERecipePicModify.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipePicModify : YTKRequest

/*
 【食谱->修改】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_cookbook_edit
 
 
 传参:
	school_id	//学校id
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	cookbook_id	//食谱id
	meal_type	//餐类型,传数字(1:早餐  2:午餐  3:晚餐)
	meal_name	//餐名
	url_group	//图片url集合(字符串,多个逗号隔开)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position cookbook_id:(NSString *)cookbook_id meal_type:(NSString *)meal_type meal_name:(NSString *)meal_name url_group:(NSString *)url_group;



@end
