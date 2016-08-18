//
//  XXEHomeworkModel.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEHomeworkModel : JSONModel

/*
 [id] => 11			//作业id
 [school_id] => 1		//学校id
 [class_id] => 1		//班级
 [date_tm] => 1478854540	//发布时间
 [date_end_tm] => 1513673458	//交作业时间
 [month] => 11		//月份
 [tid] => 3			//老师id
 [teach_course] => 英语	//科目
 [title] => 回家作业		//标题
 [condit] => 3		//状态 1:急  2:写  3:新  4:结
 [tname] => 高大京		//老师姓名
 [head_img] => app_upload/text/teacher/3.jpg	//老师头像
 [head_img_type] => 0	//头像类型
 */
@property (nonatomic, copy) NSString *homeworkId;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *date_end_tm;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
