//
//  XXERecipeSingleMealDetailInfoApi.h
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipeSingleMealDetailInfoApi : YTKRequest


/*
 【食谱单餐详情】(为了实现修改能够直接刷新而后做)
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Parent/school_cookbook_single_meal
 
 传参:
	school_id	//学校id
	date_tm		//日期,例:2016-08-16
	meal_type	//餐类型,传数字(1:早餐  2:午餐  3:晚餐)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id date_tm:(NSString *)date_tm meal_type:(NSString *)meal_type;

@end
