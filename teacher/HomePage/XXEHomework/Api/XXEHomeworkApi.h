//
//  XXEHomeworkApi.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEHomeworkApi : YTKRequest

/*
 【班级作业】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Parent/class_homework_list
 
 传参:
	school_id	//学校id (测试值:1)
	class_id	//班级 (测试值:1)
	page		//页码(加载更多,不传值默认1,测试时每页加载6个)
	teach_course	//科目,筛选用,例如:英语
	month		//月份,筛选用,例如:3
 
 注:筛选时,学校id,班级id 2个传参都不能少
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id page:(NSString *)page teach_course:(NSString *)teach_course month:(NSString *)month;


@end
