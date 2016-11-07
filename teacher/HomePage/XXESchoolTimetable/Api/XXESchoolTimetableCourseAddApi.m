

//
//  XXESchoolTimetableCourseAddApi.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseAddApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/schedule_teacher_add"

@interface XXESchoolTimetableCourseAddApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *lesson_start_tm;
@property (nonatomic, copy) NSString *lesson_end_tm;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *classroom;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *same_week_num;

@end

@implementation XXESchoolTimetableCourseAddApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id date:(NSString *)date lesson_start_tm:(NSString *)lesson_start_tm lesson_end_tm:(NSString *)lesson_end_tm course_name:(NSString *)course_name teacher_name:(NSString *)teacher_name classroom:(NSString *)classroom notes:(NSString *)notes copy_week_num:(NSString *)copy_week_num{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _date = date;
        _lesson_start_tm = lesson_start_tm;
        _lesson_end_tm = lesson_end_tm;
        _course_name = course_name;
        _teacher_name = teacher_name;
        _classroom = classroom;
        _notes = notes;
        _same_week_num = copy_week_num;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"week_date":_date,
             @"lesson_start_tm":_lesson_start_tm,
             @"lesson_end_tm":_lesson_end_tm,
             @"course_name":_course_name,
             @"teacher_name":_teacher_name,
             @"classroom":_classroom,
             @"notes":_notes,
             @"copy_week_num":_same_week_num,
             @"date":_date
             };
    
}



@end
