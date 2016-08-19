//
//  XXEHomeworkIssueTextInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEHomeworkIssueTextInfoApi : YTKRequest


/*
 【班级作业->发布作业】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/class_homework_publish
 
 
 传参:
	school_id	//学校id
	class_id	//班级id
	title		//标题
	con		//内容
	teach_course	//授课/科目(这里传的是中文)
	date_end_tm	//交期(格式2016-08-02 09:10:00)
	file		//批量上传图片
 */


- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id title:(NSString *)title con:(NSString *)con teach_course:(NSString *)teach_course date_end_tm:(NSString *)date_end_tm;



@end
