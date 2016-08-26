//
//  XXERecipeAddTextApi.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipeAddTextApi : YTKRequest

/*
 【食谱->发布】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_cookbook_publish
 
 
 传参:
	school_id	//学校id
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	date_tm		//日期(格式:2016-08-02 ,注:没有时分秒)
	breakfast_name	//早餐名
	lunch_name	//午餐名
	dinner_name	//晚餐

 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position date_tm:(NSString *)date_tm breakfast_name:(NSString *)breakfast_name lunch_name:(NSString *)lunch_name dinner_name:(NSString *)dinner_name breakfast_url:(NSString *)breakfast_url lunch_url:(NSString *)lunch_url dinner_url:(NSString *)dinner_url;


@end
