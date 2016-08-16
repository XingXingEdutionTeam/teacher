//
//  XXEChiefAndTeacherApi.h
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEChiefAndTeacherApi : YTKRequest

/*
 //身份  主任和老师 调用下面接口
 【学生列表(某个班级)】多个模块用到此接口
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/baby_list_oneclass
 
 传参:
 
 school_id	//学校id
 class_id	//班级id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id;


@end
