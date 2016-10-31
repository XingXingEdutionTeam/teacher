//
//  XXECourseManagerCourseDetailInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXECourseManagerCourseTimeModel.h"
#import "XXECourseManagerCourseTeacherModel.h"
#import "XXECourseManagerCoursePicModel.h"



@interface XXECourseManagerCourseDetailInfoModel : JSONModel

/*
 [id] => 22		//课程id
 [school_id] => 2
 [date_tm] => 1470734924
 [class1] => 1
 [class2] => 2
 [class3] => 4
 [class1_name] => 艺术
 [class2_name] => 乐器
 [class3_name] => 钢琴
 [course_name] => 钢琴周末班
 [need_num] => 3
 [now_num] => 0
 [age_up] => 6
 [age_down] => 12
 [teach_goal] => 天才要从娃娃抓起
 [week_times] => 2
 [course_hour] => 90
 [course_start_tm] => 1471449600
 [course_end_tm] => 1476720000
 [address] => 上海市浦东新区巨峰路455号
 [middle_in_rule] => 1
 [quit_rule] => 1
 [original_price] => 2400
 [now_price] => 2100
 [coin] => 1
 [details] => 课程介绍..............
 [term] => 1班
 [collect_num] => 0
 [read_num] => 0
 [popularity] => 0.0000
 [condit] => 0
 
 [course_tm] => Array
 
 [teacher_arr] => Array
 
 [pic_arr] => Array
 */

@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *class1;
@property (nonatomic, copy) NSString *class2;
@property (nonatomic, copy) NSString *class3;
@property (nonatomic, copy) NSString *class1_name;
@property (nonatomic, copy) NSString *class2_name;
@property (nonatomic, copy) NSString *class3_name;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *need_num;
@property (nonatomic, copy) NSString *now_num;
@property (nonatomic, copy) NSString *age_up;
@property (nonatomic, copy) NSString *age_down;
@property (nonatomic, copy) NSString *teach_goal;
@property (nonatomic, copy) NSString *week_times;
@property (nonatomic, copy) NSString *course_hour;
@property (nonatomic, copy) NSString *course_start_tm;
@property (nonatomic, copy) NSString *course_end_tm;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *middle_in_rule;
@property (nonatomic, copy) NSString *quit_rule;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *now_price;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *collect_num;
@property (nonatomic, copy) NSString *read_num;
@property (nonatomic, copy) NSString *popularity;
@property (nonatomic, copy) NSString *condit;
//@property (nonatomic, strong) NSMutableArray<XXECourseManagerCourseTimeModel> *course_tm;
//@property (nonatomic, strong) NSMutableArray<XXECourseManagerCourseTeacherModel> *teacher_arr;
//@property (nonatomic, strong) NSMutableArray<XXECourseManagerCoursePicModel> *pic_arr;

+ (XXECourseManagerCourseDetailInfoModel *)parseResondsData:(id)respondObject;
+(JSONKeyMapper*)keyMapper;

@end
